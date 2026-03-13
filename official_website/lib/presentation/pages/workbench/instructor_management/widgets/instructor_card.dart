import 'package:flutter/material.dart';
import 'package:official_website/domain/entities/instructor.dart';

/// 讲师卡片组件
class InstructorCard extends StatelessWidget {
  final Instructor instructor;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const InstructorCard({
    super.key,
    required this.instructor,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 头像
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFF5F5F5),
                backgroundImage: instructor.avatar.isNotEmpty
                    ? NetworkImage(instructor.avatar)
                    : null,
                child: instructor.avatar.isEmpty
                    ? const Icon(Icons.person, size: 32)
                    : null,
              ),

              const SizedBox(width: 16),

              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 名称和状态
                    Row(
                      children: [
                        Text(
                          instructor.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusChip(),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // 简介
                    Text(
                      instructor.bio,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // 统计信息
                    Wrap(
                      spacing: 16,
                      children: [
                        _buildStatItem(Icons.people, '学员', instructor.studentCount),
                        _buildStatItem(Icons.favorite, '粉丝', instructor.followerCount),
                        _buildStatItem(Icons.star, '评分', instructor.averageRating.toString()),
                      ],
                    ),
                  ],
                ),
              ),

              // 操作按钮
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                onPressed: onDelete,
                tooltip: '删除',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: instructor.status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        instructor.status.displayName,
        style: TextStyle(
          fontSize: 12,
          color: instructor.status.color,
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, dynamic value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$label $value',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
