class Carro {
  int? id;
  int ano = -1;
  String nome = '';
  String marca = '';

  Carro();

  Carro.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        ano = json['ano'],
        nome = json['nome'],
        marca = json['marca'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'ano': ano,
      'nome': nome,
      'marca': marca,
    };
  }
}
