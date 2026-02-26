import 'package:get/get.dart';
import '../../domain/usecase/set_access_token_use_case.dart';
import '../../domain/usecase/get_access_token_use_case.dart';

/// Service to handle access token recovery and persistence
/// This service helps recover from token save failures
class TokenRecoveryService extends GetxService {
  TokenRecoveryService({
    required this.setAccessTokenUseCase,
    required this.getAccessTokenUseCase,
  });

  final SetAccessTokenUseCase setAccessTokenUseCase;
  final GetAccessTokenUseCase getAccessTokenUseCase;

  // Temporary storage for failed token saves
  String? _pendingAccessToken;
  bool _isRecovering = false;

  /// Store token temporarily if saving to preferences fails
  void storePendingToken(String token) {
    _pendingAccessToken = token;
    print("🔒 Token stored temporarily for recovery: ${token.substring(0, 10)}...");
  }

  /// Attempt to recover and save any pending tokens
  /// This should be called on app startup or when connectivity is restored
  Future<bool> attemptTokenRecovery() async {
    if (_pendingAccessToken == null || _isRecovering) {
      return true; // No pending token or already recovering
    }

    _isRecovering = true;
    print("🔄 Attempting to recover pending access token...");

    try {
      // First check if token is already saved
      final existingToken = await getAccessTokenUseCase.execute();
      if (existingToken != null && existingToken.isNotEmpty) {
        print("✅ Token already exists in preferences, clearing pending token");
        _pendingAccessToken = null;
        _isRecovering = false;
        return true;
      }

      // Attempt to save the pending token
      await setAccessTokenUseCase.execute(_pendingAccessToken!);
      print("✅ Successfully recovered and saved pending token");
      _pendingAccessToken = null;
      _isRecovering = false;
      return true;

    } catch (error) {
      print("❌ Token recovery failed: $error");
      _isRecovering = false;
      return false;
    }
  }

  /// Check if there's a pending token that needs recovery
  bool get hasPendingToken => _pendingAccessToken != null;

  /// Get the pending token (for emergency access)
  String? get pendingToken => _pendingAccessToken;

  /// Clear any pending tokens (call this after successful manual recovery)
  void clearPendingToken() {
    _pendingAccessToken = null;
    print("🧹 Cleared pending token");
  }

  /// Save token with automatic retry and fallback to pending storage
  Future<bool> saveTokenSafely(String token) async {
    const maxRetries = 3;
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        await setAccessTokenUseCase.execute(token);
        print("✅ Access token saved successfully (attempt $attempt)");
        
        // Clear any pending token since save was successful
        if (_pendingAccessToken != null) {
          clearPendingToken();
        }
        
        return true;
        
      } catch (error) {
        print("❌ Failed to save token (attempt $attempt/$maxRetries): $error");
        
        if (attempt == maxRetries) {
          // All retries failed - store as pending for recovery
          storePendingToken(token);
          print("🚨 All save attempts failed. Token stored for recovery.");
          return false;
        }
        
        // Wait before retry with exponential backoff
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
    
    return false;
  }
}
