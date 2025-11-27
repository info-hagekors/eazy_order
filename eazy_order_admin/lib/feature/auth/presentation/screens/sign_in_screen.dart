import 'package:core/core.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:eazy_order_admin/feature/auth/application/sign_in_controller.dart';
import 'package:eazy_order_admin/feature/auth/presentation/screens/sign_up_screen.dart';
import 'package:eazy_order_admin/feature/auth/presentation/widgets/common_card.dart';
import 'package:eazy_order_admin/feature/main_screen/presentations/screens/main_screen.dart';
import 'package:eazy_order_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  static const String routeName = '/sign_in';

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Responsive.isDesktop(context)
      ?Colors.transparent
      :Colors.white,   //this is for mobile.....
      body: Stack(
        children: [
          // 🔵 Background Image
          // 🔵 Background Image only for Desktop/Web
          if (Responsive.isDesktop(context))
            Positioned.fill(
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.cover,
              ),
            ),


          // 🔵 Your existing sign-in UI
          Responsive.isDesktop(context)
              ? Center(child: contentDesktopWidget())
              : contentMobileWidget(),
        ],
      ),
      
    );
  }

  Widget contentDesktopWidget() {
    return Row(
      children: [
        // 🔵 LEFT SECTION (Gradient background already from parent Stack)
        Expanded(
          flex: 3,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Eazy Order',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Smart Ordering System',
                  style: TextStyle(
                    fontSize: 4.5.sp,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 350,
                  child: SvgPicture.asset(
                    'assets/icons/main.svg',
                    semanticsLabel: '',
                  ),
                ),
              ],
            ),
          ),
        ),

        // ⚪ RIGHT SECTION (FULL HEIGHT WHITE COLUMN)
        Expanded(
          flex: 2,
          child: Container(
            height: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
                      child: _signInFormWidget(),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "© 2025 Eazy Order ❤️ by Hagekors Technolabs",
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(fontSize: 14, color: AppColors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _signInFormWidget() {
    final controller = ref.read(signInControllerProvider.notifier);
    final state = ref.watch(signInControllerProvider);
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context) ?50 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome Back',
                style:  TextStyle(
                    fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,

                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                'Sign in to your account to continue',
                style:  TextStyle(
                  fontSize: 15,
                  color: AppColors.black,

                ),
              ),
            ),

            SizedBox(height: Responsive.isDesktop(context) ? 70 : 30),

            Text(
              'Email :',
              style:  TextStyle(
                  fontSize: 14,
                color: AppColors.black

              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CommonTextField(
              width: double.infinity,
              //labelText: 'email',
              hintText: 'Please enter your email',
              keyboardType: TextInputType.emailAddress,
              /*validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                } else {
                  return null;
                }
              },*/
              suffixIcon: Icon(Icons.email_outlined,color: AppColors.black12),
              onChanged: (String val) => controller.onEmailChange(val),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Password :',
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CommonTextField(
              width: double.infinity,
              obscuringCharacter: '*',
              isObscureText: true,
              hintText: 'Please enter your password',
              keyboardType: TextInputType.visiblePassword,
              /*validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'Please enter a valid password';
                } else {
                  return null;
                }
              },*/
              suffixIcon: Icon(Icons.remove_red_eye_outlined,color: AppColors.black12),
              onChanged: (String val) => controller.onPasswordChange(val)
            ),

            SizedBox(height: 30),

            AppButton(
              text: 'Log In',
              textStyle: TextStyle(fontSize: 15.5,color: AppColors.black),
              isLoading: state.isLoading,
              onPressed: state.isValid ? () {
                controller.onSignInClick();
              } : null,
            ),

            SizedBox(height:20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?  ->  ",style: TextStyle(color: AppColors.black),),
                InkWell(
                  child: Text(
                    'SignUp',
                    style: GoogleFonts.poppins(
                        color: AppColors.link,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.link
                    ),
                  ),
                  onTap: () {
                    ref.read(goRouterProvider).push(SignUpScreen.routeName);
                  },
                )
              ],
            ),

            SizedBox(height: Responsive.isDesktop(context) ? 70 : 30),

          ],
        ));
  }

  Widget contentMobileWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: _signInFormWidget(),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            "© 2025 Eazy Order ❤️ by Hagekors Technolabs",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(fontSize: 14, color: AppColors.black),
          ),
        ),

      ],
    );
  }
}
