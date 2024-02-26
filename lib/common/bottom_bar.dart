import 'package:cofarmer/providers/auth_provider.dart';
import 'package:cofarmer/screens/auth/auth_screen.dart';
import 'package:cofarmer/screens/chat/chats.dart';
import 'package:cofarmer/screens/home/home_screen.dart';
import 'package:cofarmer/screens/map/map_screen.dart';
import 'package:cofarmer/screens/proposal/create_proposal.dart';
import 'package:cofarmer/screens/settings/settings_screen.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  final controller = PageController();
  int selectedIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    // const MapScreen(),
    const ChatScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).getCurrentUser();
    final user = Provider.of<AuthProvider>(context, listen: false).user!;

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),
      floatingActionButton: user.userType!.toLowerCase() != 'farmer'
          ? null
          : FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProposalScreen(),
                  ),
                );
              },
              child: const Icon(
                Iconsax.add,
                color: Colors.white,
              ),
            ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        activeColor: kPrimaryColor,
        inactiveColor: Colors.grey,
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
          controller.animateToPage(selectedIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad);
        },
        iconSize: 24,
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            icon: Iconsax.home,
            title: 'Home',
          ),
          // BarItem(
          //   icon: Iconsax.global,
          //   title: 'Explore',
          // ),
          BarItem(
            icon: Iconsax.message,
            title: 'Chat',
          ),
          BarItem(
            icon: Iconsax.user,
            title: 'Profile',
          ),
        ],
      ),
    );
  }
}
