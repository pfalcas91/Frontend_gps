import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  State<TourPage> createState() => _TourPageState();
}

class TourStop {
  final Offset position;
  final String text;
  final String floor;

  TourStop(this.position, this.text, this.floor);
}

class _TourPageState extends State<TourPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool showChat = true;
  int currentStopIndex = 0;
  String selectedFloor = 'piso0';

  final List<TourStop> tourStops = [
    // PISO 0
    TourStop(const Offset(168, 328), 'Construído no século XVII pelo Conde de Redondo...', 'piso0'),
    TourStop(const Offset(190, 250), 'A Sala dos Atos é o local institucional dos grandes atos...', 'piso0'),
    TourStop(const Offset(200, 190), 'O portal do palácio abre para uma larga passagem...', 'piso0'),
    TourStop(const Offset(250, 95), 'O busto de Luís de Camões, em bronze, é do Mestre Escultor Joaquim Correia...', 'piso0'),
    TourStop(const Offset(130, 300), 'Ponto de informação sobre salas e docentes.', 'piso0'),
    TourStop(const Offset(300, 280), 'Esta sala tem parte das paredes forradas a azulejos... Aqui funciona o Gabinete Erasmus.', 'piso0'),

    // PISO 1
    TourStop(const Offset(420, 180), 'Estrutura de apoio a professores e estudantes...', 'piso1'),
    TourStop(const Offset(185, 460), 'O Centro de Informática dá suporte às atividades académicas...', 'piso1'),
    TourStop(const Offset(260, 340), 'Gabinete para a Inclusão e Resiliência Universitária...', 'piso1'),
    TourStop(const Offset(230, 420), 'A Associação de Estudantes representa os alunos...', 'piso1'),

    // PISO -1
    TourStop(const Offset(310, 510), 'Para aquisição de livros e materiais didáticos... (Press Center)', 'piso-1'),
    TourStop(const Offset(150, 340), 'Refeições com uma ementa variada. O bar é um ponto de encontro perfeito para relaxar...', 'piso-1'),
  ];

  String get explanation => tourStops[currentStopIndex].text;
  String get currentFloor => tourStops[currentStopIndex].floor;

  void _toggleAudio() async {
    if (isSpeaking) {
      await flutterTts.stop();
    } else {
      await flutterTts.speak(explanation);
    }
    setState(() {
      isSpeaking = !isSpeaking;
    });
  }

  void _toggleChatVisibility() {
    setState(() {
      showChat = !showChat;
    });
  }

  void _goToNextStop() {
    flutterTts.stop();
    setState(() {
      currentStopIndex = (currentStopIndex + 1) % tourStops.length;
      selectedFloor = tourStops[currentStopIndex].floor;
      isSpeaking = false;
    });
  }

  String _getMapImage() {
    switch (selectedFloor) {
      case 'piso1':
        return 'assets/01_piso-1.png';
      case 'piso-1':
        return 'assets/01_piso.png';
      default:
        return 'assets/00_piso.png';
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStop = tourStops[currentStopIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.75,
                child: Stack(
                  children: [
                    Image.asset(
                      _getMapImage(),
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    if (currentStop.floor == selectedFloor)
                      Positioned(
                        left: currentStop.position.dx,
                        top: currentStop.position.dy - 20,
                        child: const Icon(Icons.navigation,
                            size: 30, color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
            if (showChat)
              Positioned(
                top: 30,
                right: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 6)
                    ],
                  ),
                  child: Text(
                    explanation,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            Positioned(
              top: 10,
              right: 60,
              child: IconButton(
                icon: Icon(
                  isSpeaking ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                ),
                onPressed: _toggleAudio,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  showChat ? Icons.close_fullscreen : Icons.open_in_full,
                  color: Colors.white,
                ),
                onPressed: _toggleChatVisibility,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  flutterTts.stop();
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: _goToNextStop,
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Seguinte"),
              ),
            ),

            // Botão de seleção de piso (dropdown)
            Positioned(
              top: 10,
              left: MediaQuery.of(context).size.width / 2 - 60,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedFloor,
                    items: const [
                      DropdownMenuItem(value: 'piso0', child: Text('Piso 0')),
                      DropdownMenuItem(value: 'piso1', child: Text('Piso 1')),
                      DropdownMenuItem(value: 'piso-1', child: Text('Piso -1')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedFloor = value;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
