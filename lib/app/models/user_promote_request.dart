// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoterRequest {
  String password;
  String email;
  PromoterRequest({
    required this.password,
    required this.email,
  });

  PromoterRequest copyWith({
    String? password,
    String? email,
  }) {
    return PromoterRequest(
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'password': password,
      'email': email,
    };
  }

  factory PromoterRequest.fromMap(Map<String, dynamic> map) {
    return PromoterRequest(
      password: map['password'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoterRequest.fromJson(String source) => PromoterRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PromoterRequest(password: $password, email: $email)';

  @override
  bool operator ==(covariant PromoterRequest other) {
    if (identical(this, other)) return true;

    return other.password == password && other.email == email;
  }

  @override
  int get hashCode => password.hashCode ^ email.hashCode;
}
