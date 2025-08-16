import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'tabs/create_session_page.dart';

// Définition des classes manquantes
enum MessageStatus { sending, sent, delivered, read }

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.status,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isMe,
    DateTime? timestamp,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String recipientName;
  final String recipientAvatar;
  final bool isOnline;
  final String skillOffered;
  final String skillRequested;
  final String exchangeId;

  const ChatScreen({
    Key? key,
    required this.recipientName,
    required this.recipientAvatar,
    required this.isOnline,
    required this.skillOffered,
    required this.skillRequested,
    required this.exchangeId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // État de l'échange
  bool _isExchangeCompleted = false;
  bool _isSessionCreated = false;
  DateTime? _sessionStartTime;
  // ignore: unused_field
  DateTime? _sessionEndTime;
  // ignore: unused_field
  String? _sessionLocation;
  // ignore: unused_field
  String? _sessionNotes;

  // Messages d'exemple
  List<ChatMessage> messages = [
    ChatMessage(
      id: '1',
      text:
          'Salut ! J\'ai vu que tu cherches de l\'aide en développement mobile',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      status: MessageStatus.read,
    ),
    ChatMessage(
      id: '2',
      text:
          'Oui exactement ! Et toi tu proposes du design graphique c\'est parfait 😊',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: -5)),
      status: MessageStatus.read,
    ),
    ChatMessage(
      id: '3',
      text: 'Super ! On peut organiser une session d\'échange cette semaine ?',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      status: MessageStatus.read,
    ),
    ChatMessage(
      id: '4',
      text: 'Parfait ! Créons une session d\'échange 🎨',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
      status: MessageStatus.delivered,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // En-tête d'échange avec bouton de création/fin
          _buildExchangeHeader(),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Zone de saisie
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
      ),
      title: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: _getAvatarGradient(widget.recipientName),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    widget.recipientAvatar,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (widget.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),

          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipientName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  widget.isOnline ? 'En ligne' : 'Hors ligne',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isOnline
                        ? Colors.green
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showOptionsMenu();
          },
          icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildExchangeHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isExchangeCompleted
              ? [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)]
              : _isSessionCreated
              ? [Colors.blue.withOpacity(0.1), Colors.blue.withOpacity(0.05)]
              : [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.secondary.withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExchangeCompleted
              ? Colors.green.withOpacity(0.3)
              : _isSessionCreated
              ? Colors.blue.withOpacity(0.3)
              : AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _isExchangeCompleted
                    ? Icons.check_circle
                    : _isSessionCreated
                    ? Icons.event_available
                    : Icons.swap_horiz,
                color: _isExchangeCompleted
                    ? Colors.green
                    : _isSessionCreated
                    ? Colors.blue
                    : AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isExchangeCompleted
                          ? 'Échange terminé'
                          : _isSessionCreated
                          ? 'Session programmée'
                          : 'Échange de compétences',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isExchangeCompleted
                            ? Colors.green
                            : _isSessionCreated
                            ? Colors.blue
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.skillOffered,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.skillRequested,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Boutons selon l'état
          if (!_isSessionCreated && !_isExchangeCompleted) ...[
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showCreateSessionDialog,
                icon: Icon(Icons.add_circle_outline, size: 18),
                label: Text('Créer une session d\'échange'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ] else if (_isSessionCreated && !_isExchangeCompleted) ...[
            SizedBox(height: 12),
            if (_sessionStartTime != null)
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.blue, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Prévue le ${_formatDate(_sessionStartTime!)} à ${_formatTime24(_sessionStartTime!)}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showCompleteExchangeDialog,
                icon: Icon(Icons.check, size: 18),
                label: Text('Terminer la session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ] else if (_isExchangeCompleted) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Session terminée avec succès',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: _getAvatarGradient(widget.recipientName),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  widget.recipientAvatar,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: message.isMe
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: message.isMe
                              ? Colors.white.withOpacity(0.8)
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (message.isMe) ...[
                        SizedBox(width: 4),
                        _buildMessageStatusIcon(message.status),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (message.isMe) SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildMessageStatusIcon(MessageStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case MessageStatus.sending:
        icon = Icons.schedule;
        color = Colors.white.withOpacity(0.6);
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.white.withOpacity(0.8);
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.white.withOpacity(0.8);
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.white;
        break;
    }

    return Icon(icon, size: 12, color: color);
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Tapez votre message...',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          SizedBox(width: 12),

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isMe: true,
          timestamp: DateTime.now(),
          status: MessageStatus.sending,
        ),
      );
    });

    _messageController.clear();

    // Simuler l'envoi
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          messages.last = messages.last.copyWith(status: MessageStatus.sent);
        });
      }
    });

    // Scroll vers le bas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showCreateSessionDialog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateSessionPage()),
    );

    if (result != null) {
      _createSession(
        result['date'],
        result['time'],
        result['location'],
        result['notes'],
      );
    }
  }

  void _createSession(
    DateTime date,
    TimeOfDay time,
    String location,
    String notes,
  ) {
    setState(() {
      _isSessionCreated = true;
      _sessionStartTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _sessionLocation = location.isNotEmpty ? location : null;
      _sessionNotes = notes.isNotEmpty ? notes : null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Session créée avec succès !'),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showCompleteExchangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text(
                'Terminer la session',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Êtes-vous sûr de vouloir marquer cette session d\'échange comme terminée ?',
                style: TextStyle(fontSize: 15, color: AppColors.textPrimary),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Cette action ne peut pas être annulée.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _completeExchange();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Terminer',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _completeExchange() {
    setState(() {
      _isExchangeCompleted = true;
      _sessionEndTime = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Session marquée comme terminée !'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.block, color: Colors.red),
                title: Text('Bloquer ${widget.recipientName}'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique de blocage ici
                },
              ),
              ListTile(
                leading: Icon(Icons.report, color: Colors.orange),
                title: Text('Signaler ${widget.recipientName}'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique de signalement ici
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.grey),
                title: Text('Supprimer la conversation'),
                onTap: () {
                  Navigator.pop(context);
                  // Logique de suppression ici
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Méthodes utilitaires pour le formatage des dates et heures
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime24(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Méthode pour générer un gradient d'avatar basé sur le nom
  LinearGradient _getAvatarGradient(String name) {
    final colors = [
      [Colors.blue, Colors.indigo],
      [Colors.purple, Colors.deepPurple],
      [Colors.pink, Colors.red],
      [Colors.orange, Colors.deepOrange],
      [Colors.green, Colors.teal],
      [Colors.cyan, Colors.blue],
    ];

    final index = name.hashCode % colors.length;
    return LinearGradient(
      colors: colors[index.abs()],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
