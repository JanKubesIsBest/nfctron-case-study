import 'dart:convert';

import 'package:crypto_app/model/CryptoCoin.dart';
import 'package:crypto_app/model/database/open_database.dart';
import 'package:crypto_app/model/database/retrieve.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

/// Retrieves trending coins
Future<RetrievedCryptoCoins> getTrendingCoins() async {
  late final RetrievedCryptoCoins response;
  print("Getting trending coins");

  try {
    final Map<String, String> headers = <String, String>{
      "accept": "application/json",
      "x-cg-api-key": "CG-738W9EJdfn1DGs8eED84JFBS",
    };

    http.Response httpResponse = await http.get(
        Uri.parse(
          "https://api.coingecko.com/api/v3/search/trending",
        ),
        headers: headers);
    print(httpResponse.body);

    if (httpResponse.statusCode == 200) {
      final l = json.decode(httpResponse.body)['coins'];

      // For looking into the data
      // print(l[0]);

      List<CryptoCoin> trendingCoins = List<CryptoCoin>.from(
          l.map((element) => CryptoCoin.fromJSON(element['item'])));

      response = RetrievedCryptoCoins(
          sucessful: true, online: true, retrievedCrypto: trendingCoins);
    }
  } catch (_) {
    print("An error occured");

    final Database db = await openMyDatabase();

    // Retrieve from SQLite
    List<FullCryptoCoin> coins = await getCoinsViaList(db, 1);

    response = RetrievedCryptoCoins(
        sucessful: true, online: false, retrievedCrypto: coins);
  }

  return response;
}
