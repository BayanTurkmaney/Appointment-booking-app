class Institution {
  final String ownerId,
      id,
      name,
      email,
      subtitle,
      description,
      category,
      paypalEmail,
      photo;
  final double rate;
  final String? planId, phone;
  final int openAt, closeAt;
  final bool freezed, notified, blocked;
  final List<String> subCategories, openingDays;
  final List<String> sliderImages;
  final Map<String, String> address;

  Institution({
    required this.id,
    required this.category,
    required this.email,
    required this.closeAt,
    required this.description,
    required this.ownerId,
    required this.name,
    required this.openAt,
    required this.photo,
    required this.subtitle,
    required this.openingDays,
    required this.paypalEmail,
    required this.subCategories,
    required this.address,
    required this.blocked,
    required this.freezed,
    required this.notified,
    required this.rate,
    required this.sliderImages,
    this.planId,
    this.phone,
  });
}
