import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PortfolioButtonWidget extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isSelected;

  const PortfolioButtonWidget({
    Key? key,
    this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  _PortfolioButtonWidgetState createState() => _PortfolioButtonWidgetState();
}

class _PortfolioButtonWidgetState extends State<PortfolioButtonWidget>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed?.call();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1.0, end: _isPressed ? 0.95 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 150.w,
              height: 55.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: widget.isSelected
                    ? const Color(0xffFF7F00) // Orange color for selected state
                    : const Color(0xffEEEEEE), // Gray color for non-selected state
              ),
              child: Center(
                child: Text(
                  'Portfolio',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: widget.isSelected
                        ? Colors.white
                        : const Color(0xffFF7F00), // Orange color for text in non-selected state
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
