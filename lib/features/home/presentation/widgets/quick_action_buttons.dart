import 'package:flutter/material.dart';


class QuickActionButtons extends StatelessWidget {
  final VoidCallback? onVocabTap;
  final VoidCallback? onSpeakingTap;

  const QuickActionButtons({
    super.key,
    this.onVocabTap,
    this.onSpeakingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            title: 'Vocab Quiz',
            subtitle: '5 mins',
            icon: Icons.psychology_rounded,
            backgroundColor: const Color(0xFFE9F2FF), // Nhạt hơn xíu cho đẹp
            iconBgColor: const Color(0xFFC7E0FF),
            iconColor: const Color(0xFF1CB0F6),
            onTap: onVocabTap,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            title: 'Speaking',
            subtitle: '3 mins',
            icon: Icons.record_voice_over_rounded,
            backgroundColor: const Color(0xFFEAF5EB), // Nhạt hơn xíu
            iconBgColor: const Color(0xFFCBE8CC),
            iconColor: const Color(0xFF2EA836), // Xanh lá tươi hơn
            onTap: onSpeakingTap,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color iconBgColor,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05), width: 1),
          ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15, // Tăng nhẹ size
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF222222), // Đen đậm nét
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600, // Đậm hơn
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    ),
    );
  }
}
