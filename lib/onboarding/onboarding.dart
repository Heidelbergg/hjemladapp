import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hjemladapp/authentication/verifyPhone.dart';
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
              title: 'FIND ELBIL',
              body: 'Find en elbil nær dig. Du betaler kun for antal kørte kilometer.',
              decoration: const PageDecoration(),
              image: Center(
                  child: SvgPicture.asset('assets/City driver-cuate.svg')
              ),
              reverse: true,
            ),
            PageViewModel(
              title: 'LÅS OP OG KØR',
              body: 'Lås elbilen op igennem din telefon, og start turen.',
              decoration: const PageDecoration(),
              image: Center(
                  child: SvgPicture.asset('assets/Car driving-bro.svg')
              ),
              reverse: true,
            ),
            PageViewModel(
              title: 'AFSLUT OG LAD OP',
              body: 'Færdiggør din tur og tilslut elbilen til en lader.' ,
              decoration: const PageDecoration(),
              image: Center(
                  child: SvgPicture.asset('assets/Electric car-cuate.svg')
              ),
              reverse: true,
            ),
          ],
          onDone: () {
            Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300), type: PageTransitionType.rightToLeft, child: SignupPageOTP()));
          },
        ),
      ),
    );
  }
}
