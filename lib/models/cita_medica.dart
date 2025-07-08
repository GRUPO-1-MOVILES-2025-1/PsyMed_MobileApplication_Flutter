class CitaMedica {
  final int? id;
  final String patientId;
  final String date;
  final String startTime;
  final String endTime;
  final bool important;
  final int medicoId;

  CitaMedica({
    this.id,
    required this.patientId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.important,
    required this.medicoId,
  });

  factory CitaMedica.fromJson(Map<String, dynamic> json) {
    return CitaMedica(
      id: json['id'],
      patientId: json['patientId'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      important: json['important'],
      medicoId: json['medicoId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'important': important,
        'medicoId': medicoId,
      };
}
