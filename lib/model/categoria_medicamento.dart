enum CategoriaMedicamento {
  ANALGESICO('Analgésico'),
  ANTIBIOTICO('Antibiótico'),
  ANTIFUNGICO('Antifúngico'),
  ANTIVIRAL('Antiviral'),
  ANTI_INFLAMATORIO('Anti-inflamatório'),
  VITAMINAS('Vitaminas');

  final String descricao;

  const CategoriaMedicamento(this.descricao);

  @override
  String toString() {
    return descricao;
  }

  toJson() {
    return descricao;
  }
}
