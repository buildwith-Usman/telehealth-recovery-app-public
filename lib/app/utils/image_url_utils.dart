import '../config/app_config.dart';

/// Utility class for handling image URLs across the application
/// 
/// Centralizes image URL construction logic and eliminates hardcoded base URLs.
/// Uses the app configuration to get the current base URL for different environments.
/// 
/// Usage:
/// ```dart
/// String imageUrl = ImageUrlUtils().getFullImageUrl('/storage/profile/image.jpg');
/// // Returns: http://recoveryapp.stacksgather.com/storage/profile/image.jpg
/// ```
class ImageUrlUtils {
  static final ImageUrlUtils _instance = ImageUrlUtils._internal();
  factory ImageUrlUtils() => _instance;
  ImageUrlUtils._internal();

  /// Get the base URL from app configuration
  String get _baseUrl => AppConfig.shared.baseUrl;

  /// Construct full image URL from relative path
  /// Returns empty string if url is null or empty
  /// If url is already absolute (starts with http), returns as-is
  /// Otherwise prepends the base URL
  String getFullImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return '';
    }
    
    // If URL is already absolute, return as-is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    
    // Ensure proper path formatting
    String baseUrl = _baseUrl.endsWith('/') ? _baseUrl : '$_baseUrl/';
    String imagePath = url.startsWith('/') ? url.substring(1) : url;
    
    return '$baseUrl$imagePath';
  }

  /// Get profile image URL with fallback to placeholder
  String getProfileImageUrl(String? imageUrl, {String? fallbackUrl}) {
    String fullUrl = getFullImageUrl(imageUrl);
    
    if (fullUrl.isEmpty && fallbackUrl != null) {
      return getFullImageUrl(fallbackUrl);
    }
    
    return fullUrl;
  }

  /// Validate if URL is a valid image URL
  bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg'];
    final lowercaseUrl = url.toLowerCase();
    
    return validExtensions.any((ext) => lowercaseUrl.contains(ext));
  }
}