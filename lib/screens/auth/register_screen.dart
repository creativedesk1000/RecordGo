import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                SizedBox(height: 30),
                
                // App Logo and Title
                Container(
                  width: 100,
                  height: 100,
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
                    size: 50,
                    color: Color(0xFF9C27B0),
                  ),
                ),
                
                SizedBox(height: 20),
                
                Text(
                  'Record Go',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                
                SizedBox(height: 10),
                
                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Register Form
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
                        'REGISTER',
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
                                controller: authProvider.registerNameController,
                                hintText: 'Full Name',
                                icon: Icons.person,
                              ),
                              
                              SizedBox(height: 20),
                              
                              CustomTextField(
                                controller: authProvider.registerEmailController,
                                hintText: 'Email Address',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              
                              SizedBox(height: 20),
                              
                              CustomTextField(
                                controller: authProvider.registerPhoneController,
                                hintText: 'Phone Number',
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                              ),
                              
                              SizedBox(height: 20),
                              
                              CustomTextField(
                                controller: authProvider.registerAddressController,
                                hintText: 'Address',
                                icon: Icons.location_on,
                              ),
                              
                              SizedBox(height: 20),
                              
                              CustomTextField(
                                controller: authProvider.registerPasswordController,
                                hintText: 'Password',
                                icon: Icons.lock,
                                isPassword: true,
                              ),
                              
                              SizedBox(height: 30),
                              
                              CustomButton(
                                text: 'Register',
                                onPressed: _isLoading ? null : () => _handleRegister(authProvider),
                                backgroundColor: Color(0xFFF8BBD9),
                                textColor: Colors.white,
                                isLoading: _isLoading,
                              ),
                              
                              SizedBox(height: 20),
                              
                              Text(
                                'Do you have an account?',
                                style: TextStyle(color: Colors.white70),
                              ),
                              
                              SizedBox(height: 20),
                              
                              CustomButton(
                                text: 'Log In',
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
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

  Future<void> _handleRegister(AuthProvider authProvider) async {
    setState(() => _isLoading = true);
    
    try {
      await authProvider.register();
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