import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers.dart';
import '../../../core/widgets/app_loading_state.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../domain/media_item_model.dart';

final galleryCategoryProvider = StateProvider<String>((ref) => 'Todos');

final filteredGalleryProvider = FutureProvider<List<MediaItemModel>>((ref) async {
  final repo = ref.watch(galleryRepositoryProvider);
  final cat = ref.watch(galleryCategoryProvider);
  return await repo.getMediaItems(category: cat);
});

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryAsync = ref.watch(filteredGalleryProvider);
    final selectedCat = ref.watch(galleryCategoryProvider);
    final categories = ['Todos', 'Personagens', 'Locais', 'Veículos', 'Mapa'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Galeria', style: AppTypography.titleLarge)),
      body: Column(children: [
        // Category chips
        SizedBox(height: 42, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = cat == selectedCat;
            return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
              label: Text(cat), selected: isSelected,
              onSelected: (_) => ref.read(galleryCategoryProvider.notifier).state = cat,
              selectedColor: AppColors.primary, backgroundColor: AppColors.surface,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.bold),
            ));
          },
        )),
        const SizedBox(height: AppSpacing.sm),
        Expanded(child: galleryAsync.when(
          loading: () => const AppLoadingState(message: 'Carregando galeria...'),
          error: (e, _) => AppEmptyState(title: 'Erro', message: e.toString(), icon: Icons.error_outline_rounded),
          data: (items) {
            if (items.isEmpty) {
              return const AppEmptyState(title: 'Galeria vazia', message: 'Nenhuma mídia encontrada.', icon: Icons.photo_library_rounded);
            }
            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.2,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => _openFullscreen(context, items, index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Stack(children: [
                      Positioned.fill(
                        child: item.localImageAsset != null
                            ? Image.asset(item.localImageAsset!, fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(color: AppColors.surfaceLight))
                            : Container(color: AppColors.surfaceLight, child: const Icon(Icons.image_rounded, color: AppColors.textMuted, size: 48)),
                      ),
                      Positioned(bottom: 0, left: 0, right: 0, child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(gradient: LinearGradient(
                          begin: Alignment.bottomCenter, end: Alignment.topCenter,
                          colors: [Colors.black.withAlpha(200), Colors.transparent],
                        )),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(item.type.label, style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 9)),
                        ]),
                      )),
                    ]),
                  ),
                );
              },
            );
          },
        )),
      ]),
    );
  }

  void _openFullscreen(BuildContext context, List<MediaItemModel> items, int initialIndex) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _FullscreenGallery(items: items, initialIndex: initialIndex),
    ));
  }
}

class _FullscreenGallery extends StatelessWidget {
  final List<MediaItemModel> items;
  final int initialIndex;
  const _FullscreenGallery({required this.items, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white)),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(child: InteractiveViewer(
              minScale: 0.5, maxScale: 4.0,
              child: item.localImageAsset != null
                  ? Image.asset(item.localImageAsset!, fit: BoxFit.contain)
                  : const Icon(Icons.image_rounded, color: Colors.white38, size: 80),
            )),
            Padding(padding: const EdgeInsets.all(16), child: Column(children: [
              Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${item.type.label} • ${item.category}', style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 12)),
              if (item.sourceName != null) ...[
                const SizedBox(height: 2),
                Text('Fonte: ${item.sourceName}', style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 10)),
              ],
            ])),
          ]);
        },
      ),
    );
  }
}
