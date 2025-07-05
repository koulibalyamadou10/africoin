import 'package:africoin/widgets/custom_button.dart';
import 'package:africoin/dimensions/app_dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africoin/pages/login_page/login_page.dart';
import 'package:africoin/pages/signup_page/signup_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Widget> _pages = [
    const OnboardingPage1(),
    const OnboardingPage2(),
    const OnboardingPage3(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _pages,
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 30,
            child: TextButton(
              onPressed: () {
                if (_currentPage < _pages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  // Navigate to login/signup
                }
              },
              child: Text(
                _currentPage == _pages.length - 1 ? '' : 'PASSER',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _currentPage == i
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
      );
    }
    return indicators;
  }
}

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimension.paddingHorizontal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'AFRICOIN',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'UNE MONNAIE, UN CONTINENT',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          Image.asset(
            'assets/images/1-sf.png', // Replace with your actual image
            height: 250,
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimension.paddingHorizontal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'AFRICOIN',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Notre mission',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Faciliter les paiements à travers l\'Afrique grâce à une monnaie numérique commune.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 40),
          Image.asset(
            'assets/images/1-sf.png', // Replace with your actual image
            height: 200,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage3 extends StatefulWidget {
  const OnboardingPage3({super.key});

  @override
  _OnboardingPage3State createState() => _OnboardingPage3State();
}

class _OnboardingPage3State extends State<OnboardingPage3> {
  final PageController _benefitsController = PageController();
  int _currentBenefit = 0;

  final List<String> benefits = [
    'Envoi d\'argent instantané',
    'Transactions sécurisées',
    'Frais réduits',
  ];

  @override
  void dispose() {
    _benefitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimension.paddingHorizontal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'AFRICOIN',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Vos avantages',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 40),
          // Mettre les textes ici et tu les alignes pour que il commence au meme endroit a gauche met les moi dans une liste
          Container(
            child: Column(
              children: [
                Text('1. ${benefits[0]}'),
                Text('2. ${benefits[1]}'),
                Text('3. ${benefits[2]}'),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                text: 'SE CONNECTER',
                width: MediaQuery.of(context).size.width * 0.45,
                backgroundColor: Theme.of(context).colorScheme.primary,
                textStyle: const TextStyle(fontSize: 12),
                onTap: () {
                  Get.to(
                    () => const LoginPage(),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
              const SizedBox(width: 10),
              CustomButton(
                text: 'S\'INSCRIRE',
                width: MediaQuery.of(context).size.width * 0.45,
                textStyle: const TextStyle(fontSize: 12),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  Get.to(
                    () => const SignupPage(),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BenefitItem extends StatelessWidget {
  final String text;
  final bool isActive;

  const BenefitItem({super.key, required this.text, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            isActive
                ? const Color(0xFF284389).withOpacity(0.1)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border:
            isActive
                ? Border.all(color: const Color(0xFF284389), width: 1)
                : null,
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
