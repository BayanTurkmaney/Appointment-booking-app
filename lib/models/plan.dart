class Plan {
  final String id, name, description, sku;
  final double price;
  final int employeesLimit, servicesLimit, length;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.sku,
    required this.price,
    required this.employeesLimit,
    required this.servicesLimit,
    required this.length,
  });
}
