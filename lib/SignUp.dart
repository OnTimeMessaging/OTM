import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:ontimemessaging/profile.dart';

class RegisterPage extends StatefulWidget {


  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email;
  String _firstName;
  FocusNode _focusNode;
  String _lastName;
  bool _registering = false;
  TextEditingController _passwordController;
  TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    final faker = Faker();
    _firstName = faker.person.firstName();
    _lastName = faker.person.lastName();
    _email =
    '${_firstName.toLowerCase()}.${_lastName.toLowerCase()}@${faker.internet.domainName()}';
    _focusNode = FocusNode();
    _passwordController = TextEditingController(text: 'Qawsed1-');
    _usernameController = TextEditingController(
      text: _email,
    );
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _register() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _registering = true;
    });

    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: _firstName,
          id: credential.user.uid,
          imageUrl: 'https://i.pravatar.cc/300?u=$_email',
          lastName: _lastName,

        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EditProfilePage()));
    } catch (e) {
      setState(() {
        _registering = false;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
          content: Text(
            e.toString(),
          ),
          title: const Text('Error'),
        ),
      );
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            color: Colors.white,
          ),
          //   style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          // decoration: kBoxDecorationStyle,
          height: 60.0,
          child:TextField(
            style: TextStyle(color: Colors.white),
            autocorrect: false,
            autofillHints: _registering ? null : [AutofillHints.email],
            autofocus: true,
            controller: _usernameController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:Colors.white),
              ),
              border:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),

              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel,color: Colors.white,),
                onPressed: () => _usernameController.clear(),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onEditingComplete: () {
              _focusNode.requestFocus();
            },
            readOnly: _registering,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white,
          ),
          //  style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          //  decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            autocorrect: false,
            autofillHints: _registering ? null : [AutofillHints.password],
            controller: _passwordController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:Colors.white),
              ),
              border:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),

              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.cancel,color: Colors.white,),
                onPressed: () => _passwordController.clear(),
              ),
            ),
            focusNode: _focusNode,
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            onEditingComplete: _register,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }


  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child:  RaisedButton(
        child: TextButton(
          onPressed:   _registering ? null : _register,
          child: const Text('Sign Up'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white, onPressed: () {  },

      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.black, Color(0xff000428)])

                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                    //  _buildForgotPasswordBtn(),
                      // _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                     // _buildSignInWithText(),
                     // _buildSocialBtnRow(),
                      //    _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         brightness: Brightness.dark,
//         title: const Text('Register'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
//           child: Column(
//             children: [
//
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child:
//               ),
//               TextButton(
//                 onPressed: _registering ? null : _register,
//                 child: const Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
