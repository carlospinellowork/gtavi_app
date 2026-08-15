import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_badge.dart';
import '../domain/property_model.dart';

final propertiesProvider = FutureProvider<List<PropertyModel>>((ref) async {
  final repo = ref.watch(economyRepositoryProvider);
  return await repo.getProperties();
});

class EconomyScreen extends ConsumerStatefulWidget {
  const EconomyScreen({super.key});

  @override
  ConsumerState<EconomyScreen> createState() => _EconomyScreenState();
}

class _EconomyScreenState extends ConsumerState<EconomyScreen> {
  final Set<String> ownedPropertyIds = {'prop_malibu'};
  int userCapital = 45000000;

  final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  void _toggleOwnership(PropertyModel property) {
    setState(() {
      if (ownedPropertyIds.contains(property.id)) {
        ownedPropertyIds.remove(property.id);
        userCapital += property.purchasePrice;
      } else {
        if (userCapital >= property.purchasePrice) {
          ownedPropertyIds.add(property.id);
          userCapital -= property.purchasePrice;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Capital insuficiente para adquirir este negócio.')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Economia & Negócios Vice City'),
        backgroundColor: AppColors.surface,
      ),
      body: propertiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('Erro ao carregar propriedades: $err')),
        data: (properties) {
          int totalHourlyIncome = 0;
          for (final prop in properties) {
            if (ownedPropertyIds.contains(prop.id)) {
              totalHourlyIncome += prop.incomePerHour;
            }
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Capital & Portfolio Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    gradient: const LinearGradient(
                      colors: [AppColors.surface, AppColors.surfaceLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: AppColors.gold.withAlpha(120)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(60),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('SEU CAPITAL DISPONÍVEL', style: TextStyle(color: AppColors.textMuted, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                        currencyFormatter.format(userCapital),
                        style: AppTypography.displayMedium.copyWith(color: AppColors.gold, fontSize: 32),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withAlpha(30)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('RENDA PASSIVA / HORA', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                              const SizedBox(height: 4),
                              Text(
                                '+${currencyFormatter.format(totalHourlyIncome)}',
                                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('NEGÓCIOS ADQUIRIDOS', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                              const SizedBox(height: 4),
                              Text(
                                '${ownedPropertyIds.length} / ${properties.length}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
                Text('Propriedades & Empreendimentos', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.sm),

                // Properties List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final prop = properties[index];
                    final isOwned = ownedPropertyIds.contains(prop.id);
                    final roiDays = (prop.purchasePrice / (prop.incomePerHour * 24)).toStringAsFixed(1);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(prop.name, style: AppTypography.titleMedium),
                                      const SizedBox(height: 2),
                                      Text(prop.location, style: AppTypography.bodySmall),
                                    ],
                                  ),
                                ),
                                AppBadge(
                                  label: isOwned ? 'ADQUIRIDO' : 'À VENDA',
                                  color: isOwned ? Colors.greenAccent : AppColors.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(prop.description, style: AppTypography.bodySmall),
                            const SizedBox(height: 14),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('PREÇO DE COMPRA', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                    Text(
                                      currencyFormatter.format(prop.purchasePrice),
                                      style: AppTypography.titleMedium.copyWith(color: AppColors.gold, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('LUCRO / HORA', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                    Text(
                                      '+${currencyFormatter.format(prop.incomePerHour)}',
                                      style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('RETORNO (ROI)', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                    Text(
                                      '~$roiDays dias',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isOwned ? Colors.redAccent.withAlpha(180) : AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () => _toggleOwnership(prop),
                                child: Text(
                                  isOwned ? 'Vender Propriedade' : 'Adquirir Negócio',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
