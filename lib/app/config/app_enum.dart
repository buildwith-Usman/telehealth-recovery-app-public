// Define All App Level Enum here

enum ScreenName {
  signUp,
  specialistSignUp,
  login,
  forgotPassword,
  otp,
  password,
  setting
}

enum UserRole {
  patient,
  doctor,
  specialist,
  admin,
}

enum SpecialistType {
  therapist,
  psychiatrist,
}

enum AgeGroup {
  teen,
  adult,
  senior,
}

enum AreaOfExpertise {
  formalAssessmentAndDiagnosis,
  addictions,
  coupleCounseling,
  childTherapy,
  familyTherapyAndEducation,
  otherTherapies,
}

enum OtpVerificationType {
  signup,
  forgot,
}

enum AdminSessionType { upcoming, ongoing, cancelled, completed }

enum SpecialistStatus {
  pending,
  rejected,
  approved
}

enum AppointmentType {
  upcoming,
  completed,
  ongoing
}

enum AppointmentStatus {
  draft,
  pending,
  completed,
  cancelled
}

enum CallStatus {
  connecting,
  connected,
  disconnected,
  ended
}
