import 'dart:developer';
import 'dart:ui';
import 'package:supervisor/src/core/utils/functions/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FunctionsApp {
  // static String formatDate(String isoDateString) {
  //   try {
  //     DateTime dateTime =
  //         DateFormat(
  //           "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'",
  //         ).parseUTC(isoDateString).toLocal();
  //     DateTime now = DateTime.now();
  //
  //     Duration difference = now.difference(dateTime);
  //     int daysDifference = difference.inDays;
  //
  //     if (dateTime.year == now.year) {
  //       if (daysDifference == 0) {
  //         return DateFormat.jm().format(dateTime);
  //       } else if (daysDifference > 0 && daysDifference <= 7) {
  //         return DateFormat.E().format(dateTime);
  //       } else {
  //         return DateFormat.MMMd().format(dateTime);
  //       }
  //     } else {
  //       return '${dateTime.year}, ${DateFormat.MMM().format(dateTime)} ${dateTime.day}';
  //     }
  //   } catch (e) {
  //     return 'Invalid date';
  //   }
  // }

  static Future<String> selectTime(
    BuildContext context,
    bool isFromTime,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              titleMedium: TextStyle(fontFamily: 'Cairo'),
              labelLarge: TextStyle(fontFamily: 'Cairo'),
            ),
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      return formattedTime;
    }
    return '';
  }

  static Future<String> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontFamily: 'Cairo'),
              titleMedium: TextStyle(fontFamily: 'Cairo'),
              labelLarge: TextStyle(fontFamily: 'Cairo'),
              headlineLarge: TextStyle(fontFamily: 'Cairo'),
              titleSmall: TextStyle(fontFamily: 'Cairo'),
            ),
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      print('the date is : $pickedDate');
      return pickedDate.toString();
    }
    return '';
  }

  static String formatDate(String inputDate) {
    try {
      final dateTime = DateTime.parse(
        inputDate.replaceAll(' am', '').replaceAll(' pm', ''),
      );
      return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return inputDate;
    }
  }

  static String handleErrorMessage(String error) {
    if (error.contains('Network is unreachable')) {
      return 'a network error has occurred. please try again later.'.tr();
    } else if (error.contains('The phone has already been taken')) {
      return 'phone number already in use. please use a different one.'.tr();
    } else if (error.contains('The OTP is invalid or has expired.')) {
      return 'the OTP is invalid or has expired'.tr();
    } else if (error.contains(
      'there is no internet connection and there is not any last known location',
    )) {
      return 'there is no internet connection and there is not any last known location for you. try connecting to the internet'
          .tr();
    } else if (error.contains(
      'please wait until your current location is fetched',
    )) {
      return 'please wait until your current location is fetched'.tr();
    } else if (error.contains('reset by peer')) {
      return 'a network error has occurred. please try again later.'.tr();
    } else if (error.contains(
      'please connect to the internet to open the map',
    )) {
      return 'please connect to the internet to open the map. last known location will be used when there is no internet'
          .tr();
    } else if (error.contains(
      'you must connect to the internet to open the map',
    )) {
      return 'you must connect to the internet to open the map'.tr();
    } else if (error.contains('location is off')) {
      return 'please enable location services to use the map'.tr();
    } else if (error.contains(
      'The media.1 field must be a file of type: jpg, jpeg',
    )) {
      return 'the image format for the selected photos is not supported. please use a different format'
          .tr();
    } else if (error.contains("Data too long for column 'description'")) {
      return 'description field data is too long. please use a shortened description for the complaint'
          .tr();
    } else {
      return 'unknown error occurred. please try again later'.tr();
    }
  }

  static String formatDateTimeAgo(DateTime inputDate) {
    final now = DateTime.now();
    final difference = now.difference(inputDate);

    // Handle future dates
    if (difference.isNegative) {
      return 'future_date'.tr();
    }

    // Handle different time periods with proper localization and pluralization
    if (difference.inSeconds < 60) {
      return 'الأن';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      if (minutes == 1) {
        return 'دقيقة';
      } else if (minutes == 2) {
        return 'دقيقتين';
      } else if (minutes < 11) {
        return 'منذ ${minutes} دقائق';
      } else {
        return 'منذ ${minutes} دقائق';
      }
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      if (hours == 1) {
        return 'ساعة';
      } else if (hours == 2) {
        return 'ساعتين';
      } else if (hours < 11) {
        return 'منذ ${hours} ساعات';
      } else {
        return 'منذ ${hours} ساعات';
      }
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      if (days == 1) {
        return 'اليوم';
      } else if (days == 2) {
        return 'اليوم السابق';
      } else {
        return '${days} أيام';
      }
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      if (weeks == 1) {
        return 'أسبوع';
      } else if (weeks == 2) {
        return 'أسبوعين';
      } else {
        return 'منذ ${weeks} أسابيع';
      }
    } else if (difference.inDays < 365) {
      // More precise month calculation
      final inputMonth = inputDate.month;
      final nowMonth = now.month;
      final inputYear = inputDate.year;
      final nowYear = now.year;

      int months = (nowYear - inputYear) * 12 + (nowMonth - inputMonth);

      // Adjust if the day hasn't passed yet this month
      if (now.day < inputDate.day) {
        months--;
      }

      if (months <= 0) {
        months = 1;
      }

      if (months == 1) {
        return 'شهر';
      } else if (months == 2) {
        return 'شهرين';
      } else if (months < 11) {
        return 'منذ ${months} أشهر';
      } else {
        return 'منذ ${months} أشهر';
      }
    } else {
      final years = now.year - inputDate.year;
      if (years == 1) {
        return 'سنة';
      } else if (years == 2) {
        return 'سنتين';
      } else if (years < 11) {
        return 'منذ ${years} سنوات';
      } else {
        return 'منذ ${years} سنوات';
      }
    }
  }
}

Future<void> launchPhone(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    log('Could not open phone app');
  }
}

Future<void> launchWhatsApp(String phoneNumber) async {
  final Uri launchUri = Uri.parse('https://wa.me/$phoneNumber');
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    log('Could not whatsapp app');
  }
}

Color hexToColor(String code) {
  try {
    print('Raw color string: "$code"');

    // Handle null/empty
    if (code.isEmpty || code.trim().isEmpty) {
      return const Color(0xFF333333); // Fallback
    }

    // Remove # and ensure 6 chars
    String hex = code.replaceAll('#', '').padRight(6, '0').substring(0, 6);

    // Parse as RRGGBB, then add FF alpha in Color()
    return Color(int.parse(hex, radix: 16) | 0xFF000000);
  } catch (e) {
    print('Error parsing color "$code": $e');
    return const Color(0xFF333333); // Fallback
  }
}

String formatDateTime(String inputDate) {
  final dateTime = DateTime.parse(inputDate);
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
}
