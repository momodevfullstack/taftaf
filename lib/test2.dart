 // screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class Authensync extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

// Formulaire d'inscription séparé
class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      HapticFeedback.mediumImpact();
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bienvenue !',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Créez votre compte',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            _buildAdvancedTextField(
              controller: _nameController,
              label: 'Nom',
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 20),
            _buildAdvancedTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            _buildAdvancedTextField(
              controller: _passwordController,
              label: 'Mot de passe',
              icon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Color(0xFF6B7280),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            SizedBox(height: 24),
            _buildAdvancedButton(
              onPressed: _handleSignup,
              text: 'S\'inscrire',
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Ce champ est requis';
          }
          if (label == 'Email' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
            return 'Email invalide';
          }
          if (label == 'Mot de passe' && value!.length < 6) {
            return 'Minimum 6 caractères';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF667EEA), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red.shade400, width: 1),
          ),
          filled: true,
          fillColor: Color(0xFFF9FAFB),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildAdvancedButton({
    required VoidCallback onPressed,
    required String text,
    required bool isLoading,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}

class _AuthScreenState extends State<Authensync> with TickerProviderStateMixin {
  bool isLogin = true;
  
  late AnimationController _mainController;
  late AnimationController _backgroundController;
  late AnimationController _cardController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_backgroundController);

    _colorAnimation = ColorTween(
      begin: Color(0xFF667EEA),
      end: Color(0xFF764BA2),
    ).animate(_backgroundController);

    _mainController.forward();
    _cardController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _backgroundController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
    
    _cardController.reset();
    _cardController.forward();
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFF8B5CF6),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background animé
            _buildAnimatedBackground(),
            
            // Contenu principal
            SafeArea(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildMainContent(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Stack(
          children: [
            // Cercles flottants animés
            Positioned(
              top: 100,
              right: -50,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              left: -80,
              child: Transform.rotate(
                angle: -_rotationAnimation.value,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _colorAnimation.value?.withOpacity(0.2) ?? Colors.white.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 60),
            
            // Header avec logo
            _buildHeader(),
            
            SizedBox(height: 40),
            
            // Toggle moderne entre Login/Signup
            _buildModernToggle(),
            
            SizedBox(height: 30),
            
            // Carte du formulaire avec animation
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildAuthCard(),
                );
              },
            ),
            
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo avec effet 3D
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 15,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Effet glassmorphism
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'assets/icon.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                      ),
                      child: Icon(
                        Icons.swap_horiz_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 30),
        
        // Titre principal
        Text(
          'SkillSwap',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -1,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 2),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        
        SizedBox(height: 8),
        
        Text(
          'Échangez vos compétences',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildModernToggle() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isLogin) _toggleAuthMode();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: isLogin 
                      ? Colors.white 
                      : Colors.transparent,
                  boxShadow: isLogin ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ] : [],
                ),
                child: Center(
                  child: Text(
                    'Connexion',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isLogin 
                          ? Color(0xFF667EEA) 
                          : Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isLogin) _toggleAuthMode();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: !isLogin 
                      ? Colors.white 
                      : Colors.transparent,
                  boxShadow: !isLogin ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ] : [],
                ),
                child: Center(
                  child: Text(
                    'Inscription',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: !isLogin 
                          ? Color(0xFF667EEA) 
                          : Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(isLogin ? -1.0 : 1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: isLogin 
              ? LoginForm(key: ValueKey('login'))
              : SignupForm(key: ValueKey('signup')),
        ),
      ),
    );
  }
}

// Formulaire de connexion séparé
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      HapticFeedback.mediumImpact();
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bon retour !',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 8),
            
            Text(
              'Connectez-vous à votre compte',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 32),
            
            _buildAdvancedTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            
            SizedBox(height: 20),
            
            _buildAdvancedTextField(
              controller: _passwordController,
              label: 'Mot de passe',
              icon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Color(0xFF6B7280),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            
            SizedBox(height: 16),
            
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(
                    color: Color(0xFF667EEA),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            _buildAdvancedButton(
              onPressed: _handleLogin,
              text: 'Se connecter',
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Ce champ est requis';
          }
          if (label == 'Email' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
            return 'Email invalide';
          }
          if (label == 'Mot de passe' && value!.length < 6) {
            return 'Minimum 6 caractères';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF667EEA), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red.shade400, width: 1),
          ),
          filled: true,
          fillColor: Color(0xFFF9FAFB),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildAdvancedButton({
    required VoidCallback onPressed,
    required String text,
    required bool isLoading,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}


// class SignupForm extends StatefulWidget {
//   const SignupForm({Key? key}) : super(key: key);

//   @override
//   _SignupFormState createState() => _SignupFormState();
// }

// class _SignupFormState extends State<SignupForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isLoading = false;
//   bool _acceptTerms = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSignup() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (!_acceptTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Veuillez accepter les conditions d\'utilisation'),
//           backgroundColor: Colors.red.shade400,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     await Future.delayed(Duration(milliseconds: 2000));

//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//       HapticFeedback.lightImpact();
//       Navigator.pushReplacementNamed(context, '/main');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(32),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Rejoignez-nous !',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.w800,
//                 color: Color(0xFF1F2937),
//               ),
//               textAlign: TextAlign.center,
//             ),

//             SizedBox(height: 8),

//             Text(
//               'Créez votre compte et commencez à échanger',
//               style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
//               textAlign: TextAlign.center,
//             ),

//             SizedBox(height: 32),

//             _buildAdvancedTextField(
//               controller: _nameController,
//               label: 'Nom complet',
//               icon: Icons.person_outline,
//             ),

//             SizedBox(height: 20),

//             _buildAdvancedTextField(
//               controller: _emailController,
//               label: 'Email',
//               icon: Icons.email_outlined,
//               keyboardType: TextInputType.emailAddress,
//             ),

//             SizedBox(height: 20),

//             _buildAdvancedTextField(
//               controller: _passwordController,
//               label: 'Mot de passe',
//               icon: Icons.lock_outline,
//               obscureText: _obscurePassword,
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscurePassword
//                       ? Icons.visibility_outlined
//                       : Icons.visibility_off_outlined,
//                   color: Color(0xFF6B7280),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscurePassword = !_obscurePassword;
//                   });
//                 },
//               ),
//             ),

//             SizedBox(height: 20),

//             _buildAdvancedTextField(
//               controller: _confirmPasswordController,
//               label: 'Confirmer le mot de passe',
//               icon: Icons.lock_outline,
//               obscureText: _obscureConfirmPassword,
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   _obscureConfirmPassword
//                       ? Icons.visibility_outlined
//                       : Icons.visibility_off_outlined,
//                   color: Color(0xFF6B7280),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscureConfirmPassword = !_obscureConfirmPassword;
//                   });
//                 },
//               ),
//             ),

//             SizedBox(height: 20),

//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _acceptTerms = !_acceptTerms;
//                     });
//                     HapticFeedback.selectionClick();
//                   },
//                   child: Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(6),
//                       gradient: _acceptTerms
//                           ? LinearGradient(
//                               colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                             )
//                           : null,
//                       border: Border.all(
//                         color: _acceptTerms
//                             ? Colors.transparent
//                             : Color(0xFF6B7280),
//                         width: 2,
//                       ),
//                     ),
//                     child: _acceptTerms
//                         ? Icon(Icons.check, size: 16, color: Colors.white)
//                         : null,
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'J\'accepte les conditions d\'utilisation et la politique de confidentialité',
//                     style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 32),

//             _buildAdvancedButton(
//               onPressed: _handleSignup,
//               text: 'Créer le compte',
//               isLoading: _isLoading,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAdvancedTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool obscureText = false,
//     TextInputType? keyboardType,
//     Widget? suffixIcon,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: Color(0xFF1F2937),
//         ),
//         validator: (value) {
//           if (value?.isEmpty ?? true) {
//             return 'Ce champ est requis';
//           }
//           if (label == 'Email' &&
//               !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
//             return 'Email invalide';
//           }
//           if (label == 'Mot de passe' && value!.length < 6) {
//             return 'Minimum 6 caractères';
//           }
//           if (label == 'Confirmer le mot de passe' &&
//               value != _passwordController.text) {
//             return 'Les mots de passe ne correspondent pas';
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(
//             color: Color(0xFF6B7280),
//             fontWeight: FontWeight.w500,
//           ),
//           prefixIcon: Container(
//             margin: EdgeInsets.all(12),
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: Colors.white, size: 20),
//           ),
//           suffixIcon: suffixIcon,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide(color: Color(0xFF667EEA), width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide(color: Colors.red.shade400, width: 1),
//           ),
//           filled: true,
//           fillColor: Color(0xFFF9FAFB),
//           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         ),
//       ),
//     );
//   }

//   Widget _buildAdvancedButton({
//     required VoidCallback onPressed,
//     required String text,
//     required bool isLoading,
//   }) {
//     return Container(
//       height: 56,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: LinearGradient(
//           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF667EEA).withOpacity(0.4),
//             blurRadius: 15,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         child: isLoading
//             ? SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.5,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//       ),
//     );
//   }
// }
