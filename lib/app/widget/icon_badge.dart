import 'package:flutter/material.dart';

import '../config/theme.dart';

class BadgeIcons extends StatelessWidget {
  final bool isZero;
  final IconData icon;
  final VoidCallback onTap;
  final int count;

  const BadgeIcons({
    required this.count,
    required this.icon,
    this.isZero = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isZero
          ? IconButton(
              color: primaryColor,
              onPressed: onTap,
              icon: Icon(
                icon,
              ),
            )
          : Stack(
              children: [
                IconButton(
                  color: primaryColor,
                  onPressed: onTap,
                  icon: Icon(
                    icon,
                  ),
                ),
                Positioned.fill(
                  top: 2,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 10,
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: lightText,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
