// widgets/custom_app_bars.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taftaf/core/theme/app_theme.dart';

/// AppBar personnalisé pour l'onglet Home
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;
  final String? currentLocation;
  final int unreadNotifications;

  const HomeAppBar({
    super.key,
    this.onNotificationTap,
    this.onSearchTap,
    this.onFilterTap,
    this.currentLocation,
    this.unreadNotifications = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.background),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Avatar utilisateur
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),

              // Informations de localisation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bonjour ! 👋',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black.withOpacity(0.8),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            currentLocation ?? 'Bingerville, Abidjan',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bouton de recherche
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onSearchTap?.call();
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.search, color: Colors.black, size: 20),
                ),
              ),

              const SizedBox(width: 8),

              // Bouton de notifications avec badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onNotificationTap?.call();
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  if (unreadNotifications > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadNotifications > 99
                              ? '99+'
                              : '$unreadNotifications',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

//test de app bar

/// AppBar personnalisé pour l'onglet Map
class MapAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onStyleTap;
  final VoidCallback? onLayersTap;
  final VoidCallback? onLocationTap;
  final String currentMapStyle;
  final bool isLocationEnabled;

  const MapAppBar({
    super.key,
    this.onBackTap,
    this.onStyleTap,
    this.onLayersTap,
    this.onLocationTap,
    this.currentMapStyle = 'Standard',
    this.isLocationEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

/// AppBar personnalisé pour l'onglet Exchanges
class ExchangesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;
  final VoidCallback? onAddTap;
  final String activeFilter;
  final int pendingExchanges;

  const ExchangesAppBar({
    super.key,
    this.onFilterTap,
    this.onSortTap,
    this.onAddTap,
    this.activeFilter = 'Tous',
    this.pendingExchanges = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,

      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Échanges',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar personnalisé pour l'onglet Profile
class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,

      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Paramètres',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Factory pour créer l'AppBar approprié selon l'onglet
class AppBarFactory {
  static PreferredSizeWidget createAppBar({
    required int currentIndex,
    VoidCallback? onNotificationTap,
    VoidCallback? onSearchTap,
    VoidCallback? onFilterTap,
    VoidCallback? onStyleTap,
    VoidCallback? onLayersTap,
    VoidCallback? onLocationTap,
    VoidCallback? onSettingsTap,
    VoidCallback? onEditTap,
    VoidCallback? onShareTap,
    VoidCallback? onQRTap,
    VoidCallback? onSortTap,
    VoidCallback? onAddTap,
    Map<String, dynamic>? additionalData,
    VoidCallback? onMapTap,
  }) {
    switch (currentIndex) {
      case 0: // Home
        return HomeAppBar(
          onNotificationTap: onNotificationTap,
          onSearchTap: onSearchTap,
          onFilterTap: onFilterTap,
          currentLocation: additionalData?['currentLocation'],
          unreadNotifications: additionalData?['unreadNotifications'] ?? 0,
        );

      case 1: // Map
        return MapAppBar(
          onStyleTap: onStyleTap,
          onLayersTap: onLayersTap,
          onLocationTap: onLocationTap,
          currentMapStyle: additionalData?['currentMapStyle'] ?? 'Standard',
          isLocationEnabled: additionalData?['isLocationEnabled'] ?? true,
        );

      case 2: // Exchanges
        return ExchangesAppBar(
          onFilterTap: onFilterTap,
          onSortTap: onSortTap,
          onAddTap: onAddTap,
          activeFilter: additionalData?['activeFilter'] ?? 'Tous',
          pendingExchanges: additionalData?['pendingExchanges'] ?? 0,
        );

      case 3: // Profile
        return ProfileAppBar();

      default:
        return HomeAppBar(
          onNotificationTap: onNotificationTap,
          onSearchTap: onSearchTap,
        );
    }
  }
}
