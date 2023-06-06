import 'package:flutter/material.dart';

class bottomnavbar extends StatefulWidget {
  late int selectedIndex;
  final Function(int) onIndexChanged;
  bottomnavbar({required this.selectedIndex, required this.onIndexChanged});

  @override
  State<bottomnavbar> createState() => _bottomnavbarState();
}

class _bottomnavbarState extends State<bottomnavbar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(37),
          topRight: Radius.circular(37),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(37),
          topRight: Radius.circular(37),
        ),
        child: Container(
          color: Colors.transparent,
          height: 70,
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: const Color(0xFF019267),
            ),
            child: BottomNavigationBar(
              unselectedItemColor: Colors.white,
              selectedLabelStyle: const TextStyle(
                  fontFamily: 'inter', fontWeight: FontWeight.w800),
              selectedIconTheme: const IconThemeData(color: Color(0xFFFB983E)),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.confirmation_number),
                  label: 'Ticket',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: selectedIndex,
              onTap: (int index) {
                setState(() {
                  selectedIndex = index;
                });
                widget.onIndexChanged(selectedIndex);
              },
            ),
          ),
        ),
      ),
    );
  }
}
