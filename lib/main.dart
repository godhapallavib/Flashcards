import 'package:flutter/material.dart';
import 'package:mp3/database/database.dart';
import 'package:mp3/provider/provider.dart';
import 'views/decklist.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FlashProvider>(
          create: (context) => FlashProvider(),
        ),
        ChangeNotifierProvider<DatabaseHelper>(
          create: (context) => DatabaseHelper(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple[100],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.purple,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.purple,
          ),
        ),
        home: const DeckList(),
      ),
    ),
  );
}
