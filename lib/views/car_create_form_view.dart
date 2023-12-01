import 'package:flutter/material.dart';
import 'package:quarkus_api_front/controllers/car_controller.dart';

class CarCreateFormView extends StatefulWidget {
  const CarCreateFormView({super.key});

  @override
  State<CarCreateFormView> createState() => _CarCreateFormViewState();
}

class _CarCreateFormViewState extends State<CarCreateFormView> {
  final CarroController carController = CarroController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController anoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo carro'),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 800,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  controller: marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                ),
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: anoController,
                  decoration: const InputDecoration(labelText: 'Ano'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await carController.createCarro(
                      marca: marcaController.text,
                      nome: nomeController.text,
                      ano: int.parse(anoController.text),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: const Text('Criar'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
