import '../service/invertexto_service.dart';
import 'package:flutter/material.dart';

class PorExtensoPage extends StatefulWidget {
  const PorExtensoPage({super.key});

  @override
  State<PorExtensoPage> createState() => _PorExtensoPageState();
}

class _PorExtensoPageState extends State<PorExtensoPage> {
  String? campo;
  String selectedCurrency = 'BRL';
  Future<dynamic>? _future;
  final apiService = InvertextoService();

  final List<String> moedas = ['BRL', 'USD', 'EUR'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset('assets/imgs/invertexto.png', height: 40),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: "Digite um número",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                  _future = apiService.ConvertePorExtenso(
                    campo,
                    moeda: selectedCurrency,
                  );
                });
              },
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Selecione a moeda:",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedCurrency,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                  items: moedas.map((String moeda) {
                    return DropdownMenuItem<String>(
                      value: moeda,
                      child: Text(moeda),
                    );
                  }).toList(),
                  onChanged: (String? novaMoeda) {
                    setState(() {
                      selectedCurrency = novaMoeda!;
                      if (campo != null && campo!.isNotEmpty) {
                        _future = apiService.ConvertePorExtenso(
                          campo,
                          moeda: selectedCurrency,
                        );
                      }
                    });
                  },
                ),
              ],
            ),

            Expanded(
              child: _future == null
                  ? const Center(
                      child: Text(
                        "Digite um número acima",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : FutureBuilder(
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
                        } else {
                          return exibeResultado(snapshot);
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        snapshot.data["text"] ?? '',
        style: const TextStyle(color: Colors.white, fontSize: 18),
        softWrap: true,
      ),
    );
  }
}
