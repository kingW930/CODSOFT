import 'package:flutter/material.dart';

class Favouritequotes extends StatelessWidget {
  final List<Map<String, String>> favoriteQuotes;

  const Favouritequotes({super.key, required this.favoriteQuotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
      ),
      body: favoriteQuotes.isEmpty
          ?  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 50, color: Colors.grey,),
                  SizedBox(height: 10),
                  Text(
                    'No favourite quotes yet!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(favoriteQuotes[index]['quote']!),
                    subtitle: Text('-${favoriteQuotes[index]['author']!}'),
                  ),
                );
              }),
    );
  }
}
