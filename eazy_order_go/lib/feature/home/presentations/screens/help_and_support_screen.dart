import 'package:core/config/app_colors.dart';
import 'package:flutter/material.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("Help & Support Page",style: TextStyle(fontSize: 19, color: AppColors.primaryColor),),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18, top: 4, bottom: 4),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade400, // Border color
                  width: 1.2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.imageBgColor,
      ),
    );
  }
}
