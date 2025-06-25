class UpdateTaskRequest {
  final int idPatient;
  final String title;
  final String description;
  final int status;
  final String startDate;

  UpdateTaskRequest({
    required this.idPatient,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'idPatient': idPatient,
      'title': title,
      'description': description,
      'status': status,
      'startDate': startDate,
    };
  }
}
