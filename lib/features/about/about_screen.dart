import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/links.dart';
import '../../core/widgets/glass_card.dart';
import '../monetization/monetization.dart';

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
            child: Text(
              AppConstants.disclaimer,
              style: AppTypography.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GlassCard(
            child: Text(
              'As notícias trazem a fonte e o link original. Os vídeos tocam pelo player do '
              'YouTube, direto do canal de quem publicou. O app não usa imagens do jogo.',
              style: AppTypography.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _AdsSection(),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.privacy_tip_outlined,
              color: AppColors.textSecondary,
            ),
            title: const Text('Política de privacidade'),
            subtitle: const Text(
              'Sem cadastro. Os anúncios do Google podem usar o ID de publicidade do aparelho.',
            ),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            onTap: () => openLink(context, AppConstants.privacyPolicyUrl),
          ),
        ],
      ),
    );
  }
}

/// Anúncios: remover (compra única), restaurar, privacidade e aviso de afiliados.
class _AdsSection extends ConsumerStatefulWidget {
  const _AdsSection();

  @override
  ConsumerState<_AdsSection> createState() => _AdsSectionState();
}

class _AdsSectionState extends ConsumerState<_AdsSection> {
  ProductDetails? _product;

  @override
  void initState() {
    super.initState();
    ref.read(premiumProvider.notifier).product().then((p) {
      if (mounted) setState(() => _product = p);
    });
  }

  Future<void> _buy() async {
    final result = await ref.read(premiumProvider.notifier).buy();
    if (!mounted || result == PurchaseResult.started) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compra indisponível no momento. Tente mais tarde.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final premium = ref.watch(premiumProvider);
    final ads = ref.watch(adsProvider);
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (premium)
            const ListTile(
              leading: Icon(Icons.verified_rounded, color: AppColors.success),
              title: Text('Anúncios removidos'),
              subtitle: Text('Obrigado por apoiar o app!'),
            )
          else if (monetizationSupported) ...[
            ListTile(
              leading: const Icon(
                Icons.block_rounded,
                color: AppColors.primary,
              ),
              title: const Text('Remover anúncios'),
              subtitle: Text(
                _product == null
                    ? 'Compra única, para sempre'
                    : 'Compra única: ${_product!.price}',
              ),
              onTap: _buy,
            ),
            ListTile(
              leading: const Icon(
                Icons.restore_rounded,
                color: AppColors.textSecondary,
              ),
              title: const Text('Restaurar compra'),
              onTap: () => ref.read(premiumProvider.notifier).restore(),
            ),
          ],
          if (ads.privacyOptionsRequired)
            ListTile(
              leading: const Icon(
                Icons.tune_rounded,
                color: AppColors.textSecondary,
              ),
              title: const Text('Privacidade dos anúncios'),
              onTap: () => ref.read(adsProvider.notifier).showPrivacyOptions(),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Text(
              'O app se mantém com anúncios e links de afiliado: compras feitas pelos links '
              'de loja podem render comissão ao app, sem custo a mais para você.',
              style: AppTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
