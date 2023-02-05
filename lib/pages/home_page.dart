import 'package:cep_app_bloc/models/endereco_model.dart';
import 'package:cep_app_bloc/repositories/cep_repository.dart';
import 'package:cep_app_bloc/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;
  bool loadling = false;

  final formKey = GlobalKey<FormState>();
  final cepEditControl = TextEditingController();

  @override
  void dispose() {
    cepEditControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: cepEditControl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CEP obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final valid = formKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      setState(() {
                        loadling = true;
                      });
                      final endereco =
                          await cepRepository.getCep(cepEditControl.text);
                      setState(() {
                        loadling = false;
                        enderecoModel = endereco;
                      });
                    } catch (e) {
                      setState(() {
                        loadling = false;
                        enderecoModel = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Erro ao buscar endereço')));
                    }
                  }
                },
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 50),
              Visibility(
                visible: enderecoModel != null,
                child: Text(
                    'Cidade: ${enderecoModel?.localidade} \nEstado: ${enderecoModel?.uf} \nBairro: ${enderecoModel?.bairro} \nLogradouro: ${enderecoModel?.logradouro} \nComplemento: ${enderecoModel?.complemento}'),
              ),
              const SizedBox(height: 50),
              Visibility(
                visible: loadling,
                child: const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
