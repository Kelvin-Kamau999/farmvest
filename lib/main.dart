import 'package:cofarmer/common/initial_loading.dart';
import 'package:cofarmer/firebase_options.dart';
import 'package:cofarmer/providers/auth_provider.dart';
import 'package:cofarmer/providers/chat_provider.dart';
import 'package:cofarmer/providers/location_provider.dart';
import 'package:cofarmer/providers/proposal_provider.dart';
import 'package:cofarmer/screens/chat/chat_room.dart';
import 'package:cofarmer/screens/splash_screen.dart';
import 'package:cofarmer/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LocationProvider()),
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: ProposalProvider()),
        ChangeNotifierProvider.value(value: ChatProvider()),
      ],
      child: GetMaterialApp(
        title: 'CoFarmer',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const InitialLoadingScreen();
              }
              return const SplashScreen();
            }),
        routes: {
          ChatRoom.routeName: (context) => ChatRoom(),
        },
      ),
    );
  }
}
