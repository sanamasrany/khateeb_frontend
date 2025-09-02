class Level {
  final String id;
  final String text;
  final String createdById;

  Level({
    required this.id,
    required this.text,
    required this.createdById,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'].toString(),
      text: json['text'],
      createdById: json['created_by']?['id'].toString() ?? '0',
    );
  }
}


class Level1 {
  final String id;
  final String text;
  final String createdById;
  final String createdByName;
  final String? createdByPhoto;

  Level1({
    required this.id,
    required this.text,
    required this.createdById,
    required this.createdByName,
    this.createdByPhoto,
  });

  factory Level1.fromJson(Map<String, dynamic> json) {
    final textObj = json['text'] ?? {};
    final createdBy = textObj['created_by'] ?? {};

    return Level1(
      id: json['id'].toString(),
      text: textObj['text'] ?? "",
      createdById: createdBy['id']?.toString() ?? "0",
      createdByName: "${createdBy['first_name'] ?? ''} ${createdBy['last_name'] ?? ''}".trim(),
      createdByPhoto: createdBy['photo'],
    );
  }
}

