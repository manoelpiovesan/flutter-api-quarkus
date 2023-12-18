// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:quarkus_api_front/controllers/car_controller.dart';
import 'package:quarkus_api_front/models/car_model.dart';
import 'package:quarkus_api_front/views/car_create_form_view.dart';
import 'package:quarkus_api_front/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarListView extends StatefulWidget {
  const CarListView({super.key});

  @override
  State<CarListView> createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView> {
  late CarroController carController;
  String? username;
  Map<String, dynamic>? jwtDecoded;

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    jwtDecoded = JwtDecoder.decode(prefs.getString('token') ?? '');
    setState(() {
      username = jwtDecoded!['preferred_username'];
    });
  }

  @override
  void initState() {
    getUsername();
    carController = CarroController();
    super.initState();
  }

  Future<void> createCarro() async {
    await Navigator.of(context).push(
      MaterialPageRoute<Widget>(
          builder: (BuildContext ctx) => CarCreateFormView(carro: Carro()),),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 244, 231),
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const Text('Carros | '),
            const SizedBox(width: 5),
            Text(
              'Bem vindo, $username.',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(onPressed: createCarro, icon: const Icon(Icons.add)),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute<Widget>(
                    builder: (BuildContext ctx) => const LoginView(),),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Carro>>(
        future: carController.getCarros(),
        builder: (BuildContext ctx, AsyncSnapshot<List<Carro>> snapshot) {
          if (snapshot.hasData) {
            List<Carro> carros = snapshot.data!;
            return carros.isEmpty
                ? const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.sentiment_dissatisfied),
                        SizedBox(width: 5),
                        Text('Nenhum carro cadastrado'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: carros.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      Carro carro = carros[index];
                      return Card(
                        child: ListTile(
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(carro.marca),
                              const SizedBox(width: 5),
                              Text(carro.nome),
                            ],
                          ),
                          subtitle: Text(carro.ano.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute<Widget>(
                                      builder: (BuildContext ctx) =>
                                          CarCreateFormView(
                                        carro: carro,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await carController.deleteCarro(carro.id!);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
