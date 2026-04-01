class Outbound {
  int id;
  String? name;
  bool? status;
  DateTime? date;
  String? unit_type;
  double? taken_quantity;
  double? sold_quantity;
  double? remaining_quantity;
  double? total_value_item;
  String? observation;


  Outbound({required this.id, this.name, this.status, this.date, this.unit_type, this.taken_quantity, this.sold_quantity, this.remaining_quantity, this.total_value_item, this.observation});

  factory Outbound.fromJson(Map<String, dynamic> json) {
    return Outbound(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      date: json['data'] != null ? DateTime.parse(json['data']) : null,
      unit_type: json['unidade'],
      taken_quantity: (json['taken_quantity'] as num?)?.toDouble(),
      sold_quantity: (json['sold_quantity'] as num?)?.toDouble(),
      remaining_quantity: (json['remaining_quantity'] as num?)?.toDouble(),
      total_value_item: (json['total_value'] as num?)?.toDouble(),
      observation: json['observacao'],
    );
  }
}