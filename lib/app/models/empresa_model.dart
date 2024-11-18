class Empresas {
  final String empresaNome;
  final String statusDesc;
  final String? dtAprovacao;
  final String? dtReprovacao;
  final String? dtCreate;
  final String grupoEmpresarialNome;

  Empresas({
    required this.empresaNome,
    required this.statusDesc,
    this.dtAprovacao,
    this.dtReprovacao,
    this.dtCreate,
    required this.grupoEmpresarialNome,
  });

  Map<String, dynamic> toMap() {
    return {
      'empresaNome': empresaNome,
      'statusDesc': statusDesc,
      'dtAprovacao': dtAprovacao,
      'dtReprovacao': dtReprovacao,
      'dtCreate': dtCreate,
      'grupoEmpresarialNome': grupoEmpresarialNome,
    };
  }

  factory Empresas.fromMap(Map<String, dynamic> map) {
    return Empresas(
      empresaNome: map['empresaNome'] ?? '',
      statusDesc: map['statusDesc'] ?? '',
      dtAprovacao: map['dtAprovacao'],
      dtReprovacao: map['dtReprovacao'],
      dtCreate: map['dtCreate'],
      grupoEmpresarialNome: map['grupoEmpresarialNome'] ?? '',
    );
  }

  factory Empresas.fromJson(Map<String, dynamic> json) {
    return Empresas(
      empresaNome: json['empresaNome'] ?? '',
      statusDesc: json['statusDesc'] ?? '',
      dtAprovacao: json['dtAprovacao'],
      dtReprovacao: json['dtReprovacao'],
      dtCreate: json['dtCreate'],
      grupoEmpresarialNome: json['grupoEmpresarialNome'] ?? '',
    );
  }
}