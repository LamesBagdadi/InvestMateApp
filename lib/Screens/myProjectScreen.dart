import 'package:flutter/material.dart';
import '../Theme/appColors.dart';

class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with "Create New Project" button
            // List of manager's projects
            // Drafts, Active, Funded tabs
          ],
        ),
      ),
    );
  }
}