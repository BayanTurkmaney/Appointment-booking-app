class Appointment {
  final String id, date, institutionId, employeeId, userId, history;
  final List<String> servicesIds;

  Appointment({
    required this.id,
    required this.history,
    required this.date,
    required this.institutionId,
    required this.employeeId,
    required this.userId,
    required this.servicesIds,
  });
}
