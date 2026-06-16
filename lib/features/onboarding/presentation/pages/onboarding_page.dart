import 'package:flutter/material.dart';
import 'package:sikhsha_sathi/features/auth/presentation/pages/login_view.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
  });

  @override
  State<OnboardingPage> createState() =>
      _OnboardingPageState();
}

class _OnboardingPageState
    extends State<OnboardingPage> {
  final PageController _controller =
      PageController();

  int currentIndex = 0;

  final List<Map<String, dynamic>>
  pages = [
    {
      'icon': Icons.school,
      'title': 'Find Best Schools',
      'desc':
          'Get top schools recommended for your future',
    },
    {
      'icon': Icons.search,
      'title': 'Search Easily',
      'desc':
          'Search schools by location and rating',
    },
    {
      'icon': Icons.star,
      'title': 'Top Recommendations',
      'desc':
          'Smart recommendations for students',
    },
  ];

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginView(),
      ),
    );
  }

  void nextPage() {
    if (currentIndex ==
        pages.length - 1) {
      goToLogin();
    } else {
      _controller.nextPage(
        duration:
            const Duration(
              milliseconds: 300,
            ),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
              child: Align(
                alignment:
                    Alignment.centerRight,
                child: TextButton(
                  onPressed: goToLogin,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.all(
                          30,
                        ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Icon(
                          pages[index]['icon'],
                          size: 140,
                          color: Colors.blue,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          pages[index]['title'],
                          style:
                              const TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          pages[index]['desc'],
                          textAlign:
                              TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator Dots
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  margin:
                      const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                  width:
                      currentIndex == index
                          ? 20
                          : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        currentIndex == index
                            ? Colors.blue
                            : Colors.grey,
                    borderRadius:
                        BorderRadius.circular(
                          10,
                        ),
                  ),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nextPage,
                  child: Text(
                    currentIndex ==
                            pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}