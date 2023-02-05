import 'package:cep_app_bloc/models/endereco_model.dart';

abstract class CepRepository {
  Future<EnderecoModel> getCep(String cep);
}
