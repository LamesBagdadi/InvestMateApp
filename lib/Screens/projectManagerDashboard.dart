import 'package:flutter/material.dart';
import '../Theme/appColors.dart';

class ProjectManagerDashboard extends StatelessWidget {
  const ProjectManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome,", style: TextStyle(color: AppColors.textSecondary)),
                      Text("Project Manager", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Notification icon or create project button
                ],
              ),
              // ... Add project manager specific content
            ],
          ),
        ),
      ),
    );
  }
}