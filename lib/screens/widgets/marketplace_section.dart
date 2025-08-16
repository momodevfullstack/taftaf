import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import 'credits_display.dart';

/// Section Marketplace Professionnel pour Taf-Taf
/// Affiche les services professionnels avec filtrage et recherche
class MarketplaceSection extends StatefulWidget {
  final VoidCallback? onServiceTap;
  final VoidCallback? onAddServiceTap;
  final VoidCallback? onFilterTap;

  const MarketplaceSection({
    super.key,
    this.onServiceTap,
    this.onAddServiceTap,
    this.onFilterTap,
  });

  @override
  State<MarketplaceSection> createState() => _MarketplaceSectionState();
}

class _MarketplaceSectionState extends State<MarketplaceSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  String _selectedCategory = 'Tous';
  String _selectedSort = 'Pertinence';
  bool _showPremiumOnly = false;

  final List<String> _categories = [
    'Tous',
    'Plomberie',
    'Électricité',
    'Informatique',
    'Design',
    'Marketing',
    'Formation',
    'Transport',
    'Autres',
  ];

  final List<String> _sortOptions = [
    'Pertinence',
    'Prix croissant',
    'Prix décroissant',
    'Note',
    'Distance',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(_slideController),
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildFilters(),
                  const SizedBox(height: 16),
                  _buildServicesList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Marketplace Pro',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Services professionnels vérifiés',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Bouton ajouter service
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onAddServiceTap?.call();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        // Filtres principaux
        Row(
          children: [
            Expanded(child: _buildCategoryFilter()),
            const SizedBox(width: 12),
            Expanded(child: _buildSortFilter()),
          ],
        ),

        const SizedBox(height: 12),

        // Filtre premium
        _buildPremiumFilter(),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildSortFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSort,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: _sortOptions.map((String option) {
            return DropdownMenuItem<String>(value: option, child: Text(option));
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSort = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildPremiumFilter() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _showPremiumOnly = !_showPremiumOnly;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _showPremiumOnly
              ? AppColors.primary.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _showPremiumOnly
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.lightGray,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _showPremiumOnly
                  ? Icons.verified_rounded
                  : Icons.verified_outlined,
              color: _showPremiumOnly
                  ? AppColors.primary
                  : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Services Premium uniquement',
              style: TextStyle(
                color: _showPremiumOnly
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (_showPremiumOnly)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ACTIF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    return Column(
      children: [
        // En-tête de la liste
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Services disponibles',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_getFilteredServices().length} résultats',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Liste des services
        _buildServicesGrid(),
      ],
    );
  }

  Widget _buildServicesGrid() {
    final services = _getFilteredServices();

    if (services.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(services[index]);
      },
    );
  }

  Widget _buildServiceCard(ServiceData service) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onServiceTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGray, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du service
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: service.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(service.icon, color: Colors.white, size: 40),
                    ),
                    if (service.isPremium)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'PRO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Informations du service
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${service.rating}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${service.reviews})',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${service.price} CFA',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${service.creditsPrice} crédits',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: AppColors.textSecondary,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun service trouvé',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez de modifier vos filtres ou ajoutez un nouveau service',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  List<ServiceData> _getFilteredServices() {
    // Simulation de données - à remplacer par votre vraie logique
    final allServices = [
      ServiceData(
        title: 'Réparation plomberie',
        price: 15000,
        creditsPrice: 15,
        rating: 4.8,
        reviews: 127,
        icon: Icons.plumbing_rounded,
        category: 'Plomberie',
        isPremium: true,
        gradient: [AppColors.primary, AppColors.primaryLight],
      ),
      ServiceData(
        title: 'Installation électrique',
        price: 25000,
        creditsPrice: 25,
        rating: 4.9,
        reviews: 89,
        icon: Icons.electrical_services_rounded,
        category: 'Électricité',
        isPremium: true,
        gradient: [AppColors.secondary, AppColors.secondaryLight],
      ),
      ServiceData(
        title: 'Design logo',
        price: 35000,
        creditsPrice: 35,
        rating: 4.7,
        reviews: 156,
        icon: Icons.design_services_rounded,
        category: 'Design',
        isPremium: false,
        gradient: [AppColors.primary, AppColors.secondary],
      ),
      ServiceData(
        title: 'Cours de français',
        price: 8000,
        creditsPrice: 8,
        rating: 4.6,
        reviews: 203,
        icon: Icons.school_rounded,
        category: 'Formation',
        isPremium: false,
        gradient: [AppColors.secondary, AppColors.primary],
      ),
    ];

    var filtered = allServices;

    // Filtre par catégorie
    if (_selectedCategory != 'Tous') {
      filtered = filtered
          .where((s) => s.category == _selectedCategory)
          .toList();
    }

    // Filtre premium
    if (_showPremiumOnly) {
      filtered = filtered.where((s) => s.isPremium).toList();
    }

    // Tri
    switch (_selectedSort) {
      case 'Prix croissant':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Prix décroissant':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Note':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Distance':
        // Simulation - à implémenter avec la vraie géolocalisation
        break;
      default:
        // Pertinence - garder l'ordre original
        break;
    }

    return filtered;
  }
}

/// Modèle de données pour les services
class ServiceData {
  final String title;
  final int price;
  final int creditsPrice;
  final double rating;
  final int reviews;
  final IconData icon;
  final String category;
  final bool isPremium;
  final List<Color> gradient;

  ServiceData({
    required this.title,
    required this.price,
    required this.creditsPrice,
    required this.rating,
    required this.reviews,
    required this.icon,
    required this.category,
    required this.isPremium,
    required this.gradient,
  });
}
