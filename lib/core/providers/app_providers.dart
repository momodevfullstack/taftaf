// core/providers/app_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// === PROVIDERS DE CONFIGURATION ===

/// Provider pour le thème de l'application
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

/// Provider pour l'état de connexion réseau
final networkProvider = StateNotifierProvider<NetworkNotifier, bool>((ref) {
  return NetworkNotifier();
});

/// Provider pour les données utilisateur
final userDataProvider = StateNotifierProvider<UserDataNotifier, UserData>((
  ref,
) {
  return UserDataNotifier();
});

/// Provider pour les notifications
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationModel>>((
      ref,
    ) {
      return NotificationsNotifier();
    });

// === NOTIFIERS ===

/// Notifier pour la gestion du thème
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  void toggleTheme() {
    state = !state;
    // TODO: Sauvegarder dans les préférences
  }

  void setTheme(bool isDark) {
    state = isDark;
    // TODO: Sauvegarder dans les préférences
  }
}

/// Notifier pour la gestion du réseau
class NetworkNotifier extends StateNotifier<bool> {
  NetworkNotifier() : super(true);

  void setOnline(bool isOnline) {
    state = isOnline;
  }

  void checkConnectivity() async {
    // TODO: Implémenter la vérification de connectivité réelle
    await Future.delayed(const Duration(milliseconds: 500));
    state = true; // Simulation
  }
}

/// Modèle de données utilisateur
class UserData {
  final List<String> skills;
  final List<String> needs;
  final Map<String, dynamic> preferences;

  const UserData({
    this.skills = const [],
    this.needs = const [],
    this.preferences = const {},
  });

  UserData copyWith({
    List<String>? skills,
    List<String>? needs,
    Map<String, dynamic>? preferences,
  }) {
    return UserData(
      skills: skills ?? this.skills,
      needs: needs ?? this.needs,
      preferences: preferences ?? this.preferences,
    );
  }
}

/// Notifier pour la gestion des données utilisateur
class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier() : super(const UserData());

  void addSkill(String skill) {
    if (!state.skills.contains(skill)) {
      state = state.copyWith(skills: [...state.skills, skill]);
    }
  }

  void removeSkill(String skill) {
    state = state.copyWith(
      skills: state.skills.where((s) => s != skill).toList(),
    );
  }

  void addNeed(String need) {
    if (!state.needs.contains(need)) {
      state = state.copyWith(needs: [...state.needs, need]);
    }
  }

  void removeNeed(String need) {
    state = state.copyWith(needs: state.needs.where((n) => n != need).toList());
  }

  void updatePreference(String key, dynamic value) {
    final newPreferences = Map<String, dynamic>.from(state.preferences);
    newPreferences[key] = value;
    state = state.copyWith(preferences: newPreferences);
  }
}

/// Modèle de notification
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}

/// Types de notifications
enum NotificationType { exchange, message, system, payment }

/// Notifier pour la gestion des notifications
class NotificationsNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationsNotifier() : super([]);

  void addNotification(NotificationModel notification) {
    state = [notification, ...state];
  }

  void markAsRead(String notificationId) {
    state = state.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
  }

  void markAllAsRead() {
    state = state.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();
  }

  void removeNotification(String notificationId) {
    state = state
        .where((notification) => notification.id != notificationId)
        .toList();
  }

  void clearAll() {
    state = [];
  }

  int get unreadCount =>
      state.where((notification) => !notification.isRead).length;
}

// === PROVIDERS COMPOSÉS ===

/// Provider pour l'état de chargement
final loadingProvider = StateProvider<bool>((ref) => false);

/// Provider pour les erreurs
final errorProvider = StateProvider<String?>((ref) => null);
