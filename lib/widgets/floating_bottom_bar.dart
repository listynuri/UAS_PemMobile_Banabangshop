import 'package:flutter/material.dart';

class FloatingBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingBottomBar> createState() => _FloatingBottomBarState();
}

class _FloatingBottomBarState extends State<FloatingBottomBar> {
  final List<IconData> _icons = const [
    Icons.home,
    Icons.book,
    Icons.shopping_cart,
    Icons.calendar_month,
    Icons.person,
    Icons.info,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final barHeight = size.height * 0.085;

    return Positioned(
      bottom: size.height * 0.03,
      left: size.width * 0.04,
      right: size.width * 0.04,
      child: Container(
        height: barHeight,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE6F0), Color(0xFFDFF5EA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(barHeight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_icons.length, (index) {
            final isActive = widget.currentIndex == index;

            return GestureDetector(
              onTap: () => widget.onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                padding: EdgeInsets.all(barHeight * (isActive ? 0.18 : 0.12)),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withOpacity(0.0),
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  _icons[index],
                  size: barHeight * (isActive ? 0.45 : 0.38),
                  color: isActive
                      ? const Color(0xFFFF9BC1)
                      : const Color(0xFF3A6B5C).withOpacity(0.9),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
