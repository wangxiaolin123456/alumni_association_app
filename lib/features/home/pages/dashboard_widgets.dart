import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    required this.subtitle,
    required this.badge,
    super.key,
  });

  final String subtitle;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.hub_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '校友会',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(subtitle),
            ],
          ),
        ),
        Chip(
          avatar: const Icon(Icons.verified, size: 16),
          label: Text(badge),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({required this.merchant, super.key});

  final bool merchant;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF063CCA), Color(0xFF2589FF)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '连接校友资源\n共创价值生态',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  merchant ? '经营数据与核销协同' : '发现商家、活动与合作机会',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Icon(
            merchant ? Icons.trending_up_rounded : Icons.public_rounded,
            color: Colors.white.withValues(alpha: 0.85),
            size: 72,
          ),
        ],
      ),
    );
  }
}

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({required this.items, super.key});

  final List<(IconData, String, Color)> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 92,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: item.$3.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(item.$1, color: item.$3),
              ),
            ),
            const SizedBox(height: 6),
            Text(item.$2, maxLines: 1),
          ],
        );
      },
    );
  }
}
