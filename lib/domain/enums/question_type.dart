/// Enum for different types of questions in a questionnaire
/// Defines the UI component and behavior for each question type
enum QuestionType {
  /// Radio buttons - single choice from options
  multipleChoice,
  
  /// Dropdown menu - single selection from a list
  dropdown,
  
  /// Single selection (radio buttons or similar)
  singleSelection,
  
  /// Multiple selection with checkboxes
  multipleSelection,
  
  /// Text input field for open-ended responses
  textInput,
  
  /// Numeric input field for number values
  numberInput,
  
  /// Date picker input for date selection
  dateInput,
}

/// Extension methods for QuestionType enum
extension QuestionTypeExtension on QuestionType {
  /// Human-readable display name for the question type
  String get displayName {
    switch (this) {
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.dropdown:
        return 'Dropdown';
      case QuestionType.singleSelection:
        return 'Single Selection';
      case QuestionType.multipleSelection:
        return 'Multiple Selection';
      case QuestionType.textInput:
        return 'Text Input';
      case QuestionType.numberInput:
        return 'Number Input';
      case QuestionType.dateInput:
        return 'Date Input';
    }
  }

  /// Whether this question type allows multiple answers
  bool get allowsMultipleAnswers {
    switch (this) {
      case QuestionType.multipleSelection:
        return true;
      case QuestionType.multipleChoice:
      case QuestionType.dropdown:
      case QuestionType.singleSelection:
      case QuestionType.textInput:
      case QuestionType.numberInput:
      case QuestionType.dateInput:
        return false;
    }
  }

  /// Whether this question type requires predefined options
  bool get requiresOptions {
    switch (this) {
      case QuestionType.multipleChoice:
      case QuestionType.dropdown:
      case QuestionType.singleSelection:
      case QuestionType.multipleSelection:
        return true;
      case QuestionType.textInput:
      case QuestionType.numberInput:
      case QuestionType.dateInput:
        return false;
    }
  }

  /// Whether this question type accepts text input
  bool get acceptsTextInput {
    switch (this) {
      case QuestionType.textInput:
        return true;
      case QuestionType.multipleChoice:
      case QuestionType.dropdown:
      case QuestionType.singleSelection:
      case QuestionType.multipleSelection:
      case QuestionType.numberInput:
      case QuestionType.dateInput:
        return false;
    }
  }

  /// Icon name or identifier for UI representation
  String get iconName {
    switch (this) {
      case QuestionType.multipleChoice:
        return 'radio_button_checked';
      case QuestionType.dropdown:
        return 'arrow_drop_down';
      case QuestionType.singleSelection:
        return 'radio_button_checked';
      case QuestionType.multipleSelection:
        return 'check_box';
      case QuestionType.textInput:
        return 'text_fields';
      case QuestionType.numberInput:
        return 'numbers';
      case QuestionType.dateInput:
        return 'date_range';
    }
  }
}