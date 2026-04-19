import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/constants/asset_paths.dart';

/// A button widget with fun press animations and sound effects for kids
class AnimatedGameButton extends StatefulWidget {
  const AnimatedGameButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = const Color(0xFF4CAF50),
    this.foregroundColor = Colors.white,
    this.width = 250,
    this.height = 70,
    this.borderRadius = 20,
    this.playSound = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;
  final double height;
  final double borderRadius;
  final bool playSound;

  @override
  State<AnimatedGameButton> createState() => _AnimatedGameButtonState();
}

class _AnimatedGameButtonState extends State<AnimatedGameButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: ElevatedButton(
            onPressed: widget.onPressed != null
                ? () {
                    // Play click sound
                    if (widget.playSound) {
                      FlameAudio.play(AssetPaths.clickSound, volume: 0.5);
                    }
                    // Call the original onPressed callback
                    widget.onPressed!();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
              elevation: 8,
              shadowColor: Colors.black45,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              disabledBackgroundColor: Colors.grey.shade400,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
