class ConstsApi {
  static const String baseUrl = 'http://acesso.novoatacarejo.com';
  static const String promotorAuth = '$baseUrl/api/auth/promotor';
  static const String basicAuth = 'Basic bGVvbmFyZG86MTIzNDU2';
  static const String codigoAuth = '$baseUrl/api/auth/empresa/codigo';
  static const String validarEmail = '$baseUrl/api/promotor/verificar/email';
  static const String registar = '$baseUrl/api/promotor/cadastro';
  static const String escala = '$baseUrl/api/promotor/escala';
  static const String ponto = '$baseUrl/api/promotor/ponto';
  static const String alterarDados = '$baseUrl/api/promotor/meusdados';
  static const String fotoPromotor = '$baseUrl/api/promotor/cadastro/upload';
  static const String termoPromotor = '$baseUrl/api/promotor/termo';
  static const String termoAceite = '$baseUrl/api/promotor/termo-aceite';
  static const String alterarSenha = '$baseUrl/api/promotor/alterar-senha';
  static const String esqueciSenha = '$baseUrl/api/promotor/esqueci-minha-senha';
  static const String validarCodigoEmpresa = '$baseUrl/api/auth/verify/empresa/codigo';
  static const String statusService = '$baseUrl/api/promotor/status';
  static const String fotoURL = "http://acesso.novoatacarejo.com";
  static const String inativarConta = '$baseUrl/api/promotor/inativar';
}
