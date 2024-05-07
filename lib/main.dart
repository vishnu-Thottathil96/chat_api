import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamie/providers/chat_provider.dart';
import 'package:lamie/providers/chatlist_provider.dart';
import 'package:lamie/providers/google_login.dart';
import 'package:lamie/providers/login_provider.dart';
import 'package:lamie/providers/signup_provider.dart';
import 'package:lamie/providers/togle_searchbar.dart';
import 'package:lamie/view/pages/splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => ChatListProvider()),
        ChangeNotifierProvider(create: (context) => ToggleSearchBarProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => GoogleLoginProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.mitrTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
