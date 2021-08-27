import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'SignUp.dart';

class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode _focusNode;
  bool _loggingIn = false;
  TextEditingController _passwordController;
  TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _passwordController = TextEditingController(text: '');
    _usernameController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _passwordController?.dispose();
    _usernameController?.dispose();
    super.dispose();
  }

  void _login() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loggingIn = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _loggingIn = false;
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
            fontSize: 25
          ),
          //style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          // decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            autocorrect: false,
            autofillHints: _loggingIn ? null : [AutofillHints.email],
            autofocus: true,
            controller: _usernameController,
            style: TextStyle(color:Colors.white),
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
            readOnly: _loggingIn,
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
            fontSize: 25
          ),
          // style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          // decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            autocorrect: false,
            autofillHints: _loggingIn ? null : [AutofillHints.password],
            controller: _passwordController,
            style: TextStyle(color:Colors.white),
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
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                onPressed: () => _passwordController.clear(),
              ),
            ),
            focusNode: _focusNode,
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            onEditingComplete: _login,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
          ),
        ),
        // hintStyle: kHintTextStyle,
      ],
    );
  }

  // Widget _buildForgotPasswordBtn() {
  //   return Container(
  //     alignment: Alignment.centerRight,
  //     child: FlatButton(
  //       onPressed: () => print('Forgot Password Button Pressed'),
  //       padding: EdgeInsets.only(right: 0.0),
  //       child: Text(
  //         'Forgot Password?',
  //         style: TextStyle(
  //           color: Colors.white,
  //         ),
  //
  //         /// style: kLabelStyle,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child:  RaisedButton(
        child: TextButton(
                  onPressed: _loggingIn ? null : _login,
                  child: const Text('Login'),
                ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white, onPressed: () {  },

      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),

      ],
    );
  }

  //
  // Widget _buildSocialBtn(Function onTap, AssetImage logo) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       height: 60.0,
  //       width: 60.0,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black26,
  //             offset: Offset(0, 2),
  //             blurRadius: 6.0,
  //           ),
  //         ],
  //         image: DecorationImage(
  //           image: logo,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildSocialBtnRow() {
  //   final authBloc = Provider.of<AuthBloc>(context);
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 30.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         _buildSocialBtn(
  //               () => authBloc.loginGoogle(),
  //           AssetImage(
  //             'assets/img/facebook.jpg',
  //           ),
  //         ),
  //         _buildSocialBtn(
  //               () => authBloc.loginGoogle(),
  //           AssetImage(
  //             'assets/img/google.jpg',
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterPage())),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
                    colors: [Color(0xff004e92), Color(0xff000428)])

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
                     // _buildForgotPasswordBtn(),
                      //     _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                      _buildSignInWithText(),
                      //  _buildSocialBtnRow(),
                      _buildSignupBtn(),
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
//         title: const Text('Login'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
//           child: Column(
//             children: [
//               TextField(
//                 autocorrect: false,
//                 autofillHints: _loggingIn ? null : [AutofillHints.email],
//                 autofocus: true,
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                   ),
//                   labelText: 'Email',
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.cancel),
//                     onPressed: () => _usernameController?.clear(),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 onEditingComplete: () {
//                   _focusNode.requestFocus();
//                 },
//                 readOnly: _loggingIn,
//                 textCapitalization: TextCapitalization.none,
//                 textInputAction: TextInputAction.next,
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: TextField(
//                   autocorrect: false,
//                   autofillHints: _loggingIn ? null : [AutofillHints.password],
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(8.0),
//                       ),
//                     ),
//                     labelText: 'Password',
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.cancel),
//                       onPressed: () => _passwordController?.clear(),
//                     ),
//                   ),
//                   focusNode: _focusNode,
//                   keyboardType: TextInputType.emailAddress,
//                   obscureText: true,
//                   onEditingComplete: _login,
//                   textCapitalization: TextCapitalization.none,
//                   textInputAction: TextInputAction.done,
//                 ),
//               ),
//               TextButton(
//                 onPressed: _loggingIn ? null : _login,
//                 child: const Text('Login'),
//               ),
//               TextButton(
//                 onPressed: _loggingIn
//                     ? null
//                     : () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) =>  RegisterPage(),
//                           ),
//                         );
//                       },
//                 child: const Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
