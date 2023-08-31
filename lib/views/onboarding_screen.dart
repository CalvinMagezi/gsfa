import 'package:flutter/material.dart';
import 'package:mobile_gosoft/views/create_account/create_account_screen.dart';
import 'package:mobile_gosoft/widgets/bottomsheets/login_bottom_sheet.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "title": "View real-time consumption",
      "description":
          "Easily track your water usage in real-time - helping you manage of your consumption.",
      "image": "assets/images/onboarding_image1.png",
    },
    {
      "title": "Notifications",
      "description": "Get reminded when you need to settle your water bills.",
      "image": "assets/images/onboarding_image1.png",
    },
    {
      "title": "Transparent billing",
      "description":
          "Understand how your water charges and final amount are broken down.",
      "image": "assets/images/onboarding_image1.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) => OnboardingPage(
              title: onboardingData[index]["title"]!,
              description: onboardingData[index]["description"]!,
              image: onboardingData[index]["image"]!,
              icon: index == 0 || index == 1
                  ? PhosphorIcons.light.caretRight
                  : null,
            ),
          ),
          if (_currentPage > 0)
            Positioned(
              top: 60.0,
              left: 16.0,
              child: GestureDetector(
                onTap: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
                child: Icon(
                  PhosphorIcons.light.arrowLeft,
                  color: Colors.black,
                  size: 48,
                ),
              ),
            ),
          if (_currentPage == onboardingData.length - 1)
            Positioned(
              bottom: 32.0,
              left: 16.0,
              right: 16.0,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountScreen(),
                          ),
                        );
                      },
                      child: Text("Create Account"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1570ef),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFEFF8FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return LoginBottomSheet();
                          },
                        );
                      },
                      child: Text(
                        "Log in",
                        style: TextStyle(color: Color(0xff1849a9)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_currentPage == 0 || _currentPage == 1)
            Positioned(
              bottom: 32.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  Container(
                    height: 16.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: _currentPage == 0 ? 12.0 : 8.0,
                          height: _currentPage == 0 ? 12.0 : 8.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == 0
                                ? Color(0xff175CD3)
                                : Colors.transparent,
                            border: Border.all(
                              color: Color(0xff175CD3),
                              width: 1.0,
                            ),
                          ),
                        ),
                        Container(
                          width: _currentPage == 1 ? 12.0 : 8.0,
                          height: _currentPage == 1 ? 12.0 : 8.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == 1
                                ? Color(0xff175CD3)
                                : Colors.transparent,
                            border: Border.all(
                              color: Color(0xff175CD3),
                              width: 1.0,
                            ),
                          ),
                        ),
                        Container(
                          width: _currentPage == 2 ? 12.0 : 8.0,
                          height: _currentPage == 2 ? 12.0 : 8.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == 2
                                ? Color(0xff175CD3)
                                : Colors.transparent,
                            border: Border.all(
                              color: Color(0xff175CD3),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: Color(0xff1570ef),
                        radius: 35.0,
                        child: Icon(
                          PhosphorIcons.light.caretRight,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final IconData? icon;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 270.0,
        ),
        SizedBox(height: 32.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xff111827),
            ),
          ),
        ),
      ],
    );
  }
}
