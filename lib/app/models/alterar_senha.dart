import 'dart:convert';

class AlterarSenha {
  String email;
  String passwordNew;
  AlterarSenha({
    required this.email,
    required this.passwordNew,
  });

  AlterarSenha copyWith({
    String? email,
    String? passwordNew,
  }) {
    return AlterarSenha(
      email: email ?? this.email,
      passwordNew: passwordNew ?? this.passwordNew,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'passwordNew': passwordNew,
    };
  }

  factory AlterarSenha.fromMap(Map<String, dynamic> map) {
    return AlterarSenha(
      email: map['email'] as String,
      passwordNew: map['passwordNew'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlterarSenha.fromJson(String source) => AlterarSenha.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AlterarSenha(email: $email, passwordNew: $passwordNew)';

  @override
  bool operator ==(covariant AlterarSenha other) {
    if (identical(this, other)) return true;

    return other.email == email && other.passwordNew == passwordNew;
  }

  @override
  int get hashCode => email.hashCode ^ passwordNew.hashCode;
}
