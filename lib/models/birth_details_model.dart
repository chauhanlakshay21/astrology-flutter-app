class BirthDetailsModel {
  final String fullName;
  final String gender;
  final DateTime dateOfBirth;
  final String timeOfBirth;
  final String placeOfBirth;
  final String currentConcern;

  BirthDetailsModel({
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.placeOfBirth,
    required this.currentConcern,
  });

  String toFormattedString() {
    return '''
Name: $fullName
Gender: $gender
Date of Birth: ${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}
Time of Birth: $timeOfBirth
Place of Birth: $placeOfBirth
Current Concern: $currentConcern
''';
  }
}
