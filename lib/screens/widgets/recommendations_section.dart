// widgets/recommendations_section.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/user_model.dart';
import 'user_card.dart';

class RecommendationsSection extends StatelessWidget {
  final bool isLoading;
  final String searchQuery;
  final List<UserModel> mockUsers;
  final VoidCallback onShowAllUsers;
  final Function(UserModel) onUserTap;
  final Function(UserModel) onToggleFavorite;
  final Function(UserModel) onContactUser;

  const RecommendationsSection({
    Key? key,
    required this.isLoading,
    required this.searchQuery,
    required this.mockUsers,
    required this.onShowAllUsers,
    required this.onUserTap,
    required this.onToggleFavorite,
    required this.onContactUser, required double scrollOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserModel> filteredUsers = mockUsers
        .where((user) => user.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommandés pour vous',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: onShowAllUsers,
              icon: Icon(Icons.filter_list, size: 16),
              label: Text('Filtrer'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (isLoading)
          _buildLoadingShimmer()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300 + (index * 100)),
                child: UserCard(
                  user: filteredUsers[index],
                  onTap: () => onUserTap(filteredUsers[index]),
                  onToggleFavorite: () => onToggleFavorite(filteredUsers[index]),
                  onContact: () => onContactUser(filteredUsers[index]),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(3, (index) => Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
      )),
    );
  }
}