import 'dart:convert';

class UserPromote {
  final int id;
  final String cpf;
  final String nome;
  final String dtNascimento;
  final String email;
  final String telefone;
  final String foto;
  String status;
  final String empresa;

  UserPromote({
    required this.id,
    required this.cpf,
    required this.nome,
    required this.dtNascimento,
    required this.email,
    required this.telefone,
    required this.foto,
    required this.status,
    required this.empresa,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cpf': cpf,
      'nome': nome,
      'dtNascimento': dtNascimento,
      'email': email,
      'telefone': telefone,
      'foto': foto,
      'status': status,
      'empresa': empresa,
    };
  }

  factory UserPromote.fromMap(Map<String, dynamic> map) {
    return UserPromote(
      id: map['id'] ?? 0,
      cpf: map['cpf'] ?? '',
      nome: map['nome'] ?? '',
      dtNascimento: map['dtNascimento'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      foto: map['foto'] ?? '',
      status: map['status'] ?? '',
      empresa: map['empresa'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserPromote(id: $id, cpf: $cpf, nome: $nome, dtNascimento: $dtNascimento, email: $email, telefone: $telefone, foto: $foto, status: $status, empresa: $empresa)';
  }

  UserPromote copyWith({
    int? id,
    String? cpf,
    String? nome,
    String? dtNascimento,
    String? email,
    String? telefone,
    String? foto,
    String? status,
    String? empresa,
  }) {
    return UserPromote(
      id: id ?? this.id,
      cpf: cpf ?? this.cpf,
      nome: nome ?? this.nome,
      dtNascimento: dtNascimento ?? this.dtNascimento,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      foto: foto ?? this.foto,
      status: status ?? this.status,
      empresa: empresa ?? this.empresa,
    );
  }

  String toJson() => json.encode({"data": toMap()});

  factory UserPromote.fromJson(Map<String, dynamic> json) {
    return UserPromote(
      id: json['data']['id'],
      cpf: json['data']['cpf'],
      nome: json['data']['nome'],
      dtNascimento: json['data']['dtNascimento'],
      email: json['data']['email'],
      telefone: json['data']['telefone'],
      foto: json['data']['foto'],
      status: json['data']['status'],
      empresa: json['data']['empresa'],
    );
  }
}
