import 'package:flutter/material.dart';

import '../widgets/nozul_bottom_bar.dart';
import '../widgets/nozul_drawer.dart';
import 'bookings_screen.dart';
import 'favoritesScreen.dart';
import 'home_content.dart';
import 'welcome_screen.dart';
import 'account_screen.dart';
import 'register_screen.dart';

// نقطة الدخول الحالية نفسها؛ لا نغيّر استدعاء HomeScreen في WelcomeScreen.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialAccount});
  final RegistrationData? initialAccount;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Set<int> favoriteHotelIds = {};

  late int selectedTabIndex;
  RegistrationData? _account;
  @override
  void initState() {
    super.initState();
    _account = widget.initialAccount;
    selectedTabIndex = 0;
    _pageController = PageController(initialPage: selectedTabIndex);
  }

  String selectedCurrency = 'ريال يمني جديد';

  void _openAccount() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const WelcomeScreen()),
    );
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _toggleFavorite(int hotelId) {
    setState(() {
      if (!favoriteHotelIds.add(hotelId)) {
        favoriteHotelIds.remove(hotelId);
      }
    });
  }

  void _changeTab(int index) {
    FocusScope.of(context).unfocus();
    if (index == 3 && _account == null) {
      _openAccount();
      return;
    }
    if (!_pageController.hasClients) return;

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: NozulDrawer(
        selectedCurrency: selectedCurrency,
        onCurrencyChanged: (currency) {
          setState(() => selectedCurrency = currency);
        },
        onLoginPressed: () {
          _scaffoldKey.currentState?.closeEndDrawer();
          _openAccount();
        },
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              FocusScope.of(context).unfocus();
              setState(() {
                selectedTabIndex = index;
              });
            },

            children: [
              HomeContent(
                favoriteHotelIds: favoriteHotelIds,
                onFavoritePressed: _toggleFavorite,
                onAccountPressed: _openAccount,
                onMenuPressed: _openDrawer,
              ),

              BookingsScreen(onMenuPressed: _openDrawer),
              FavoritesScreen(
                favoriteHotelIds: favoriteHotelIds,
                onFavoritePressed: _toggleFavorite,
                onMenuPressed: _openDrawer,
              ),
              if (_account != null)
                AccountScreen(account: _account!, onMenuPressed: _openDrawer),
            ],
          ),
          if (MediaQuery.viewInsetsOf(context).bottom == 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NozulBottomBar(
                    selectedIndex: selectedTabIndex,
                    onChanged: _changeTab,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
