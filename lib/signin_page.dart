import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import the DashboardPage

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isFormValid = false;
  bool _isEmailValid = true;

  void _validateForm() {
    setState(() {
      _isEmailValid = _validateEmail(_emailController.text);
      _isFormValid = _isEmailValid && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _showInvalidEmailNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid email address'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showEmptyFieldsNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in both email and password fields'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 75),
              child: Image.asset(
                'assets/images/speclab.png',
              ),
            ),
            const SizedBox(height: 320),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Alexandria',
                          color: Color(0xFF381E72),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        width: 333,
                        height: 60,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEDEA),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Color(0xFFB9B0B0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alexandria-Light'),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => _validateForm(),
                        ),
                      ),
                      if (!_isEmailValid)
                        const Padding(
                          padding: EdgeInsets.only(top: 5, right: 170),
                          child: Text(
                            'Invalid email address',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 10,),
                      Container(
                        width: 333,
                        height: 60,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEDEA),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible, // Hide the password input
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Color(0xFFB9B0B0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alexandria-Light'),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              padding: const EdgeInsets.only(bottom: 5),
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFFB9B0B0),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) => _validateForm(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight, // Align to the right
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15), // Add right padding
                          child: TextButton(
                            onPressed: () {
                              print("Forgot Password clicked");
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color(0xFF131212),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alexandria-Light',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 333,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1877F2), // Start color
                              Color(0xFF0E458C), // End color
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ElevatedButton(
                          onPressed: _isFormValid ? () {
                            if (!_isEmailValid) {
                              _showInvalidEmailNotification();
                            } else if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                              _showEmptyFieldsNotification();
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DashboardPage()),
                              );
                              print("Login clicked");
                            }
                          } : () {
                            _showEmptyFieldsNotification();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alexandria',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't Have An Account? ",
                            style: TextStyle(
                              color: Color(0xFF131212),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alexandria-Light',
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: Color(0xFF381E72),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Alexandria-Light',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}