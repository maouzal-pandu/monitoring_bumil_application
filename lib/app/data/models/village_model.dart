class VillageModel {
  final int id;
  final String name;

  VillageModel({required this.id, required this.name});

  factory VillageModel.fromJson(Map<String, dynamic> json) {
    return VillageModel(id: json["id"], name: json["nama"]);
  }
}
