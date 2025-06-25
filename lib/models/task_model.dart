class Task {
  final String id;
  final int idPatient;
  final String title;
  final String description;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.idPatient,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      idPatient: json['idPatient'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idPatient': idPatient,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Getters para compatibilidad con el código existente de medicamentos
  String get name => title;
  String get dosage => description;
  String get quantity => 'Status: $status';
  String get startDate => createdAt.toString().split(' ')[0];
  String get endDate => updatedAt.toString().split(' ')[0];

  // Método para obtener el estado como texto
  String get statusText {
    switch (status) {
      case 0:
        return 'Pendiente';
      case 1:
        return 'En Progreso';
      case 2:
        return 'Completada';
      default:
        return 'Desconocido';
    }
  }
}

class CreateTaskRequest {
  final int idPatient;
  final String title;
  final String description;
  final int status;

  CreateTaskRequest({
    required this.idPatient,
    required this.title,
    required this.description,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'idPatient': idPatient,
      'title': title,
      'description': description,
      'status': status,
    };
  }
}

class UpdateTaskRequest {
  final String title;
  final String description;
  final int status;

  UpdateTaskRequest({
    required this.title,
    required this.description,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
    };
  }
}