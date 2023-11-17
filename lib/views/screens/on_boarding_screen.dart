import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';

import '../../constants/colors.dart';
import '../../constants/global.dart';
import '../widgets/primary_button.dart';
import 'auth/login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  static const String routeName = '/onBoarding';
  final PageController _pageController = PageController();

  OnBoardingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: OnBoard(
                pageController: _pageController,
                onSkip: () {
                  // print('skipped');
                },
                // Either Provide onDone Callback or nextButton Widget to handle done state
                onDone: () {
                  // print('done tapped');
                },
                onBoardData: onBoardData,
                titleStyles: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.15,
                ),
                descriptionStyles: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                pageIndicatorStyle: const PageIndicatorStyle(
                  width: 80,
                  inactiveColor: kGreyBorderColor,
                  activeColor: kOffersTitleColor,
                  inactiveSize: Size(8, 8),
                  activeSize: Size(22, 12),
                ),
                // Either Provide onSkip Callback or skipButton Widget to handle skip state
                skipButton: Row(
                  children: [
                    OnBoardConsumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(onBoardStateProvider);
                        return state.page != 0
                            ? IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.black),
                                onPressed: () => _onBackTap(state),
                              )
                            : Container();
                      },
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    TextButton(
                      onPressed: () async {
                        await storage.write(key: 'onBoarding', value: 'done');
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [kGreyBorderColor, kGreyBorderColor],
                          ),
                        ),
                        child: Text(
                          "Skip".tr(),
                          style: const TextStyle(
                            color: kGreyTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Either Provide onDone Callback or nextButton Widget to handle done state
                nextButton: OnBoardConsumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(onBoardStateProvider);
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          color: kPrimaryColor,
                          text:
                              state.isLastPage ? "Start Now".tr() : "Next".tr(),
                          onPressed: () async {
                            _onNextTap(state, context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNextTap(OnBoardState onBoardState, BuildContext context) async {
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      //print("nextButton pressed");
      await storage.write(key: 'onBoarding', value: 'done');
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    }
  }

  void _onBackTap(OnBoardState onBoardState) {
    if (onBoardState.page != 0) {
      _pageController.animateToPage(
        onBoardState.page - 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      //print("nextButton pressed");
    }
  }
}

final List<OnBoardModel> onBoardData = [
  OnBoardModel(
    title: 'Selecting a Car'.tr(),
    description:
        "Find your dream car and start the bidding process by selecting from a wide range of vehicles available on our car auction app."
            .tr(),
    imgUrl: "assets/images/onboarding_1.png",
  ),
  OnBoardModel(
    title: "Placing a Bid".tr(),
    description:
        "Discover the exciting world of car auctions and confidently place your bids on the vehicles that catch your eye."
            .tr(),
    imgUrl: "assets/images/onboarding_2.png",
  ),
  OnBoardModel(
    title: "Winning a Car".tr(),
    description:
        "Winning a car with Company app. Complete the transaction and become the proud owner of your desired vehicle."
            .tr(),
    imgUrl: "assets/images/onboarding_3.png",
  ),
];
