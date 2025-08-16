// widgets/stats_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../models/user_model.dart';

/// Widget moderne pour afficher les statistiques utilisateur
/// Design premium avec animations fluides et interface professionnelle
class StatsSection extends StatefulWidget {
  final void Function(String statType) onStatTap;

  const StatsSection({
    Key? key,
    required this.onStatTap,
  }) : super(key: key);

  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final List<StatModel> _stats = [
    StatModel(
      'Échanges',
      '3',
      Icons.swap_horiz,
      AppColors.primary,
      '+2 cette semaine',
      Icons.trending_up,
      Colors.green,
    ),
    StatModel(
      'Heures',
      '12h',
      Icons.schedule,
      AppColors.secondary,
      '8h ce mois',
      Icons.timer,
      Colors.blue,
    ),
    StatModel(
      'Note',
      '4.8',
      Icons.star,
      AppColors.primary,
      'Top 10%',
      Icons.emoji_events,
      Colors.amber,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimations = List.generate(
      _stats.length,
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
      _stats.length,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
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
        _buildStatsGrid(),
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
            Icons.analytics_outlined,
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
                'Vos statistiques',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              Text(
                'Suivez votre progression et vos performances',
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

  Widget _buildStatsGrid() {
    return Row(
      children: _stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        
        return Expanded(
          child: AnimatedBuilder(
            animation: _staggerController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimations[index],
                child: SlideTransition(
                  position: _slideAnimations[index],
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 8,
                      right: index == _stats.length - 1 ? 0 : 8,
                    ),
                    child: StatCard(
                      stat: stat,
                      onTap: () => _onStatTap(stat.title.toLowerCase()),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  void _onStatTap(String statType) {
    HapticFeedback.lightImpact();
    widget.onStatTap(statType);
  }
}

/// Modèle de données pour une statistique
class StatModel {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;
  final IconData trendIcon;
  final Color trendColor;

  StatModel(
    this.title,
    this.value,
    this.icon,
    this.color,
    this.subtitle,
    this.trendIcon,
    this.trendColor,
  );
}

/// Carte individuelle de statistique avec design premium
class StatCard extends StatefulWidget {
  final StatModel stat;
  final VoidCallback onTap;

  const StatCard({
    Key? key,
    required this.stat,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _elevationAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.95),
                    widget.stat.color.withValues(alpha: 0.05),
                    widget.stat.color.withValues(alpha: 0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.stat.color.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.stat.color.withValues(alpha: 0.08),
                    blurRadius: 20 * _elevationAnimation.value,
                    offset: Offset(0, 8 * _elevationAnimation.value),
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
              child: Column(
                children: [
                  _buildIconSection(),
                  const SizedBox(height: 16),
                  _buildValueSection(),
                  const SizedBox(height: 8),
                  _buildTitleSection(),
                  const SizedBox(height: 6),
                  _buildSubtitleSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.stat.color,
            widget.stat.color.withValues(alpha: 0.8),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.stat.color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        widget.stat.icon,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  Widget _buildValueSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.stat.value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.0,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: widget.stat.trendColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.stat.trendIcon,
            color: widget.stat.trendColor,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Text(
      widget.stat.title,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitleSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.stat.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: widget.stat.color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        widget.stat.subtitle,
        style: TextStyle(
          fontSize: 10,
          color: widget.stat.color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        textAlign: TextAlign.center,
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