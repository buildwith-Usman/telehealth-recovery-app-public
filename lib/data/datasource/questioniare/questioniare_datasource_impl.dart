import 'package:dio/dio.dart';
import 'package:recovery_consultation_app/data/datasource/questioniare/questioniare_datasource.dart';
import 'package:recovery_consultation_app/domain/models/questionnaire_models.dart';

import '../../api/api_client/api_client_type.dart';
import '../../api/request/add_questionnaires_request.dart';
import '../../api/response/add_questionnaires_response.dart';
import '../../api/response/error_response.dart';

class QuestioniareDataSourceImpl implements QuestioniareDatasource {
  QuestioniareDataSourceImpl({
    required this.apiClient,
  });

  final APIClientType apiClient;

  @override
  Future<AddQuestionnairesResponse?> addQuestionnaires(
      AddQuestionnairesRequest request) async {
    try {
      final response = await apiClient.addQuestionnaires(request);
      return response.data;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<Questionnaire> getQuestionnaire() async {
    return _createSampleQuestionnaire();
  }


  Questionnaire _createSampleQuestionnaire() {
    return Questionnaire(
      id: 'therapist_matching',
      title: 'Help Us Match You To The Right Therapist',
      description:
      'Answer a few questions to help us find the best therapist for your needs.',
      questions: [
        Question(
          id: 'therapist_gender_preference',
          title: 'What gender do you prefer your therapist to be?',
          type: QuestionType.singleSelection,
          isRequired: true,
          options: [
            const QuestionOption(id: 'male', text: 'Male'),
            const QuestionOption(id: 'female', text: 'Female'),
          ],
        ),
        Question(
          id: 'therapist_age_preference',
          title: 'What age do you prefer your therapist to be?',
          type: QuestionType.singleSelection,
          isRequired: true,
          options: [
            const QuestionOption(id: '20-35', text: '20–35 years'),
            const QuestionOption(id: '35-50', text: '35–50 years'),
            const QuestionOption(id: '50+', text: '50+ years'),
          ],
        ),
        Question(
          id: 'language_preference',
          title: 'What language do you prefer your therapist to speak?',
          type: QuestionType.multipleSelection,
          isRequired: true,
          options: [
            const QuestionOption(id: 'english', text: 'English'),
            const QuestionOption(id: 'urdu', text: 'Urdu'),
            const QuestionOption(id: 'pashto', text: 'Pashto'),
            const QuestionOption(id: 'punjabi', text: 'Punjabi'),
            const QuestionOption(id: 'siraiki', text: 'Siraiki'),
            const QuestionOption(id: 'sindhi', text: 'Sindhi'),
            const QuestionOption(id: 'balochi', text: 'Balochi'),
          ],
        ),
        Question(
          id: 'user_age_group',
          title: 'Which age group do you belong to?',
          type: QuestionType.singleSelection,
          isRequired: true,
          options: [
            const QuestionOption(id: 'teen', text: 'Teen'),
            const QuestionOption(id: 'adult', text: 'Adult'),
            const QuestionOption(id: 'senior', text: 'Senior'),
          ],
        ),
        Question(
          id: 'therapy_support_needs',
          title: 'What would you like help or support with?',
          subtitle: 'Select all that apply',
          type: QuestionType.multipleSelection,
          isRequired: true,
          options: [
            const QuestionOption(
                id: 'assessment_diagnosis',
                text: 'Formal Assessment and Diagnosis'),
            const QuestionOption(id: 'addictions', text: 'Addictions'),
            const QuestionOption(id: 'couple_counseling', text: 'Couple Counseling'),
            const QuestionOption(id: 'child_therapy', text: 'Child Therapy'),
            const QuestionOption(
                id: 'family_therapy', text: 'Family Therapy and Education'),
            const QuestionOption(id: 'other_therapies', text: 'Other Therapies'),
          ],
        ),
        Question(
          id: 'preferred_day',
          title: 'What is your preferred day for the sessions?',
          type: QuestionType.dropdown,
          isRequired: true,
          options: [
            const QuestionOption(id: 'monday', text: 'Monday'),
            const QuestionOption(id: 'tuesday', text: 'Tuesday'),
            const QuestionOption(id: 'wednesday', text: 'Wednesday'),
            const QuestionOption(id: 'thursday', text: 'Thursday'),
            const QuestionOption(id: 'friday', text: 'Friday'),
            const QuestionOption(id: 'saturday', text: 'Saturday'),
            const QuestionOption(id: 'sunday', text: 'Sunday'),
          ],
        ),
        Question(
          id: 'preferred_time',
          title: 'What is your preferred time for the sessions?',
          type: QuestionType.dropdown,
          isRequired: true,
          options: [
            const QuestionOption(id: 'morning', text: 'Morning (5 AM – 12 PM)'),
            const QuestionOption(id: 'afternoon', text: 'Afternoon (12 PM – 5 PM)'),
            const QuestionOption(id: 'evening', text: 'Evening (5 PM – 9 PM)'),
            const QuestionOption(id: 'night', text: 'Night (9 PM – 5 AM)'),
          ],
        ),
      ],
    );
  }
}
