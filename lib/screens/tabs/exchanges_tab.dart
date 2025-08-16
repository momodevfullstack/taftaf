// tabs/exchanges_tab.dart
import 'package:flutter/material.dart';
import 'package:taftaf/screens/chat_screen.dart';
import '../../core/theme/app_theme.dart';
// ignore: duplicate_import
import '../chat_screen.dart';

class ExchangesTab extends StatefulWidget {
  const ExchangesTab({Key? key}) : super(key: key);

  @override
  State<ExchangesTab> createState() => _ExchangesTabState();
}

class _ExchangesTabState extends State<ExchangesTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Données d'exemple pour les conversations
  final List<Exchange> exchanges = const [
    Exchange(
      id: '1',
      userName: 'Marie Dubois',
      userAvatar: 'MD',
      skillOffered: 'Développement Web',
      skillRequested: 'Design UI/UX',
      lastMessage: 'Parfait ! À demain pour notre session 🎨',
      lastMessageTime: '14:30',
      status: ExchangeStatus.active,
      unreadCount: 2,
      isOnline: true,
    ),
    Exchange(
      id: '2',
      userName: 'Pierre Martin',
      userAvatar: 'PM',
      skillOffered: 'Photographie',
      skillRequested: 'Montage Vidéo',
      lastMessage: 'Les photos sont magnifiques, merci !',
      lastMessageTime: '12:45',
      status: ExchangeStatus.completed,
      unreadCount: 0,
      isOnline: false,
    ),
    Exchange(
      id: '3',
      userName: 'Sophie Laurent',
      userAvatar: 'SL',
      skillOffered: 'Cuisine Française',
      skillRequested: 'Jardinage Bio',
      lastMessage: 'Je confirme pour samedi matin 👩‍🍳',
      lastMessageTime: '10:15',
      status: ExchangeStatus.active,
      unreadCount: 1,
      isOnline: true,
    ),
    Exchange(
      id: '4',
      userName: 'Alex Chen',
      userAvatar: 'AC',
      skillOffered: 'Piano Classique',
      skillRequested: 'Guitare Jazz',
      lastMessage: 'Merci pour les partitions !',
      lastMessageTime: 'Hier',
      status: ExchangeStatus.completed,
      unreadCount: 0,
      isOnline: false,
    ),
    Exchange(
      id: '5',
      userName: 'Emma Rodriguez',
      userAvatar: 'ER',
      skillOffered: 'Anglais Business',
      skillRequested: 'Marketing Digital',
      lastMessage: 'J\'accepte votre proposition d\'échange',
      lastMessageTime: '2j',
      status: ExchangeStatus.pending,
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // En-tête moderne
          Container(
            padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(children: [SizedBox(height: 20)]),
          ),

          // Liste des conversations
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExchangesList(exchanges),
                _buildExchangesList(
                  exchanges
                      .where((e) => e.status == ExchangeStatus.active)
                      .toList(),
                ),
                _buildExchangesList(
                  exchanges
                      .where((e) => e.status == ExchangeStatus.completed)
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangesList(List<Exchange> filteredExchanges) {
    if (filteredExchanges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 40,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Aucun échange',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Vos conversations apparaîtront ici',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: filteredExchanges.length,
      itemBuilder: (context, index) {
        final exchange = filteredExchanges[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: _buildExchangeItem(context, exchange),
        );
      },
    );
  }

  Widget _buildExchangeItem(BuildContext context, Exchange exchange) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openConversation(context, exchange),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Avatar avec statut en ligne
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: _getAvatarGradient(exchange.userName),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          exchange.userAvatar,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (exchange.isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 16),

                // Contenu principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom et heure
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              exchange.userName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            exchange.lastMessageTime,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6),

                      // Échange de compétences - Version compacte
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              exchange.skillOffered,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.swap_horiz,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              exchange.skillRequested,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      // Dernier message et badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              exchange.lastMessage,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildStatusDot(exchange.status),
                              if (exchange.unreadCount > 0) ...[
                                SizedBox(width: 8),
                                Container(
                                  key: Key('unreadCountBadge'),
                                  height: 20,
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${exchange.unreadCount}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDot(ExchangeStatus status) {
    Color color;
    switch (status) {
      case ExchangeStatus.active:
        color = Colors.green;
        break;
      case ExchangeStatus.completed:
        color = AppColors.secondary;
        break;
      case ExchangeStatus.pending:
        color = Colors.orange;
        break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  LinearGradient _getAvatarGradient(String name) {
    final gradients = [
      LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
      LinearGradient(colors: [Color(0xFFf093fb), Color(0xFFf5576c)]),
      LinearGradient(colors: [Color(0xFF4facfe), Color(0xFF00f2fe)]),
      LinearGradient(colors: [Color(0xFF43e97b), Color(0xFF38f9d7)]),
      LinearGradient(colors: [Color(0xFFfa709a), Color(0xFFfee140)]),
    ];
    return gradients[name.hashCode % gradients.length];
  }

  // ignore: unused_element
  int _getActiveCount() =>
      exchanges.where((e) => e.status == ExchangeStatus.active).length;
  // ignore: unused_element
  int _getCompletedCount() =>
      exchanges.where((e) => e.status == ExchangeStatus.completed).length;

  void _openConversation(BuildContext context, Exchange exchange) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          recipientName: exchange.userName,
          recipientAvatar: exchange.userAvatar,
          isOnline: exchange.isOnline,
          skillOffered: exchange.skillOffered,
          skillRequested: exchange.skillRequested,
          exchangeId: exchange.id,
        ),
      ),
    );
  }
}

// Modèles de données mis à jour
class Exchange {
  final String id;
  final String userName;
  final String userAvatar;
  final String skillOffered;
  final String skillRequested;
  final String lastMessage;
  final String lastMessageTime;
  final ExchangeStatus status;
  final int unreadCount;
  final bool isOnline;

  const Exchange({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.skillOffered,
    required this.skillRequested,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.status,
    required this.unreadCount,
    required this.isOnline,
  });
}

enum ExchangeStatus { active, completed, pending }
