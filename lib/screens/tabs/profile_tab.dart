import 'package:flutter/material.dart';
import 'package:taftaf/core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _mySkills = [
    {
      'name': 'Développement Flutter',
      'level': 4,
      'category': 'Tech',
      'verified': true,
    },
    {
      'name': 'Design UI/UX',
      'level': 3,
      'category': 'Design',
      'verified': false,
    },
    {'name': 'Photographie', 'level': 4, 'category': 'Art', 'verified': true},
    {
      'name': 'Cours d\'anglais',
      'level': 5,
      'category': 'Langues',
      'verified': true,
    },
  ];

  final List<Map<String, dynamic>> _wantedSkills = [
    {'name': 'Cuisine française', 'category': 'Cuisine', 'priority': 'high'},
    {'name': 'Guitare', 'category': 'Musique', 'priority': 'medium'},
    {'name': 'Jardinage', 'category': 'Jardinage', 'priority': 'low'},
  ];

  bool _notificationsEnabled = true;
  bool _profilePublic = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _refreshProfile,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                SizedBox(height: 24),
                _buildStatsSection(),
                SizedBox(height: 24),
                _buildAchievementsSection(),
                SizedBox(height: 24),
                _buildSkillsSection(),
                SizedBox(height: 24),
                _buildWantedSkillsSection(),
                SizedBox(height: 24),
                _buildRecentActivitySection(),
                SizedBox(height: 24),
                _buildSettingsSection(),
                SizedBox(height: 100), // Espace pour le bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: 'profile_avatar',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF10B981),
                      child: Text(
                        'JD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.verified, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Développeur & Designer passionné',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.white.withOpacity(0.8),
              ),
              SizedBox(width: 6),
              Text(
                'Abidjan, Cocody',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 15,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProfileStat('4.9', 'Rating', Icons.star_rounded),
              Container(
                width: 1,
                height: 30,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildProfileStat('23', 'Échanges', Icons.swap_horiz_rounded),
              Container(
                width: 1,
                height: 30,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildProfileStat(
                'Jan 2025',
                'Membre',
                Icons.calendar_today_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Heures données',
            '28h',
            Icons.trending_up_rounded,
            Color(0xFF10B981),
            '+4h cette semaine',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Heures reçues',
            '22h',
            Icons.trending_down_rounded,
            Color(0xFF4F46E5),
            '+2h cette semaine',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Balance',
            '+6h',
            Icons.account_balance_wallet_rounded,
            Color(0xFFF59E0B),
            'Solde positif',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFFF59E0B),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAchievementBadge('🏆', 'Expert', 'Top 10%'),
              _buildAchievementBadge('🔥', 'Streaker', '7 jours'),
              _buildAchievementBadge('⭐', 'Populaire', '4.9★'),
              _buildAchievementBadge('🎯', 'Précis', '95% match'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(
    String emoji,
    String title,
    String description,
  ) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Color(0xFFF59E0B).withOpacity(0.3)),
          ),
          child: Center(child: Text(emoji, style: TextStyle(fontSize: 24))),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        Text(
          description,
          style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
// informaton des competence fictifs
  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mes compétences',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddSkillDialog(),
              icon: Icon(Icons.add_rounded, size: 18),
              label: Text(
                'Ajouter',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF4F46E5).withOpacity(0.1),
                foregroundColor: Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ...(_mySkills.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> skill = entry.value;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeOutBack,
            child: _buildSkillCard(skill),
          );
        }).toList()),
      ],
    );
  }

  Widget _buildSkillCard(Map<String, dynamic> skill) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: skill['verified']
              ? Color(0xFF10B981).withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getSkillIcon(skill['category']),
              color: Color(0xFF10B981),
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        skill['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    if (skill['verified'])
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Vérifié',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  skill['category'],
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                _buildSkillLevel(skill['level']),
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded, color: Color(0xFF64748B)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Modifier'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) => _handleSkillAction(value, skill),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillLevel(int level) {
    return Row(
      children: List.generate(5, (index) {
        return Container(
          margin: EdgeInsets.only(right: 4),
          child: Icon(
            index < level ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 18,
            color: index < level ? Color(0xFFF59E0B) : Color(0xFFE2E8F0),
          ),
        );
      }),
    );
  }

  Widget _buildWantedSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Compétences recherchées',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddWantedSkillDialog(),
              icon: Icon(Icons.add_rounded, size: 18),
              label: Text(
                'Ajouter',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF7C3AED).withOpacity(0.1),
                foregroundColor: Color(0xFF7C3AED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _wantedSkills
              .map((skill) => _buildWantedSkillChip(skill))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildWantedSkillChip(Map<String, dynamic> skill) {
    Color priorityColor = _getPriorityColor(skill['priority']);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: priorityColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Icon(
            _getSkillIcon(skill['category']),
            size: 18,
            color: priorityColor,
          ),
          SizedBox(width: 8),
          Text(
            skill['name'],
            style: TextStyle(
              color: priorityColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _wantedSkills.remove(skill);
              });
            },
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Color(0xFFEF4444);
      case 'medium':
        return Color(0xFFF59E0B);
      case 'low':
        return Color(0xFF10B981);
      default:
        return Color(0xFF64748B);
    }
  }

  Widget _buildRecentActivitySection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, color: Color(0xFF4F46E5), size: 24),
              SizedBox(width: 8),
              Text(
                'Activité récente',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildActivityItem(
            'Échange Flutter avec Marie',
            '2h',
            'Il y a 2 jours',
          ),
          _buildActivityItem(
            'Cours d\'anglais pour Pierre',
            '1h30',
            'Il y a 3 jours',
          ),
          _buildActivityItem(
            'Session photo avec Julie',
            '3h',
            'Il y a 1 semaine',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String duration, String date) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.swap_horiz_rounded,
              color: Color(0xFF4F46E5),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '$duration • $date',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paramètres',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingItem(
                Icons.notifications_outlined,
                'Notifications',
                'Gérer vos préférences de notification',
                () => _showNotificationSettings(),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  activeColor: Color(0xFF10B981),
                ),
              ),
              Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildSettingItem(
                Icons.public_outlined,
                'Profil public',
                'Votre profil est visible par tous',
                () => _toggleProfileVisibility(),
                trailing: Switch(
                  value: _profilePublic,
                  onChanged: (value) {
                    setState(() {
                      _profilePublic = value;
                    });
                  },
                  activeColor: Color(0xFF10B981),
                ),
              ),
              Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildSettingItem(
                Icons.security_outlined,
                'Confidentialité',
                'Paramètres de confidentialité et sécurité',
                () => _showPrivacySettings(),
              ),
              Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildSettingItem(
                Icons.help_outline_rounded,
                'Aide et support',
                'FAQ, contacter le support',
                () => _showHelpCenter(),
              ),
              Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildSettingItem(
                Icons.info_outline_rounded,
                'À propos',
                'Version de l\'app, conditions d\'utilisation',
                () => _showAboutDialog(),
              ),
              Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildSettingItem(
                Icons.logout_rounded,
                'Déconnexion',
                'Se déconnecter de votre compte',
                () => _showLogoutConfirmation(),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDestructive
              ? Color(0xFFEF4444).withOpacity(0.1)
              : Color(0xFF64748B).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Color(0xFFEF4444) : Color(0xFF64748B),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isDestructive ? Color(0xFFEF4444) : Color(0xFF0F172A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
      ),
      trailing:
          trailing ??
          Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B)),
      onTap: onTap,
    );
  }

  // Méthodes utilitaires et actions
  IconData _getSkillIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return Icons.computer_rounded;
      case 'design':
        return Icons.design_services_rounded;
      case 'art':
        return Icons.palette_rounded;
      case 'langues':
        return Icons.language_rounded;
      case 'cuisine':
        return Icons.restaurant_rounded;
      case 'musique':
        return Icons.music_note_rounded;
      case 'jardinage':
        return Icons.local_florist_rounded;
      case 'sport':
        return Icons.sports_rounded;
      case 'education':
        return Icons.school_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  Future<void> _refreshProfile() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Simulate data refresh
    });
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lien de profil copié dans le presse-papier !'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleProfileVisibility() {
    setState(() {
      _profilePublic = !_profilePublic;
    });
  }

  void _handleSkillAction(String action, Map<String, dynamic> skill) {
    if (action == 'edit') {
      _showEditSkillDialog(skill);
    } else if (action == 'delete') {
      _showDeleteSkillConfirmation(skill);
    }
  }

  void _showEditSkillDialog(Map<String, dynamic> skill) {
    // Implementation for editing a skill
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier la compétence'),
        content: Text('Fonctionnalité de modification à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save changes
              Navigator.of(context).pop();
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteSkillConfirmation(Map<String, dynamic> skill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer la compétence'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${skill['name']}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _mySkills.remove(skill);
              });
              Navigator.of(context).pop();
            },
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog() {
    // Implementation for adding a new skill
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter une compétence'),
        content: Text('Fonctionnalité d\'ajout à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save new skill
              Navigator.of(context).pop();
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddWantedSkillDialog() {
    // Implementation for adding a new wanted skill
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter une compétence recherchée'),
        content: Text('Fonctionnalité d\'ajout à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save new wanted skill
              Navigator.of(context).pop();
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}

class _showEditProfileDialog {
  void call(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier le profil'),
        content: Text('Fonctionnalité de modification de profil à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save changes
              Navigator.of(context).pop();
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}

class _showNotificationSettings {
  void call(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Paramètres de notification'),
        content: Text('Fonctionnalité de notification à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

class _showPrivacySettings {
  void call(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Paramètres de confidentialité'),
        content: Text('Fonctionnalité de confidentialité à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

class _showHelpCenter {
  void call(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aide et support'),
        content: Text('Fonctionnalité d\'aide à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

class _showAboutDialog {
  void call(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Mon Application',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.info_outline_rounded, size: 48),
      children: [
        Text(
          'Cette application vous permet de gérer votre profil, vos compétences et vos échanges.',
        ),
        SizedBox(height: 16),
        Text('© 2023 Mon Entreprise'),
      ],
    );
  }
}

class _showLogoutConfirmation {
  void call(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Déconnexion'),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle logout logic
              Navigator.of(context).pop();
            },
            child: Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}
