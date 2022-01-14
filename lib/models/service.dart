class Service {
  String id;
  String institutionId;
  String name;
  String category;
  String description;
  int length;
  double price;
  bool atLeast;
  int retainer;
  bool hasRetainer;

  Service({
    required this.institutionId,
    required this.id,
    required this.atLeast,
    required this.category,
    required this.description,
    required this.hasRetainer,
    required this.length,
    required this.name,
    required this.price,
    required this.retainer,
  });
}
