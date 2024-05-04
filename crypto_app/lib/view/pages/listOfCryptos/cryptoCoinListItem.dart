import 'package:crypto_app/model/CryptoCoin.dart';
import 'package:crypto_app/view/coinPage/coinPage.dart';
import 'package:flutter/material.dart';

class CryptoCoinListItem extends StatelessWidget {
  final CryptoCoin coin;

  const CryptoCoinListItem({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CoinPage(coin: coin))),
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(
                          coin.imageLink,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coin.name,
                          style: const TextStyle(fontSize: 25),
                        ),
                        Text(
                          coin.symbol,
                          style: const TextStyle(
                              fontSize: 15, color: Color.fromARGB(159, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Text(
                    '\$',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    coin.price.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 17),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}