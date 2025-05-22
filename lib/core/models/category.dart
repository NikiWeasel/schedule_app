class RegCategory {
  String? id;
  final String name;
  final String description;
  final List<String> regulationIds;

  RegCategory(
      {this.id,
      required this.name,
      required this.description,
      required this.regulationIds});
}
