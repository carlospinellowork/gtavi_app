import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressStateProvider);
    final favoritesAsync = ref.watch(favoritesStateProvider);

    final overallPercent = ((progressAsync.value?.overallPercentage ?? 0.0) * 100).toInt();
    final favCount = favoritesAsync.value?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Perfil do Jogador', style: AppTypography.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // User Avatar Card
            GlassCard(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(100),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person_rounded, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Vice Outlaw #77', style: AppTypography.titleLarge),
                  const SizedBox(height: 4),
                  Text('Sincronizado Localmente', style: AppTypography.bodySmall),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileStat('Progresso', '$overallPercent%'),
                      _buildProfileStat('Favoritos', '$favCount'),
                      _buildProfileStat('Horas', '42h'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Cloud Sync / Auth Future Card
            GlassCard(
              backgroundColor: AppColors.surfaceLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_sync_rounded, color: AppColors.secondary, size: 24),
                      const SizedBox(width: 10),
                      Text('Sincronização em Nuvem', style: AppTypography.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crie uma conta gratuita para salvar seu progresso, favoritos e configurações na nuvem entre múltiplos dispositivos.',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    text: 'Entrar / Criar Conta',
                    icon: Icons.login_rounded,
                    variant: AppButtonVariant.primary,
                    isFullWidth: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Autenticação em nuvem estará disponível na versão 2.0.'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Settings Options
            GlassCard(
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.bookmark_rounded,
                    title: 'Meus Favoritos',
                    onTap: () => context.push('/favorites'),
                  ),
                  const Divider(height: 1, color: AppColors.surfaceBorder),
                  _buildSettingsTile(
                    icon: Icons.notifications_rounded,
                    title: 'Notificações & Alertas',
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.surfaceBorder),
                  _buildSettingsTile(
                    icon: Icons.palette_rounded,
                    title: 'Tema (Dark Vice Neon)',
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.surfaceBorder),
                  _buildSettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Suporte & Sobre o App',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 20),
      title: Text(title, style: AppTypography.bodyMedium),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
