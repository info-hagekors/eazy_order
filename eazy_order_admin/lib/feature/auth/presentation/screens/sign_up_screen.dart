import 'package:core/core.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:eazy_order_admin/feature/auth/application/sign_up_controller.dart';
import 'package:eazy_order_admin/feature/auth/entity/signup_entity.dart';
import 'package:eazy_order_admin/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:eazy_order_admin/feature/auth/presentation/widgets/common_card.dart';
import 'package:eazy_order_admin/feature/main_screen/presentations/screens/main_screen.dart';
import 'package:eazy_order_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = '/sign_up';

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.transparent,
        body: Stack(
          children:[
            if(Responsive.isDesktop(context))
              Positioned.fill(
                  child: Image.asset(
                      "assets/images/background.png",
                  fit: BoxFit.cover
                  ),
              ),
            Responsive.isDesktop(context)
                ? Center(child: contentDesktopWidget(state))
                : Container(
                color: AppColors.white,
            child: contentMobileWidget(state)),
          ],
        )
    );
  }

  Widget contentDesktopWidget(SignupEntity state) {
    return Row(
      children: [
        // 🔵 LEFT SECTION — gradient image already from parent (Stack background)
        Expanded(
          flex: 3,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Eazy Order',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Smart Ordering System',
                  style: TextStyle(
                    fontSize: 14.5,
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

        // ⚪ RIGHT SECTION — FULL HEIGHT WHITE CONTAINER
        Expanded(
          flex: 2,
          child: Container(
            height: double.infinity,
            color: AppColors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // FORM AREA
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
                      child: _stepWiseFormWidget(state),
                    ),
                  ),
                ),

                // FOOTER AREA
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "© 2025 Eazy Order ❤️ by Hagekors Technolabs",
                    textAlign: TextAlign.center,
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


  Widget _stepWiseFormWidget(SignupEntity state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // MAIN CONTENT
          state.currentStep == 1
              ? _signUpFormWidget(state)
              : state.currentStep == 2
              ? _verifyEmailWidget(state)
              : _createPasswordWidget(state),

          const SizedBox(height: 20),

        ],
      ),
    );
  }


  Widget _signUpFormWidget(SignupEntity state) {
    final controller = ref.read(signUpControllerProvider.notifier);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black
                ),
              ),
            ),
            const SizedBox(
              height: 55,
            ),
            Text(
              'Full Name :',
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
              hintText: 'Please enter your full name',
              keyboardType: TextInputType.emailAddress,
              /*validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                } else {
                  return null;
                }
              },*/
              suffixIcon: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/profile.svg',
                  color: AppColors.link,
                  fit: BoxFit.contain,
                ),
              ),
              onChanged: (String val) => controller.onFullNameChange(val),
            ),
            const SizedBox(
              height: 20,
            ),
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
              suffixIcon: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/email.svg',
                  color: AppColors.link,
                  fit: BoxFit.contain,
                ),
              ),
              onChanged: (String val) => controller.onEmailChange(val),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Mobile :',
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
              hintText: 'Please enter your 10 digit mobile number',
              keyboardType: TextInputType.visiblePassword,
              /*validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'Please enter a valid password';
                } else {
                  return null;
                }
              },*/
              suffixIcon: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/lock.svg',
                  fit: BoxFit.contain,
                  color: AppColors.link,
                ),
              ),
              onChanged: (String val) => controller.onMobileChange(val),
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(
                  height: 20,
                  child: Checkbox(
                    value: state.isAgree,
                    checkColor: AppColors.background2,
                    activeColor: AppColors.primaryColor,
                    //onChanged: (val) => setState(() => agreed = val ?? false),
                    onChanged: (val) => controller.onAgreeChange(val ?? false),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        'By clicking next button you are agree to',
                        style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                          color: AppColors.black
                        ),
                      ),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(AppConsts.termsCondition)),
                        child: Text(
                            "Terms & Conditions",
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                              decorationColor: AppColors.black
                            )
                        ),
                      ),
                      Text(
                        ' and ',
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(AppConsts.privacyPolicy)),
                        child: Text(
                            "Privacy Policy",
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.black
                            )
                        ),
                      ),
                      /*Text(
                        ' and ',
                        style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white
                        ),
                      ),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(AppConsts.refundPolicy)),
                        child: Text(
                            "Refund Policy",
                            style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline
                            )
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            AppButton(
              text: 'Register Now',
              color: AppColors.white,
              textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.5
              ),
              isLoading: state.isLoading1,
              onPressed: state.isStep1Validated ? () {
                ref.read(signUpControllerProvider.notifier).onStep1NextClick();
              } : null,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?  ->  ",
                  style: GoogleFonts.poppins(
                      color: AppColors.black
                  ),
                ),
                InkWell(
                  child: Text(
                    'SignIn',
                    style: GoogleFonts.poppins(
                        color: AppColors.link,
                      decoration: TextDecoration.underline,
                     decorationColor: AppColors.link,
                    ),
                  ),
                  onTap: () {
                    ref.read(goRouterProvider).push(SignInScreen.routeName);
                  },
                )
              ],
            ),
          ],
        )
    );
  }

  Widget _verifyEmailWidget(SignupEntity state) {
    final controller = ref.read(signUpControllerProvider.notifier);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify your email',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "We've send otp to you ${state.email} email and +91${state.mobile} mobile number",
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Enter Email OTP',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),
            CommonTextField(
              width: double.infinity,
              hintText: 'Please enter your email otp',
              /*validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                } else {
                  return null;
                }
              },*/
              suffixIcon: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/lock.svg',
                  color: AppColors.link,
                ),
              ),
              onChanged: (String val) => controller.onOtpEmailChange(val),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Enter mobile OTP',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),
            CommonTextField(
              width: double.infinity,
              //labelText: 'email',
              hintText: 'Please enter your mobile otp',
              /*validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                } else {
                  return null;
                }
              },*/
              suffixIcon: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/lock.svg',
                  color: AppColors.link,
                  fit: BoxFit.contain,
                ),
              ),
              onChanged: (String val) => controller.onOtpPhoneChange(val),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              text: 'Next',
              color: AppColors.primaryColor,
              onPressed: state.isStep2Validated ? () {
                controller.onStep2NextClick();
              } : null,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?  ->  ",
                  style: GoogleFonts.poppins(
                      color: AppColors.black,
                  ),
                ),
                InkWell(
                  child: Text(
                    'SignIn',
                    style:  GoogleFonts.poppins(
                        color: AppColors.link,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.link
                    ),
                  ),
                  onTap: () {
                    ref.read(goRouterProvider).push(SignInScreen.routeName);
                  },
                )
              ],
            ),
          ],
        ));
  }

  Widget _createPasswordWidget(SignupEntity state) {
    final controller = ref.read(signUpControllerProvider.notifier);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create your password',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Enter your password',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 10,
            ),
            CommonTextField(
              width: double.infinity,
              isObscureText: true,
              obscuringCharacter: '*',
              hintText: 'Please enter your password',
              keyboardType: TextInputType.emailAddress,
              /*validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                } else {
                  return null;
                }
              },*/
              suffixIcon: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/lock.svg',
                  fit: BoxFit.contain,
                  color: AppColors.link,
                ),
              ),
              onChanged: (String val) => controller.onPasswordChange(val),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Confirm Password',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),
            CommonTextField(
              width: double.infinity,
              hintText: 'Please enter confirm password',
              keyboardType: TextInputType.emailAddress,
              /*validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                } else {
                  return null;
                }
              },*/
              suffixIcon: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/lock.svg',
                  fit: BoxFit.contain,
                  color: AppColors.link,
                ),
              ),
              onChanged: (String val) => controller.onConfirmPasswordChange(val),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(height: 10,),
            AppButton(
              text: 'Finish',
              color: AppColors.primaryColor,
              isLoading: state.isLoading3,
              onPressed: state.isStep3Validated ? () {
                controller.onSignupClick();
              } : null,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?  ->  ",
                  style: GoogleFonts.poppins(
                      color: AppColors.black
                  ),),
                InkWell(
                  child: Text(
                    'SignIn',
                    style: GoogleFonts.poppins(
                        color: AppColors.link,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.link,
                    ),
                  ),
                  onTap: () {
                    ref.read(goRouterProvider).push(SignInScreen.routeName);
                  },
                )
              ],
            ),
          ],
        )
    );
  }

  Widget contentMobileWidget(SignupEntity state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: _stepWiseFormWidget(state),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            "© 2025 Eazy Order ❤️ by Hagekors Technolabs",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.black),
          ),
        ),

      ],
    );
  }
}
