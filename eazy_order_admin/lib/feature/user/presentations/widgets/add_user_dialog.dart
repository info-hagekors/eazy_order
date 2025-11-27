import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUserDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreate;

  const AddUserDialog({super.key, required this.onCreate});

  @override
  State<AddUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String mobile = '';
  String role = 'Manager';

  final List<String> roles = ['Admin', 'Manager', 'Waiter', 'Chef'];

  bool isLoading = false;

  void submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => isLoading = true);

      final newUser = {
        'name': name,
        'email': email,
        'role': role,
        'createdAt': DateTime.now(),
      };

      await widget.onCreate(newUser);

      if (context.mounted) Navigator.of(context).pop();
    }
  }

  final labelStyle = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      title: Text(
          'Create New User',
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold
        ),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          //width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Name',
                style: labelStyle,
              ),
              CommonTextFormField(
                onChanged: (val) {},
                hintText: "Enter User's Full Name",
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => name = val ?? '',
              ),
              SizedBox(height: 10,),
              Text(
                'Email',
                style: labelStyle,
              ),
              CommonTextFormField(
                onChanged: (val) {},
                hintText: "Enter email address",
                onSaved: (val) => email = val ?? '',
                validator: (val) => val == null || !val.contains('@') ? 'Invalid email' : null,
              ),
              SizedBox(height: 10,),
              Text(
                'Mobile',
                style: labelStyle,
              ),
              CommonTextFormField(
                onChanged: (val) {},
                hintText: "Enter 10 digit mobile number",
                onSaved: (val) => mobile = val ?? '',
                validator: (val) => (val?.isEmpty ?? true) || val?.length != 10 ? 'Invalid mobile number' : null,
              ),
              SizedBox(height: 10,),
              Text(
                'Role',
                style: labelStyle,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: AppColors.background2
                    ),
                    color: AppColors.background3
                ),
                child: DropdownButtonFormField(
                  value: role,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.background3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.background3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.borderColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                  iconEnabledColor: AppColors.black,
                  items: roles
                      .map((r) => DropdownMenuItem(value: r, child: Text(r, style: labelStyle.copyWith(
                      fontWeight: FontWeight.normal
                  ),)))
                      .toList(),
                  onChanged: (val) => role = val ?? '',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel', style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black
          ),),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor
          ),
          child: isLoading ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ) : Text(
              'Create',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white
            ),
          ),
        ),
      ],
    );
  }
}
