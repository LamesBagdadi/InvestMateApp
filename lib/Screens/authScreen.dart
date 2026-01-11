import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ADD THIS
import '../Theme/appColors.dart';
import 'package:my_app/mainWrapper.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  String? _selectedRole; // investor or project manager
  bool _isLoading = false; // ADD THIS for loading state

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance; // ADD THIS

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ADD THIS: Firebase Authentication Methods
  Future<void> _authenticate() async {
    // REMOVED role validation - only check required fields

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar("Please fill all fields", isError: true);
      return;
    }

    if (!isLogin && _nameController.text.isEmpty) {
      _showSnackBar("Please enter your name", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isLogin) {
        // LOGIN EXISTING USER
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        _showSnackBar("Login successful!", isError: false);
      } else {
        // CREATE NEW USER
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save additional user data to Firebase Realtime Database
        await _saveUserData(userCredential.user!);

        _showSnackBar("Account created successfully!", isError: false);
      }

      // Navigate to MainWrapper AFTER successful auth
      _navigateToMainWrapper();

    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      String errorMessage = "Authentication failed";

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password";
          break;
        case 'email-already-in-use':
          errorMessage = "Email already in use";
          break;
        case 'weak-password':
          errorMessage = "Password should be at least 6 characters";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        default:
          errorMessage = e.message ?? "Authentication failed";
      }

      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar("An unexpected error occurred", isError: true);
      print("Auth error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ADD THIS: Save user data to Realtime Database
  Future<void> _saveUserData(User user) async {
    // We'll implement this fully later - for now just structure
    try{
      print("User created: ${user.uid}");
      print("Would save: Name: ${_nameController.text}");
    }
    catch(e){
      print("⚠️ Could not save user data (database not set up yet): $e");
    }

    // TODO: Implement database save
    // Example: await FirebaseDatabase.instance.ref('users/${user.uid}').set({...});
  }

  // ADD THIS: Navigation after successful auth
  void _navigateToMainWrapper() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainWrapper(
          userRole: _selectedRole ?? 'investor', // Default to investor
          userEmail: _emailController.text.trim(),
        ),
      ),
    );
  }

  // ADD THIS: Helper for showing snackbars
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isError ? Colors.white : AppColors.textMain),
        ),
        backgroundColor: isError ? Colors.red : AppColors.secondary,
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 175,
                width: 175,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/appLogo_investMate.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                isLogin ? "Welcome Back" : "Create Account",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isLogin
                    ? "Invest in your future today."
                    : "Join a community of smart investors.",
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),

              // role selection (only for sign Up) - KEEPING YOUR ORIGINAL DESIGN
              if (!isLogin) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "I am a:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMain,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildRoleSelection(),
                const SizedBox(height: 20),
              ],

              // Name field only for signup - YOUR ORIGINAL
              if (!isLogin) ...[
                _buildTextField(
                  "Full Name",
                  Icons.person_outline,
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
              ],

              // Email field - YOUR ORIGINAL
              _buildTextField(
                "Email Address",
                Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              // Password field - YOUR ORIGINAL
              _buildTextField(
                "Password",
                Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 10),
              if (isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement password reset
                      _showSnackBar("Password reset feature coming soon", isError: false);
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Login/Signup Button with loading state
              SizedBox(
                width: double.infinity,
                height: 55,
                child: _isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accent,
                  ),
                )
                    : ElevatedButton(
                  onPressed: _authenticate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    isLogin ? "Login" : "Get Started",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Toggle between Login/Signup - YOUR ORIGINAL
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? "New here?" : "Already have an account?",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null // Disable when loading
                        : () {
                      setState(() {
                        isLogin = !isLogin;
                        if (isLogin) {
                          _selectedRole = null; // Reset role when switching to login
                        }
                      });
                    },
                    child: Text(
                      isLogin ? "Create Account" : "Sign In",
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      IconData icon, {
        bool isPassword = false,
        TextEditingController? controller,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      enabled: !_isLoading, // Disable when loading
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  // Role selection widget - YOUR ORIGINAL DESIGN
  Widget _buildRoleSelection() {
    return Row(
      children: [
        Expanded(
          child: _buildRoleCard(
            title: "Investor",
            description: "Looking to invest in projects",
            icon: Icons.trending_up,
            isSelected: _selectedRole == "investor",
            onTap: () {
              setState(() {
                _selectedRole = "investor";
              });
            },
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildRoleCard(
            title: "Project Manager",
            description: "Seeking funding for projects",
            icon: Icons.business_center,
            isSelected: _selectedRole == "project_manager",
            onTap: () {
              setState(() {
                _selectedRole = "project_manager";
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.textMain,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? AppColors.primary.withOpacity(0.8)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}