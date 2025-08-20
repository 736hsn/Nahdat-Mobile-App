abstract class LoginState {}

class LoginInitial extends LoginState {}

class SendOtpLoading extends LoginState {}

class SendOtpSuccess extends LoginState {
  final String message;
  final String phoneNumber;

  SendOtpSuccess(this.message, this.phoneNumber);
}

class ResendOtpSuccess extends LoginState {
  final String message;
  final String phoneNumber;

  ResendOtpSuccess(this.message, this.phoneNumber);
}

class SendOtpError extends LoginState {
  final String error;

  SendOtpError(this.error);
}

class VerifyOtpLoading extends LoginState {}

class VerifyOtpSuccess extends LoginState {
  final String message;
  final String token;

  VerifyOtpSuccess(this.message, this.token);
}

class VerifyOtpError extends LoginState {
  final String error;

  VerifyOtpError(this.error);
}
