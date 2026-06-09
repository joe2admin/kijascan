import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kijascan/core/theme_controller.dart';
import 'package:kijascan/utils/constants/colors.dart';
import 'package:kijascan/utils/constants/sizes.dart';
import 'package:kijascan/utils/helpers/helper_functions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final backgroundColor = dark ? TColors.dark : TColors.light;
    final foregroundColor = dark ? TColors.light : TColors.dark;
    final subtitleColor = dark ? TColors.darkerGrey : Colors.black38;

    BoxDecoration buildCardDecoration() {
      return BoxDecoration(
        color: dark ? TColors.darkContainer : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: dark ? Colors.transparent : TColors.grey.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: dark 
            ? [] 
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      );
    }

    Widget buildSectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: subtitleColor,
          ),
        ),
      );
    }

    Widget buildToggleTile({
      required IconData icon,
      required Color iconBgColor,
      required Color iconColor,
      required String title,
      String? subtitle,
      required bool value,
      ValueChanged<bool>? onChanged,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: buildCardDecoration(),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconBgColor, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
              fontSize: TSizes.fontSizeMd,
              letterSpacing: -0.2,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: dark ? Colors.white54 : Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null,
          trailing: Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: TColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: dark ? Colors.white24 : Colors.black26,
          ),
        ),
      );
    }

    Widget buildNavTile({
      required IconData icon,
      required Color iconBgColor,
      required Color iconColor,
      required String title,
      String? subtitle,
      required VoidCallback onTap,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: buildCardDecoration(),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconBgColor, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: -0.2,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: dark ? Colors.white54 : Colors.black54, 
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null,
          trailing: Icon(Iconsax.arrow_right_3, color: subtitleColor, size: 16),
          onTap: onTap,
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: dark ? TColors.softGrey : TColors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: foregroundColor,
            fontSize: TSizes.fontSizeXl,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          // ── Preferences ──────────────────────────────
          buildSectionHeader('Preferences'),

          buildToggleTile(
            icon: Iconsax.moon,
            iconBgColor: TColors.primary,
            iconColor: dark ? TColors.white : TColors.softGrey,
            title: 'Theme',
            subtitle: dark ? 'Dark theme active' : 'Light theme active',
            value: dark,
            onChanged: (val) {
              Get.find<ThemeController>().toggleTheme();
            },
          ),

          buildToggleTile(
            icon: Iconsax.notification,
            iconBgColor: dark ? TColors.darkerGrey : TColors.grey,
            iconColor: dark ? TColors.darkGrey : TColors.darkerGrey,
            title: 'Notifications',
            subtitle: 'Not available yet',
            value: false,
            onChanged: null,
          ),

          // ── About ─────────────────────────────────────
          buildSectionHeader('About'),

          buildNavTile(
            icon: Iconsax.info_circle,
            iconBgColor: TColors.primary,
            iconColor: dark ? TColors.white : TColors.softGrey,
            title: 'About KijaScan',
            subtitle: 'Version 1.0.0',
            onTap: () => Get.toNamed('/about'),
          ),
        ],
      ),
    );
  }
}
