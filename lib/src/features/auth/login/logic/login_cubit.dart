import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';
import 'package:supervisor/src/core/services/auth_service.dart';
import '../../../../core/api/dio_consumer.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/common/models/result.dart';
import '../../../../core/utils/generated/translation/locale_keys.g.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  // "message": "user is not active"
  //

  final DioConsumer _dioConsumer = DioConsumer();
  final AuthService _authService = getIt<AuthService>();
  String? _phoneNumber;

  LoginCubit() : super(LoginInitial());

  String? get phoneNumber => _phoneNumber;

  Future<void> sendOtp(String phoneNumber, {bool isResend = false}) async {
    try {
      emit(SendOtpLoading());
      _phoneNumber = phoneNumber;

      final Result<Response> result = await _dioConsumer.post(
        endpoint: EndPoints.sendOTP,
        body: {'phone': phoneNumber},
      );

      if (result.isSuccess) {
        log('OTP sent successfully :${result.data?.data?['message']}');
        isResend
            ? emit(
                ResendOtpSuccess(
                  result.data?.data?['message'] ?? 'OTP sent successfully',
                  phoneNumber,
                ),
              )
            : emit(
                SendOtpSuccess(
                  result.data?.data?['message'] ?? 'OTP sent successfully',
                  phoneNumber,
                ),
              );
      } else {
        log('OTP not sent :${result.error}');
        emit(SendOtpError(_getErrorMessage(result.error)));
      }
    } catch (e) {
      log('Exception in sendOtp: $e');
      emit(SendOtpError(_getErrorMessage(e.toString())));
    }
  }

  Future<void> verifyOtp(String otp) async {
    print("-----------verifyOtp-----------");
    print("-----------otp-----------");
    print(otp);
    print("-----------_phoneNumber-----------");
    print(_phoneNumber);
    try {
      emit(VerifyOtpLoading());

      final Result<Response> result = await _dioConsumer.post(
        endpoint: EndPoints.loginWithOtp,
        body: {'phone': _phoneNumber, 'otp': otp},
      );

      if (result.isSuccess) {
        final token = result.data?.data?['token'];

        if (token != null) {
          // Save token and user data using AuthService
          await _authService.saveToken(token);

          emit(
            VerifyOtpSuccess(
              result.data?.data?['message'] ?? 'OTP verified successfully',
              token,
            ),
          );
          log('Login successful');
        } else {
          emit(
            VerifyOtpError(
              'Authentication failed: Token not found in response',
            ),
          );
        }
      } else {
        emit(VerifyOtpError(_getErrorMessage(result.error)));
      }
    } catch (e) {
      log('Exception in verifyOtp: $e');
      emit(VerifyOtpError(_getErrorMessage(e.toString())));
    }
  }

  String _getErrorMessage(String? error) {
    if (error == null) return LocaleKeys.connectionError;

    // Check for common connection errors
    if (error.contains('Connection refused') ||
        error.contains('connection error') ||
        error.contains('SocketException')) {
      return LocaleKeys.serverNotAvailable;
    }

    // Check for timeout errors
    if (error.contains('timeout') || error.contains('TimeoutException')) {
      return LocaleKeys.connectionError;
    }

    // For other errors, try to extract meaningful message
    if (error.contains('DioException')) {
      return LocaleKeys.connectionError;
    }

    // Return the error as is if it's a simple message
    return error;
  }

  void reset() {
    _phoneNumber = null;
    emit(LoginInitial());
  }
}
