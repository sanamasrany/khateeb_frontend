class TextModel {
  final int id;
  final String text;

  TextModel({required this.id, required this.text});

  factory TextModel.fromJson(Map<String, dynamic> json) {
    return TextModel(
      id: json['id'],
      text: json['text'],
    );
  }
}

class ChannelModel {
  final int id;
  final String name;
  final String description;

  ChannelModel({required this.id, required this.name, required this.description});

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class EmployeeModel {
  final int id;
  final String fullName;
  final String role;

  EmployeeModel({required this.id, required this.fullName, required this.role});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return EmployeeModel(
      id: user['id'],
      fullName: "${user['first_name']} ${user['last_name']}",
      role: json['role'],
    );
  }
}
