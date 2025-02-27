// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotes2/pages/favouritequotes.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String quoteURL = "https://api.quotable.io/random";
  String currentQuote = 'Tap to generate quote';
  var accessKey = 'f9vYkXbYvlJMoH_A8ggC4D8m8NwOyfT2OC5LtcP4KH4';
  String BackgroundURL = 'https://api.unsplash.com/photos/random';

  List<Map<String, String>> quoteslist = [];
  List<Map<String, String>> favoriteQuoteslist = [];
  int currentIndex = 0;
   bool isloading = false;

  Future<void> fetchQuote() async {

    if (isloading) return;
    isloading = true;


    final connectivityResult =await Connectivity().checkConnectivity();

  if(connectivityResult == ConnectivityResult.none){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please connect to the internet')),
    );
    isloading = false;
    return;
  }

  try{
    final qresponse =await http.get(Uri.parse(quoteURL));
    final bresponse =  await http.get(Uri.parse('$BackgroundURL?client_id=$accessKey'));

    if (qresponse.statusCode == 200 && bresponse.statusCode == 200) {
      final quoteData = jsonDecode(qresponse.body);
      final backgroundData = jsonDecode(bresponse.body);
      final String backgroundUrl= backgroundData['urls']?['regular'] ?? '';


      setState(() {
        quoteslist.add({
          'quote': quoteData['content'],
          'author': quoteData['author'],
          'background': backgroundUrl,
        });
      });
    } else {
      throw Exception('failed to load data:  ${qresponse.statusCode}, ${bresponse.statusCode}');
    }
  }
  finally{
    isloading = false;
  }
  }

  void shareQuote(String quote, String author) {
    Share.share('$quote-$author');
  }

  Future<void> saveFavoriteQuote(Map<String, String> quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuoteslist.add(quote);
    });
    await prefs.setStringList(
        'favourites', favoriteQuoteslist.map((q) => jsonEncode(q)).toList());
  }

  Future<void> loadFavoriteQuotes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? savedQuotes = prefs.getStringList('favourites');
  if (savedQuotes != null) {
    setState(() {
      favoriteQuoteslist = savedQuotes
          .map((quote) => Map<String, String>.from(jsonDecode(quote)))
          .toList();
    });
  }
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchQuote();
    loadFavoriteQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 71, 66, 66),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Quotes by kingw', style: TextStyle(fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Favouritequotes(favoriteQuotes: favoriteQuoteslist,)));
              },
              icon: Icon(Icons.favorite, size: 50, color: Colors.red,))
        ],
        elevation: 0,
      ),
      body: 
      
      
      
      Center(
        child: CarouselSlider(
          items: quoteslist.map((quote) {
            return Stack(
              children: [
                CachedNetworkImage(
                    imageUrl: quote['background']!,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          quote['quote']!,
                          style: TextStyle(fontSize: 24, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '-${quote['author']!}',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            shareQuote(quote['quote']!, quote['author']!),
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            saveFavoriteQuote(quote);
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ))
                    ],
                  ),
                )
              ],
            );
          }).toList(),
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              autoPlay: false,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
                if (index == quoteslist.length - 1) {
                  fetchQuote();
                }
              },
            ),
        ),
      ),
    );
  }
}
