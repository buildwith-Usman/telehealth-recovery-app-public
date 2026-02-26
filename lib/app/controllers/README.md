# Generic Error Handling System

This system provides a centralized way to handle API errors across all controllers in the Flutter app.

## Components Created

### 1. `ErrorHandlerService` (`lib/app/services/error_handler_service.dart`)
- Centralized error handling logic
- Automatic field assignment based on error messages
- Toast notifications
- Status code-specific handling

### 2. `BaseController` (`lib/app/controllers/base_controller.dart`)
- Base class for all controllers
- Provides `executeApiCall()` method for automatic error handling
- Helper methods for error management

## How to Use

### Step 1: Extend BaseController
```dart
class YourController extends BaseController {
  // Your controller code
}
```

### Step 2: Define Error Fields
```dart
var nameError = RxnString();
var emailError = RxnString();
var phoneError = RxnString();
var generalError = RxnString();
var isLoading = false.obs;
```

### Step 3: Use executeApiCall for API Calls
```dart
Future<void> yourApiMethod() async {
  final fieldErrors = createCommonFieldErrors(
    nameError: nameError,
    emailError: emailError,
    phoneError: phoneError,
  );

  final result = await executeApiCall<YourReturnType>(
    apiCall: () async {
      return await yourApiService.callApi();
    },
    fieldErrors: fieldErrors,
    generalError: generalError,
    isLoading: isLoading,
    showToast: true,
    onSuccess: () {
      // Handle success
    },
  );

  if (result != null) {
    // Handle successful result
  }
}
```

## Error Handling Features

### Automatic Field Assignment
- "Email already taken" → automatically assigned to `emailError`
- "Phone number invalid" → automatically assigned to `phoneError`
- "Name is required" → automatically assigned to `nameError`
- Other errors → assigned to `generalError`

### Status Code Handling
- **0** (Network): Connection error message
- **401** (Unauthorized): Session expired + re-auth flag
- **422** (Validation): Field-specific error assignment
- **409** (Conflict): Resource already exists (email/phone taken)
- **500+** (Server): Server unavailable message
- **Others**: Use API message or generic fallback

### Automatic Features
- ✅ Loading state management
- ✅ Error field clearing before API calls
- ✅ Toast notifications
- ✅ Type-safe return values
- ✅ Consistent error messages

## Migration Example

### Before (Manual Error Handling)
```dart
Future<void> signUp() async {
  try {
    clearSignupError();
    isLoading.value = true;
    
    final result = await signUpUseCase.execute(params);
    // Handle result...
    
  } on BaseErrorEntity catch (error) {
    if (error.statusCode == 422) {
      if (error.message?.contains('email') == true) {
        emailError.value = error.message;
      }
      // More manual error handling...
    }
  } catch (e) {
    signupErrorMessage.value = "An unexpected error occurred";
  } finally {
    isLoading.value = false;
  }
}
```

### After (Generic Error Handling)
```dart
Future<void> signUp() async {
  final fieldErrors = createCommonFieldErrors(
    nameError: nameError,
    emailError: emailError,
    phoneError: mobileError,
  );

  final result = await executeApiCall<SignUpEntity>(
    apiCall: () => signUpUseCase.execute(params),
    fieldErrors: fieldErrors,
    generalError: signupErrorMessage,
    isLoading: isLoading,
    showToast: true,
    onSuccess: () => signupSuccess.value = true,
  );

  if (result != null) {
    goToOtpScreen(result.verificationRequired);
  }
}
```

## Benefits

1. **Consistency**: All controllers handle errors the same way
2. **DRY Principle**: No code duplication
3. **Maintainability**: Error logic centralized in one place
4. **User Experience**: Consistent error messages and toasts
5. **Type Safety**: Generic return types
6. **Flexibility**: Can be customized per controller when needed

## Example Usage in SignupController

The `SignupController` has been updated to demonstrate this pattern:
- Extends `BaseController`
- Uses `executeApiCall()` for the signup method
- Automatic error assignment to form fields
- Simplified error clearing

This pattern can now be applied to all other controllers (LoginController, ForgotPasswordController, etc.) for consistent error handling across the entire app.
