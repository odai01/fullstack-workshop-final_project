import 'package:firebase_auth/firebase_auth.dart';

bool isUserSignedIn() {
  return FirebaseAuth.instance.currentUser != null;
}
