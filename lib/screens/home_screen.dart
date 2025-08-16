// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taftaf/screens/tabs/settings.dart';
import 'dart:async';

// Imports des composants
import '../core/theme/app_theme.dart';
import 'models/user_model.dart';
import 'widgets/advanced_app_bar.dart';
import 'widgets/advanced_bottom_nav.dart';

import 'tabs/home_tab.dart';
import 'tabs/map_tab.dart';
import 'tabs/exchanges_tab.dart';

/// Écran principal de l'application avec navigation par onglets
/// Version ultra-optimisée avec gestion d'état moderne et architecture MVVM
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreen> {
  // === CONTROLLERS ET ANIMATIONS ===
  int _currentIndex = 0;
  late final PageController _pageController;
  late final AnimationController _animationController;
  late final AnimationController _fabAnimationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;

  // === ÉTAT DE L'APPLICATION OPTIMISÉ ===
  bool _isLoading = false;
  bool _isOffline = false;
  Timer? _searchDebounce;
  bool _isDarkMode = false;

  // ValueNotifiers pour optimiser les rebuilds
  late final ValueNotifier<String> _searchQueryNotifier;
  late final ValueNotifier<List<UserModel>> _filteredUsersNotifier;
  late final TextEditingController _searchController;

  // === DONNÉES STATIC UTILISATEURS ===
  late final List<UserModel> _staticUsers;
  final List<String> _userSkills = [];
  final List<String> _userNeeds = [];

  // Cache pour optimiser les performances
  final Map<String, Widget> _widgetCache = {};
  bool _hasMoreUsers = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeStaticData();
    _initializeUserData();
    _setupAnimations();
    _setupValueNotifiers();
    _loadInitialData();
    _loadThemePreference();
  }

  /// Initialise tous les contrôleurs nécessaires
  void _initializeControllers() {
    _pageController = PageController();
    _searchController = TextEditingController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  /// Initialise les ValueNotifiers pour optimiser les performances
  void _setupValueNotifiers() {
    _searchQueryNotifier = ValueNotifier<String>('');
    _filteredUsersNotifier = ValueNotifier<List<UserModel>>(_staticUsers);

    // Écoute les changements de recherche avec debouncing
    _searchQueryNotifier.addListener(_onSearchQueryChanged);
  }

  /// Initialise les données utilisateur
  void _initializeUserData() {
    _userSkills.addAll([
      'Développement Flutter',
      'Design UI/UX',
      'Photographie',
    ]);

    _userNeeds.addAll(['Cours d\'anglais', 'Jardinage']);
  }

  /// Initialise les données statiques des utilisateurs
  void _initializeStaticData() {
    _staticUsers = [
      UserModel(
        id: '1',
        name: 'Marie Dubois',
        avatar: 'M',
        distance: 0.8,
        skills: const ['Cuisine française', 'Pâtisserie', 'Œnologie'],
        needs: const ['Cours d\'anglais', 'Réparation vélo'],
        rating: 4.8,
        exchanges: 12,
        isOnline: true,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
        profileImage: null,
        level: 'Expert',
        responseTime: '2h',
      ),
      UserModel(
        id: '2',
        name: 'Ahmed Traoré',
        avatar: 'A',
        distance: 1.2,
        skills: const ['Développement web', 'Photographie', 'Design UI/UX'],
        needs: const ['Cours de guitare', 'Jardinage'],
        rating: 4.9,
        exchanges: 8,
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
        profileImage: null,
        level: 'Professionnel',
        responseTime: '4h',
      ),
      UserModel(
        id: '3',
        name: 'Sophie Martin',
        avatar: 'S',
        distance: 0.5,
        skills: const ['Yoga', 'Méditation', 'Coaching personnel'],
        needs: const ['Aide déménagement', 'Cours informatique'],
        rating: 4.7,
        exchanges: 15,
        isOnline: true,
        lastSeen: DateTime.now(),
        profileImage: null,
        level: 'Mentor',
        responseTime: '1h',
      ),
      UserModel(
        id: '4',
        name: 'Kofi Asante',
        avatar: 'K',
        distance: 2.1,
        skills: const ['Menuiserie', 'Électricité', 'Plomberie'],
        needs: const ['Marketing digital', 'Comptabilité'],
        rating: 4.6,
        exchanges: 20,
        isOnline: true,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 15)),
        profileImage: null,
        level: 'Artisan',
        responseTime: '3h',
      ),
      UserModel(
        id: '5',
        name: 'Fatou Diallo',
        avatar: 'F',
        distance: 1.8,
        skills: const ['Couture', 'Broderie', 'Mode'],
        needs: const ['Livraison', 'Photographie produit'],
        rating: 4.9,
        exchanges: 25,
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 4)),
        profileImage: null,
        level: 'Créatrice',
        responseTime: '1h',
      ),
    ];
  }

  /// Configure les animations d'entrée
  void _setupAnimations() {
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  /// Charge la préférence de thème
  Future<void> _loadThemePreference() async {
    // TODO: Implémenter la persistance du thème
    setState(() {
      _isDarkMode = false;
    });
  }

  /// Bascule le mode sombre/clair
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _provideLightHapticFeedback();
    // TODO: Sauvegarder la préférence
  }

  /// Charge les données initiales avec simulation réseau
  Future<void> _loadInitialData() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _filteredUsersNotifier.value = List.from(_staticUsers);
      _hasMoreUsers = _staticUsers.length > 3;

      if (kDebugMode) {
        debugPrint(
          '✅ Données statiques chargées: ${_staticUsers.length} utilisateurs',
        );
      }
    } on TimeoutException catch (_) {
      _handleLoadingError('Délai d\'attente dépassé', isTimeout: true);
    } catch (error) {
      _handleLoadingError('Erreur lors du chargement des données');
      if (kDebugMode) {
        debugPrint('❌ Erreur chargement initial: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Gère les erreurs de chargement
  void _handleLoadingError(String message, {bool isTimeout = false}) {
    if (!mounted) return;

    setState(() => _isOffline = isTimeout);
    _showErrorSnackBar(message);

    if (isTimeout) {
      _showRetryOption();
    }
  }

  /// Affiche une option de retry
  void _showRetryOption() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Connexion impossible'),
        action: SnackBarAction(
          label: 'Réessayer',
          onPressed: () => _loadInitialData(),
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  /// Gère les changements de recherche avec debouncing
  void _onSearchQueryChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _updateFilteredUsers(_searchQueryNotifier.value);
    });
  }

  /// Met à jour la liste filtrée
  void _updateFilteredUsers(String query) {
    if (query.trim().isEmpty) {
      _filteredUsersNotifier.value = List.from(_staticUsers);
      return;
    }

    final filteredUsers = _getFilteredUsers(query);
    _filteredUsersNotifier.value = filteredUsers;

    if (kDebugMode) {
      debugPrint('🔍 Recherche "$query": ${filteredUsers.length} résultats');
    }
  }

  /// Filtre les utilisateurs selon la requête
  List<UserModel> _getFilteredUsers(String query) {
    final lowerQuery = query.toLowerCase();

    return _staticUsers.where((user) {
      return user.name.toLowerCase().contains(lowerQuery) ||
          user.skills.any(
            (skill) => skill.toLowerCase().contains(lowerQuery),
          ) ||
          user.needs.any((need) => need.toLowerCase().contains(lowerQuery)) ||
          user.level.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Simule le chargement de plus d'utilisateurs
  Future<void> _loadMoreUsers() async {
    if (!_hasMoreUsers || _isLoading) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
      _hasMoreUsers = false;
    });
  }

  /// Efface la recherche
  void _clearSearch() {
    _searchController.clear();
    _searchQueryNotifier.value = '';
    _provideLightHapticFeedback();
  }

  /// Affiche tous les utilisateurs dans une bottom sheet
  Future<void> _showAllUsersBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAllUsersBottomSheet(),
    );
  }

  /// Construit la bottom sheet de tous les utilisateurs
  Widget _buildAllUsersBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            _buildBottomSheetHandle(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Tous les utilisateurs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _staticUsers.length,
                itemBuilder: (context, index) {
                  return _buildUserSearchCard(_staticUsers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Toggle favori utilisateur
  void _toggleFavorite(UserModel user) {
    _provideMediumHapticFeedback();
    _showSuccessSnackBar('${user.name} ajouté aux favoris');

    if (kDebugMode) {
      debugPrint('❤️ Toggle favori pour ${user.name}');
    }
  }

  /// Contact utilisateur
  void _contactUser(UserModel user) {
    _provideMediumHapticFeedback();
    _showSuccessSnackBar('Conversation avec ${user.name} ouverte');

    if (kDebugMode) {
      debugPrint('💬 Contact avec ${user.name}');
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _animationController.dispose();
    _fabAnimationController.dispose();
    _pageController.dispose();
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    _filteredUsersNotifier.dispose();
    _widgetCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBarFactory.createAppBar(
        currentIndex: _currentIndex,
        onNotificationTap: () => _showNotificationsBottomSheet(),
        onSearchTap: () => _showSearchBottomSheet(),
        onFilterTap: () => _showFilterBottomSheet(),
        onStyleTap: () => _toggleTheme(),
        onLayersTap: () => _showLayersBottomSheet(),
        onMapTap: () => _showMapOptions(),
      ),
      body: _buildAnimatedBody(),
      bottomNavigationBar: AdvancedBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Construit le corps animé de l'application
  Widget _buildAnimatedBody() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: _buildPageView(),
          ),
        );
      },
    );
  }

  /// Construit la vue à onglets avec gestion offline
  Widget _buildPageView() {
    if (_isOffline) {
      return _buildOfflineMode();
    }

    return PageView(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      physics: const BouncingScrollPhysics(),
      children: [
        HomeTab(
          isLoading: _isLoading,
          searchQuery: _searchQueryNotifier.value,
          mockUsers: _staticUsers,
          onRefresh: _loadInitialData,
          onAddSkill: _showAddSkillDialog,
          onSearch: _showSearchBottomSheet,
          onShowAllUsers: _showAllUsersBottomSheet,
          onUserTap: _showUserDetailBottomSheet,
          onToggleFavorite: _toggleFavorite,
          onContactUser: _contactUser,
        ),
        AdvancedMapScreen(),
        const ExchangesTab(),
        SettingsPage(),
      ],
    );
  }

  /// Construit le mode hors ligne
  Widget _buildOfflineMode() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 80,
              color: _isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Mode hors ligne',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _isDarkMode ? Colors.grey[300] : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Vérifiez votre connexion internet et réessayez',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadInitialData,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() => _isOffline = false);
                _filteredUsersNotifier.value = List.from(_staticUsers);
              },
              child: Text(
                'Utiliser les données en cache',
                style: TextStyle(
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === GESTIONNAIRES D'ÉVÉNEMENTS ===

  /// Gère la sélection d'un onglet
  void _onTabSelected(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);
    _animateToPage(index);
    _provideLightHapticFeedback();
  }

  /// Gère le changement de page
  void _onPageChanged(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);
    _provideLightHapticFeedback();
  }

  /// Anime vers la page spécifiée
  void _animateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // === BOTTOM SHEETS ===

  /// Affiche la bottom sheet des notifications
  Future<void> _showNotificationsBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNotificationsBottomSheet(),
    );
  }

  /// Construit le bottom sheet des notifications
  Widget _buildNotificationsBottomSheet() {
    const cacheKey = 'notifications_bottom_sheet';

    return _widgetCache[cacheKey] ??= Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildBottomSheetHandle(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Expanded(child: _buildNotificationsList()),
        ],
      ),
    );
  }

  /// Construit la liste des notifications
  Widget _buildNotificationsList() {
    final staticNotifications = [
      {
        'title': 'Nouvelle demande d\'échange',
        'message': 'Marie souhaite échanger avec vous',
        'time': '5 min',
        'read': false,
      },
      {
        'title': 'Échange confirmé',
        'message': 'Votre échange avec Ahmed est confirmé',
        'time': '1h',
        'read': true,
      },
    ];

    if (staticNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: _isDarkMode ? Colors.grey[600] : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune notification',
              style: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: staticNotifications.length,
      itemBuilder: (context, index) {
        final notification = staticNotifications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: _isDarkMode ? Colors.grey[800] : Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: notification['read'] as bool
                  ? (_isDarkMode ? Colors.grey[700] : Colors.grey[300])
                  : AppColors.primary,
              child: Icon(
                Icons.notifications,
                color: notification['read'] as bool
                    ? (_isDarkMode ? Colors.grey[400] : Colors.grey[600])
                    : Colors.white,
              ),
            ),
            title: Text(
              notification['title'] as String,
              style: TextStyle(
                fontWeight: notification['read'] as bool
                    ? FontWeight.normal
                    : FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              notification['message'] as String,
              style: TextStyle(
                color: _isDarkMode ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            trailing: Text(
              notification['time'] as String,
              style: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
              ),
            ),
            onTap: () => _provideLightHapticFeedback(),
          ),
        );
      },
    );
  }

  /// Affiche la bottom sheet de recherche
  Future<void> _showSearchBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSearchBottomSheet(),
    );
  }

  /// Construit la bottom sheet de recherche
  Widget _buildSearchBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            _buildBottomSheetHandle(),
            _buildSearchField(),
            Expanded(
              child: ValueListenableBuilder<List<UserModel>>(
                valueListenable: _filteredUsersNotifier,
                builder: (context, filteredUsers, child) {
                  return _buildSearchResults(scrollController, filteredUsers);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le champ de recherche
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ValueListenableBuilder<String>(
        valueListenable: _searchQueryNotifier,
        builder: (context, searchQuery, child) {
          return TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: 'Rechercher des compétences...',
              hintStyle: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[500],
              ),
              prefixIcon: Icon(
                Icons.search,
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[500],
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: _isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[500],
                      ),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: _isDarkMode ? Colors.grey[800] : Colors.grey[100],
            ),
            onChanged: (value) {
              _searchQueryNotifier.value = value.trim();
            },
          );
        },
      ),
    );
  }

  /// Construit les résultats de recherche
  Widget _buildSearchResults(
    ScrollController scrollController,
    List<UserModel> filteredUsers,
  ) {
    if (filteredUsers.isEmpty && _searchQueryNotifier.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: _isDarkMode ? Colors.grey[600] : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun résultat trouvé',
              style: TextStyle(
                fontSize: 18,
                color: _isDarkMode ? Colors.grey[400] : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Essayez avec d\'autres mots-clés',
              style: TextStyle(
                fontSize: 14,
                color: _isDarkMode ? Colors.grey[500] : Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: filteredUsers.length + (_hasMoreUsers ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == filteredUsers.length) {
          _loadMoreUsers();
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return _buildUserSearchCard(filteredUsers[index]);
      },
    );
  }

  /// Construit une carte utilisateur pour la recherche
  Widget _buildUserSearchCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      color: _isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: Text(
                user.avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (user.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.skills.take(2).join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _isDarkMode ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.orange),
                const SizedBox(width: 2),
                Text(
                  user.rating.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${user.exchanges} échanges',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${user.distance.toStringAsFixed(1)} km',
              style: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: user.isOnline ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user.isOnline ? 'En ligne' : 'Hors ligne',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pop(context);
          _showUserDetailBottomSheet(user);
        },
      ),
    );
  }

  // === MÉTHODES UTILITAIRES ===

  /// Affiche le bottom sheet de filtres
  void _showFilterBottomSheet() {
    // TODO: Implémenter les filtres
    _showInfoSnackBar('Filtres à venir');
  }

  /// Affiche le bottom sheet des couches
  void _showLayersBottomSheet() {
    // TODO: Implémenter les couches
    _showInfoSnackBar('Couches à venir');
  }

  /// Affiche les options de carte
  void _showMapOptions() {
    // TODO: Implémenter les options de carte
    _showInfoSnackBar('Options de carte à venir');
  }

  /// Affiche le dialog d'ajout de compétence
  Future<void> _showAddSkillDialog() async {
    // TODO: Implémenter le dialog d'ajout
    _showInfoSnackBar('Ajout de compétence à venir');
  }

  /// Affiche les détails d'un utilisateur
  Future<void> _showUserDetailBottomSheet(UserModel user) async {
    // TODO: Implémenter la bottom sheet de détails
    _showInfoSnackBar('Détails de ${user.name} à venir');
  }

  /// Construit le handle pour les bottom sheets
  Widget _buildBottomSheetHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[600] : Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // === FEEDBACK HAPTIQUE ===

  /// Fournit un feedback haptique léger
  void _provideLightHapticFeedback() {
    if (mounted) {
      HapticFeedback.lightImpact();
    }
  }

  /// Fournit un feedback haptique moyen
  void _provideMediumHapticFeedback() {
    if (mounted) {
      HapticFeedback.mediumImpact();
    }
  }

  // === SNACKBARS ===

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
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
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
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
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
            Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
