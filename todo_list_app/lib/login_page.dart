// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:todo_list_app/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// class GoogleSignInPage extends StatefulWidget {
//   @override
//   _GoogleSignInPageState createState() => _GoogleSignInPageState();
// }

// class _GoogleSignInPageState extends State<GoogleSignInPage> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
//   late FirebaseAuth? _auth;
//   bool _initialized = false;

//   @override
//   void initState() {
//     super.initState();
// WidgetsFlutterBinding.ensureInitialized();
//    Firebase.initializeApp();
//     initializeFirebase();
//     print('enter1'); // Call the initialization method
//   }

//   Future<void> initializeFirebase() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     print("inside initializeFirebase()");
//     try {
//       await Firebase.initializeApp().then((value) {
//         FirebaseAuth.instance;
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//     try {
//       print('Firebase initialized successfully');

//       setState(() {
//         _initialized = true;
//       });
//     } catch (error) {
//       print('Firebase initialization error: $error');
//     }
//   }

//   Future<void> _handleSignIn() async {
//     try {
//       if (!_initialized) {
//         print('Firebase is not initialized yet. Please wait...');
//         return;
//       }

//       if (_auth == null) {
//         print(
//             'Firebase authentication instance is null even after initialization.');
//         return;
//       }

//       final GoogleSignInAccount? googleSignInAccount =
//           await _googleSignIn.signIn();
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount!.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       final UserCredential authResult =
//           await _auth!.signInWithCredential(credential);
//       final User? user = authResult.user;

//       if (user == null) {
//         print('User authentication failed');
//         return;
//       }

//       print('User email: ${user.email}');
//       // Navigate to HomeScreen or perform other actions here
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
//       );
//     } catch (error) {
//       print('Error signing in with Google: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Sign-In Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Welcome to Google Sign-In Page',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _handleSignIn,
//               child: Text('Sign in with Google'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}


class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  ValueNotifier userCredential = ValueNotifier('');

  @override
   @override
  void initState() {
    initializeFirebase();
    super.initState();
    
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (error) {
      print('Error initializing Firebase: $error');
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Google SignIn Screen')),
        body: ValueListenableBuilder(
            valueListenable: userCredential,
            builder: (context, value, child) {
              return (userCredential.value == '' ||
                      userCredential.value == null)
                  ? Center(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          iconSize: 40,
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () async {
                            userCredential.value = await signInWithGoogle();
                            if (userCredential.value != null)
                              print(userCredential.value.user!.email);
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1.5, color: Colors.black54)),
                            child: Image.network(
                                userCredential.value.user!.photoURL.toString()),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(userCredential.value.user!.displayName
                              .toString()),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(userCredential.value.user!.email.toString()),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                bool result = await signOutFromGoogle();
                                if (result) userCredential.value = '';
                              },
                              child: const Text('Logout'))
                        ],
                      ),
                    );
            }));
  }
}

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    // TODO
    print('exception->$e');
  }
}

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}
