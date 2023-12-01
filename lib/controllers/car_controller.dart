import "dart:convert";

import "package:http/http.dart" as http;
import "package:quarkus_api_front/models/car_model.dart";

class CarroController {
  Future<List<Carro>> getCarros() async {
    var url = Uri.parse('http://localhost:8080/carro');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var carros = <Carro>[];
      var json = response.body;
      var jsonList = jsonDecode(json) as List<dynamic>;
      for (var element in jsonList) {
        var carro = Carro.fromJson(element);
        carros.add(carro);
      }
      return carros;
    } else {
      throw Exception('Falha ao carregar carros');
    }
  }

  Future<Carro> getCarro(int id) async {
    var url = Uri.parse('http://localhost:8080/carro/$id');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = response.body;
      var carro = Carro.fromJson(jsonDecode(json));
      return carro;
    } else {
      throw Exception('Falha ao carregar carro');
    }
  }

  Future<int> countCarros() async {
    var url = Uri.parse('http://localhost:8080/carro/count');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = response.body;
      var count = jsonDecode(json);
      return count;
    } else {
      throw Exception('Falha ao carregar carros');
    }
  }

  // delete
  Future<void> deleteCarro(int id) async {
    var url = Uri.parse('http://localhost:8080/carro/$id');
    var response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw Exception('Falha ao deletar carro');
    }
  }

  // update
  Future<void> updateCarro(Carro carro) async {
    var url = Uri.parse('http://localhost:8080/carro/${carro.id}');
    var response = await http.put(url, body: jsonEncode(carro.toJson()));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Falha ao atualizar carro');
    }
  }

  // create
  Future<void> createCarro(
      {required String nome, required String marca, required int ano}) async {
    var url = Uri.parse('http://localhost:8080/carro');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome,
          'marca': marca,
          'ano': ano,
        }));

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return;
    } else {
      throw Exception('Falha ao criar carro');
    }
  }
}
