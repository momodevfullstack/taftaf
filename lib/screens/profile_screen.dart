import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> _mySkills = [
    {'name': 'Développement Flutter', 'level': 4, 'category': 'Tech'},
    {'name': 'Design UI/UX', 'level': 3, 'category': 'Design'},
    {'name': 'Photographie', 'level': 4, 'category': 'Art'},
    {'name': 'Cours d\'anglais', 'level': 5, 'category': 'Langues'},
  ];

  final List<Map<String, dynamic>> _wantedSkills = [
    {'name': 'Cuisine française', 'category': 'Cuisine'},
    {'name': 'Guitare', 'category': 'Musique'},
    {'name': 'Jardinage', 'category': 'Jardinage'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditProfileDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24),
            _buildStatsSection(),
            SizedBox(height: 24),
            _buildSkillsSection(),
            SizedBox(height: 24),
            _buildWantedSkillsSection(),
            SizedBox(height: 24),
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF4F46E5),
                child: Text(
                  'JD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.verified, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),

          Text(
            'Développeur & Designer',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
          ),

          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16, color: Color(0xFF64748B)),
              SizedBox(width: 4),
              Text(
                'Abidjan, Cocody',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ],
          ),

          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.star, size: 20, color: Color(0xFFF59E0B)),
                  SizedBox(width: 4),
                  Text(
                    '4.8',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Text(
                '15 échanges',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(width: 20),
              Text(
                'Depuis Jan 2025',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Heures données',
            '24h',
            Icons.trending_up,
            Color(0xFF10B981),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Heures reçues',
            '18h',
            Icons.trending_down,
            Color(0xFF4F46E5),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Balance',
            '+6h',
            Icons.account_balance,
            Color(0xFFF59E0B),
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
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddSkillDialog(),
              icon: Icon(Icons.add, size: 16),
              label: Text('Ajouter'),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...(_mySkills.map((skill) => _buildSkillCard(skill)).toList()),
      ],
    );
  }

  Widget _buildSkillCard(Map<String, dynamic> skill) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSkillIcon(skill['category']),
              color: Color(0xFF10B981),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  skill['category'],
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
          _buildSkillLevel(skill['level']),
        ],
      ),
    );
  }

  Widget _buildSkillLevel(int level) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          size: 16,
          color: index < level ? Color(0xFFF59E0B) : Color(0xFFE2E8F0),
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddWantedSkillDialog(),
              icon: Icon(Icons.add, size: 16),
              label: Text('Ajouter'),
            ),
          ],
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _wantedSkills
              .map((skill) => _buildWantedSkillChip(skill))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildWantedSkillChip(Map<String, dynamic> skill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF4F46E5).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF4F46E5).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getSkillIcon(skill['category']),
            size: 16,
            color: Color(0xFF4F46E5),
          ),
          SizedBox(width: 6),
          Text(
            skill['name'],
            style: TextStyle(
              color: Color(0xFF4F46E5),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _wantedSkills.remove(skill);
              });
            },
            child: Icon(Icons.close, size: 16, color: Color(0xFF64748B)),
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 12),
        _buildSettingItem(
          Icons.notifications_outlined,
          'Notifications',
          'Gérer vos préférences de notification',
          () => _showNotificationSettings(),
        ),
        _buildSettingItem(
          Icons.security_outlined,
          'Confidentialité',
          'Paramètres de confidentialité et sécurité',
          () => _showPrivacySettings(),
        ),
        _buildSettingItem(
          Icons.help_outline,
          'Aide et support',
          'FAQ, contacter le support',
          () => _showHelpCenter(),
        ),
        _buildSettingItem(
          Icons.info_outline,
          'À propos',
          'Version de l\'app, conditions d\'utilisation',
          () => _showAboutDialog(),
        ),
        SizedBox(height: 16),
        _buildSettingItem(
          Icons.logout,
          'Déconnexion',
          'Se déconnecter de votre compte',
          () => _showLogoutConfirmation(),
          isDestructive: true,
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
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Color(0xFFEF4444).withOpacity(0.1)
                : Color(0xFF64748B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Color(0xFFEF4444) : Color(0xFF64748B),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Color(0xFFEF4444) : Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right, color: Color(0xFF64748B)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.white,
      ),
    );
  }

  // Méthodes utilitaires
  IconData _getSkillIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return Icons.computer;
      case 'design':
        return Icons.design_services;
      case 'art':
        return Icons.palette;
      case 'langues':
        return Icons.language;
      case 'cuisine':
        return Icons.restaurant;
      case 'musique':
        return Icons.music_note;
      case 'jardinage':
        return Icons.local_florist;
      case 'sport':
        return Icons.sports;
      case 'education':
        return Icons.school;
      default:
        return Icons.star;
    }
  }

  // Dialogues et actions
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier le profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Titre/Profession',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Profil mis à jour !')));
            },
            child: Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog() {
    final _skillNameController = TextEditingController();
    String _selectedCategory = 'Tech';
    int _selectedLevel = 3;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Ajouter une compétence'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _skillNameController,
                decoration: InputDecoration(
                  labelText: 'Nom de la compétence',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items:
                    [
                          'Tech',
                          'Design',
                          'Art',
                          'Langues',
                          'Cuisine',
                          'Musique',
                          'Sport',
                        ]
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
              SizedBox(height: 16),
              Text('Niveau: $_selectedLevel/5'),
              Slider(
                value: _selectedLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (value) =>
                    setState(() => _selectedLevel = value.toInt()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_skillNameController.text.isNotEmpty) {
                  this.setState(() {
                    _mySkills.add({
                      'name': _skillNameController.text,
                      'level': _selectedLevel,
                      'category': _selectedCategory,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWantedSkillDialog() {
    final _skillNameController = TextEditingController();
    String _selectedCategory = 'Tech';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Ajouter une compétence recherchée'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _skillNameController,
                decoration: InputDecoration(
                  labelText: 'Nom de la compétence',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items:
                    [
                          'Tech',
                          'Design',
                          'Art',
                          'Langues',
                          'Cuisine',
                          'Musique',
                          'Sport',
                        ]
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_skillNameController.text.isNotEmpty) {
                  this.setState(() {
                    _wantedSkills.add({
                      'name': _skillNameController.text,
                      'category': _selectedCategory,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notifications'),
        content: Text('Paramètres de notification à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confidentialité'),
        content: Text('Paramètres de confidentialité à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aide et support'),
        content: Text('Centre d\'aide à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'SkillSwap Local',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 SkillSwap Local',
      children: [Text('Application d\'échange de compétences locales')],
    );
  }



  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Déconnexion'),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/auth');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF4444)),
            child: Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}



