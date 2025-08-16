// widgets/quick_actions_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

/// Widget moderne pour afficher les actions rapides
/// Design premium avec animations fluides et interface professionnelle
class QuickActionsSection extends StatefulWidget {
  final VoidCallback onAddSkill;
  final VoidCallback onSearch;
  final VoidCallback onExplore;
  final bool isLoading;

  const QuickActionsSection({
    Key? key,
    required this.onAddSkill,
    required this.onSearch,
    required this.onExplore,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<QuickActionsSection> createState() => _QuickActionsSectionState();
}

class _QuickActionsSectionState extends State<QuickActionsSection>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final List<QuickActionModel> _actions = [
    QuickActionModel(
      'Proposer\nune compétence',
      Icons.add_circle_outline,
      AppColors.primary,
      'Partagez vos talents',
      Icons.trending_up,
    ),
    QuickActionModel(
      'Rechercher\nune aide',
      Icons.search_outlined,
      AppColors.secondary,
      'Trouvez de l\'aide',
      Icons.people_outline,
    ),
    QuickActionModel(
      'Explorer\nles services',
      Icons.explore_outlined,
      AppColors.successColor,
      'Découvrez plus',
      Icons.rocket_launch,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimations = List.generate(
      _actions.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(
            index * 0.2,
            (index + 1) * 0.2,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      _actions.length,
      (index) =>
          Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _staggerController,
              curve: Interval(
                index * 0.2,
                (index + 1) * 0.2,
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 20),
        _buildActionsGrid(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.flash_on_outlined,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actions rapides',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              Text(
                'Accédez rapidement aux fonctionnalités principales',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsGrid() {
    return Column(
      children: [
        // Première ligne avec 2 actions
        Row(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _staggerController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimations[0],
                    child: SlideTransition(
                      position: _slideAnimations[0],
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: QuickActionCard(
                          action: _actions[0],
                          onTap: _handleAddSkill,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _staggerController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimations[1],
                    child: SlideTransition(
                      position: _slideAnimations[1],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: QuickActionCard(
                          action: _actions[1],
                          onTap: _handleSearch,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Deuxième ligne avec 1 action centrée
        AnimatedBuilder(
          animation: _staggerController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimations[2],
              child: SlideTransition(
                position: _slideAnimations[2],
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: QuickActionCard(
                    action: _actions[2],
                    onTap: _handleExplore,
                    isCompact: true,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _handleAddSkill() {
    HapticFeedback.lightImpact();
    widget.onAddSkill();
  }

  void _handleSearch() {
    HapticFeedback.lightImpact();
    widget.onSearch();
  }

  void _handleExplore() {
    HapticFeedback.lightImpact();
    widget.onExplore();
  }
}

/// Modèle de données pour une action rapide
class QuickActionModel {
  final String title;
  final IconData icon;
  final Color color;
  final String subtitle;
  final IconData accentIcon;

  QuickActionModel(
    this.title,
    this.icon,
    this.color,
    this.subtitle,
    this.accentIcon,
  );
}

/// Carte individuelle d'action rapide avec design premium
class QuickActionCard extends StatefulWidget {
  final QuickActionModel action;
  final VoidCallback onTap;
  final bool isCompact;

  const QuickActionCard({
    Key? key,
    required this.action,
    required this.onTap,
    this.isCompact = false,
  }) : super(key: key);

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _glowAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _elevationAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setHoverState(true),
      onTapUp: (_) => _setHoverState(false),
      onTapCancel: () => _setHoverState(false),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: widget.isCompact ? 80 : 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.action.color,
                    widget.action.color.withValues(alpha: 0.8),
                    widget.action.color.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.action.color.withValues(alpha: 0.3),
                    blurRadius: 20 * _elevationAnimation.value,
                    offset: Offset(0, 8 * _elevationAnimation.value),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: widget.action.color.withValues(alpha: 0.2),
                    blurRadius: 40 * _glowAnimation.value,
                    offset: const Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Motif d'arrière-plan
                    _buildBackgroundPattern(),

                    // Contenu principal
                    Padding(
                      padding: EdgeInsets.all(widget.isCompact ? 16 : 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIconSection(),
                          if (!widget.isCompact) ...[
                            const SizedBox(height: 12),
                            _buildTitleSection(),
                            const SizedBox(height: 4),
                            _buildSubtitleSection(),
                          ],
                        ],
                      ),
                    ),

                    // Icône d'accent
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          widget.action.accentIcon,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: QuickActionPatternPainter(
          AppColors.white.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildIconSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Icon(
        widget.action.icon,
        color: Colors.white,
        size: widget.isCompact ? 20 : 28,
      ),
    );
  }

  Widget _buildTitleSection() {
    return Text(
      widget.action.title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: widget.isCompact ? 12 : 14,
        height: 1.2,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildSubtitleSection() {
    return Text(
      widget.action.subtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 1.2,
      ),
    );
  }

  void _setHoverState(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() => _isHovered = isHovered);
      if (isHovered) {
        _hoverController.forward();
      } else {
        _hoverController.reverse();
      }
    }
  }
}

/// Peintre personnalisé pour le motif d'arrière-plan des actions rapides
class QuickActionPatternPainter extends CustomPainter {
  final Color color;

  QuickActionPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Dessine des lignes diagonales subtiles
    for (int i = 0; i < 3; i++) {
      final start = Offset(size.width * 0.1 + i * 20, size.height * 0.1);
      final end = Offset(size.width * 0.9 - i * 20, size.height * 0.9);
      canvas.drawLine(start, end, paint);
    }

    // Dessine des points décoratifs
    for (int i = 0; i < 4; i++) {
      final center = Offset(
        size.width * 0.2 + i * 0.2,
        size.height * 0.3 + (i % 2) * 0.4,
      );
      canvas.drawCircle(center, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
