import 'package:flutter/material.dart';
import '../service/invertexto_service.dart';

class GeradorDePessoas extends StatefulWidget {
  const GeradorDePessoas({super.key});

  @override
  State<GeradorDePessoas> createState() => _GeradorDePessoasState();
}

class _GeradorDePessoasState extends State<GeradorDePessoas> {
  Future<Map<String, dynamic>>? _future;
  final apiService = InvertextoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/invertexto.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _future = apiService.GeradorDePessoas();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
              child: const Text("Gerar Pessoa", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _future == null
                  ? const Center(
                      child: Text(
                        "Clique no botão para gerar uma pessoa",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : FutureBuilder<Map<String, dynamic>>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 5.0,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString().replaceFirst(
                                'Exception: ',
                                '',
                              ),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return exibeResultado(snapshot.data!);
                        } else {
                          return const Center(
                            child: Text(
                              "Nenhum dado disponível",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(Map<String, dynamic> data) {
    final creditCard = data['credit_card'] ?? {};
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        '''
UUID: ${data["uuid"] ?? "-"}
Nome: ${data["name"] ?? "-"}
CPF: ${data["cpf"] ?? "-"}
CNPJ: ${data["cnpj"] ?? "-"}
Data de Nascimento: ${data["birth_date"] ?? "-"}
Email: ${data["email"] ?? "-"}
Username: ${data["username"] ?? "-"}
Senha: ${data["password"] ?? "-"}
Telefone: ${data["phone_number"] ?? "-"}
Domínio: ${data["domain_name"] ?? "-"}
Empresa: ${data["company"] ?? "-"}
IPv4: ${data["ipv4"] ?? "-"}
User Agent: ${data["user_agent"] ?? "-"}

Cartão de Crédito:
  Tipo: ${creditCard["type"] ?? "-"}
  Número: ${creditCard["number"] ?? "-"}
  Nome: ${creditCard["name"] ?? "-"}
  Validade: ${creditCard["expiration"] ?? "-"}
''',
        style: const TextStyle(color: Colors.white, fontSize: 16),
        softWrap: true,
      ),
    );
  }
}
