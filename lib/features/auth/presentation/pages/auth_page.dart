// ignore_for_file: prefer_const_constructors

import 'package:dairy_app/core/animations/flip_card_animation.dart';
import 'package:dairy_app/core/dependency_injection/injection_container.dart';
import 'package:dairy_app/features/auth/data/repositories/fingerprint_auth_repo.dart';
import 'package:dairy_app/features/auth/presentation/widgets/quit_app_dialog.dart';
import 'package:dairy_app/features/auth/presentation/widgets/sign_in_form.dart';
import 'package:dairy_app/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatefulWidget {
  // user id of last logged in user to determine if it is a fresh login or not
  final String? lastLoggedInUserId;
  late FingerPrintAuthRepository fingerPrintAuthRepository;

  AuthPage({Key? key, this.lastLoggedInUserId}) : super(key: key) {
    fingerPrintAuthRepository = sl<FingerPrintAuthRepository>();
    fingerPrintAuthRepository.startFingerPrintAuthIfNeeded();
  }
  static String get route => '/auth';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late Image neonImage;

  @override
  void initState() {
    super.initState();
    neonImage = Image.asset("assets/images/background.png");
  }

  @override
  void didChangeDependencies() {
    precacheImage(neonImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool res = await quitAppDialog(context);
        if (res == true) {
          SystemNavigator.pop();
        }

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/background.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlipCardAnimation(
                    frontWidget: (void Function() flipCard) {
                      return SignUpForm(flipCard: flipCard);
                    },
                    rearWidget: (void Function() flipCard) {
                      return SignInForm(
                          flipCard: flipCard,
                          lastLoggedInUserId: widget.lastLoggedInUserId);
                    },
                  ),
                  const SizedBox(height: 40),
                  if (widget.fingerPrintAuthRepository
                          .shouldActivateFingerPrint() &&
                      MediaQuery.of(context).viewInsets.bottom == 0)
                    Icon(
                      Icons.fingerprint,
                      size: 50,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// shdjdjeui
