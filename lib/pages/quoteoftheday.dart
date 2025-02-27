import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; 
import 'homepage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Quoteoftheday extends StatelessWidget {
  // Fetch a random quote from the API
  Future<String> fetchQuoteOfTheDay() async {
    final connectivityResult = await Connectivity().checkConnectivity();

if(connectivityResult == await ConnectivityResult.none){
  throw Exception('No internet connection');
}

    try {
      final response = await http.get(Uri.parse('https://api.quotable.io/random'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['content'];
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      // Handle no internet connection
      throw Exception('No internet connection: $e');
    } on Exception catch (e) {
      // Handle other exceptions
      throw Exception('An error occurred: $e');
    }
  }

  // Save the quote and date to SharedPreferences
  Future<void> saveQuote(String quote, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('quote', quote);
    await prefs.setString('date', date);
  }

  // Retrieve the saved quote and date from SharedPreferences
  Future<Map<String, String?>> getSavedQuote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'quote': prefs.getString('quote'),
      'date': prefs.getString('date'),
    };
  }

  // Show the quote of the day dialog
  Future<void> _showQuoteOftheday(BuildContext context) async {
    // Show a loading dialog while fetching data
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('QUOTE OF THE DAY!!!'),
        content: SizedBox(
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    try {
      // Retrieve saved quote and date
      final savedData = await getSavedQuote();
      String savedQuote = savedData['quote'] ?? 'No quote available'; // Provide a default value
      String savedDate = savedData['date'] ?? ''; // Provide a default value
      String currentDate = DateTime.now().toIso8601String().split('T')[0];

      // Fetch a new quote if the saved quote is from a previous day or doesn't exist
      if (savedDate != currentDate || savedQuote.isEmpty) {
        savedQuote = await fetchQuoteOfTheDay();
        await saveQuote(savedQuote, currentDate);
      }

      // Close the loading dialog
      Navigator.pop(context);

      // Show the quote of the day dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('QUOTE OF THE DAY!!!'),
          content: Text(savedQuote),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
              child: Text('Continue'),
            ),
          ],
        ),
      );
    } on SocketException catch (e) {
      // Handle no internet connection
      Navigator.pop(context); // Close the loading dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the error dialog
                _showQuoteOftheday(context); // Retry fetching the quote
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    } on Exception catch (e) {
      // Handle other exceptions
      Navigator.pop(context); // Close the loading dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the error dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger the quote of the day dialog when the widget is built
    Future.microtask(() => _showQuoteOftheday(context));

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}












// ignore_for_file: use_build_context_synchronously
/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homepage.dart';

class Quoteoftheday extends StatelessWidget {
  Future<String> fetchQuoteOfTheDay() async {
    final response =
        await http.get(Uri.parse('https://api.quotable.io/random'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['content'];
    } else {
      throw Exception('failed to load quote');
    }
  }

  Future<void> saveQuote(String quote, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('quote', quote);
    await prefs.setString('date', date);
  }

  Future<Map<String, String?>> getSavedQuote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   return {
    'quote': prefs.getString('quote'),
    'date': prefs.getString('date'),
  };
  }

  Future<void> _showQuoteOftheday(BuildContext context) async {
    showDialog(context: context, barrierDismissible: false, builder: (context)=> AlertDialog(title: Text('QUOTE OF THE DAY!!!'),content: SizedBox(height: 50,child: Center(child: CircularProgressIndicator(),),),));
    final savedData = await getSavedQuote();
    String savedQuote = savedData['quote']?? 'No quote available';;
    String savedDate = savedData['date'] ?? '';
    String currentDate = DateTime.now().toIso8601String().split('T')[0];

    if (savedDate != currentDate || savedQuote.isEmpty) {
      savedQuote = await fetchQuoteOfTheDay();
      await saveQuote(savedQuote, currentDate);
    }
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('QUOTE OF THE DAY!!!'),
              content: Text(savedQuote),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                    },
                    child: Text('continue'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
   Future.microtask(() => _showQuoteOftheday(context));
    return Scaffold (
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
*/