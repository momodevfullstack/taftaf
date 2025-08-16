import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../core/theme/app_theme.dart';

/// Splash Screen et Onboarding pour Taf-Taf
/// Design simple et esthétique avec images d'arrière-plan
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // === CONTROLLERS D'ANIMATION ===
  late AnimationController _logoController;
  late AnimationController _fadeController;

  // === ANIMATIONS ===
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _fadeAnimation;

  // === ÉTAT DE L'APPLICATION ===
  PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showOnboarding = false;

  // === DONNÉES ONBOARDING TAF-TAF ===
  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      icon: Icons.handshake_rounded,
      title: "Échange de services",
      subtitle: "en toute simplicité",
      description: "",
      backgroundImage: 'assets/images/onboarding/page1_bg.png',
      accentColor: AppColors.primary,
    ),
    OnboardingData(
      icon: Icons.search_rounded,
      title: "Trouvez ou proposez",
      subtitle: "un service en quelques clics",
      description: "Des milliers de services disponibles",
      backgroundImage: 'assets/images/onboarding/page2_bg.png',
      accentColor: AppColors.secondary,
    ),
    OnboardingData(
      icon: Icons.credit_score_rounded,
      title: "Gagnez des crédits",
      subtitle: "ou proposez vos services professionnels",
      description: "Système de crédits intelligent",
      backgroundImage: 'assets/images/onboarding/page3_bg.png',
      accentColor: AppColors.primary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startSplashSequence();
  }

  void _initializeControllers() {
    // Contrôleur pour l'animation du logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Contrôleur pour le fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _setupAnimations();
  }

  void _setupAnimations() {
    // Animation du logo : scale + opacity
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Animation du fade
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void _startSplashSequence() async {
    // Démarrage de l'animation du logo
    _logoController.forward();

    // Attendre 3 secondes
    await Future.delayed(const Duration(milliseconds: 3000));

    if (mounted) {
      // Transition vers l'onboarding
      setState(() {
        _showOnboarding = true;
      });
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showOnboarding ? _buildOnboarding() : _buildSplash(),
    );
  }

  Widget _buildSplash() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
            AppColors.secondary.withOpacity(0.6),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _logoController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo principal avec animation
                Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Espacement
                const SizedBox(height: 40),

                // Nom de l'application avec animation
                Opacity(
                  opacity: _logoOpacityAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _logoOpacityAnimation.value)),
                    child: Text(
                      'Taf-Taf',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Sous-titre avec animation
                Opacity(
                  opacity: _logoOpacityAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 15 * (1 - _logoOpacityAnimation.value)),
                    child: Text(
                      'Freemium',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Espacement
                const SizedBox(height: 60),

                // Indicateur de chargement élégant
                Opacity(
                  opacity: _logoOpacityAnimation.value,
                  child: Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _logoController.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOnboarding() {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildOnboardingContent(),
        );
      },
    );
  }

  Widget _buildOnboardingContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Image de fond qui couvre TOUT l'écran (incluant les boutons)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    _onboardingData[_currentPage].backgroundImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Overlay global pour la lisibilité
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3), // Couleur sombre uniforme
            ),
          ),

          // Contenu de l'onboarding
          SafeArea(
            child: Column(
              children: [
                // Indicateur de progression
                _buildProgressIndicator(),

                // Pages d'onboarding
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingPage(_onboardingData[index]);
                    },
                  ),
                ),

                // Boutons de navigation
                _buildNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Logo miniature (plus petit)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.swap_horiz_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),

          const SizedBox(width: 8),

          // Titre (plus petit)
          Text(
            'Taf-Taf',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),

          const Spacer(),

          // Badge "Freemium" (plus discret)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              'FREEMIUM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _onboardingData.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 40 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône principale (plus petite)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(data.icon, size: 50, color: Colors.white),
              ),

              const SizedBox(height: 40),

              // Titre principal (plus petit)
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(0, 3),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),

              // Sous-titre avec accent color (plus petit)
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: data.accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Description (plus courte et plus discrète)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Text(
                  data.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    letterSpacing: 0.2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton "Précédent" (visible sauf sur la première page)
          _currentPage > 0
              ? Flexible(
                  child: TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Précédent',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(width: 80), // Espace vide plus petit
          // Bouton principal
          Flexible(
            flex: 2,
            child: _currentPage == _onboardingData.length - 1
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/auth');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0, // Pas d'ombre
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Commencer',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0, // Pas d'ombre
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Suivant',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Données pour l'onboarding
class OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String backgroundImage;
  final Color accentColor;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.backgroundImage,
    required this.accentColor,
  });
}

/// Peintre moderne pour les particules animées
class ModernParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 4 + 2;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Lignes de connexion subtiles
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 15; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = random.nextDouble() * size.width;
      final y2 = random.nextDouble() * size.height;

      if ((x1 - x2).abs() < 200 && (y1 - y2).abs() < 200) {
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
