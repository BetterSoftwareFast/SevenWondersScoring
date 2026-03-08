import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final ButtonStyle wondersButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFFF8EED9), // light parchment
  foregroundColor: const Color(0xFF4A2F0B), // warm brown text
  padding: const EdgeInsets.symmetric(vertical: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: const BorderSide(
      color: Color(0xFFB8860B), // gold outline
      width: 1.2,
    ),
  ),
  elevation: 3,
  shadowColor: Colors.black.withOpacity(0.25),
  textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
);


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Remove the title to avoid redundancy
        title: null,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Themed header
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5C8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFB8860B),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emblem
                    Center(
                      child: SizedBox(
                        height: 36,
                        width: 36,
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFDAA520), // gold tint
                            BlendMode.srcIn,
                          ),
                          child: SvgPicture.asset('assets/icons/laurel.svg'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Gold accent bar
                    Container(
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDAA520),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '7 Wonders Scoring',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A2F0B),
                          ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Track your games with style',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B4E1E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                style: wondersButtonStyle,
                onPressed: () {
                  Navigator.pushNamed(context, '/new_game');
                },
                child: const Text('New Game'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                style: wondersButtonStyle,
                onPressed: () {
                  Navigator.pushNamed(context, '/previous_games');
                },
                child: const Text('Previous Games'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


