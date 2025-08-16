// tabs/home_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Imports des composants
import '../../core/theme/app_theme.dart';
import '../models/user_model.dart';
import '../widgets/stats_section.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/recommendations_section.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/credits_display.dart';
import '../widgets/marketplace_section.dart';

/// Widget principal de l'onglet Accueil
///
/// Affiche les statistiques utilisateur, les actions rapides,
/// et les recommandations d'utilisateurs avec pull-to-refresh
class HomeTab extends StatefulWidget {
  /// Indique si les données sont en cours de chargement
  final bool isLoading;

  /// Requête de recherche active
  final String searchQuery;

  /// Liste des utilisateurs à afficher
  final List<UserModel> mockUsers;

  /// Callback pour rafraîchir les données
  final Future<void> Function() onRefresh;

  /// Callback pour ajouter une compétence
  final VoidCallback onAddSkill;

  /// Callback pour ouvrir la recherche
  final VoidCallback onSearch;

  /// Callback pour afficher tous les utilisateurs
  final VoidCallback onShowAllUsers;

  /// Callback appelé lors du tap sur un utilisateur
  final void Function(UserModel user) onUserTap;

  /// Callback pour basculer le statut favori
  final void Function(UserModel user) onToggleFavorite;

  /// Callback pour contacter un utilisateur
  final void Function(UserModel user) onContactUser;

  const HomeTab({
    super.key,
    required this.isLoading,
    required this.searchQuery,
    required this.mockUsers,
    required this.onRefresh,
    required this.onAddSkill,
    required this.onSearch,
    required this.onShowAllUsers,
    required this.onUserTap,
    required this.onToggleFavorite,
    required this.onContactUser,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // === ANIMATIONS ===
  late final AnimationController _slideAnimationController;
  late final AnimationController _fadeAnimationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  // === SCROLL CONTROLLER ===
  late final ScrollController _scrollController;

  // === ÉTAT LOCAL ===
  bool _isRefreshing = false;
  double _scrollOffset = 0.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _startEntryAnimation();
  }

  /// Initialise les contrôleurs
  void _initializeControllers() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollChanged);

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  /// Configure les animations
  void _setupAnimations() {
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeIn),
    );
  }

  /// Démarre l'animation d'entrée
  void _startEntryAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeAnimationController.forward();
      _slideAnimationController.forward();
    });
  }

  /// Gère les changements de scroll pour les effets parallax
  void _onScrollChanged() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildRefreshIndicator(),
    );
  }

  /// Construit le RefreshIndicator avec gestion d'état
  Widget _buildRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.primary,
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      displacement: 60,
      child: _buildScrollableContent(),
    );
  }

  /// Gère le refresh avec feedback visuel et haptique
  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      // Feedback haptique
      await HapticFeedback.mediumImpact();

      // Appel du callback de refresh
      await widget.onRefresh();

      // Animation de succès
      if (mounted) {
        _slideAnimationController.reset();
        _slideAnimationController.forward();
      }
    } catch (error) {
      debugPrint('Erreur lors du refresh: $error');

      if (mounted) {
        _showErrorSnackBar('Erreur lors de la mise à jour');
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  /// Construit le contenu scrollable
  Widget _buildScrollableContent() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // Espace pour l'AppBar
        const SliverToBoxAdapter(child: SizedBox(height: 120)),

        // Contenu principal
        SliverToBoxAdapter(child: _buildMainContent()),

        // Espace pour le BottomNav
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  /// Construit le contenu principal avec animations
  Widget _buildMainContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: 24),
              _buildCreditsSection(),
              const SizedBox(height: 24),
              _buildStatsSection(),
              const SizedBox(height: 32),
              _buildQuickActionsSection(),
              const SizedBox(height: 32),
              _buildMarketplaceSection(),
              const SizedBox(height: 32),
              _buildRecommendationsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la section des crédits
  Widget _buildCreditsSection() {
    return CreditsDisplay(
      currentCredits: 125,
      totalEarnedCredits: 350,
      totalSpentCredits: 225,
      onCreditsTap: () {
        _showInfoSnackBar('Gérez vos crédits Taf-Taf');
      },
      showDetails: false,
      isAnimated: true,
    );
  }

  /// Construit la section du marketplace professionnel
  Widget _buildMarketplaceSection() {
    return MarketplaceSection(
      onServiceTap: () {
        _showInfoSnackBar('Détails du service');
      },
      onAddServiceTap: () {
        _showInfoSnackBar('Ajouter un service professionnel');
      },
      onFilterTap: () {
        _showInfoSnackBar('Filtres avancés');
      },
    );
  }

  /// Construit l'en-tête de bienvenue avec effet parallax
  Widget _buildWelcomeHeader() {
    final parallaxOffset = _scrollOffset * 0.3;

    return Transform.translate(
      offset: Offset(0, -parallaxOffset),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.secondary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Découvrez de nouvelles opportunités d\'échange',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit la section des statistiques avec gestion du loading
  Widget _buildStatsSection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: widget.isLoading
          ? const LoadingShimmer(height: 120, borderRadius: 16)
          : StatsSection(
              key: const ValueKey('stats'),
              onStatTap: _onStatTapped,
            ),
    );
  }

  /// Construit la section des actions rapides
  Widget _buildQuickActionsSection() {
    return QuickActionsSection(
      onAddSkill: _handleAddSkill,
      onSearch: _handleSearch,
      onExplore: _handleExplore,
      isLoading: widget.isLoading,
    );
  }

  /// Construit la section des recommandations
  Widget _buildRecommendationsSection() {
    return RecommendationsSection(
      isLoading: widget.isLoading || _isRefreshing,
      searchQuery: widget.searchQuery,
      mockUsers: widget.mockUsers,
      onShowAllUsers: _handleShowAllUsers,
      onUserTap: _handleUserTap,
      onToggleFavorite: _handleToggleFavorite,
      onContactUser: _handleContactUser,
      scrollOffset: _scrollOffset,
    );
  }

  // === GESTIONNAIRES D'ÉVÉNEMENTS ===

  /// Gère l'ajout de compétence avec feedback
  void _handleAddSkill() {
    HapticFeedback.lightImpact();
    widget.onAddSkill();
  }

  /// Gère l'ouverture de la recherche
  void _handleSearch() {
    HapticFeedback.lightImpact();
    widget.onSearch();
  }

  /// Gère l'exploration (nouvelle fonctionnalité)
  void _handleExplore() {
    HapticFeedback.lightImpact();
    _showInfoSnackBar('Fonctionnalité d\'exploration bientôt disponible');
  }

  /// Gère l'affichage de tous les utilisateurs
  void _handleShowAllUsers() {
    HapticFeedback.lightImpact();
    widget.onShowAllUsers();
  }

  /// Gère le tap sur un utilisateur avec animation
  void _handleUserTap(UserModel user) {
    HapticFeedback.lightImpact();

    // Animation de feedback
    _fadeAnimationController.reverse().then((_) {
      widget.onUserTap(user);
      _fadeAnimationController.forward();
    });
  }

  /// Gère le toggle favori avec feedback visuel
  void _handleToggleFavorite(UserModel user) {
    HapticFeedback.mediumImpact();
    widget.onToggleFavorite(user);

    // Animation de succès
    _showSuccessSnackBar('${user.name} ajouté aux favoris');
  }

  /// Gère le contact utilisateur
  void _handleContactUser(UserModel user) {
    HapticFeedback.lightImpact();
    widget.onContactUser(user);
  }

  /// Gère le tap sur une statistique
  void _onStatTapped(String statType) {
    HapticFeedback.lightImpact();

    switch (statType) {
      case 'exchanges':
        _showInfoSnackBar('Historique de vos échanges');
        break;
      case 'rating':
        _showInfoSnackBar('Votre note moyenne');
        break;
      case 'skills':
        _showInfoSnackBar('Vos compétences partagées');
        break;
      default:
        _showInfoSnackBar('Statistique sélectionnée: $statType');
    }
  }

  // === UTILITAIRES ===

  /// Retourne un message de bienvenue contextuel
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Bonjour ! 🌅';
    } else if (hour < 17) {
      return 'Bon après-midi ! ☀️';
    } else {
      return 'Bonsoir ! 🌙';
    }
  }

  // === NOTIFICATIONS ===

  /// Affiche une SnackBar de succès
  void _showSuccessSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Affiche une SnackBar d'information
  void _showInfoSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1),
        ),
      ),
    );
  }

  /// Affiche une SnackBar d'erreur
  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Réessayer',
          textColor: Colors.white,
          onPressed: () => _handleRefresh(),
        ),
      ),
    );
  }
}
