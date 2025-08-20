import 'dart:developer';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class NotificationsService {
  static const String _oneSignalAppId = '25a983c8-8450-47cc-80db-12fef26be775';
  // static const String _oneSignalAppId = '25a983c8-8450-47cc-80db-12fef26be775';
  static bool _isInitialized = false;
  static bool _isInitializing = false;

  static Future<void> initializeOneSignal() async {
    if (_isInitialized || _isInitializing) {
      log('OneSignal: Already initialized or initializing');
      return;
    }

    _isInitializing = true;
    try {
      // Initialize OneSignal
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.initialize(_oneSignalAppId);

      // Wait a bit for initialization to complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Request notification permissions
      await OneSignal.Notifications.requestPermission(true);

      // Set up notification event listeners
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        log('OneSignal: Notification received in foreground');
        // Display the notification
        event.notification.display();
      });

      OneSignal.Notifications.addClickListener((event) {
        log('OneSignal: Notification clicked');
        // Handle notification click
      });

      _isInitialized = true;
      log('OneSignal initialized successfully');
    } catch (e) {
      log('Error initializing OneSignal: $e');
    } finally {
      _isInitializing = false;
    }
  }

  static Future<void> setExternalUserId(String userId) async {
    if (!_isInitialized) {
      log('OneSignal: Not initialized yet, waiting...');
      await _waitForInitialization();
    }

    // Check if user is subscribed first
    if (!await _isUserSubscribed()) {
      log('OneSignal: User not subscribed yet, waiting for subscription...');
      await _waitForSubscription();
    }

    // Add retry logic for setting external user ID
    for (int i = 0; i < 3; i++) {
      try {
        await OneSignal.login(userId);
        log('OneSignal: External user ID set to: $userId');

        // Wait a moment for the server sync
        await Future.delayed(const Duration(milliseconds: 2000));

        // Verify the external user ID was set
        await _verifyExternalUserId(userId);
        return;
      } catch (e) {
        log('Error setting OneSignal external user ID (attempt ${i + 1}): $e');
        if (i < 2) {
          // Wait before retrying
          await Future.delayed(Duration(milliseconds: 1000 * (i + 1)));
        }
      }
    }
    log('OneSignal: Failed to set external user ID after 3 attempts');
  }

  static Future<bool> _isUserSubscribed() async {
    try {
      final pushSubscription = OneSignal.User.pushSubscription;
      final isSubscribed = pushSubscription.optedIn;
      final subscriptionId = pushSubscription.id;

      log(
        'OneSignal: Subscription check - optedIn: $isSubscribed, ID: $subscriptionId',
      );
      return (isSubscribed == true) && (subscriptionId != null);
    } catch (e) {
      log('OneSignal: Error checking subscription status: $e');
      return false;
    }
  }

  static Future<void> _waitForSubscription() async {
    int attempts = 0;
    while (attempts < 20) {
      // Wait up to 10 seconds
      if (await _isUserSubscribed()) {
        log('OneSignal: User is now subscribed');
        return;
      }
      await Future.delayed(const Duration(milliseconds: 500));
      attempts++;
    }
    log('OneSignal: Timeout waiting for subscription');
  }

  static Future<void> _verifyExternalUserId(String expectedUserId) async {
    try {
      // Add tags to help verify the user ID was set
      await OneSignal.User.addTagWithKey(
        'external_user_id_set',
        expectedUserId,
      );
      await OneSignal.User.addTagWithKey(
        'external_user_id_timestamp',
        DateTime.now().toIso8601String(),
      );

      log(
        'OneSignal: Added verification tags for external user ID: $expectedUserId',
      );
    } catch (e) {
      log('OneSignal: Error adding verification tags: $e');
    }
  }

  static Future<void> removeExternalUserId() async {
    if (!_isInitialized) {
      log('OneSignal: Not initialized yet, waiting...');
      await _waitForInitialization();
    }

    try {
      await OneSignal.logout();
      log('OneSignal: External user ID removed');
    } catch (e) {
      log('Error removing OneSignal external user ID: $e');
    }
  }

  static Future<void> _waitForInitialization() async {
    int attempts = 0;
    while (!_isInitialized && attempts < 10) {
      await Future.delayed(const Duration(milliseconds: 500));
      attempts++;
    }
    if (!_isInitialized) {
      log('OneSignal: Initialization timeout, proceeding anyway');
    }
  }

  static Future<String?> getPlayerId() async {
    try {
      final user = OneSignal.User.pushSubscription;
      return user.id;
    } catch (e) {
      log('Error getting OneSignal player ID: $e');
      return null;
    }
  }

  static Future<void> sendTag(String key, String value) async {
    try {
      await OneSignal.User.addTagWithKey(key, value);
      log('OneSignal: Tag added - $key: $value');
    } catch (e) {
      log('Error adding OneSignal tag: $e');
    }
  }

  static Future<void> removeTag(String key) async {
    try {
      await OneSignal.User.removeTag(key);
      log('OneSignal: Tag removed - $key');
    } catch (e) {
      log('Error removing OneSignal tag: $e');
    }
  }

  // Check if OneSignal is initialized
  static bool get isInitialized => _isInitialized;

  // Ensure user is subscribed to push notifications
  static Future<bool> ensureUserSubscribed() async {
    try {
      log('OneSignal: Ensuring user is subscribed...');

      // Check current subscription status
      if (await _isUserSubscribed()) {
        log('OneSignal: User is already subscribed');
        return true;
      }

      // Request notification permissions
      log('OneSignal: Requesting notification permissions...');
      await OneSignal.Notifications.requestPermission(true);

      // Wait for subscription to be established
      await Future.delayed(const Duration(milliseconds: 2000));

      // Check again
      final isSubscribed = await _isUserSubscribed();
      if (isSubscribed) {
        log('OneSignal: ✅ User is now subscribed');
      } else {
        log(
          'OneSignal: ❌ User is still not subscribed. Check if permissions were granted.',
        );
      }

      return isSubscribed;
    } catch (e) {
      log('OneSignal: Error ensuring user subscription: $e');
      return false;
    }
  }

  // Force refresh user data and sync with OneSignal servers
  static Future<void> forceRefreshUserData() async {
    try {
      log('🔄 OneSignal: Force refreshing user data...');

      // Force opt-out and opt-in to refresh the subscription
      await OneSignal.User.pushSubscription.optOut();
      await Future.delayed(const Duration(milliseconds: 1000));
      await OneSignal.User.pushSubscription.optIn();

      // Wait for re-subscription
      await Future.delayed(const Duration(milliseconds: 3000));

      // Get fresh subscription info
      final pushSubscription = OneSignal.User.pushSubscription;
      final newSubscriptionId = pushSubscription.id;

      log('🔄 OneSignal: New Subscription ID: $newSubscriptionId');

      // Clear all tags first
      final currentTags = await OneSignal.User.getTags();
      for (String key in currentTags.keys) {
        await OneSignal.User.removeTag(key);
      }

      log('🔄 OneSignal: Cleared all existing tags');

      // Wait for tags to clear
      await Future.delayed(const Duration(milliseconds: 2000));

      log(
        '🔄 OneSignal: Force refresh completed. Re-run setExternalUserId now.',
      );
    } catch (e) {
      log('🔄 OneSignal: Error during force refresh: $e');
    }
  }

  // Manually trigger subscription (can be called from UI)
  static Future<void> manuallyRequestSubscription() async {
    try {
      log('OneSignal: Manually requesting subscription...');

      // Show permission prompt
      await OneSignal.Notifications.requestPermission(true);

      // Wait for user response
      await Future.delayed(const Duration(milliseconds: 3000));

      // Check subscription status
      final isSubscribed = await _isUserSubscribed();
      if (isSubscribed) {
        log('OneSignal: ✅ User granted permissions and is now subscribed');
      } else {
        log('OneSignal: ❌ User denied permissions or subscription failed');
      }

      // Run diagnostics
      await testExternalUserId();
    } catch (e) {
      log('OneSignal: Error during manual subscription request: $e');
    }
  }

  // Test method to verify external user ID is set correctly
  static Future<void> testExternalUserId() async {
    try {
      log('OneSignal Test - Starting diagnostics...');

      // Check initialization status
      log('OneSignal Test - Is initialized: $_isInitialized');

      // Check subscription status
      final pushSubscription = OneSignal.User.pushSubscription;
      final isSubscribed = pushSubscription.optedIn;
      final subscriptionId = pushSubscription.id;

      log('OneSignal Test - Subscription status: $isSubscribed');
      log('OneSignal Test - Subscription ID: $subscriptionId');

      // Check if user is subscribed
      final userIsSubscribed = await _isUserSubscribed();
      log('OneSignal Test - User is subscribed: $userIsSubscribed');

      // Get tags to verify external user ID (properly await the Future)
      final tags = await OneSignal.User.getTags();
      log('OneSignal Test - Current tags: $tags');

      // Log important info for dashboard matching
      log('🔍 DASHBOARD SEARCH INFO:');
      log('🔍 Look for Subscription ID: $subscriptionId');
      log(
        '🔍 Expected External ID: ${tags['external_user_id_set'] ?? 'Not set'}',
      );
      log('🔍 Timestamp: ${tags['external_user_id_timestamp'] ?? 'Not set'}');

      if (userIsSubscribed) {
        log(
          'OneSignal Test - ✅ User is properly subscribed. External ID should sync to dashboard.',
        );
        if (tags.containsKey('external_user_id_set')) {
          log(
            'OneSignal Test - ✅ External user ID tag found: ${tags['external_user_id_set']}',
          );
        } else {
          log('OneSignal Test - ❌ External user ID tag not found');
        }
      } else {
        log(
          'OneSignal Test - ❌ User is NOT subscribed. External ID will NOT appear in dashboard.',
        );
        log(
          'OneSignal Test - 💡 Make sure to grant notification permissions when prompted.',
        );
      }
    } catch (e) {
      log('OneSignal Test - Error during diagnostics: $e');
    }
  }
}
