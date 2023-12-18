import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:quarkus_api_front/controllers/authentication.dart';
import 'package:quarkus_api_front/models/car_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarroController {
  Authentication authentication = Authentication();
  DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

  Future<List<Carro>> getCarros() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri url = Uri.parse('${env['QUARKUS_API_URL']}/carro/protected');
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204 ||
        response.statusCode == 201) {
      List<Carro> carros = <Carro>[];
      String json = response.body;
      dynamic jsonList = jsonDecode(json) as List<dynamic>;
      for (final dynamic element in jsonList) {
        Carro carro = Carro.fromJson(element);
        carros.add(carro);
      }
      return carros;
    } else {
      throw Exception('Falha ao carregar carros: ${response.statusCode}');
    }
  }

  Future<Carro> getCarro(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse('${env['QUARKUS_API_URL']}/carro/$id');
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );

    if (response.statusCode == 200) {
      String json = response.body;
      Carro carro = Carro.fromJson(jsonDecode(json));
      return carro;
    } else {
      throw Exception('Falha ao carregar carro');
    }
  }

  Future<int> countCarros() async {
    Uri url = Uri.parse('${env['QUARKUS_API_URL']}/carro/count');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String json = response.body;
      dynamic count = jsonDecode(json);
      return count;
    } else {
      throw Exception('Falha ao carregar carros');
    }
  }

  // delete
  Future<void> deleteCarro(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse('${env['QUARKUS_API_URL']}/carro/$id');
    http.Response response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw Exception('Falha ao deletar carro');
    }
  }

  // update
  Future<void> updateCarro(Carro carro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri url = Uri.parse('${env['QUARKUS_API_URL']}/carro/${carro.id}');
    http.Response response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(carro.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204 ||
        response.statusCode == 201) {
      return;
    } else {
      throw Exception('Falha ao atualizar carro');
    }
  }

  // create
  Future<void> createCarro(Carro carro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri url = Uri.parse('${env['QUARKUS_API_URL']}/carro/protected');
    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: json.encode(carro.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return;
    } else {
      throw Exception('Falha ao criar carro: ${response.statusCode}');
    }
  }
}
