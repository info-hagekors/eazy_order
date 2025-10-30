import 'package:core/core.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:eazy_order_admin/feature/auth/application/sign_in_controller.dart';
import 'package:eazy_order_admin/feature/auth/presentation/screens/sign_up_screen.dart';
import 'package:eazy_order_admin/feature/auth/presentation/widgets/common_card.dart';
import 'package:eazy_order_admin/feature/main_screen/presentations/screens/main_screen.dart';
import 'package:eazy_order_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

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
        body: Responsive.isDesktop(context) ? Center(
          child: contentDesktopWidget(),
        ) : contentMobileWidget()
    );
  }

  Widget contentDesktopWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonCard(
          //width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Expanded(
              flex: 3,
                child: Column(
                  children: [
                    Text(
                      'Eazy Order',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('Smart Ordering System'),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 350,
                      child: SvgPicture.asset('assets/icons/main.svg', semanticsLabel: ''),
                    )
                  ],
                )),
            const VerticalDivider(
              width: 1,
              color: AppColors.white,
            ),
            Expanded(
              flex: 2,
              child: _signInFormWidget(),
            )
          ]),
        )
      ],
    );
  }

  Widget _signInFormWidget() {
    final controller = ref.read(signInControllerProvider.notifier);
    final state = ref.watch(signInControllerProvider);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign In',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Email',
              style: const TextStyle(fontSize: 12),
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
                  fit: BoxFit.contain,
                ),
              ),
              onChanged: (String val) => controller.onEmailChange(val),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Password',
              style: const TextStyle(fontSize: 12),
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
              suffixIcon: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/lock.svg',
                  fit: BoxFit.contain,
                ),
              ),
              onChanged: (String val) => controller.onPasswordChange(val)
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
              text: 'Sign In',
              isLoading: state.isLoading,
              onPressed: state.isValid ? () {
                controller.onSignInClick();
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
                Text("Don't have an account? "),
                InkWell(
                  child: Text(
                    'SignUp',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    ref.read(goRouterProvider).push(SignUpScreen.routeName);
                  },
                )
              ],
            )
          ],
        ));
  }

  Widget contentMobileWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: _signInFormWidget()
    );
  }
}
