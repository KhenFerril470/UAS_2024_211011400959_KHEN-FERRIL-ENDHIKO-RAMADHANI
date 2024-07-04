import 'package:flutter/material.dart';
import 'api_service.dart';
import 'crypto_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Data Harga Crypto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CryptoListScreen(),
    );
  }
}

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  late Future<List<Crypto>> futureCryptos;

  @override
  void initState() {
    super.initState();
    futureCryptos = ApiService().fetchCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harga Cryptocurrency'),
      ),
      body: FutureBuilder<List<Crypto>>(
        future: futureCryptos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data'));
          } else {
            List<Crypto> cryptos = snapshot.data!;
            return ListView.builder(
              itemCount: cryptos.length,
              itemBuilder: (context, index) {
                Crypto crypto = cryptos[index];
                return ListTile(
                  title: Text('${crypto.name} (${crypto.symbol})'),
                  subtitle: Text('\$${crypto.priceUsd.toStringAsFixed(2)}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
