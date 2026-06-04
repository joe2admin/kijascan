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
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final backgroundColor = dark ? TColors.dark : TColors.softGrey;
    final foregroundColor = dark ? TColors.light : TColors.dark;
    final cardColor = dark ? TColors.black : TColors.white;
    final subtitleColor = dark ? TColors.darkerGrey : Colors.black38;

    Widget buildSectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
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
      required ValueChanged<bool> onChanged,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              fontSize: TSizes.fontSizeMd,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: dark ? TColors.grey : TColors.darkerGrey,
                    fontSize: 12,
                  ),
                )
              : null,
          trailing: Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: dark ? TColors.primary : TColors.accent,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: dark ? TColors.darkGrey : TColors.dark,
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(color: subtitleColor, fontSize: 12),
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
        backgroundColor: dark ? TColors.dark : TColors.light,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Iconsax.arrow_left_2, color: foregroundColor, size: 18),
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: foregroundColor,
            fontSize: TSizes.fontSizeXl,
            fontWeight: FontWeight.w800,
            fontFamily: 'Outfit',
          ),
        ),
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
            iconBgColor: TColors.primary,
            iconColor: dark ? TColors.white : TColors.softGrey,
            title: 'Notifications',
            subtitle: _notificationsEnabled
                ? 'Push alerts enabled'
                : 'All alerts muted',
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              // TODO: handle notification permission logic here
            },
          ),

          // ── About ─────────────────────────────────────
          buildSectionHeader('About'),

          buildNavTile(
            icon: Iconsax.info_circle,
            iconBgColor: TColors.primary,
            iconColor: dark ? TColors.white : TColors.softGrey,
            title: 'About KijaScan',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
