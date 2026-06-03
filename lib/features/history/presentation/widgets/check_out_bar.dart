import 'package:flutter/material.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';

class CheckOutBar extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onCheckOut;

  const CheckOutBar({required this.isSubmitting, required this.onCheckOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: TColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: isSubmitting ? null : onCheckOut,
          behavior: HitTestBehavior.opaque,
          child: AnimatedOpacity(
            opacity: isSubmitting ? 0.7 : 1,
            duration: const Duration(milliseconds: 150),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: TColors.error,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: TColors.error.withValues(alpha: 0.32),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: TColors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: TColors.white,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Check Out',
                          style: TextStyle(
                            color: TColors.white,
                            fontSize: TSizes.fontSizeMd,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
