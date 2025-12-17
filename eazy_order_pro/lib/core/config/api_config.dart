
class ApiConfig {

  static const String baseUrl = 'http://dms.force360.in/api/V1';
  static const String apiVersion = 'v1';

  // API Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String defaulterList = '$baseUrl/contact/defaulter';
  static const String stats = '$baseUrl/contact/defaulter/stats';
  static const String addDefaulter = '$baseUrl/contact/defaulter/create';
}