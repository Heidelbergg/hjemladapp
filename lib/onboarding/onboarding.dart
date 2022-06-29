import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hjemladapp/authentication/verifyPhone.dart';
import 'package:hjemladapp/home/homepage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:page_transition/page_transition.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: IntroductionScreen(
          scrollPhysics: const BouncingScrollPhysics(),
          next: const Icon(Icons.arrow_forward_ios_rounded, size: 22),
          done: const Text("Begynd", style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: Colors.blue,
              color: Colors.black26,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)
              )
          ),
          pages: [
            PageViewModel(
              title: 'RESERVER TID',
              body: 'Reserver en lader i et tidsrum der passer dig. Du kan reservere 4 timer ad gangen.',
              decoration: const PageDecoration(),
              image: Center(
                  child: SvgPicture.asset('assets/City driver-cuate.svg')
              ),
              reverse: true,
            ),
            PageViewModel(
              title: 'SCAN OG LAD',
              body: 'Scan QR koden på ladestanderen med din telefon og start opladningen - nemt og enkelt.',
              decoration: const PageDecoration(),
              image: Center(
                  child: SvgPicture.asset('assets/Electric car-cuate.svg')
              ),
              reverse: true,
            ),
            PageViewModel(
              title: 'KUN TIL BEBOERNE',
              body: 'Laderne i din boligforening er kun tilgængelige til beboere med elbil. ',
              decoration: const PageDecoration(),
              image: Center(
                  child: SvgPicture.asset('assets/Houses-cuate.svg')
              ),
              reverse: true,
            ),
          ],
          onDone: (){
            Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: SignupPageOTP()));
          },
        ),
      ),
    );
  }
}
