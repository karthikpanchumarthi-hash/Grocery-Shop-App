class Address {
  final String id;
  final String type;
  final String name;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;
  final String? phone;
  final String? instructions;

  Address({
    required this.id,
    required this.type,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
    this.phone,
    this.instructions,
  });

  String get fullAddress {
    return '$street, $city, $state $zipCode, $country';
  }

  Address copyWith({
    String? id,
    String? type,
    String? name,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isDefault,
    String? phone,
    String? instructions,
  }) {
    return Address(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
      phone: phone ?? this.phone,
      instructions: instructions ?? this.instructions,
    );
  }
}