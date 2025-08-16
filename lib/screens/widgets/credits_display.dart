import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

/// Widget moderne pour afficher le système de crédits Taf-Taf
/// Design premium avec animations fluides et interface professionnelle
class CreditsDisplay extends StatefulWidget {
  final int currentCredits;
  final int totalEarnedCredits;
  final int totalSpentCredits;
  final VoidCallback? onCreditsTap;
  final bool showDetails;
  final bool isAnimated;

  const CreditsDisplay({
    super.key,
    required this.currentCredits,
    this.totalEarnedCredits = 0,
    this.totalSpentCredits = 0,
    this.onCreditsTap,
    this.showDetails = false,
    this.isAnimated = true,
  });

  @override
  State<CreditsDisplay> createState() => _CreditsDisplayState();
}

class _CreditsDisplayState extends State<CreditsDisplay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    if (!widget.isAnimated) return;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _startAnimations();
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (widget.onCreditsTap != null) {
          widget.onCreditsTap!();
        } else {
          setState(() {
            _isExpanded = !_isExpanded;
          });
          if (_isExpanded) {
            _slideController.forward();
          } else {
            _slideController.reverse();
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        height: _isExpanded ? 140 : 100,
        child: _buildCreditsCard(),
      ),
    );
  }

  Widget _buildCreditsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.secondary.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Arrière-plan avec motif subtil
            _buildBackgroundPattern(),

            // Contenu principal
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Ligne principale des crédits
                  _buildMainCreditsRow(),

                  // Détails (si étendu)
                  if (_isExpanded) ...[
                    const SizedBox(height: 16),
                    _buildCreditsDetails(),
                  ],
                ],
              ),
            ),

            // Indicateur d'expansion
            Positioned(
              bottom: 12,
              right: 20,
              child: AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: AppColors.primary.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: CreditsPatternPainter(
          AppColors.primary.withValues(alpha: 0.03),
        ),
      ),
    );
  }

  Widget _buildMainCreditsRow() {
    return Row(
      children: [
        // Icône des crédits avec animation
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.credit_score,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            );
          },
        ),

        const SizedBox(width: 16),

        // Informations des crédits
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crédits Taf-Taf',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '${widget.currentCredits}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.successColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Disponible',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.successColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Bouton d'action
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCreditsDetails() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                'Gagnés',
                '${widget.totalEarnedCredits}',
                Icons.trending_up,
                AppColors.successColor,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            Expanded(
              child: _buildDetailItem(
                'Dépensés',
                '${widget.totalSpentCredits}',
                Icons.trending_down,
                AppColors.warningColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Peintre personnalisé pour le motif d'arrière-plan
class CreditsPatternPainter extends CustomPainter {
  final Color color;

  CreditsPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Dessine des cercles subtils
    for (int i = 0; i < 3; i++) {
      final radius = (i + 1) * 20.0;
      final center = Offset(
        size.width * 0.8 - i * 15,
        size.height * 0.2 + i * 10,
      );
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
