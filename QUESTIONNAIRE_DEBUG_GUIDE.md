# 🔧 Questionnaire Debugging Guide

## **Debug Logs Added:**

I've added comprehensive logging throughout the questionnaire loading flow to help identify the issue:

### **Flow Tracking:**
1. **Controller**: `onInit()` → `_loadQuestionnaire()`
2. **Use Case**: `LoadQuestionnaireUseCase.execute()`
3. **Repository**: `QuestionnaireRepositoryImpl.getQuestionnaire()`
4. **Data Source**: `QuestionnaireDataSourceImpl.getQuestionnaire()`

### **Debug Output to Watch For:**

When you run the app and navigate to the questionnaire page, you should see these logs in order:

```
🎯 CONTROLLER: onInit() called - starting questionnaire loading
🔄 CONTROLLER: Starting questionnaire loading...
🔄 CONTROLLER: Calling loadQuestionnaireUseCase.execute()
🔄 USE CASE: LoadQuestionnaireUseCase.execute() called
🔄 USE CASE: Calling repository.getQuestionnaire()
🔄 REPOSITORY: getQuestionnaire() called
🔄 REPOSITORY: Calling datasource.getQuestionnaire()
🔍 DATASOURCE DEBUG: Loading questionnaire
✅ REPOSITORY: Datasource returned questionnaire: therapist_matching
✅ USE CASE: Repository returned questionnaire: therapist_matching
✅ USE CASE: Returning questionnaire with X questions
✅ CONTROLLER: Use case returned questionnaire: therapist_matching with X questions
✅ CONTROLLER: executeApiCall onSuccess callback triggered
✅ CONTROLLER: Setting questionnaire with X questions
📊 CONTROLLER: Questionnaire set successfully - ID: therapist_matching
🎯 CONTROLLER: onInit() completed
```

## **Troubleshooting Steps:**

### **1. Check if Controller is Created:**
If you don't see the `onInit()` logs:
- **Issue**: Controller not being instantiated
- **Solution**: Check if `QuestionnaireBinding` is properly registered in your route

### **2. Check if Use Case is Called:**
If you see controller logs but not use case logs:
- **Issue**: Dependency injection problem
- **Solution**: Verify `LoadQuestionnaireUseCase` is properly injected in `QuestionnaireBinding`

### **3. Check if Repository is Called:**
If you see use case logs but not repository logs:
- **Issue**: Repository not properly injected in UseCase module
- **Solution**: Check `UseCase module` → `loadQuestionnaireUseCase` → `questioniareRepository`

### **4. Check if Data Source is Called:**
If you see repository logs but not datasource logs:
- **Issue**: Data source not properly injected in Repository
- **Solution**: Check `RepositoryModule` → `questioniareRepository` → `questioniareDatasource`

### **5. Check if UI Updates:**
If you see all logs but UI still shows loading:
- **Issue**: Reactive binding problem
- **Solution**: Check if `Obx(() => widget.controller.questionnaire == null)` is working

## **Common Issues to Check:**

### **A. Dependency Injection:**
```dart
// In QuestionnaireBinding - ensure both are injected:
QuestionnaireController(
  addQuestionnairesUseCase: addQuestionnairesUseCase,  // ✅
  loadQuestionnaireUseCase: loadQuestionnaireUseCase,  // ✅ Check this
)
```

### **B. Route Registration:**
```dart
// Make sure your route uses the binding:
GetPage(
  name: AppRoutes.questionnaire,
  page: () => const QuestionnairePage(),
  binding: QuestionnaireBinding(),  // ✅ Check this
)
```

### **C. Controller Access:**
```dart
// In QuestionnairePage, ensure controller is accessible:
Obx(() => widget.controller.questionnaire == null)  // ✅ Should work
```

## **Quick Fix Options:**

### **Option 1: Manual Testing**
Add this to your QuestionnaireController for immediate testing:

```dart
// Temporary test method - call this from a button
void testLoad() async {
  debugPrint('🧪 TEST: Manual questionnaire load');
  await _loadQuestionnaire();
}
```

### **Option 2: Direct Sample Data**
If dependency injection is the issue, temporarily bypass it:

```dart
// In onInit(), add this fallback:
if (_questionnaire.value == null) {
  debugPrint('🔧 FALLBACK: Using direct sample data');
  _questionnaire.value = _createDirectSampleQuestionnaire();
}
```

## **Next Steps:**

1. **Run the app** and navigate to questionnaire page
2. **Check debug console** for the log sequence above
3. **Identify where the flow breaks** (no logs appear)
4. **Apply the corresponding troubleshooting step**

If you share the debug output, I can pinpoint exactly where the issue is! 🔍