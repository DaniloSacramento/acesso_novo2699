// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Termo {
  final String id;
  final String dtReferencia;
  final String versao;
  final String conteudo;

  Termo(
    this.id,
    this.dtReferencia,
    this.versao,
    this.conteudo,
  );

  Termo copyWith({
    String? id,
    String? dtReferencia,
    String? versao,
    String? conteudo,
  }) {
    return Termo(
      id ?? this.id,
      dtReferencia ?? this.dtReferencia,
      versao ?? this.versao,
      conteudo ?? this.conteudo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dtReferencia': dtReferencia,
      'versao': versao,
      'conteudo': conteudo,
    };
  }

  factory Termo.fromMap(Map<String, dynamic> map) {
    return Termo(
      map['id'] as String,
      map['dtReferencia'] as String,
      map['versao'] as String,
      map['conteudo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Termo.fromJson(String source) => Termo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Termo(id: $id, dtReferencia: $dtReferencia, versao: $versao, conteudo: $conteudo)';
  }

  @override
  bool operator ==(covariant Termo other) {
    if (identical(this, other)) return true;

    return other.id == id && other.dtReferencia == dtReferencia && other.versao == versao && other.conteudo == conteudo;
  }

  @override
  int get hashCode {
    return id.hashCode ^ dtReferencia.hashCode ^ versao.hashCode ^ conteudo.hashCode;
  }
}
