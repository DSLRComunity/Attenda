import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappButton extends StatelessWidget {
  const WhatsappButton({
    Key? key,
    required this.num,
    this.message,
  }) : super(key: key);
  final String num;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () async {
          await openWhatsapp(num, message);
        },
        child: SvgPicture.asset(
          'assets/images/whatsapp.svg',
          fit: BoxFit.cover,
          width: 30.w,
          height: 30.h,
        ));
  }

  Future<void> openWhatsapp(String num, String? message) async {
    var whatsappUrl = message == null
        ? 'https://api.whatsapp.com/send/?phone=+2$num&text=""'
        : 'https://api.whatsapp.com/send/?phone=+2$num&text=$message';
    launchUrl(Uri.parse(whatsappUrl));
  }
}
