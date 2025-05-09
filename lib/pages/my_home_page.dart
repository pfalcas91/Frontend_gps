import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tour_pages.dart';


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Fundo claro escolhido
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Image.asset(
              'assets/logo_gps.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            Text(
              'Autónoma GPS',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0077B6), // Azul UAL
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language, color: Color(0xFF0077B6)),
            onSelected: (locale) {
              context.setLocale(locale);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: Locale('pt'), child: Text('Português')),
              PopupMenuItem(value: Locale('en'), child: Text('English')),
              PopupMenuItem(value: Locale('ru'), child: Text('Русский')),
              PopupMenuItem(value: Locale('es'), child: Text('Español')),
              PopupMenuItem(value: Locale('pl'), child: Text('Polski')),
              PopupMenuItem(value: Locale('tr'), child: Text('Türkçe')),
              PopupMenuItem(value: Locale('de'), child: Text('Deutsch')),
              PopupMenuItem(value: Locale('fr'), child: Text('Français')),
              PopupMenuItem(value: Locale('nl'), child: Text('Nederlands')),
              PopupMenuItem(value: Locale('zh'), child: Text('中文')),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'welcome'.tr(), // "Bem-vindo"
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0077B6),
                ),
              ),
              const SizedBox(height: 50),
              CustomCardButton(
                imagePath: 'assets/23077544-24a4-4680-b802-2781e6dc94ec.png', // Ícone modo navegação
                text: 'Modo Navegação'.tr(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TourPage()),
                  );
                },

              ),
              const SizedBox(height: 30),
              
                CustomCardButton(
                  imagePath: 'assets/foto_camoes.png',
                  text: 'Modo Visita'.tr(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TourPage()),
                    );
                  },
                ),


            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  const CustomCardButton({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B4D8), // Azul secundário
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
