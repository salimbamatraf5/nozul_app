import 'package:flutter/material.dart';

import '../data/hotels_data.dart';
import '../theme/app_colors.dart';
import '../widgets/hotel_card.dart';
import '../widgets/nozul_app_bar.dart';

// محتوى الرئيسية فقط؛ التنقل وحالة المفضلة في HomeScreen.
class HomeContent extends StatefulWidget {
  final Set<int> favoriteHotelIds;
  final ValueChanged<int> onFavoritePressed;
  final VoidCallback onAccountPressed;
  final VoidCallback onMenuPressed;

  const HomeContent({
    super.key,
    required this.favoriteHotelIds,
    required this.onFavoritePressed,
    required this.onAccountPressed,
    required this.onMenuPressed,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with AutomaticKeepAliveClientMixin<HomeContent> {
  String searchQuery = '';
  String selectedGov = 'الكل';
  bool sortByRating = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.darkGold;
    final surfaceColor = isDark
        ? AppColors.DarkSurface
        : AppColors.lightSurface;
    final governorates = ['الكل', ...hotels.map((hotel) => hotel.gov).toSet()];
    final query = searchQuery.trim().toLowerCase();

    final filteredHotels = hotels.where((hotel) {
      final matchesGov = selectedGov == 'الكل' || hotel.gov == selectedGov;
      final matchesSearch =
          hotel.name.toLowerCase().contains(query) ||
          hotel.location.toLowerCase().contains(query);
      return matchesGov && matchesSearch;
    }).toList();

    if (sortByRating) {
      filteredHotels.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      appBar: NozulAppBar(
        isHome: true,
        onAccountPressed: widget.onAccountPressed,
        onMenuPressed: widget.onMenuPressed,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListView.builder(
            key: const PageStorageKey<String>('home-hotels'),
            padding: EdgeInsets.fromLTRB(
              16,
              100,
              16,
              112 + MediaQuery.paddingOf(context).bottom,
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            // الشريط الأفقي يبقى ظاهرًا أيضًا عند عدم وجود نتائج.
            itemCount: filteredHotels.isEmpty ? 2 : filteredHotels.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final filter in [
                                'الأعلى تقييمًا',
                                'الأحدث',
                                'الأقرب',
                                'السعر',
                              ])
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    end: 8,
                                  ),
                                  child: ActionChip(
                                    onPressed: () {
                                      if (filter == 'الأعلى تقييمًا') {
                                        setState(
                                          () => sortByRating = !sortByRating,
                                        );
                                      }
                                    },
                                    avatar: Icon(
                                      filter == 'الأعلى تقييمًا'
                                          ? Icons.star_rounded
                                          : filter == 'الأحدث'
                                          ? Icons.new_releases_outlined
                                          : filter == 'الأقرب'
                                          ? Icons.near_me_outlined
                                          : Icons.swap_vert_rounded,
                                      size: 18,
                                      color: goldColor,
                                    ),
                                    label: Text(filter),
                                    labelStyle: TextStyle(
                                      color:
                                          filter == 'الأعلى تقييمًا' &&
                                              sortByRating
                                          ? goldColor
                                          : theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    backgroundColor: surfaceColor,
                                    surfaceTintColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: BorderSide(
                                        color:
                                            filter == 'الأعلى تقييمًا' &&
                                                sortByRating
                                            ? goldColor
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        color: goldColor,
                        borderRadius: BorderRadius.circular(14),
                        child: IconButton(
                          onPressed: () {
                            // نافذة الفلاتر لاحقًا.
                          },
                          padding: const EdgeInsets.all(14),
                          icon: Icon(
                            Icons.tune_rounded,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (filteredHotels.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 64,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: goldColor,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'لا توجد فنادق تطابق البحث',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'جرّب اسمًا آخر أو غيّر المحافظة',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                );
              }

              final hotel = filteredHotels[index - 1];
              return HotelCard(
                key: ValueKey(hotel.id),
                name: hotel.name,
                location: hotel.location,
                image: hotel.image,
                rating: hotel.rating,
                isFavorite: widget.favoriteHotelIds.contains(hotel.id),
                onTap: () {
                  // تفاصيل الفندق لاحقًا.
                },
                onFavoritePressed: () => widget.onFavoritePressed(hotel.id),
              );
            },
          ),
          // لا توجد خلفية للصف؛ صور الفنادق تمر خلف الفراغات بين الحقول.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (value) => setState(() => searchQuery = value),
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن فندق...',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 18,
                        ),
                        prefixIcon: Icon(Icons.search, color: goldColor),
                        filled: true,
                        fillColor: surfaceColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: goldColor, width: 1.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedGov,
                      isExpanded: true,
                      dropdownColor: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: goldColor,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 18,
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 8,
                            end: 4,
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: goldColor,
                          ),
                        ),
                        filled: true,
                        fillColor: surfaceColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: goldColor, width: 1.2),
                        ),
                      ),
                      items: governorates
                          .map(
                            (gov) => DropdownMenuItem<String>(
                              value: gov,
                              child: Text(
                                gov,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        FocusScope.of(context).unfocus();
                        setState(() => selectedGov = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
