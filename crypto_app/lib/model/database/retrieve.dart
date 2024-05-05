import 'package:crypto_app/model/CryptoCoin.dart';
import 'package:sqflite/sqflite.dart';

Future<List<FullCryptoCoin>> getCoin(Database db, String cryptoId) async {
  final List<Map<String, Object?>> coinsMap = await db.query('coin', where: 'coin.coin_id = ?', whereArgs: [cryptoId]);

  return [
    for (final {
      'coin_id': id as String,
      'name': name as String,
      'symbol': symbol as String,
      'image_link': imageLink as String,
      'price': price as double,
      'price_change_perc': priceChangePercentage as double,
      'price_change': priceChangeOverall as double,
      'todays_low': todaysLow as double,
      'todays_high': todaysHigh as double,
      'market_cap': marketCap as int,
      'market_cap_rank':  marketCapRanking as int,
      'total_supply':  totalSupply as double,
      'total_volume':  totalVolume as double,
    } in coinsMap)
    FullCryptoCoin(stats: InfoAndStats(totalSupply: totalSupply, totalVolume: totalVolume.toInt(), marketCap: marketCap, marketCapRanking: marketCapRanking, todaysHigh: todaysHigh, todaysLow: todaysLow, priceChangeOverall: priceChangeOverall, priceChangePercentage: priceChangePercentage), sucessful: true, symbol: symbol, imageLink: imageLink, id: id, name: name, price: price)
  ];
}

Future<List<FullCryptoCoin>> getCoinsViaList(Database db, int listId) async {
  const String neededAtributes = "coin.coin_id, coin.name, symbol, image_link, price, price_change_perc, price_change, todays_low, todays_high, market_cap, market_cap_rank, total_supply, total_volume";
  final List<Map<String, Object?>> coinsMap = await db.rawQuery("SELECT $neededAtributes FROM coin LEFT JOIN is_connected ON is_connected.coin_id = coin.id LEFT JOIN list ON list.id = is_connected.list_id WHERE list.id = $listId",);

  return [
    for (final {
      'coin_id': id as String,
      'name' : name as String,
      'symbol': symbol as String,
      'image_link': imageLink as String,
      'price': price as double,
      'price_change_perc': priceChangePercentage as double,
      'price_change': priceChangeOverall as double,
      'todays_low': todaysLow as double,
      'todays_high': todaysHigh as double,
      'market_cap': marketCap as int,
      'market_cap_rank':  marketCapRanking as int,
      'total_supply':  totalSupply as double,
      'total_volume':  totalVolume as double,
    } in coinsMap)
    FullCryptoCoin(stats: InfoAndStats(totalSupply: totalSupply, totalVolume: totalVolume.toInt(), marketCap: marketCap, marketCapRanking: marketCapRanking, todaysHigh: todaysHigh, todaysLow: todaysLow, priceChangeOverall: priceChangeOverall, priceChangePercentage: priceChangePercentage), sucessful: true, symbol: symbol, imageLink: imageLink, id: id, name: name, price: price)
  ];
}


Future<int> getIdOfACoin(Database db, String coinCoinId) async {
  final List<Map<String, Object?>> coinsMap = await db.query('coin', where: 'coin_id = ?', whereArgs: [coinCoinId]);
  
  try {
    return coinsMap[0]['id'] as int;
  } catch (error) {
    print("Error, returning zero");
    return 0;
  }
}