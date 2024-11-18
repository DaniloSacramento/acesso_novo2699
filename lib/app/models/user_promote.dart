import 'dart:convert';

import 'package:acessonovo/app/models/empresa_model.dart';

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
  final List<Empresas> empresas;

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
    required this.empresas,
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
      'empresas': empresas?.map((e) => e.toMap()).toList(),
    };
  }

  factory UserPromote.fromMap(Map<String, dynamic> map) {
    List<Empresas> empresasList = [];
    if (map['empresas'] != null) {
      empresasList = List<Empresas>.from(
        (map['empresas'] as List).map((e) => Empresas.fromMap(e as Map<String, dynamic>)),
      );
    }
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
      empresas: empresasList,
    );
  }

  String toJson() => json.encode({"data": toMap()});

  factory UserPromote.fromJson(Map<String, dynamic> json) {
    List<Empresas> empresasList = [];
    if (json['data']['empresas'] != null) {
      empresasList = List<Empresas>.from(
        (json['data']['empresas'] as List).map((e) => Empresas.fromJson(e)),
      );
    }
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
      empresas: empresasList,
    );
  }

  @override
  String toString() {
    return 'UserPromote(id: $id, cpf: $cpf, nome: $nome, dtNascimento: $dtNascimento, email: $email, telefone: $telefone, foto: $foto, status: $status, empresa: $empresa, empresas: $empresas)';
  }
}
