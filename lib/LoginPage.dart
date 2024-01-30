    import 'package:flutter/material.dart';
    import 'package:firebase_auth/firebase_auth.dart';

    import 'AdmiPage.dart';

    class AdminLogin extends StatefulWidget {
    static const routeName = '/SignInScreen';

    @override
    _AdminLoginState createState() => _AdminLoginState();
    }

    class _AdminLoginState extends State<AdminLogin> {
      late double _height;
      late double _width;
      late double _pixelRatio;
      late bool _large;
      late bool _medium;
      TextEditingController emailController = TextEditingController();
      TextEditingController passwordController = TextEditingController();
      GlobalKey<FormState> _key = GlobalKey();
      final FirebaseAuth _auth = FirebaseAuth.instance;

      @override
      Widget build(BuildContext context) {
        _height = MediaQuery.of(context).size.height;
        _width = MediaQuery.of(context).size.width;
        _pixelRatio = MediaQuery.of(context).devicePixelRatio;
        _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
        _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
        return Scaffold(
          body: Material(
            child: Container(
              height: _height,
              width: _width,
              padding: EdgeInsets.only(bottom: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    clipShape(),
                    welcomeTextRow(),
                    signInTextRow(),
                    form(),
                    SizedBox(height: _height / 12),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 50.0,
              child: Center(
                child: Text(
                  '© 2024 alhandasiya. All rights reserved.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
        );
      }

    Widget clipShape() {
    return Stack(
    children: <Widget>[
    Opacity(
    opacity: 0.75,
    child: ClipPath(
    clipper: CustomShapeClipper(),
    child: Container(
    height: _large ? _height / 4 : (_medium ? _height / 3.75 : _height / 3.5),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Colors.blue[200]!, Colors.indigo],
    ),
    ),
    ),
    ),
    ),
    Opacity(
    opacity: 0.5,
    child: ClipPath(
    clipper: CustomShapeClipper2(),
    child: Container(
    height: _large ? _height / 4.5 : (_medium ? _height / 4.25 : _height / 4),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Colors.blue[200]!, Colors.indigo],
    ),
    ),
    ),
    ),
    ),
    ],
    );
    }

    Widget welcomeTextRow() {
    return Container(
    margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
    child: Row(
    children: <Widget>[
    Text(
    "Welcome",
    style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: _large ? 60 : (_medium ? 50 : 40),
    ),
    ),
    ],
    ),
    );
    }

    Widget signInTextRow() {
    return Container(
    margin: EdgeInsets.only(left: _width / 15.0),
    child: Row(
    children: <Widget>[
    Text(
    "Sign in to your account",
    style: TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: _large ? 20 : (_medium ? 17.5 : 15),
    ),
    ),
    ],
    ),
    );
    }

    Widget form() {
    return Container(
    margin: EdgeInsets.only(left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
    child: Form(
    key: _key,
    child: Column(
    children: <Widget>[
    emailTextFormField(),
    SizedBox(height: _height / 40.0),
    passwordTextFormField(),
    SizedBox(height: _height / 40.0),
    ElevatedButton(
    onPressed: signInWithEmailAndPassword,
    style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    ),
    primary: Colors.blue[200],
    ),
    child: Container(
    alignment: Alignment.center,
    width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
    padding: const EdgeInsets.all(12.0),
    child: Text(
    'SIGN IN',
    style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
    ),
    ),
    ),
    ],
    ),
    ),
    );
    }
    Widget emailTextFormField() {
    return CustomTextField(
    keyboardType: TextInputType.emailAddress,
    textEditingController: emailController,
    icon: Icons.email,
    hint: "Email ID",
    );
    }

    Widget passwordTextFormField() {
    return CustomTextField(
    keyboardType: TextInputType.emailAddress,
    textEditingController: passwordController,
    icon: Icons.lock,
    obscureText: true,
    hint: "Password",
    );
    }

    Future<void> signInWithEmailAndPassword() async {
    if (_key.currentState!.validate()) {
    try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text,
    );
    // Sign in successful, navigate to AdminPage.
    Navigator.of(context).pushReplacement(
    MaterialPageRoute(
    builder: (context) => AdminPage(),
    ),
    );
    } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
    // Invalid email or password, show appropriate error message.
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Invalid email or password.'),
    duration: Duration(milliseconds: 1500),
    ),
    );
    } else {
    // Other FirebaseAuthExceptions, show a generic error message.
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Error signing in: $e'),
    duration: Duration(milliseconds: 1500),
    ),
    );
    }
    } catch (e) {
    // Handle other errors (e.g., network issues).
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Error signing in: $e'),
    duration: Duration(milliseconds: 1500),
    ),
    );
    }
    } else {
    // Show a snackbar indicating that the email and password fields are required.
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Please fill in the email and password fields.'),
    duration: Duration(milliseconds: 1500),
    ),
    );
    }
    }
    Widget signUpTextRow() {
    return Container(
    margin: EdgeInsets.only(top: _height / 120.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Text(
    "Don't have an account?",
    style: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: _large ? 14 : (_medium ? 12 : 10)),
    ),
    ],
    ),
    );
    }
    }

    class CustomShapeClipper extends CustomClipper<Path> {
    @override
    Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 70);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
    firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 50.0);
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
    }

    @override
    bool shouldReclip(CustomClipper oldClipper) => true;
    }

    class CustomShapeClipper2 extends CustomClipper<Path> {
    @override
    Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
    firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 5);
    var secondControlPoint = Offset(size.width * .75, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
    }

    @override
    bool shouldReclip(CustomClipper oldClipper) => true;
    }

    class ResponsiveWidget {
    static bool isScreenLarge(double width, double pixel) {
    return width * pixel >= 1440;
    }

    static bool isScreenMedium(double width, double pixel) {
    return width * pixel < 1440 && width * pixel >= 1080;
    }

    static bool isScreenSmall(double width, double pixel) {
    return width * pixel <= 720;
    }
    }

    class CustomTextField extends StatelessWidget {
    final String hint;
    final TextEditingController textEditingController;
    final TextInputType keyboardType;
    final bool obscureText;
    final IconData icon;
    late double _width;
    late double _pixelRatio;
    late bool large;
    late bool medium;

    CustomTextField({
    required this.hint,
    required this.textEditingController,
    required this.keyboardType,
    required this.icon,
    this.obscureText = false,
    });

    @override
    Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
    borderRadius: BorderRadius.circular(30.0),
    elevation: large ? 12 : (medium ? 10 : 8),
    child: TextFormField(
    controller: textEditingController,
    keyboardType: keyboardType,
    cursorColor: Colors.blue[200]!,

    decoration: InputDecoration(
    prefixIcon: Icon(icon, color: Colors.blue[200]!, size: 20),
    hintText: hint,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide.none),

    ),

    ),

    );
    }
    }