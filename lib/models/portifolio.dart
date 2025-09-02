class Portfolio {
  final int id;
  final String text;
  final String audioFile;
  final double? cer;
  final double? der;
  final double? wer;
  final String? error;

  Portfolio({
    required this.id,
    required this.text,
    required this.audioFile,
    this.cer,
    this.der,
    this.wer,
    this.error,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    final score = json['score'];
    return Portfolio(
      id: json['id'],
      text: json['text_data']?['text'] ?? "",
      audioFile: json['recorde_data']?['file'] ?? "",
      cer: score is Map && score['cer'] != null ? (score['cer'] as num).toDouble() : null,
      der: score is Map && score['der'] != null ? (score['der'] as num).toDouble() : null,
      wer: score is Map && score['wer'] != null ? (score['wer'] as num).toDouble() : null,
      error: score is Map && score['error'] != null ? score['error'] : null,
    );
  }
}
