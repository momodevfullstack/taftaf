import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _notificationsEnabled = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _darkMode = true;
  bool _biometricAuth = false;
  bool _locationServices = true;
  String _selectedLanguage = 'Français';
  double _fontSize = 16.0;

  final TextEditingController _nameController = TextEditingController(
    text: 'Alexandra Martin',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'alexandra.martin@email.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+33 7 89 12 34 56',
  );

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _darkMode
                ? [Color(0xFF0A0A0A), Color(0xFF1A1A1A), Color(0xFF2A2A2A)]
                : [Color(0xFFF8F9FA), Color(0xFFE9ECEF), Color(0xFFDEE2E6)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(children: [Expanded(child: _buildContent())]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _buildProfileSection(),
            SizedBox(height: 32),
            _buildSettingsSection(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _darkMode ? Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _darkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF667EEA).withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'AM',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF34C759),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _darkMode ? Color(0xFF1C1C1E) : Colors.white,
                      width: 3,
                    ),
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            _nameController.text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: _darkMode ? Colors.white : Color(0xFF1C1C1E),
            ),
          ),
          SizedBox(height: 4),
          Text(
            _emailController.text,
            style: TextStyle(
              fontSize: 16,
              color: _darkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Connecté', '24h', Icons.schedule),
              ),
              SizedBox(width: 12),
              Expanded(child: _buildStatCard('Niveau', 'Pro', Icons.star)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _darkMode ? Color(0xFF2C2C2E) : Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF667EEA), size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _darkMode ? Colors.white : Color(0xFF1C1C1E),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: _darkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildSettingsGroup('Général', [
          _buildSettingsTile(
            'Notifications',
            'Gérer vos alertes',
            Icons.notifications_outlined,
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: Color(0xFF34C759),
            ),
          ),
          _buildSettingsTile(
            'Mode sombre',
            'Interface adaptée à vos yeux',
            _darkMode ? Icons.dark_mode : Icons.light_mode,
            trailing: Switch.adaptive(
              value: _darkMode,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() {
                  _darkMode = value;
                });
              },
              activeColor: Color(0xFF667EEA),
            ),
          ),
          _buildSettingsTile(
            'Langue',
            _selectedLanguage,
            Icons.language_outlined,
            onTap: () => _showLanguageSelector(),
          ),
        ]),

        SizedBox(height: 24),

        _buildSettingsGroup('Confidentialité & Sécurité', [
          _buildSettingsTile(
            'Authentification biométrique',
            'Touch ID / Face ID',
            Icons.fingerprint,
            trailing: Switch.adaptive(
              value: _biometricAuth,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() {
                  _biometricAuth = value;
                });
              },
              activeColor: Color(0xFFFF9500),
            ),
          ),
          _buildSettingsTile(
            'Localisation',
            'Services de géolocalisation',
            Icons.location_on_outlined,
            trailing: Switch.adaptive(
              value: _locationServices,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() {
                  _locationServices = value;
                });
              },
              activeColor: Color(0xFF007AFF),
            ),
          ),
          _buildSettingsTile(
            'Mot de passe',
            'Modifier votre mot de passe',
            Icons.lock_outline,
            onTap: () => _showPasswordDialog(),
          ),
        ]),

        SizedBox(height: 24),

        _buildSettingsGroup('Apparence', [
          _buildFontSizeSlider(),
          _buildSettingsTile(
            'Notifications push',
            'Alertes en temps réel',
            Icons.push_pin_outlined,
            trailing: Switch.adaptive(
              value: _pushNotifications,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() {
                  _pushNotifications = value;
                });
              },
              activeColor: Color(0xFFFF3B30),
            ),
          ),
        ]),

        SizedBox(height: 24),

        _buildSettingsGroup('Support', [
          _buildSettingsTile(
            'Centre d\'aide',
            'FAQ et documentation',
            Icons.help_outline,
            onTap: () => _showSnackBar('Ouverture du centre d\'aide'),
          ),
          _buildSettingsTile(
            'Contactez-nous',
            'Support client 24/7',
            Icons.mail_outline,
            onTap: () => _showSnackBar('Ouverture du support'),
          ),
          _buildSettingsTile(
            'À propos',
            'Version 2.1.0',
            Icons.info_outline,
            onTap: () => _showAboutDialog(),
          ),
        ]),

        SizedBox(height: 32),

        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _darkMode ? Colors.grey[400] : Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _darkMode ? Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _darkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.08),
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              int index = entry.key;
              Widget child = entry.value;

              return Column(
                children: [
                  child,
                  if (index < children.length - 1)
                    Divider(
                      height: 1,
                      indent: 60,
                      color: _darkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _darkMode ? Color(0xFF2C2C2E) : Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Color(0xFF667EEA), size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _darkMode ? Colors.white : Color(0xFF1C1C1E),
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: _darkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing
              else if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: _darkMode ? Colors.grey[400] : Colors.grey[600],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeSlider() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _darkMode ? Color(0xFF2C2C2E) : Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.text_fields,
                  color: Color(0xFF667EEA),
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Taille du texte',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _darkMode ? Colors.white : Color(0xFF1C1C1E),
                      ),
                    ),
                    Text(
                      '${_fontSize.round()}px',
                      style: TextStyle(
                        fontSize: 14,
                        color: _darkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Color(0xFF667EEA),
              inactiveTrackColor: _darkMode
                  ? Color(0xFF2C2C2E)
                  : Color(0xFFF2F2F7),
              thumbColor: Color(0xFF667EEA),
              overlayColor: Color(0xFF667EEA).withOpacity(0.1),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 6,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() {
                  _fontSize = value;
                });
              },
            ),
          ),
          Center(
            child: Text(
              'Exemple de texte',
              style: TextStyle(
                fontSize: _fontSize,
                color: _darkMode ? Colors.white : Color(0xFF1C1C1E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF3B30), Color(0xFFFF6B6B)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF3B30).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLogoutDialog(),
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Se déconnecter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: _darkMode ? Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Choisir la langue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _darkMode ? Colors.white : Color(0xFF1C1C1E),
                ),
              ),
            ),
            ...['Français', 'English', 'Español', 'Deutsch'].map(
              (lang) => ListTile(
                title: Text(
                  lang,
                  style: TextStyle(
                    color: _darkMode ? Colors.white : Color(0xFF1C1C1E),
                  ),
                ),
                trailing: _selectedLanguage == lang
                    ? Icon(Icons.check, color: Color(0xFF34C759))
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLanguage = lang;
                  });
                  Navigator.pop(context);
                  _showSnackBar('Langue changée vers $lang');
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _darkMode ? Color(0xFF1C1C1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Changer le mot de passe',
          style: TextStyle(color: _darkMode ? Colors.white : Color(0xFF1C1C1E)),
        ),
        content: Text(
          'Cette action vous redirigera vers une page sécurisée.',
          style: TextStyle(
            color: _darkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Redirection vers la page sécurisée');
            },
            child: Text('Continuer'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _darkMode ? Color(0xFF1C1C1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'À propos',
          style: TextStyle(color: _darkMode ? Colors.white : Color(0xFF1C1C1E)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 2.1.0',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _darkMode ? Colors.white : Color(0xFF1C1C1E),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Dernière mise à jour: 15 janvier 2025',
              style: TextStyle(
                color: _darkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Cette application vous permet de gérer tous vos paramètres de manière intuitive et moderne.',
              style: TextStyle(
                color: _darkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _darkMode ? Color(0xFF1C1C1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Se déconnecter',
          style: TextStyle(color: _darkMode ? Colors.white : Color(0xFF1C1C1E)),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: TextStyle(
            color: _darkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Déconnexion réussie');
            },
            style: TextButton.styleFrom(foregroundColor: Color(0xFFFF3B30)),
            child: Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF34C759),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}
