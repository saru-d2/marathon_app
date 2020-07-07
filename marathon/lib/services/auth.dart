import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marathon/models/user.dart';

// to update the database value

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  //create user object based on firebaseUser

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // uath change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and passowrd
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
  }

  //register with eamil and password
  Future registerWithEmailAndPassword(
      String email, String password, String age, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      _db.collection('users').document(user.uid).setData({
        'displayName': name,
        'age': age,
        'uid': user.uid,
        'lastseen': DateTime.now(),
        'email': email,
      });
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
  }

  // sign in with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult result = await _auth.signInWithCredential(credential);
    FirebaseUser user = result.user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    updateUserData(user);
    return _userFromFirebaseUser(user);
  }

  Future signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  //sign out
  Future signOut() async {
    try {
      signOutGoogle();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //to update the db
  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection("users").document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoUrl': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
    }, merge: true);
  }

  Future getUser() async {
    try {
      final user = await _auth.currentUser();
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
