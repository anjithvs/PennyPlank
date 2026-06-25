class SavingsModel {
  String name;
  Map<int, int> moneyCounts;

  SavingsModel({
    required this.name,
    required this.moneyCounts,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'moneyCounts':
      moneyCounts.map((key, value) => MapEntry(key.toString(), value)),
    };
  }

  factory SavingsModel.fromJson(Map<String, dynamic> json) {
    return SavingsModel(
      name: json['name'],
      moneyCounts: Map<String, dynamic>.from(json['moneyCounts']).map(
            (key, value) => MapEntry(int.parse(key), value as int),
      ),
    );
  }
}