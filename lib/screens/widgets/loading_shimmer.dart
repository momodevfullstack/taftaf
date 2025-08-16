// widgets/loading_shimmer.dart
import 'package:flutter/material.dart';

/// Widget d'effet shimmer pour les états de chargement
/// 
/// Crée un effet de brillance animé pour indiquer le chargement
/// des données de manière élégante et moderne
class LoadingShimmer extends StatefulWidget {
  /// Largeur du shimmer (null = largeur maximale)
  final double? width;
  
  /// Hauteur du shimmer
  final double height;
  
  /// Rayon des coins arrondis
  final double borderRadius;
  
  /// Couleur de base du shimmer
  final Color? baseColor;
  
  /// Couleur de surbrillance du shimmer
  final Color? highlightColor;
  
  /// Durée de l'animation
  final Duration duration;
  
  /// Widget enfant personnalisé (optionnel)
  final Widget? child;

  const LoadingShimmer({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.child,
  });

  /// Factory pour créer un shimmer rectangulaire simple
  factory LoadingShimmer.rectangular({
    Key? key,
    double? width,
    required double height,
    double borderRadius = 8.0,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return LoadingShimmer(
      key: key,
      width: width,
      height: height,
      borderRadius: borderRadius,
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  /// Factory pour créer un shimmer circulaire
  factory LoadingShimmer.circular({
    Key? key,
    required double size,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return LoadingShimmer(
      key: key,
      width: size,
      height: size,
      borderRadius: size / 2,
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  /// Factory pour créer un shimmer de texte
  factory LoadingShimmer.text({
    Key? key,
    double? width,
    double height = 16.0,
    double borderRadius = 4.0,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return LoadingShimmer(
      key: key,
      width: width,
      height: height,
      borderRadius: borderRadius,
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  /// Initialise l'animation du shimmer
  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Répète l'animation indéfiniment
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Couleurs par défaut basées sur le thème
    final baseColor = widget.baseColor ?? 
        (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ?? 
        (isDark ? Colors.grey[700]! : Colors.grey[100]!);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: _buildShimmerGradient(baseColor, highlightColor),
          ),
          child: widget.child,
        );
      },
    );
  }

  /// Construit le gradient du shimmer avec l'animation
  LinearGradient _buildShimmerGradient(Color baseColor, Color highlightColor) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [
        _animation.value - 0.3,
        _animation.value,
        _animation.value + 0.3,
      ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
      colors: [
        baseColor,
        highlightColor,
        baseColor,
      ],
    );
  }
}

/// Widget pour créer plusieurs shimmers en liste
class LoadingShimmerList extends StatelessWidget {
  /// Nombre d'éléments shimmer
  final int itemCount;
  
  /// Hauteur de chaque élément
  final double itemHeight;
  
  /// Espacement entre les éléments
  final double spacing;
  
  /// Padding du conteneur
  final EdgeInsetsGeometry? padding;
  
  /// Rayon des coins
  final double borderRadius;

  const LoadingShimmerList({
    super.key,
    required this.itemCount,
    this.itemHeight = 60.0,
    this.spacing = 12.0,
    this.padding,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index < itemCount - 1 ? spacing : 0,
            ),
            child: LoadingShimmer(
              height: itemHeight,
              borderRadius: borderRadius,
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget shimmer pour une carte utilisateur
class UserCardShimmer extends StatelessWidget {
  /// Largeur de la carte
  final double? width;
  
  /// Hauteur de la carte
  final double height;

  const UserCardShimmer({
    super.key,
    this.width,
    this.height = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar shimmer
           LoadingShimmer.circular(size: 50),
          const SizedBox(width: 12),
          
          // Contenu shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nom
                LoadingShimmer.text(
                  width: 120,
                  height: 16,
                ),
                const SizedBox(height: 8),
                
                // Compétences
                LoadingShimmer.text(
                  width: 80,
                  height: 12,
                ),
                const SizedBox(height: 4),
                
                // Distance
                LoadingShimmer.text(
                  width: 60,
                  height: 12,
                ),
              ],
            ),
          ),
          
          // Actions shimmer
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingShimmer.circular(size: 24),
              const SizedBox(height: 8),
              LoadingShimmer.circular(size: 24),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget shimmer pour les statistiques
class StatsShimmer extends StatelessWidget {
  /// Nombre de statistiques
  final int statsCount;

  const StatsShimmer({
    super.key,
    this.statsCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          statsCount,
          (index) => Column(
            children: [
              LoadingShimmer.text(
                width: 40,
                height: 24,
              ),
              const SizedBox(height: 8),
              LoadingShimmer.text(
                width: 50,
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}