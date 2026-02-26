# Agora Video Call Setup Guide

## Step 1: Update Agora App ID

1. Open `lib/app/services/agora_video_service.dart`
2. Replace `'YOUR_AGORA_APP_ID'` with your actual Agora App ID from your Agora Console:

```dart
static const String appId = 'your_actual_app_id_here';
```

## Step 2: Token Generation

### For Testing (Development Only)
You can use Agora's test mode:
1. Go to your Agora Console
2. Navigate to your project
3. Enable "App Certificate" (optional for testing)
4. Use empty string for token in testing mode

### For Production
You MUST implement server-side token generation:

1. **Create a token server** that generates tokens using your App Certificate
2. **Update the token generation** in `video_call_controller.dart`:

```dart
// Replace this line in _initializeCall method:
token: AgoraVideoService.generateTestToken(_channelName.value, 0),

// With actual token from your server:
token: await _getTokenFromServer(_channelName.value, 0),
```

3. **Implement the server call method**:

```dart
Future<String> _getTokenFromServer(String channelName, int uid) async {
  // Call your backend API to generate token
  try {
    final response = await dio.post('/api/agora/token', data: {
      'channelName': channelName,
      'uid': uid,
    });
    return response.data['token'];
  } catch (e) {
    print('Error getting token: $e');
    return '';
  }
}
```

## Step 3: Platform Permissions

### Android
Add these permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

### iOS
Add these permissions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for video calls</string>
```

## Step 4: Testing the Video Call

1. **Update appointment card navigation** to pass channel information:
   - In your appointment card, make sure to pass a unique `channelName` for each call
   - Example: `channelName: 'appointment_${appointmentId}'`

2. **Test with two devices** or use Agora's web demo for testing

## Step 5: Production Checklist

- [ ] Replace test App ID with production App ID
- [ ] Implement server-side token generation
- [ ] Add proper error handling for network issues
- [ ] Test camera/microphone permissions on both platforms
- [ ] Implement call quality monitoring
- [ ] Add call recording (if needed)
- [ ] Test with different network conditions

## Common Issues & Solutions

### Issue: "App ID is invalid"
- **Solution**: Make sure you've replaced the placeholder App ID with your actual Agora App ID

### Issue: "Token expired" 
- **Solution**: Implement token refresh mechanism or use server-side token generation

### Issue: Permissions denied
- **Solution**: Check platform-specific permission declarations and handle permission requests properly

### Issue: No video/audio
- **Solution**: Check device permissions and ensure Agora engine is properly initialized

## Additional Features to Implement

1. **Call Recording**: Use Agora's cloud recording service
2. **Screen Sharing**: Already implemented for specialists
3. **Chat During Call**: Integration with your existing chat system
4. **Call Quality Monitoring**: Implement network quality callbacks
5. **Call Analytics**: Track call duration, quality metrics, etc.

For more information, visit the [Agora Flutter SDK Documentation](https://docs.agora.io/en/video-calling/get-started/get-started-sdk?platform=flutter).