class PaymentMethod {
  final String id;
  final String type;
  final String name;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final String? upiId;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.upiId,
    this.isDefault = false,
  });

  String get maskedCardNumber {
    if (cardNumber == null || cardNumber!.length < 4) return '••••';
    return '•••• ${cardNumber!.substring(cardNumber!.length - 4)}';
  }

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? name,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? upiId,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      upiId: upiId ?? this.upiId,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}