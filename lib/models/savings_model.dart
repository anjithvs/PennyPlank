class SavingsModel {
  String name;
  Map<int, int> noteCounts;

  SavingsModel({
    required this.name,
    required this.noteCounts,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'noteCounts':
      noteCounts.map((key, value) => MapEntry(key.toString(), value)),
    };
  }

  factory SavingsModel.fromJson(Map<String, dynamic> json) {
    return SavingsModel(
      name: json['name'],
      noteCounts: Map<String, dynamic>.from(json['noteCounts'])
          .map((key, value) =>
          MapEntry(int.parse(key), value as int)),
    );
  }
}