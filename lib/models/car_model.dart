class Carro {
  final int id;
  final int ano;
  final String nome;
  final String marca;

  Carro({required this.id, required this.ano, required this.nome, required this.marca});

  factory Carro.fromJson(Map<String, dynamic> json) {
    return Carro(
      id: json['id'],
      ano: json['ano'],
      nome: json['nome'],
      marca: json['marca'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ano': ano,
      'nome': nome,
      'marca': marca,
    };
  }
}
