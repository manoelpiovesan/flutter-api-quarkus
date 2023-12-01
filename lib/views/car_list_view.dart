import 'package:flutter/material.dart';
import 'package:quarkus_api_front/controllers/car_controller.dart';
import 'package:quarkus_api_front/models/car_model.dart';
import 'package:quarkus_api_front/views/car_create_form_view.dart';

class CarListView extends StatefulWidget {
  const CarListView({super.key});

  @override
  State<CarListView> createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView> {
  late CarroController carController;

  @override
  void initState() {
    carController = CarroController();
    super.initState();
  }

  Future<void> createCarro() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const CarCreateFormView()));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Carros'),
          actions: [
            IconButton(onPressed: createCarro, icon: const Icon(Icons.add)),
          ],
        ),
        body: FutureBuilder(
            future: carController.getCarros(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                var carros = snapshot.data as List<Carro>;
                return ListView.builder(
                    itemCount: carros.length,
                    itemBuilder: (ctx, index) {
                      var carro = carros[index];
                      return ListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(carro.marca),
                            const SizedBox(width: 5),
                            Text(carro.nome),
                          ],
                        ),
                        subtitle: Text(carro.ano.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await carController.deleteCarro(carro.id);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
