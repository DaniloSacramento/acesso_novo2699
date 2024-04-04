// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StatusTeste {
  String status;
  StatusTeste({
    required this.status,
  });

  StatusTeste copyWith({
    String? status,
  }) {
    return StatusTeste(
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
    };
  }

  factory StatusTeste.fromMap(Map<String, dynamic> map) {
    return StatusTeste(
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusTeste.fromJson(String source) => StatusTeste.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'StatusTeste(status: $status)';

  @override
  bool operator ==(covariant StatusTeste other) {
    if (identical(this, other)) return true;

    return other.status == status;
  }

  @override
  int get hashCode => status.hashCode;
}
