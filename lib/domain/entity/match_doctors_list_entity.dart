class MatchDoctorsListEntity {
  final List<DoctorUserEntity>? doctors;

  MatchDoctorsListEntity({
    this.doctors,
  });

  @override
  String toString() {
    return 'MatchDoctorsListEntity{doctors: $doctors}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchDoctorsListEntity &&
          runtimeType == other.runtimeType &&
          doctors == other.doctors;

  @override
  int get hashCode => doctors.hashCode;
}

class DoctorUserEntity {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? type;
  final bool? isVerified;
  final String? profileImage;
  final String? createdAt;
  final String? updatedAt;
  final DoctorInfoDetailsEntity? doctorInfo;
  final List<UserLanguageEntity>? userLanguages;
  final List<UserQuestionnaireEntity>? userQuestionnaires;

  DoctorUserEntity({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.type,
    this.isVerified,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
    this.doctorInfo,
    this.userLanguages,
    this.userQuestionnaires,
  });

  @override
  String toString() {
    return 'DoctorUserEntity{id: $id, name: $name, email: $email, phone: $phone, type: $type, isVerified: $isVerified, profileImage: $profileImage, createdAt: $createdAt, updatedAt: $updatedAt, doctorInfo: $doctorInfo, userLanguages: $userLanguages, userQuestionnaires: $userQuestionnaires}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorUserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          type == other.type &&
          isVerified == other.isVerified &&
          profileImage == other.profileImage &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          doctorInfo == other.doctorInfo &&
          userLanguages == other.userLanguages &&
          userQuestionnaires == other.userQuestionnaires;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      type.hashCode ^
      isVerified.hashCode ^
      profileImage.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      doctorInfo.hashCode ^
      userLanguages.hashCode ^
      userQuestionnaires.hashCode;
}

class DoctorInfoDetailsEntity {
  final int? id;
  final int? userId;
  final String? specialization;
  final String? experience;
  final String? dob;
  final String? degree;
  final String? licenseNo;
  final int? countryId;
  final String? gender;
  final int? age;
  final int? approved;
  final int? completed;
  final String? createdAt;
  final String? updatedAt;

  DoctorInfoDetailsEntity({
    this.id,
    this.userId,
    this.specialization,
    this.experience,
    this.dob,
    this.degree,
    this.licenseNo,
    this.countryId,
    this.gender,
    this.age,
    this.approved,
    this.completed,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'DoctorInfoDetailsEntity{id: $id, userId: $userId, specialization: $specialization, experience: $experience, dob: $dob, degree: $degree, licenseNo: $licenseNo, countryId: $countryId, gender: $gender, age: $age, approved: $approved, completed: $completed, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorInfoDetailsEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          specialization == other.specialization &&
          experience == other.experience &&
          dob == other.dob &&
          degree == other.degree &&
          licenseNo == other.licenseNo &&
          countryId == other.countryId &&
          gender == other.gender &&
          age == other.age &&
          approved == other.approved &&
          completed == other.completed &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      specialization.hashCode ^
      experience.hashCode ^
      dob.hashCode ^
      degree.hashCode ^
      licenseNo.hashCode ^
      countryId.hashCode ^
      gender.hashCode ^
      age.hashCode ^
      approved.hashCode ^
      completed.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

class UserLanguageEntity {
  final int? id;
  final int? userId;
  final String? language;
  final String? createdAt;
  final String? updatedAt;

  UserLanguageEntity({
    this.id,
    this.userId,
    this.language,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'UserLanguageEntity{id: $id, userId: $userId, language: $language, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLanguageEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          language == other.language &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      language.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

class UserQuestionnaireEntity {
  final int? id;
  final int? userId;
  final String? key;
  final String? answer;
  final String? createdAt;
  final String? updatedAt;

  UserQuestionnaireEntity({
    this.id,
    this.userId,
    this.key,
    this.answer,
    this.createdAt,
    this.updatedAt,
  });

  // Helper methods to convert comma-separated strings to lists
  List<String> get answersList => answer?.split(',').where((s) => s.isNotEmpty).toList() ?? [];

  @override
  String toString() {
    return 'UserQuestionnaireEntity{id: $id, userId: $userId, key: $key, answer: $answer, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserQuestionnaireEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          key == other.key &&
          answer == other.answer &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      key.hashCode ^
      answer.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
