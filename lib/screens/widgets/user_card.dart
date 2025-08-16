// widgets/user_card.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onContact;

  const UserCard({
    Key? key,
    required this.user,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserHeader(),
                SizedBox(height: 16),
                _buildUserSkillsAndNeeds(),
                SizedBox(height: 16),
                _buildUserActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary,
              child: Text(
                user.avatar,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            if (user.isOnline)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.level,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                  Text(
                    '${user.distance.toStringAsFixed(1)} km',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(
                    '${user.rating} (${user.exchanges})',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                  Text(
                    user.responseTime,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserSkillsAndNeeds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkillSection(title: 'Propose:', items: user.skills, color: AppColors.primary),
        SizedBox(height: 12),
        SkillSection(title: 'Recherche:', items: user.needs, color: AppColors.secondary),
      ],
    );
  }

  Widget _buildUserActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onContact,
            icon: Icon(Icons.message, size: 18),
            label: Text('Contacter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondary),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: onToggleFavorite,
            icon: Icon(
              Icons.favorite_border,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

class SkillSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;

  const SkillSection({
    Key? key,
    required this.title,
    required this.items,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: items.map((item) => Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}