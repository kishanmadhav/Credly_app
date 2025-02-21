import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'user_model.dart';
import 'main.dart'; // Import CibilScoreForm
import 'home_page.dart'; // Import HomePage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1), // Light blue background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Space for app name
                Text(
                  'Credly',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor, // Dark blue color from theme
                  ),
                ),
                const SizedBox(height: 40), // Space below the app name
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(_nameController, 'Name'),
                      _buildTextField(_emailController, 'Email'),
                      _buildTextField(_phoneController, 'Phone Number'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor, // Button color from theme
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded button
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final user = User(
                              name: _nameController.text,
                              email: _emailController.text,
                              phoneNumber: _phoneController.text,
                            );

                            // Save user information and navigate to the HomePage
                            Provider.of<UserModel>(context, listen: false).login(user);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage(userName: user.name)), // Navigate to HomePage
                            );
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners for text fields
            borderSide: BorderSide.none, // Remove border line
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding inside text field
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
