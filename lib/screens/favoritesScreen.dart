import 'package:flutter/material.dart';

import '../data/hotels_data.dart';
import '../widgets/hotel_card.dart';
import '../widgets/nozul_app_bar.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<int> favoriteHotelIds;
  final ValueChanged<int> onFavoritePressed;
  final VoidCallback? onMenuPressed;

  const FavoritesScreen({
    super.key,
    required this.favoriteHotelIds,
    required this.onFavoritePressed,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteHotels = hotels.where((hotel) {
      return favoriteHotelIds.contains(hotel.id);
    }).toList();

    return Scaffold(
      appBar: NozulAppBar(title: 'المفضلة', onMenuPressed: onMenuPressed),
      body: favoriteHotels.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'لم تضف أي فندق إلى المفضلة بعد',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              key: const PageStorageKey<String>('favorites-hotels'),
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                112 + MediaQuery.paddingOf(context).bottom,
              ),
              itemCount: favoriteHotels.length,
              itemBuilder: (context, index) {
                final hotel = favoriteHotels[index];
                return HotelCard(
                  key: ValueKey(hotel.id),
                  name: hotel.name,
                  location: hotel.location,
                  image: hotel.image,
                  rating: hotel.rating,
                  isFavorite: true,
                  onTap: () {
                    // تفاصيل الفندق لاحقًا.
                  },
                  onFavoritePressed: () => onFavoritePressed(hotel.id),
                );
              },
            ),
    );
  }
}
