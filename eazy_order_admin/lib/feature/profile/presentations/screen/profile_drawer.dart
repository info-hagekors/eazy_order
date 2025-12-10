import 'dart:io';

import 'package:core/config/app_colors.dart';
import 'package:eazy_order_admin/feature/profile/presentations/widget/wave_clipper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController(
    text: "Angelina Jolie",
  );
  final TextEditingController emailController = TextEditingController(
    text: "angelina@eazyorder.com",
  );
  final TextEditingController mobileController = TextEditingController(
    text: "+91 98765 43210",
  );

  String? selectedRole;


  Future<void> _pickProfileImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  static const List<String> roles = [
    'Admin',
    'Manager',
    'Waiter',
    'Chef',
  ];


  void _saveProfile() {
    final String name = nameController.text.trim();
    final String mobile = mobileController.text.trim();

    if (name.isEmpty || mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and Mobile cannot be empty")),
      );
      return;
    }

    // ✅ DEBUG (replace with API call)
    debugPrint("✅ SAVED PROFILE");
    debugPrint("Name: $name");
    debugPrint("Mobile: $mobile");
    debugPrint("Image: ${profileImage?.path}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );

    // ✅ Optional: close drawer
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 350,
      backgroundColor: AppColors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
        ),
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 240,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accentColor, AppColors.accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children:  [
                      GestureDetector(
                        onTap: _pickProfileImage,
                        child: CircleAvatar(
                          radius: 68,
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!)
                              : const AssetImage("assets/images/profile_pic.png")
                          as ImageProvider,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                ),

                                Positioned(
                                  right: 6,
                                  bottom: 6,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.white,
                                    child: const Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: AppColors.black,
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
              ),
            ),

            SizedBox(height: 15),

            // ✅ MENU ITEMS
         Expanded(
           child: SingleChildScrollView(
             child: Column(
               children: [
                 _editableField(
                   icon: Icons.person,
                   controller: nameController,
                 ),
                 SizedBox(height: 15),

                 _editableField(
                   icon: Icons.email,
                   controller: emailController,
                   keyboardType: TextInputType.emailAddress,
                   readOnly: true,
                 ),
                 SizedBox(height: 15),

                 _editableField(
                   icon: Icons.phone,
                   controller: mobileController,
                   keyboardType: TextInputType.phone,
                   readOnly: true
                 ),
                 SizedBox(height: 15),

                 _roleDropdown(),
               ],
             ),
           ),
         ),

            Padding(
              padding: const EdgeInsets.all(30),
              child: SizedBox(
                width: 170,
                height: 38,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editableField({
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    TextStyle? textstyle,

  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        enableInteractiveSelection: !readOnly,

        style: TextStyle(fontSize: 12.5,color: readOnly ? AppColors.black26 : AppColors.black,),  //common textStyle for all..........
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 13,
              horizontal: 12
          ),
          prefixIcon: Icon(icon, color: readOnly ? AppColors.black26 : AppColors.black,size: 16),   //common icon for all...........
          filled: true,
          fillColor: AppColors.background2.withOpacity(.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
  Widget _roleDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 4),
      child: DropdownButtonFormField<String>(
        dropdownColor: AppColors.white,
        value: selectedRole,
        isDense: true,
        hint: const Text(
          "Select role",
          style: TextStyle(
              fontSize: 13,
              color: AppColors.black),
        ),
        style: TextStyle(
          fontSize: 14
        ),
        items: roles.map((role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRole = value;
          });
        },
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 13,
              horizontal: 12
          ),
          prefixIcon: const Icon(Icons.work,color: AppColors.black45,size: 16,),   //only for select role icon......................
          suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined,color: AppColors.black,size: 20),
          filled: true,
          fillColor: AppColors.background2.withOpacity(.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
