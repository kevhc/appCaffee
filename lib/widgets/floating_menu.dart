// floating_menu.dart
import 'package:flutter/material.dart';
import 'dart:math';

class FloatingMenu extends StatefulWidget {
  final Function onHomePressed;
  final Function onProfilePressed;
  final Function onLogoutPressed;

  const FloatingMenu({
    required this.onHomePressed,
    required this.onProfilePressed,
    required this.onLogoutPressed,
  });

  @override
  _FloatingMenuState createState() => _FloatingMenuState();
}

class _FloatingMenuState extends State<FloatingMenu> {
  bool _isMenuOpen = false;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 56.0;
    const double arcRadius = 95.0;
    final double angleStep = pi / 4;

    return Stack(
      children: [
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.teal,
            child: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              setState(() {
                _isMenuOpen = !_isMenuOpen;
              });
            },
            shape: CircleBorder(),
          ),
        ),
        if (_isMenuOpen) ...[
          for (int i = 0; i < 3; i++) // 3 buttons: Home, Profile, Logout
            Positioned(
              bottom: 16 + arcRadius * sin(i * angleStep),
              right: 16 + arcRadius * cos(i * angleStep),
              child: MouseRegion(
                onEnter: (_) => setState(() {
                  _isHovering = true;
                }),
                onExit: (_) => setState(() {
                  _isHovering = false;
                }),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: _isHovering ? 70.0 : 56.0,
                  height: _isHovering ? 70.0 : 56.0,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade700,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (_isHovering)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        i == 0
                            ? Icons.home
                            : i == 1
                                ? Icons.person
                                : Icons.logout,
                        color: Colors.white,
                        size: _isHovering ? 30.0 : 24.0,
                      ),
                      onPressed: () {
                        if (i == 0) {
                          widget.onHomePressed();
                        } else if (i == 1) {
                          widget.onProfilePressed();
                        } else if (i == 2) {
                          widget.onLogoutPressed();
                        }
                      },
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
