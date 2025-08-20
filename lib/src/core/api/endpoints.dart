class EndPoints {
  // News API endpoints
  // TODO: Configure this URL properly for your environment
  // For development, use localhost or your local server IP
  // For production, use your actual server URL
  // static const String baserUrl = "http://localhost:8084/api/v1/";
  static const String baserUrl = "https://admin.nahdat.org/api/v1/";

  static const String posts = "posts";
  static const String categories = "categories";
  static const String tags = "tags";
  static const String users = "users";
  static const String media = "media";
  static const String comments = "comments";
  static const String pages = "pages";

  // Auth API endpoints (assuming a different base URL for auth)
  static const String sendOTP = "auth/send_otp";
  static const String loginWithOtp = "auth/login";
  static const String register = "auth/register";
  static const String profile = "auth/me";

  // Voter API endpoints
  static const String voter = "voter";
  static const String pollingCenter = "polling_center";
  static const String locationUpdate = "location/update";
  static const String voterVoting = "voter/voting";

  // Strip API endpoints
  static const String strip = "strip_image";
  static const String search = "search";
  static const String statistics = "statistics";

  // Notification API endpoints
  static const String notifications = "notification";

  // Confirm Entry API endpoints
  static const String confirmEntry = "confirm_login";
}
