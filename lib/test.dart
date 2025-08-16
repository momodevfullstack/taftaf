// // screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:async';

// // Imports des composants
// import '../core/theme/app_theme.dart';
// import 'models/user_model.dart';
// import 'widgets/advanced_app_bar.dart';
// import 'widgets/advanced_bottom_nav.dart';
// import 'widgets/smart_fab.dart';
// import 'tabs/home_tab.dart';
// import 'tabs/map_tab.dart';
// import 'tabs/exchanges_tab.dart';
// import 'tabs/profile_tab.dart';

// /// Écran principal de l'application avec navigation par onglets
// ///
// /// Gère l'état global de navigation, les animations, la recherche
// /// et les interactions utilisateur avec feedback haptique
// /// Version optimisée avec gestion d'état améliorée et données statiques
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreen> {
  
//   // === CONTROLLERS ET ANIMATIONS ===
//   int _currentIndex = 0;
//   late final PageController _pageController;
//   late final AnimationController _animationController;
//   late final AnimationController _fabAnimationController;
//   late final Animation<double> _fadeAnimation;
//   late final Animation<double> _slideAnimation;

//   // === ÉTAT DE L'APPLICATION OPTIMISÉ ===
//   bool _isLoading = false;
//   bool _isOffline = false; // Pour simulation mode offline
//   Timer? _searchDebounce;
  
//   // ValueNotifiers pour optimiser les rebuilds
//   late final ValueNotifier<String> _searchQueryNotifier;
//   late final ValueNotifier<List<UserModel>> _filteredUsersNotifier;
//   late final TextEditingController _searchController;

//   // === DONNÉES STATIC UTILISATEURS (En attendant l'API) ===
//   late final List<UserModel> _staticUsers;
//   final List<String> _userSkills = [];
//   final List<String> _userNeeds = [];
  
//   // Cache pour optimiser les performances
//   final Map<String, Widget> _widgetCache = {};
//   bool _hasMoreUsers = false; // Pour simulation pagination

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _initializeStaticData();
//     _initializeUserData();
//     _setupAnimations();
//     _setupValueNotifiers();
//     _loadInitialData();
//   }

//   /// Initialise tous les contrôleurs nécessaires
//   void _initializeControllers() {
//     _pageController = PageController();
//     _searchController = TextEditingController();

//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _fabAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }

//   /// Initialise les ValueNotifiers pour optimiser les performances
//   void _setupValueNotifiers() {
//     _searchQueryNotifier = ValueNotifier<String>('');
//     _filteredUsersNotifier = ValueNotifier<List<UserModel>>(_staticUsers);
    
//     // Écoute les changements de recherche avec debouncing
//     _searchQueryNotifier.addListener(_onSearchQueryChanged);
//   }

//   /// Initialise les données utilisateur
//   void _initializeUserData() {
//     // Compétences initiales de l'utilisateur (données statiques)
//     _userSkills.addAll([
//       'Développement Flutter',
//       'Design UI/UX',
//       'Photographie',
//     ]);

//     // Besoins initiaux de l'utilisateur (données statiques)
//     _userNeeds.addAll(['Cours d\'anglais', 'Jardinage']);
//   }

//   /// Initialise les données statiques des utilisateurs (En attendant l'API)
//   void _initializeStaticData() {
//     _staticUsers = [
//       UserModel(
//         id: '1',
//         name: 'Marie Dubois',
//         avatar: 'M',
//         distance: 0.8,
//         skills: const ['Cuisine française', 'Pâtisserie', 'Œnologie'],
//         needs: const ['Cours d\'anglais', 'Réparation vélo'],
//         rating: 4.8,
//         exchanges: 12,
//         isOnline: true,
//         lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
//         profileImage: null,
//         level: 'Expert',
//         responseTime: '2h',
//       ),
//       UserModel(
//         id: '2',
//         name: 'Ahmed Traoré',
//         avatar: 'A',
//         distance: 1.2,
//         skills: const ['Développement web', 'Photographie', 'Design UI/UX'],
//         needs: const ['Cours de guitare', 'Jardinage'],
//         rating: 4.9,
//         exchanges: 8,
//         isOnline: false,
//         lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
//         profileImage: null,
//         level: 'Professionnel',
//         responseTime: '4h',
//       ),
//       UserModel(
//         id: '3',
//         name: 'Sophie Martin',
//         avatar: 'S',
//         distance: 0.5,
//         skills: const ['Yoga', 'Méditation', 'Coaching personnel'],
//         needs: const ['Aide déménagement', 'Cours informatique'],
//         rating: 4.7,
//         exchanges: 15,
//         isOnline: true,
//         lastSeen: DateTime.now(),
//         profileImage: null,
//         level: 'Mentor',
//         responseTime: '1h',
//       ),
//       UserModel(
//         id: '4',
//         name: 'Kofi Asante',
//         avatar: 'K',
//         distance: 2.1,
//         skills: const ['Menuiserie', 'Électricité', 'Plomberie'],
//         needs: const ['Marketing digital', 'Comptabilité'],
//         rating: 4.6,
//         exchanges: 20,
//         isOnline: true,
//         lastSeen: DateTime.now().subtract(const Duration(minutes: 15)),
//         profileImage: null,
//         level: 'Artisan',
//         responseTime: '3h',
//       ),
//       UserModel(
//         id: '5',
//         name: 'Fatou Diallo',
//         avatar: 'F',
//         distance: 1.8,
//         skills: const ['Couture', 'Broderie', 'Mode'],
//         needs: const ['Livraison', 'Photographie produit'],
//         rating: 4.9,
//         exchanges: 25,
//         isOnline: false,
//         lastSeen: DateTime.now().subtract(const Duration(hours: 4)),
//         profileImage: null,
//         level: 'Créatrice',
//         responseTime: '1h',
//       ),
//     ];
//   }

//   /// Configure les animations d'entrée
//   void _setupAnimations() {
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );

//     // Démarre l'animation d'entrée
//     _animationController.forward();
//   }

//   /// Charge les données initiales avec simulation réseau et gestion d'erreurs améliorée
//   Future<void> _loadInitialData() async {
//     if (!mounted) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       // Simulation du chargement des données réseau
//       await Future.delayed(const Duration(milliseconds: 800));
      
//       // SIMULATION: En production, remplacer par des appels API réels
//       // final results = await Future.wait([
//       //   _userService.loadNearbyUsers(),
//       //   _notificationService.loadUnreadCount(),
//       //   _skillService.loadUserProfile(),
//       // ]);
      
//       // Simulation de succès avec données statiques
//       _filteredUsersNotifier.value = List.from(_staticUsers);
//       _hasMoreUsers = _staticUsers.length > 3; // Simulation pagination
      
//       if (kDebugMode) {
//         debugPrint('✅ Données statiques chargées: ${_staticUsers.length} utilisateurs');
//       }
      
//     } on TimeoutException catch (e) {
//       _handleLoadingError('Délai d\'attente dépassé', isTimeout: true);
//     } catch (error) {
//       _handleLoadingError('Erreur lors du chargement des données');
//       if (kDebugMode) {
//         debugPrint('❌ Erreur chargement initial: $error');
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   /// Gère les erreurs de chargement avec différents types d'erreurs
//   void _handleLoadingError(String message, {bool isTimeout = false}) {
//     if (!mounted) return;
    
//     setState(() => _isOffline = isTimeout);
//     _showErrorSnackBar(message);
    
//     // En cas de timeout, proposer un retry
//     if (isTimeout) {
//       _showRetryOption();
//     }
//   }

//   /// Affiche une option de retry en cas d'erreur réseau
//   void _showRetryOption() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Connexion impossible'),
//         action: SnackBarAction(
//           label: 'Réessayer',
//           onPressed: () => _loadInitialData(),
//         ),
//         duration: const Duration(seconds: 5),
//       ),
//     );
//   }

//   /// Gère les changements de recherche avec debouncing optimisé
//   void _onSearchQueryChanged() {
//     _searchDebounce?.cancel();
//     _searchDebounce = Timer(const Duration(milliseconds: 300), () {
//       _updateFilteredUsers(_searchQueryNotifier.value);
//     });
//   }

//   /// Met à jour la liste filtrée (optimisé avec ValueNotifier)
//   void _updateFilteredUsers(String query) {
//     if (query.trim().isEmpty) {
//       _filteredUsersNotifier.value = List.from(_staticUsers);
//       return;
//     }

//     final filteredUsers = _getFilteredUsers(query);
//     _filteredUsersNotifier.value = filteredUsers;
    
//     if (kDebugMode) {
//       debugPrint('🔍 Recherche "$query": ${filteredUsers.length} résultats');
//     }
//   }

//   /// Simule le chargement de plus d'utilisateurs (pagination)
//   Future<void> _loadMoreUsers() async {
//     if (!_hasMoreUsers || _isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     await Future.delayed(const Duration(milliseconds: 500));
    
//     // SIMULATION: En production, appeler l'API pour plus de données
//     // final moreUsers = await _userService.loadMoreUsers(offset: _staticUsers.length);
    
//     setState(() {
//       _isLoading = false;
//       _hasMoreUsers = false; // Simulation: plus de données disponibles
//     });
//   }

//   @override
//   void dispose() {
//     _searchDebounce?.cancel();
//     _animationController.dispose();
//     _fabAnimationController.dispose();
//     _pageController.dispose();
//     _searchController.dispose();
//     _searchQueryNotifier.dispose();
//     _filteredUsersNotifier.dispose();
//     _widgetCache.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       extendBodyBehindAppBar: true,
//       appBar: TafTafAppBar(
//         onNotificationTap: _showNotificationsBottomSheet,
//         onSearchTap: _showSearchBottomSheet,
//       ),
//       body: _buildAnimatedBody(),
//       bottomNavigationBar: AdvancedBottomNav(
//         currentIndex: _currentIndex,
//         onTap: _onTabSelected,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }

//   /// Construit le corps animé de l'application
//   Widget _buildAnimatedBody() {
//     return AnimatedBuilder(
//       animation: _fadeAnimation,
//       builder: (context, child) {
//         return Opacity(
//           opacity: _fadeAnimation.value,
//           child: Transform.translate(
//             offset: Offset(0, _slideAnimation.value),
//             child: _buildPageView(),
//           ),
//         );
//       },
//     );
//   }

//   /// Construit la vue à onglets avec gestion offline
//   Widget _buildPageView() {
//     if (_isOffline) {
//       return _buildOfflineMode();
//     }

//     return PageView(
//       controller: _pageController,
//       onPageChanged: _onPageChanged,
//       physics: const BouncingScrollPhysics(),
//       children: [
//         HomeTab(
//           isLoading: _isLoading,
//           searchQuery: _searchQueryNotifier.value,
//           mockUsers: _staticUsers,
//           onRefresh: _loadInitialData,
//           onAddSkill: _showAddSkillDialog,
//           onSearch: _showSearchBottomSheet,
//           onShowAllUsers: _showAllUsersBottomSheet,
//           onUserTap: _showUserDetailBottomSheet,
//           onToggleFavorite: _toggleFavorite,
//           onContactUser: _contactUser,
//         ),
//         const AdvancedMapScreen(),
//         const ExchangesTab(),
//         const ProfileTab(),
//       ],
//     );
//   }

//   /// Construit le mode hors ligne
//   Widget _buildOfflineMode() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.cloud_off,
//               size: 80,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Mode hors ligne',
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Vérifiez votre connexion internet et réessayez',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: _loadInitialData,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Réessayer'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 setState(() => _isOffline = false);
//                 // Afficher les données en cache
//                 _filteredUsersNotifier.value = List.from(_staticUsers);
//               },
//               child: const Text('Utiliser les données en cache'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // === GESTIONNAIRES D'ÉVÉNEMENTS OPTIMISÉS ===

//   /// Gère la sélection d'un onglet avec animation optimisée
//   void _onTabSelected(int index) {
//     if (_currentIndex == index) return;

//     setState(() => _currentIndex = index);
//     _animateToPage(index);
//     _provideLightHapticFeedback();
//   }

//   /// Gère le changement de page
//   void _onPageChanged(int index) {
//     if (_currentIndex != index) {
//       setState(() => _currentIndex = index);
//       _provideLightHapticFeedback();
//     }
//   }

//   /// Anime vers la page spécifiée
//   void _animateToPage(int index) {
//     _pageController.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   // === BOTTOM SHEETS OPTIMISÉES ===

//   /// Affiche la bottom sheet des notifications
//   Future<void> _showNotificationsBottomSheet() async {
//     await showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => _buildNotificationsBottomSheet(),
//     );
//   }

//   /// Construit le bottom sheet des notifications (avec widget en cache)
//   Widget _buildNotificationsBottomSheet() {
//     const cacheKey = 'notifications_bottom_sheet';
    
//     return _widgetCache[cacheKey] ??= Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           _buildBottomSheetHandle(),
//           const Padding(
//             padding: EdgeInsets.all(20),
//             child: Text(
//               'Notifications',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: _buildNotificationsList(),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Construit la liste des notifications (données statiques pour le moment)
//   Widget _buildNotificationsList() {
//     // SIMULATION: En production, récupérer depuis l'API
//     final staticNotifications = [
//       {
//         'title': 'Nouvelle demande d\'échange',
//         'message': 'Marie souhaite échanger avec vous',
//         'time': '5 min',
//         'read': false,
//       },
//       {
//         'title': 'Échange confirmé',
//         'message': 'Votre échange avec Ahmed est confirmé',
//         'time': '1h',
//         'read': true,
//       },
//     ];

//     if (staticNotifications.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.notifications_none, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'Aucune notification',
//               style: TextStyle(color: Colors.grey, fontSize: 16),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: staticNotifications.length,
//       itemBuilder: (context, index) {
//         final notification = staticNotifications[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 8),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: notification['read'] as bool
//                   ? Colors.grey[300]
//                   : AppColors.primary,
//               child: Icon(
//                 Icons.notifications,
//                 color: notification['read'] as bool
//                     ? Colors.grey[600]
//                     : Colors.white,
//               ),
//             ),
//             title: Text(
//               notification['title'] as String,
//               style: TextStyle(
//                 fontWeight: notification['read'] as bool
//                     ? FontWeight.normal
//                     : FontWeight.bold,
//               ),
//             ),
//             subtitle: Text(notification['message'] as String),
//             trailing: Text(
//               notification['time'] as String,
//               style: TextStyle(color: Colors.grey[600], fontSize: 12),
//             ),
//             onTap: () {
//               // Marquer comme lu et naviguer vers le détail
//               _provideLightHapticFeedback();
//             },
//           ),
//         );
//       },
//     );
//   }

//   /// Affiche la bottom sheet de recherche optimisée
//   Future<void> _showSearchBottomSheet() async {
//     await showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => _buildSearchBottomSheet(),
//     );
//   }

//   /// Construit la bottom sheet de recherche avec ValueListenableBuilder
//   Widget _buildSearchBottomSheet() {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.9,
//       minChildSize: 0.5,
//       maxChildSize: 0.95,
//       builder: (context, scrollController) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           children: [
//             _buildBottomSheetHandle(),
//             _buildSearchField(),
//             Expanded(
//               child: ValueListenableBuilder<List<UserModel>>(
//                 valueListenable: _filteredUsersNotifier,
//                 builder: (context, filteredUsers, child) {
//                   return _buildSearchResults(scrollController, filteredUsers);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Construit le champ de recherche optimisé
//   Widget _buildSearchField() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: ValueListenableBuilder<String>(
//         valueListenable: _searchQueryNotifier,
//         builder: (context, searchQuery, child) {
//           return TextField(
//             controller: _searchController,
//             autofocus: true,
//             decoration: InputDecoration(
//               hintText: 'Rechercher des compétences...',
//               prefixIcon: const Icon(Icons.search),
//               suffixIcon: searchQuery.isNotEmpty
//                   ? IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: _clearSearch,
//                     )
//                   : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               filled: true,
//               fillColor: Colors.grey[100],
//             ),
//             onChanged: (value) {
//               _searchQueryNotifier.value = value.trim();
//             },
//           );
//         },
//       ),
//     );
//   }

//   /// Construit les résultats de recherche avec lazy loading
//   Widget _buildSearchResults(ScrollController scrollController, List<UserModel> filteredUsers) {
//     if (filteredUsers.isEmpty && _searchQueryNotifier.value.isNotEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search_off, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'Aucun résultat trouvé',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Essayez avec d\'autres mots-clés',
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       controller: scrollController,
//       padding: const EdgeInsets.all(16),
//       itemCount: filteredUsers.length + (_hasMoreUsers ? 1 : 0),
//       itemBuilder: (context, index) {
//         // Indicateur de chargement pour plus de données
//         if (index == filteredUsers.length) {
//           _loadMoreUsers();
//           return const Padding(
//             padding: EdgeInsets.all(16),
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
        
//         return _buildUserSearchCard(filteredUsers[index]);
//       },
//     );
//   }

//   /// Construit une carte utilisateur pour la recherche (optimisée)
//   Widget _buildUserSearchCard(UserModel user) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(12),
//         leading: Stack(
//           children: [
//             CircleAvatar(
//               radius: 24,
//               backgroundColor: AppColors.primary,
//               child: Text(
//                 user.avatar,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             if (user.isOnline)
//               Positioned(
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   width: 12,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 2),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         title: Text(
//           user.name,
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               user.skills.take(2).join(', '),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.star, size: 14, color: Colors.orange),
//                 const SizedBox(width: 2),
//                 Text(
//                   user.rating.toString(),
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   '${user.exchanges} échanges',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               '${user.distance.toStringAsFixed(1)} km',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                 color: user.isOnline ? Colors.green : Colors.grey,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 user.isOnline ? 'En ligne' : 'Hors ligne',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         onTap: () {
//           Navigator.pop(context);
//           _showUserDetailBottomSheet(user);
//         },
//       ),
//     );
//   }

//   // === DIALOGS AMÉLIORÉS AVEC GESTION D'ERREURS ===

//   /// Affiche le dialog d'ajout de compétence amélioré avec validation
//   Future<void> _showAddSkillDialog() async {
//     await showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => _buildAddSkillDialog(),
//     );
//   }

//   /// Construit le dialog d'ajout de compétence avec validation renforcée
//   Widget _buildAddSkillDialog() {
//     return StatefulBuilder(
//       builder: (context, setDialogState) {
//         final TextEditingController skillController = TextEditingController();
//         final TextEditingController needController = TextEditingController();
//         bool isSkillSelected = true;
//         String? errorMessage;
//         bool isLoading = false;

//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           titlePadding: EdgeInsets.zero,
//           contentPadding: const EdgeInsets.all(20),
//           title: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.add_circle_outline,
//                   color: AppColors.primary,
//                   size: 28,
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Ajouter une compétence',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.8,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Sélecteur de type amélioré
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setDialogState(() => isSkillSelected = true);
//                             _provideLightHapticFeedback();
//                           },
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               color: isSkillSelected
//                                   ? AppColors.primary
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.star,
//                                   color: isSkillSelected
//                                       ? Colors.white
//                                       : Colors.grey,
//                                   size: 20,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'Compétence',
//                                   style: TextStyle(
//                                     color: isSkillSelected
//                                         ? Colors.white
//                                         : Colors.grey,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setDialogState(() => isSkillSelected = false);
//                             _provideLightHapticFeedback();
//                           },
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               color: !isSkillSelected
//                                   ? Colors.orange
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.help_outline,
//                                   color: !isSkillSelected
//                                       ? Colors.white
//                                       : Colors.grey,
//                                   size: 20,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'Besoin',
//                                   style: TextStyle(
//                                     color: !isSkillSelected
//                                         ? Colors.white
//                                         : Colors.grey,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Champ de saisie avec validation en temps réel
//                 TextField(
//                   controller: isSkillSelected ? skillController : needController,
//                   autofocus: true,
//                   textCapitalization: TextCapitalization.words,
//                   maxLength: 50, // Limite de caractères
//                   decoration: InputDecoration(
//                     labelText: isSkillSelected
//                         ? 'Nom de la compétence'
//                         : 'Nom du besoin',
//                     hintText: isSkillSelected
//                         ? 'Ex: Développement Flutter, Cuisine...'
//                         : 'Ex: Aide jardinage, Cours anglais...',
//                     prefixIcon: Icon(
//                       isSkillSelected ? Icons.star : Icons.help_outline,
//                       color: isSkillSelected ? AppColors.primary : Colors.orange,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: isSkillSelected ? AppColors.primary : Colors.orange,
//                         width: 2,
//                       ),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[50],
//                     errorText: errorMessage,
//                     counterText: '', // Masquer le compteur par défaut
//                   ),
//                   onChanged: (value) {
//                     if (errorMessage != null) {
//                       setDialogState(() => errorMessage = null);
//                     }
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 // Suggestions de compétences populaires (données statiques)
//                 if (_searchQueryNotifier.value.isEmpty) ...[
//                   Text(
//                     isSkillSelected 
//                         ? 'Compétences populaires :' 
//                         : 'Besoins fréquents :',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: 6,
//                     children: (isSkillSelected 
//                         ? ['Développement web', 'Design', 'Photographie', 'Cuisine', 'Jardinage']
//                         : ['Déménagement', 'Cours d\'anglais', 'Réparation', 'Garde d\'enfants', 'Ménage']
//                     ).map((suggestion) => GestureDetector(
//                       onTap: () {
//                         final controller = isSkillSelected ? skillController : needController;
//                         controller.text = suggestion;
//                         setDialogState(() => errorMessage = null);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: (isSkillSelected ? AppColors.primary : Colors.orange).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: (isSkillSelected ? AppColors.primary : Colors.orange).withOpacity(0.3),
//                           ),
//                         ),
//                         child: Text(
//                           suggestion,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: isSkillSelected ? AppColors.primary : Colors.orange,
//                           ),
//                         ),
//                       ),
//                     )).toList(),
//                   ),
//                   const SizedBox(height: 16),
//                 ],

//                 // Affichage des compétences/besoins actuels
//                 if (isSkillSelected && _userSkills.isNotEmpty) ...[
//                   Text(
//                     'Mes compétences actuelles :',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: 6,
//                     children: _userSkills.take(3).map((skill) => Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: AppColors.primary.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         skill,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                     )).toList(),
//                   ),
//                 ],

//                 if (!isSkillSelected && _userNeeds.isNotEmpty) ...[
//                   Text(
//                     'Mes besoins actuels :',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: 6,
//                     children: _userNeeds.take(3).map((need) => Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: Colors.orange.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         need,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.orange,
//                         ),
//                       ),
//                     )).toList(),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: isLoading ? null : () {
//                 skillController.dispose();
//                 needController.dispose();
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Annuler',
//                 style: TextStyle(
//                   color: isLoading ? Colors.grey : Colors.grey[600],
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             ElevatedButton.icon(
//               onPressed: isLoading ? null : () async {
//                 final text = isSkillSelected
//                     ? skillController.text.trim()
//                     : needController.text.trim();

//                 // Validation renforcée
//                 if (text.isEmpty) {
//                   setDialogState(() => errorMessage = 'Veuillez saisir un nom');
//                   return;
//                 }

//                 if (text.length < 3) {
//                   setDialogState(() => errorMessage = 'Le nom doit contenir au moins 3 caractères');
//                   return;
//                 }

//                 if (text.length > 50) {
//                   setDialogState(() => errorMessage = 'Le nom ne peut dépasser 50 caractères');
//                   return;
//                 }

//                 // Vérifier les caractères interdits
//                 if (text.contains(RegExp(r'[<>{}[\]\\|`~]'))) {
//                   setDialogState(() => errorMessage = 'Caractères spéciaux non autorisés');
//                   return;
//                 }

//                 // Vérifier les doublons
//                 final list = isSkillSelected ? _userSkills : _userNeeds;
//                 if (list.any((item) => item.toLowerCase() == text.toLowerCase())) {
//                   setDialogState(() {
//                     errorMessage = isSkillSelected
//                         ? 'Cette compétence existe déjà'
//                         : 'Ce besoin existe déjà';
//                   });
//                   return;
//                 }

//                 // Simulation d'enregistrement avec délai
//                 setDialogState(() => isLoading = true);
                
//                 try {
//                   await Future.delayed(const Duration(milliseconds: 800));
                  
//                   // SIMULATION: En production, appeler l'API
//                   // if (isSkillSelected) {
//                   //   await _userService.addSkill(text);
//                   // } else {
//                   //   await _userService.addNeed(text);
//                   // }

//                   // Ajouter localement (données statiques)
//                   setState(() {
//                     if (isSkillSelected) {
//                       _userSkills.add(text);
//                     } else {
//                       _userNeeds.add(text);
//                     }
//                   });

//                   skillController.dispose();
//                   needController.dispose();
//                   Navigator.pop(context);

//                   // Feedback de succès
//                   _provideMediumHapticFeedback();
//                   _showSuccessSnackBar(
//                     isSkillSelected
//                         ? 'Compétence "$text" ajoutée avec succès'
//                         : 'Besoin "$text" ajouté avec succès',
//                   );

//                   if (kDebugMode) {
//                     debugPrint('✅ ${isSkillSelected ? "Compétence" : "Besoin"} ajouté: $text');
//                   }

//                 } catch (error) {
//                   setDialogState(() {
//                     isLoading = false;
//                     errorMessage = 'Erreur lors de l\'enregistrement';
//                   });
                  
//                   if (kDebugMode) {
//                     debugPrint('❌ Erreur ajout ${isSkillSelected ? "compétence" : "besoin"}: $error');
//                   }
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isSkillSelected ? AppColors.primary : Colors.orange,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               icon: isLoading 
//                   ? const SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                   : const Icon(Icons.add, size: 20),
//               label: Text(
//                 isLoading ? 'Ajout...' : 'Ajouter',
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Affiche les détails d'un utilisateur avec accessibilité améliorée
//   Future<void> _showUserDetailBottomSheet(UserModel user) async {
//     await showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => _buildUserDetailBottomSheet(user),
//     );
//   }

//   /// Construit la bottom sheet de détail utilisateur optimisée
//   Widget _buildUserDetailBottomSheet(UserModel user) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.85,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           _buildBottomSheetHandle(),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildUserHeader(user),
//                   const SizedBox(height: 20),
//                   _buildUserStats(user),
//                   const SizedBox(height: 20),
//                   _buildUserSkills(user),
//                   const SizedBox(height: 20),
//                   _buildUserNeeds(user),
//                   const SizedBox(height: 20),
//                   _buildMatchingSection(user),
//                   const SizedBox(height: 20),
//                   _buildActionButtons(user),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Construit l'en-tête utilisateur avec indicateurs de statut
//   Widget _buildUserHeader(UserModel user) {
//     return Row(
//       children: [
//         Stack(
//           children: [
//             CircleAvatar(
//               radius: 35,
//               backgroundColor: AppColors.primary,
//               child: Text(
//                 user.avatar,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             if (user.isOnline)
//               Positioned(
//                 right: 2,
//                 bottom: 2,
//                 child: Container(
//                   width: 18,
//                   height: 18,
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 3),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 user.name,
//                 style: const TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: user.isOnline ? Colors.green : Colors.grey,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       user.isOnline ? 'En ligne' : 'Hors ligne',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
//                   Text(
//                     '${user.distance.toStringAsFixed(1)} km',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 user.isOnline 
//                     ? 'Actif maintenant'
//                     : 'Vu il y a ${_formatLastSeen(user.lastSeen)}',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   /// Formate la dernière connexion
//   String _formatLastSeen(DateTime lastSeen) {
//     final now = DateTime.now();
//     final difference = now.difference(lastSeen);
    
//     if (difference.inMinutes < 60) {
//       return '${difference.inMinutes} min';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours}h';
//     } else {
//       return '${difference.inDays}j';
//     }
//   }

//   /// Construit les statistiques utilisateur avec icônes colorées
//   Widget _buildUserStats(UserModel user) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildStatItem('Note', user.rating.toString(), Icons.star, Colors.orange),
//           _buildStatItem('Échanges', user.exchanges.toString(), Icons.swap_horiz, AppColors.primary),
//           _buildStatItem('Niveau', user.level, Icons.trending_up, Colors.green),
//           _buildStatItem('Réponse', user.responseTime, Icons.access_time, Colors.blue),
//         ],
//       ),
//     );
//   }

//   /// Construit un élément de statistique avec couleur
//   Widget _buildStatItem(String label, String value, IconData icon, Color color) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: color, size: 20),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 11,
//           ),
//         ),
//       ],
//     );
//   }

//   /// Construit la section des compétences avec design amélioré
//   Widget _buildUserSkills(UserModel user) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.star, color: AppColors.primary, size: 20),
//             const SizedBox(width: 8),
//             const Text(
//               'Compétences',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const Spacer(),
//             Text(
//               '${user.skills.length}',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: user.skills.map((skill) => Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: AppColors.primary.withOpacity(0.3),
//               ),
//             ),
//             child: Text(
//               skill,
//               style: TextStyle(
//                 color: AppColors.primary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           )).toList(),
//         ),
//       ],
//     );
//   }

//   /// Construit la section des besoins
//   Widget _buildUserNeeds(UserModel user) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Icon(Icons.help_outline, color: Colors.orange, size: 20),
//             const SizedBox(width: 8),
//             const Text(
//               'Recherche',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const Spacer(),
//             Text(
//               '${user.needs.length}',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: user.needs.map((need) => Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.orange.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Colors.orange.withOpacity(0.3),
//               ),
//             ),
//             child: Text(
//               need,
//               style: const TextStyle(
//                 color: Colors.orange,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           )).toList(),
//         ),
//       ],
//     );
//   }

//   /// Construit la section de matching (nouvelles fonctionnalité)
//   Widget _buildMatchingSection(UserModel user) {
//     // SIMULATION: Calcul des correspondances avec l'utilisateur actuel
//     final mySkills = _userSkills.toSet();
//     final myNeeds = _userNeeds.toSet();
//     final userSkills = user.skills.toSet();
//     final userNeeds = user.needs.toSet();
    
//     final canHelpWith = mySkills.intersection(userNeeds);
//     final canHelpMe = userSkills.intersection(myNeeds);
    
//     if (canHelpWith.isEmpty && canHelpMe.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.green.withOpacity(0.1),
//             Colors.blue.withOpacity(0.1),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.green.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.handshake, color: Colors.green, size: 20),
//               const SizedBox(width: 8),
//               const Text(
//                 'Correspondances',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
          
//           if (canHelpWith.isNotEmpty) ...[
//             Text(
//               'Vous pouvez aider avec :',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 4),
//             Wrap(
//               spacing: 6,
//               runSpacing: 6,
//               children: canHelpWith.map((skill) => Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   skill,
//                   style: const TextStyle(
//                     color: Colors.green,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               )).toList(),
//             ),
//             const SizedBox(height: 8),
//           ],
          
//           if (canHelpMe.isNotEmpty) ...[
//             Text(
//               '${user.name.split(' ')[0]} peut vous aider avec :',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 4),
//             Wrap(
//               spacing: 6,
//               runSpacing: 6,
//               children: canHelpMe.map((skill) => Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   skill,
//                   style: const TextStyle(
//                     color: Colors.blue,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               )).toList(),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   /// Construit les boutons d'action améliorés
//   Widget _buildActionButtons(UserModel user) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Navigator.pop(context);
//               _contactUser(user);
//             },
//             icon: const Icon(Icons.message_rounded),
//             label: const Text('Contacter'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 2,
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Navigator.pop(context);
//               _toggleFavorite(user);
//             },
//             icon: const Icon(Icons.favorite_border),
//             label: const Text('Favoris'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey[100],
//               foregroundColor: Colors.grey[700],
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 0,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             onPressed: () {
//               // Menu d'options supplémentaires
//               _showUserOptionsMenu(user);
//             },
//             icon: Icon(Icons.more_vert, color: Colors.grey[600]),
//             padding: const EdgeInsets.all(16),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Affiche le menu d'options utilisateur
//   void _showUserOptionsMenu(UserModel user) {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildBottomSheetHandle(),
//             const SizedBox(height: 16),
//             ListTile(
//               leading: const Icon(Icons.share),
//               title: const Text('Partager le profil'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _shareUserProfile(user);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.report),
//               title: const Text('Signaler'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _reportUser(user);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.block),
//               title: const Text('Bloquer'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _blockUser(user);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Partage le profil utilisateur
//   void _shareUserProfile(UserModel user) {
//     // SIMULATION: En production, générer un lien de partage
//     _showSuccessSnackBar('Lien de profil copié dans le presse-papier');
//     if (kDebugMode) {
//       debugPrint('📤 Partage du profil de ${user.name}');
//     }
//   }

//   /// Signale un utilisateur
//   void _reportUser(UserModel user) {
//     showDialog<void>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Signaler cet utilisateur'),
//         content: const Text('Êtes-vous sûr de vouloir signaler cet utilisateur ?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Annuler'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _showSuccessSnarkBar('Utilisateur signalé');
//               // SIMULATION: En production, envoyer le signalement
//               if (kDebugMode) {
//                 debugPrint('🚩 Signalement de ${user.name}');
//               }
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Signaler', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Bloque un utilisateur
//   void _blockUser(UserModel user) {
//     showDialog<void>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Bloquer cet utilisateur'),
//         content: Text('${user.name} ne pourra plus vous contacter ni voir votre profil.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Annuler'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _showSuccessSnackBar('Utilisateur bloqué');
//               // SIMULATION: En production, ajouter à la liste des bloqués
//               if (kDebugMode) {
//                 debugPrint('🚫 Blocage de ${user.name}');
//               }
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.