class SalePoint {
  final int? id;
  final String? name;
  final String? email;
  final String? password;

  SalePoint({
    this.id,
    this.name,
    this.email,
    this.password
  });

  factory SalePoint.fromJson(Map<String, dynamic> json) {
    return SalePoint(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (password != null) 'password': password, 
    };
  }
}