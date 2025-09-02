class JobRequest {
  final int id;
  final String channelName;
  final String channelDescription;
  final String role;
  final String status;

  JobRequest({
    required this.id,
    required this.channelName,
    required this.channelDescription,
    required this.role,
    required this.status,
  });

  factory JobRequest.fromJson(Map<String, dynamic> json) {
    return JobRequest(
      id: json['id'],
      channelName: json['channel']['name'],
      channelDescription: json['channel']['description'],
      role: json['role'],
      status: json['status']
    );
  }
}
