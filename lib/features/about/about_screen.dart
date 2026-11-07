import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/links.dart';
import '../../core/widgets/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: ListView(
        padding: AppSpacing.paddingMd,
        children: [
          Text(AppConstants.appName, style: AppTypography.displayMedium),
          Text(AppConstants.appTagline, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          GlassCard(
            borderColor: AppColors.warning.withAlpha(120),
            child: Text(AppConstants.disclaimer, style: AppTypography.bodyMedium),
          ),
          const SizedBox(height: AppSpacing.md),
          GlassCard(
            child: Text(
              'As notícias trazem a fonte e o link original. Os vídeos abrem no YouTube, '
              'no canal de quem publicou. As imagens do app são ilustrações próprias, não '
              'imagens do jogo.',
              style: AppTypography.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.textSecondary),
            title: const Text('Política de privacidade'),
            subtitle: const Text('O app não pede conta nem coleta dados pessoais.'),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            onTap: () => openLink(context, AppConstants.privacyPolicyUrl),
          ),
        ],
      ),
    );
  }
}
