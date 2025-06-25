class Task {
  final String idPatient;
  final String title;
  final String description;
  final int status;
  final String startDate;

  Task({
    required this.idPatient,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
  });

  // Método para convertir el status a texto
  String get statusText {
    switch (status) {
      case 0:
        return 'Pendiente';
      case 1:
        return 'En progreso';
      case 2:
        return 'Completada';
      default:
        return 'Desconocido';
    }
  }

  // Para parsear desde JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      idPatient: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 0,
      startDate: json['startDate'] ?? '',
    );
  }

  // Para enviar como JSON
  Map<String, dynamic> toJson() {
    return {
      'id': idPatient,
      'title': title,
      'description': description,
      'status': status,
      'startDate': startDate,
    };
  }
}
