import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8BBD9), // Light pink
              Color(0xFFE1BEE7), // Light purple
              Color(0xFF9C27B0), // Purple
              Color(0xFF673AB7), // Deep purple
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 50),
                
                // App Logo and Title
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mic,
                    size: 60,
                    color: Color(0xFF9C27B0),
                  ),
                ),
                
                SizedBox(height: 30),
                
                Text(
                  'Record Go',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                
                SizedBox(height: 10),
                
                Text(
                  'Your Voice, Your Story',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
                
                SizedBox(height: 50),
                
                // Login Form
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'LOG IN',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF673AB7),
                        ),
                      ),
                      
                      SizedBox(height: 40),
                      
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return Column(
                            children: [
                              CustomTextField(
                                controller: authProvider.loginEmailController,
                                hintText: 'Email',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              
                              SizedBox(height: 20),
                              
                              CustomTextField(
                                controller: authProvider.loginPasswordController,
                                hintText: 'Password',
                                icon: Icons.lock,
                                isPassword: true,
                              ),
                              
                              SizedBox(height: 20),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: false,
                                        onChanged: (value) {},
                                        activeColor: Color(0xFF9C27B0),
                                      ),
                                      Text(
                                        'Remind me',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 30),
                              
                              CustomButton(
                                text: 'Log In',
                                onPressed: _isLoading ? null : () => _handleLogin(authProvider),
                                backgroundColor: Color(0xFFF8BBD9),
                                textColor: Colors.white,
                                isLoading: _isLoading,
                              ),
                              
                              SizedBox(height: 20),
                              
                              Text(
                                'Or',
                                style: TextStyle(color: Colors.white70),
                              ),
                              
                              SizedBox(height: 20),
                              
                              CustomButton(
                                text: 'Register',
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                                ),
                                backgroundColor: Colors.transparent,
                                textColor: Colors.white,
                                borderColor: Color(0xFF673AB7),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    setState(() => _isLoading = true);
    
    try {
      await authProvider.login();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
} 