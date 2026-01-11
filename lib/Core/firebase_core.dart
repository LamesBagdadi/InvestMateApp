import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

class FirebaseCore {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized');
  }

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseDatabase get database => FirebaseDatabase.instance;
}