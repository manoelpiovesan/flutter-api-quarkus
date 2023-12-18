import 'package:flutter/material.dart';
import 'package:quarkus_api_front/controllers/car_controller.dart';
import 'package:quarkus_api_front/models/car_model.dart';

class CarCreateFormView extends StatefulWidget {
  final Carro carro;

  const CarCreateFormView({required this.carro, super.key});

  @override
  State<CarCreateFormView> createState() => _CarCreateFormViewState();
}

class _CarCreateFormViewState extends State<CarCreateFormView> {
  final CarroController carController = CarroController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 244, 231),
      appBar: AppBar(
        title: const Text('Novo carro'),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 800,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      initialValue: widget.carro.marca,
                      onSaved: (String? newValue) {
                        widget.carro.marca = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Marca'),
                    ),
                    TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      initialValue: widget.carro.nome,
                      onSaved: (String? newValue) {
                        widget.carro.nome = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    TextFormField(
                      validator: (String? value) {
                        int? ano = int.tryParse(value ?? '');

                        if (ano == null) {
                          return 'Campo obrigatório';
                        }
                        if (ano < 1900 || ano > 2023) {
                          return 'Ano inválido';
                        }
                        return null;
                      },
                      initialValue: widget.carro.ano == -1
                          ? ''
                          : widget.carro.ano.toString(),
                      onSaved: (String? newValue) {
                        widget.carro.ano = int.parse(newValue!);
                      },
                      decoration: const InputDecoration(labelText: 'Ano'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          if (widget.carro.id == null) {
                            await carController.createCarro(widget.carro);
                          } else {
                            await carController.updateCarro(widget.carro);
                          }

                          Navigator.of(context).pop();
                        }
                      },
                      child:
                          Text(widget.carro.id == null ? 'Criar' : 'Atualizar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
