import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../navigation/navigation_service.dart';
import '../../routes/app_routes.dart';

class PersistentBottomNav extends StatefulWidget {
  const PersistentBottomNav({super.key});

  @override
  State<PersistentBottomNav> createState() => _PersistentBottomNavState();
}

class _PersistentBottomNavState extends State<PersistentBottomNav> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = NavigationService.currentBottomNavIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update index after dependencies change and Navigator is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateIndexFromRoute();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      NavigationService.currentBottomNavIndex = index;
    });

    // Use the global navigator key to navigate
    // This ensures we always have access to the Navigator
    final navigator = NavigationService.navigatorKey.currentState;
    if (navigator == null) {
      // If navigator isn't ready, try again after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        final nav = NavigationService.navigatorKey.currentState;
        if (nav != null) {
          _navigateToRoute(index, nav);
        }
      });
      return;
    }

    _navigateToRoute(index, navigator);
  }

  void _navigateToRoute(int index, NavigatorState navigator) {
    String targetRoute;
    switch (index) {
      case 0:
        targetRoute = AppRoutes.home;
        break;
      case 1:
        targetRoute = AppRoutes.courses;
        break;
      case 2:
        targetRoute = AppRoutes.dashboard;
        break;
      case 3:
        targetRoute = AppRoutes.profile;
        break;
      default:
        return;
    }

    navigator.pushNamedAndRemoveUntil(
      targetRoute,
      (route) {
        final name = route.settings.name;
        return name == AppRoutes.home ||
            name == AppRoutes.courses ||
            name == AppRoutes.dashboard ||
            name == AppRoutes.profile;
      },
    );
  }

  void _updateIndexFromRoute() {
    // Only try to update if we have a valid context
    if (!mounted) return;

    // Use maybeOf to safely check if Navigator is available
    // This won't throw an exception if Navigator isn't available
    final navigator = Navigator.maybeOf(context);
    if (navigator == null) return;

    try {
      // Try to get the route - this requires Navigator context
      final route = ModalRoute.of(context);
      if (route == null) return;

      final routeName = route.settings.name;
      if (routeName == null) return;

      final routeIndex = NavigationService.getCurrentIndexFromRoute(routeName);
      if (routeIndex != _currentIndex && mounted) {
        setState(() {
          _currentIndex = routeIndex;
          NavigationService.currentBottomNavIndex = routeIndex;
        });
      }
    } catch (e) {
      // If we can't get the route, just keep the current index
      // This can happen if the widget is built before Navigator is ready
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't call _updateIndexFromRoute here - it's handled in didChangeDependencies
    // to avoid Navigator context issues

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.orange,
          unselectedItemColor: AppColors.darkGrey,
          selectedLabelStyle: AppTextStyles.bodyText(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.bodyText(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 0
                      ? AppColors.orange.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.home_outlined,
                  size: 24,
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.home,
                  size: 24,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 1
                      ? AppColors.orange.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.book_outlined,
                  size: 24,
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.book,
                  size: 24,
                ),
              ),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 2
                      ? AppColors.orange.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard_outlined,
                  size: 24,
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard,
                  size: 24,
                ),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 3
                      ? AppColors.orange.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 24,
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  size: 24,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
