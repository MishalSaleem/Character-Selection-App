import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class Character {
  final String imagePath;
  final String name;
  final String description;
  final Color backgroundColor;
  final Color highlightColor;

  Character({
    required this.imagePath,
    required this.name,
    required this.description,
    required this.backgroundColor,
    required this.highlightColor,
  });
}

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  _CharacterSelectionScreenState createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final List<Character> characters = [
    Character(
      imagePath: 'assets/images/pic1.png',
      name: 'NYX',
      description:
          'A master of stealth and shadow, Nyx moves unseen through the neon-drenched streets. Her training in forgotten arts allows her to manipulate darkness itself, making her the perfect operative for missions that require absolute discretion and lethal precision.',
      backgroundColor: const Color(0xFF1C2541),
      highlightColor: const Color(0xFF6B58A2),
    ),
    Character(
      imagePath: 'assets/images/pic2.png',
      name: 'ZENITH',
      description:
          'The pinnacle of cybernetic engineering, Zenith is more machine than human. Her advanced combat chassis and integrated AI targeting systems grant her unparalleled strength, speed, and tactical awareness on any battlefield.',
      backgroundColor: const Color(0xFF3A506B),
      highlightColor: const Color(0xFF00BFFF),
    ),
    Character(
      imagePath: 'assets/images/pic3.png',
      name: 'VEXA',
      description:
          'A rogue agent who defected from the corporate armies, Vexa is infused with unstable, bio-enchanted abilities. She can channel raw energy through her body and equipment, creating devastating area-of-effect attacks that leave her enemies in disarray.',
      backgroundColor: const Color(0xFF1E3A3A),
      highlightColor: const Color(0xFFD90429),
    ),
    Character(
      imagePath: 'assets/images/pic4.png',
      name: 'KAI',
      description:
          'A high-tech soldier equipped with a neural-linked combat suit, Kai is a one-person army. His suit adapts to any threat in real-time, augmenting his physical abilities and providing a constant stream of battlefield data directly to his mind.',
      backgroundColor: const Color(0xFF0D2828),
      highlightColor: const Color(0xFF50FC43),
    ),
  ];

  int _selectedCharacterIndex = 0;
  int _selectedNavIndex = 0;
  int? _tappedIconIndex;

  void _onCharacterTapped(int index) {
    setState(() {
      _selectedCharacterIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          _buildAnimatedCharacterImage(screenHeight),
          _buildTopNavBar(),
          _buildAnimatedCharacterDetails(screenWidth, screenHeight),
          _buildSideSelectionIcons(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 900),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: Container(
        key: ValueKey<int>(_selectedCharacterIndex),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.0, -0.6),
            radius: 1.2,
            colors: [
              characters[_selectedCharacterIndex]
                  .highlightColor
                  .withOpacity(0.5),
              characters[_selectedCharacterIndex].backgroundColor,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCharacterImage(double screenHeight) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeOutQuart,
      switchOutCurve: Curves.easeInQuart,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final isEntering = (child.key as ValueKey<String>).value ==
            characters[_selectedCharacterIndex].imagePath;

        final slideAnimation = Tween<Offset>(
          begin: Offset(0.0, isEntering ? 1.0 : -0.5),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Container(
        key: ValueKey<String>(characters[_selectedCharacterIndex].imagePath),
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          characters[_selectedCharacterIndex].imagePath,
          height: screenHeight * 0.95,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    final navItems = ["FEMALE", "MALE", "ALL CHARACTER"];
    return Positioned(
      top: 50,
      left: 60,
      right: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(navItems.length, (index) {
              bool isSelected = _selectedNavIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedNavIndex = index),
                child: Padding(
                  padding: const EdgeInsets.only(right: 35.0),
                  child: Text(
                    navItems[index],
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.5), width: 1.5)),
            child: Icon(Icons.more_horiz,
                color: Colors.white.withOpacity(0.8), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCharacterDetails(
      double screenWidth, double screenHeight) {
    return Positioned(
      left: 60,
      top: screenHeight * 0.25,
      child: SizedBox(
        width: screenWidth * 0.35,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0.0, 0.2), end: Offset.zero)
                        .animate(animation),
                    child: child));
          },
          child: Column(
            key: ValueKey<String>(characters[_selectedCharacterIndex].name),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                characters[_selectedCharacterIndex].name,
                style: GoogleFonts.poppins(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                characters[_selectedCharacterIndex].description,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideSelectionIcons() {
    return Positioned(
      right: 60,
      top: 0,
      bottom: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(characters.length, (index) {
          final isSelected = _selectedCharacterIndex == index;
          final isTapped = _tappedIconIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _tappedIconIndex = index),
              onTapUp: (_) => setState(() => _tappedIconIndex = null),
              onTapCancel: () => setState(() => _tappedIconIndex = null),
              onTap: () => _onCharacterTapped(index),
              child: AnimatedScale(
                scale: isTapped ? 0.9 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 75 : 65,
                  height: isSelected ? 75 : 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isSelected
                            ? characters[index].highlightColor
                            : Colors.white.withOpacity(0.3),
                        width: 3),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: characters[index]
                                    .highlightColor
                                    .withOpacity(0.5),
                                blurRadius: 20.0)
                          ]
                        : [],
                  ),
                  child: ClipOval(
                      child: Image.asset(characters[index].imagePath,
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
