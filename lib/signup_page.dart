import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordMatch = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _validatePassword() {
    setState(() {
      _isPasswordMatch = _passwordController.text == _confirmPasswordController.text;
      _validateForm();
    });
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _isPasswordMatch;
    });
  }

  void _showEmptyFieldsNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            const SizedBox(height: 250),
            Expanded(
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
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Alexandria',
                          color: Color(0xFF381E72),
                        ),
                      ),
                      const SizedBox(height: 30,),
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
                            hintText: "Username",
                            hintStyle: TextStyle(color: Color(0xFFB9B0B0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alexandria-Light'),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => _validateForm(),
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
                          obscureText: !_isPasswordVisible,
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
                          onChanged: (value) => _validatePassword(),
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
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            hintStyle: const TextStyle(color: Color(0xFFB9B0B0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alexandria-Light'),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              padding: const EdgeInsets.only(bottom: 5),
                              icon: Icon(
                                _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFFB9B0B0),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) => _validatePassword(),
                        ),
                      ),
                      if (!_isPasswordMatch)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Passwords do not match",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 40,),
                      Container(
                        width: 333,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1877F2),
                              Color(0xFF0E458C),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ElevatedButton(
                          onPressed: _isFormValid ? () {
                            if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                              _showEmptyFieldsNotification();
                            } else {
                              Navigator.pushNamed(context, '/emailAdd');
                              print("Signup clicked");
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
                            "Sign up",
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
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Already Have An Account? ",
                            style: TextStyle(
                              color: Color(0xFF131212),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alexandria-Light',
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Login",
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