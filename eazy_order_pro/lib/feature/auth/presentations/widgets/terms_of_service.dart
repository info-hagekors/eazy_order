/*

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:core/core.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  static const termsOfService = 'These Terms of Service govern your use of Jiinue App, our website located at https://Jiinue.com, and any related services provided by Jiinue App.\n\nWhen you create an Jiinue account or use Jiinue, you agree to abide by these Terms of Service and to comply with all applicable laws and regulations. If you do not agree with these Terms of Service, you are prohibited from further using the app, accessing our website, or using any other services provided by Jiinue.\n\nIf you access or download Jiinue from (1) the Apple App Store, you agree to any Usage Rules set forth in the App Store Terms of Service; and/or (2) the Google Play Store, you agree to the Android, Google Inc. Terms and Conditions including the Google Apps Terms of Service.\n\nWe, Jiinue, reserve the right to review and amend any of these Terms of Service at our sole discretion. Upon doing so, we will update this page and notify you through the app and/or the email address you provided when  you created your account. Any changes to these Terms of Service will take effect immediately from the date of publication.\n\nThese Terms of Service were last updated on 29 January 2022.';
  static const limitationsOfUse = "By using Jiinue and our website, you warrant on behalf of yourself, any entity who you represent who has entered into these Terms of Service, and your users that you will not:\n\nmodify, copy, prepare derivative works of, decompile, or reverse engineer Jiinue or any materials and software contained within Jiinue or on our websiteremove any copyright or other proprietary notations from Jiinue or any materials and software contained within Jiinue or on our website;\ntransfer Jiinue or any of its associated materials to another person or “mirror” the materials on any other server;\nknowingly or negligently use Jiinue or any of its associated services in a way that abuses or disrupts our networks or any other service Jiinue provides;\nuse Jiinue or its associated services to transmit or publish any harassing, indecent, obscene, fraudulent, or unlawful material;\nuse Jiinue or its associated services in violation of any applicable laws or regulations;\nuse Jiinue to send unauthorized advertising or spam;harvest, collect, or gather user data without the user’s consent; or\nuse Jiinue or its associated services in such a way that may infringe the privacy, intellectual property rights, or other rights of third parties.\n\nIntellectual Property\n\nThe intellectual property in the materials in Jiinue and on our website are owned by or licensed to Jiinue. You may download Jiinue, to view, use, and display the application on your mobile device for your personal use only.\n\nThis constitutes the grant of a license, not a transfer of title. This license shall automatically terminate if you violate any of these restrictions or these Terms of Service, and may be terminated by Jiinue at any time.\n\nUser-Generated Content\n\nYou retain your intellectual property ownership rights over content you submit to us for publication within Jiinue and/or on its corresponding website. We will never claim ownership of your content, but we do require a license from you in order to use it.\n\nWhen you use Jiinue or its associated services to post, upload, share, or otherwise transmit content covered by intellectual property rights, you grant to us a non-exclusive, royalty-free, transferable, sub-licensable, worldwide license to use, distribute, modify, run, copy, publicly display, translate, or otherwise create derivative works of your content in a manner that is consistent with your privacy preferences and our Privacy Policy.\n\nThe license you grant us can be terminated at any time by deleting your content or account. However, to the extent that we (or our partners) have used your content in connection with commercial or sponsored content, the license will continue until the relevant commercial or post has been discontinued by us.\n\nYou give us permission to use your username and other identifying information associated with your account in a manner that is consistent with your privacy preferences, and our Privacy Policy.\n\nAutomatic Updates\n\nYou give us permission to download and install updates to Jiinue on your device in accordance with your privacy preferences. This permission can be revoked at any time by deleting Jiinue from your device.\n\nLiability\n\nJiinue and the materials in Jiinue and on our website are provided on an 'as is' basis. To the extent permitted by law, Jiinue makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property, or other violation of rights.\n\nIn no event shall Jiinue or its suppliers be liable for any consequential loss suffered or incurred by you or any third party arising from the use or inability to use Jiinue, our website, or any other services provided by Jiinue or the materials in Jiinue, even if Jiinue or an authorized representative has been notified, orally or in writing, of the possibility of such damage.\n\nIn the context of this agreement, “consequential loss” includes any consequential loss, indirect loss, real or anticipated loss of profit, loss of benefit, loss of revenue, loss of business, loss of goodwill, loss of opportunity, loss of savings, loss of reputation, loss of use and/or loss or corruption of data, whether under statute, contract, equity, tort (including negligence), indemnity, or otherwise.Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.42.h,),
            Text(
              'Terms of Service',
              style: GoogleFonts.interTight(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.label1
              ),
            ),
            SizedBox(height: 20.h,),
            Text(
              termsOfService,
              style: GoogleFonts.interTight(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black.withAlpha(178)
              ),
            ),
            SizedBox(height: 46.h,),
            Text(
              'Limitations of Use\n',
              style: GoogleFonts.interTight(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.label1
              ),
            ),
            Text(
              limitationsOfUse,
              style: GoogleFonts.interTight(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black.withAlpha(178)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
