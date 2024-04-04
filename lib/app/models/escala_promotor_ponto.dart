import 'dart:convert';

class PromotorEscalaPonto {
  String dtReferencia;
  String hrCargaHoraria;
  String? hrChegada;
  String? hrSaida;
  String hrIntervalo;
  String? dtCheckIn;
  String? dtCheckOut;
  String? loja;

  PromotorEscalaPonto(
      {required this.dtReferencia,
      required this.hrCargaHoraria,
      this.hrChegada,
      this.hrSaida,
      required this.hrIntervalo,
      this.dtCheckIn,
      this.dtCheckOut,
      this.loja});

  PromotorEscalaPonto copyWith({
    String? dtReferencia,
    String? hrCargaHoraria,
    String? hrChegada,
    String? hrSaida,
    String? hrIntervalo,
    String? dtCheckIn,
    String? dtCheckOut,
    String? loja,
  }) {
    return PromotorEscalaPonto(
        dtReferencia: dtReferencia ?? this.dtReferencia,
        hrCargaHoraria: hrCargaHoraria ?? this.hrCargaHoraria,
        hrChegada: hrChegada ?? this.hrChegada,
        hrSaida: hrSaida ?? this.hrSaida,
        hrIntervalo: hrIntervalo ?? this.hrIntervalo,
        dtCheckIn: dtCheckIn ?? this.dtCheckIn,
        dtCheckOut: dtCheckOut ?? this.dtCheckOut,
        loja: loja ?? this.loja);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dtReferencia': dtReferencia,
      'hrCargaHoraria': hrCargaHoraria,
      'hrChegada': hrChegada,
      'hrSaida': hrSaida,
      'hrIntervalo': hrIntervalo,
      'dtCheckIn': dtCheckIn,
      'dtCheckOut': dtCheckOut,
      'loja': loja,
    };
  }

  factory PromotorEscalaPonto.fromMap(Map<String, dynamic> map) {
    return PromotorEscalaPonto(
      dtReferencia: map['dtReferencia'] as String,
      hrCargaHoraria: map['hrCargaHoraria'] as String,
      hrChegada: map['hrChegada'],
      hrSaida: map['hrSaida'],
      hrIntervalo: map['hrIntervalo'] as String,
      dtCheckIn: map['dtCheckIn'],
      dtCheckOut: map['dtCheckOut'],
      loja: map['loja'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotorEscalaPonto.fromJson(Map<String, dynamic> json) {
    return PromotorEscalaPonto(
        dtReferencia: json["dtReferencia"] ?? "",
        hrCargaHoraria: json["hrCargaHoraria"] ?? "",
        hrIntervalo: json["hrIntervalo"] ?? "",
        dtCheckIn: json["dtCheckIn"],
        dtCheckOut: json["dtCheckOut"],
        loja: json["loja"]);
  }

  @override
  String toString() {
    return 'Ponto(dtReferencia: $dtReferencia, hrCargaHoraria: $hrCargaHoraria, hrChegada: $hrChegada, hrSaida: $hrSaida, hrIntervalo: $hrIntervalo, dtCheckIn: $dtCheckIn, dtCheckOut: $dtCheckOut )';
  }
}
