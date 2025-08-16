// widgets/advanced_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class AdvancedBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdvancedBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AdvancedBottomNav> createState() => _AdvancedBottomNavState();
}

class _AdvancedBottomNavState extends State<AdvancedBottomNav>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AdvancedBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Réduit de 90 à 70
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ), // Marges réduites
      child: Stack(
        children: [
          // Fond principal avec effet glassmorphism
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), // Réduit de 30 à 25
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.8),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08), // Ombre réduite
                  blurRadius: 20, // Réduit de 25 à 20
                  offset: const Offset(0, 8), // Réduit de 10 à 8
                ),
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08), // Ombre réduite
                  blurRadius: 12, // Réduit de 15 à 12
                  offset: const Offset(0, 4), // Réduit de 5 à 4
                ),
              ],
            ),
          ),

          // Items de navigation
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  0,
                  Icons.home_outlined,
                  Icons.home_rounded,
                  'Accueil',
                ),
                _buildNavItem(
                  1,
                  Icons.map_outlined,
                  Icons.map_rounded,
                  'Carte',
                ),
                _buildNavItem(
                  2,
                  Icons.swap_horiz_outlined,
                  Icons.swap_horiz_rounded,
                  'Echange',
                ),
                _buildNavItem(
                  3,
                  Icons.settings_outlined,
                  Icons.settings_rounded,
                  'Parametre',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isActive = widget.currentIndex == index;

    return GestureDetector(
      onTap: () {
        widget.onTap(index);
        HapticFeedback.mediumImpact();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isActive ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 50, // Réduit de 60 à 50
              height: 50, // Réduit de 60 à 50
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(
                      isActive ? 6 : 5,
                    ), // Réduit les paddings
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        14,
                      ), // Réduit de 16 à 14
                      color: isActive
                          ? AppColors.primary.withOpacity(0.15)
                          : Colors.transparent,
                      border: isActive
                          ? Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            )
                          : null,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isActive ? activeIcon : icon,
                        key: ValueKey(isActive),
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: isActive ? 20 : 19, // Réduit de 24/22 à 20/19
                      ),
                    ),
                  ),
                  const SizedBox(height: 1), // Réduit de 2 à 1
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: isActive ? 9.5 : 9, // Réduit de 11/10 à 9.5/9
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
