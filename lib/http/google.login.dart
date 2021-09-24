import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;

class GoogleLogin {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<GoogleSignInAccount> handleSignIn() async {
    try {
      GoogleSignInAccount acc = await _googleSignIn.signIn();
      return acc;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> handleGetContact(GoogleSignInAccount _currentUser) async {
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();
}