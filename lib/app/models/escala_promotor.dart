import 'dart:convert';

import 'package:acessonovo/app/models/escala_promotor_ponto.dart';
import 'package:flutter/foundation.dart';

class EscalaPromotor {
  String loja;
  String dtInicio;
  String dtTermino;
  String hrChegada;
  String hrSaida;
  String fornNomeFantasia;
  String? fornLogoMarca;
  String atividades;
  String setores;
  List<PromotorEscalaPonto> pontos;
  EscalaPromotor({
    required this.loja,
    required this.dtInicio,
    required this.dtTermino,
    required this.hrChegada,
    required this.hrSaida,
    required this.fornNomeFantasia,
    this.fornLogoMarca,
    required this.atividades,
    required this.setores,
    required this.pontos,
  });

  EscalaPromotor copyWith({
    String? loja,
    String? dtInicio,
    String? dtTermino,
    String? hrChegada,
    String? hrSaida,
    String? fornNomeFantasia,
    String? fornLogoMarca,
    String? atividades,
    String? setores,
    List<PromotorEscalaPonto>? pontos,
  }) {
    return EscalaPromotor(
      loja: loja ?? this.loja,
      dtInicio: dtInicio ?? this.dtInicio,
      dtTermino: dtTermino ?? this.dtTermino,
      hrChegada: hrChegada ?? this.hrChegada,
      hrSaida: hrSaida ?? this.hrSaida,
      fornNomeFantasia: fornNomeFantasia ?? this.fornNomeFantasia,
      fornLogoMarca: fornLogoMarca ?? this.fornLogoMarca,
      atividades: atividades ?? this.atividades,
      setores: setores ?? this.setores,
      pontos: pontos ?? this.pontos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'loja': loja,
      'dtInicio': dtInicio,
      'dtTermino': dtTermino,
      'hrChegada': hrChegada,
      'hrSaida': hrSaida,
      'fornNomeFantasia': fornNomeFantasia,
      'fornLogoMarca': fornLogoMarca,
      'atividades': atividades,
      'setores': setores,
      'pontos': pontos.map((x) => x.toMap()).toList(),
    };
  }

  factory EscalaPromotor.fromMap(Map<String, dynamic> map) {
    return EscalaPromotor(
      loja: map['loja'] ?? "",
      dtInicio: map['dtInicio'] ?? "",
      dtTermino: map['dtTermino'] ?? "",
      hrChegada: map['hrChegada'] ?? "",
      hrSaida: map['hrSaida'] ?? "",
      fornNomeFantasia: map['fornNomeFantasia'] ?? "",
      fornLogoMarca: map['fornLogoMarca'] ?? "",
      atividades: map['atividades'] ?? "",
      setores: map['setores'] ?? "",
      pontos: List<PromotorEscalaPonto>.from(
        (map['pontos']).map<PromotorEscalaPonto>(
          (x) => PromotorEscalaPonto.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory EscalaPromotor.fromJson(String source) => EscalaPromotor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EscalaPromotor(loja: $loja, dtInicio: $dtInicio, dtTermino: $dtTermino, hrChegada: $hrChegada, hrSaida: $hrSaida, fornNomeFantasia: $fornNomeFantasia, fornLogoMarca: $fornLogoMarca, atividades: $atividades, setores: $setores, pontos: $pontos,)';
  }

  @override
  bool operator ==(covariant EscalaPromotor other) {
    if (identical(this, other)) return true;

    return other.loja == loja &&
        other.dtInicio == dtInicio &&
        other.dtTermino == dtTermino &&
        other.hrChegada == hrChegada &&
        other.hrSaida == hrSaida &&
        other.fornNomeFantasia == fornNomeFantasia &&
        other.fornLogoMarca == fornLogoMarca &&
        other.atividades == atividades &&
        other.setores == setores &&
        listEquals(other.pontos, pontos);
  }

  @override
  int get hashCode {
    return loja.hashCode ^
        dtInicio.hashCode ^
        dtTermino.hashCode ^
        hrChegada.hashCode ^
        hrSaida.hashCode ^
        fornNomeFantasia.hashCode ^
        fornLogoMarca.hashCode ^
        atividades.hashCode ^
        setores.hashCode ^
        pontos.hashCode;
  }
}
