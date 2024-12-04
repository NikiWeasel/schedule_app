class Regulation {
  Regulation({
    this.id,
    required this.name,
    required this.duration,
    required this.cost,
  });

  String? id;
  final String name;
  final int duration;
  final int cost;
}
