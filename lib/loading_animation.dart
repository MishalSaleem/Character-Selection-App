import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final Character character;

  const CharacterDetailsScreen({
    Key? key,
    required this.character,
  }) : super(key: key);

  @override
  _CharacterDetailsScreenState createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.character.bgColor,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      widget.character.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white54,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            widget.character.bgColor.withOpacity(0.7),
                            widget.character.bgColor,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    widget.character.name,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: widget.character.accentColor.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.character.title,
                    style: TextStyle(
                      fontSize: 24,
                      color: widget.character.accentColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    widget.character.description,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    'CHARACTER STATS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.character.accentColor,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildStatBar('Strength', 0.8, widget.character.accentColor),
                  _buildStatBar('Agility', 0.9, widget.character.accentColor),
                  _buildStatBar(
                      'Intelligence', 0.7, widget.character.accentColor),
                  _buildStatBar(
                      'Tech Affinity', 0.95, widget.character.accentColor),

                  const SizedBox(height: 40),

                  Text(
                    'SPECIAL ABILITIES',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.character.accentColor,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Ability Cards
                  _buildAbilityCard(
                    'Adaptive Learning',
                    'Real-time analysis of combat situations to improve tactics and effectiveness.',
                    widget.character.accentColor,
                  ),

                  const SizedBox(height: 16),

                  _buildAbilityCard(
                    'Neural Interface',
                    'Direct connection to digital systems through neural implants.',
                    widget.character.accentColor,
                  ),

                  const SizedBox(height: 40),

                  // Select Button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        Navigator.of(context).pop();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 16),
                        decoration: BoxDecoration(
                          color: widget.character.accentColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  widget.character.accentColor.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Text(
                          'SELECT CHARACTER',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilityCard(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class Character {
  final String name;
  final String title;
  final String description;
  final String image;
  final Color bgColor;
  final Color accentColor;

  Character({
    required this.name,
    required this.title,
    required this.description,
    required this.image,
    required this.bgColor,
    required this.accentColor,
  });
}
