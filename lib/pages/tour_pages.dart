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

  TourStop(this.position, this.text);
}

class _TourPageState extends State<TourPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool showChat = true;
  int currentStopIndex = 0;

  final List<TourStop> tourStops = [
    TourStop(
      const Offset(168, 328), // Entrada principal
      'Bem-vindo à Universidade Autónoma de Lisboa. Este edifício, antes de ser adaptado a instalações universitárias, foi um palácio do século XIX. Mantém traços arquitetónicos clássicos, e a sua entrada imponente era originalmente o acesso de carruagens.',
    ),
    TourStop(
      const Offset(200, 190), // Átrio
      'Este átrio é o coração da universidade. Aqui realizam-se eventos, exposições e serve como ponto de encontro entre alunos e professores. À sua volta situam-se salas de aula e acessos a diferentes áreas da faculdade.',
    ),
    TourStop(
      const Offset(250, 95), // Estátua de Camões
      'Luís de Camões é um símbolo da cultura e da língua portuguesa. A estátua presente neste espaço representa o compromisso da universidade com o conhecimento, a literatura e a identidade nacional.',
    ),
  ];

  String get explanation => tourStops[currentStopIndex].text;

  @override
  void initState() {
    super.initState();
    _configureTts();
  }

  void _configureTts() async {
    await flutterTts.setLanguage("pt-PT");
    await flutterTts.setSpeechRate(0.5);
  }

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
      isSpeaking = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            minScale: 1.0,
            maxScale: 3.5,
            child: Stack(
              children: [
                Image.asset(
                  'assets/00_piso.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),

                // Ícones dos pontos
                ...tourStops.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stop = entry.value;
                  return Positioned(
                    left: stop.position.dx,
                    top: stop.position.dy,
                    child: Image.asset(
                      'assets/icon_camoes.png',
                      width: 30,
                      height: 30,
                      color: index == currentStopIndex
                          ? null
                          : Colors.grey.withOpacity(0.5),
                    ),
                  );
                }),

                // Seta vermelha dinâmica
                Positioned(
                  left: tourStops[currentStopIndex].position.dx,
                  top: tourStops[currentStopIndex].position.dy - 40,
                  child: const Icon(Icons.navigation, size: 40, color: Colors.red),
                ),
              ],
            ),
          ),

          // Caixa de texto (chat)
          if (showChat)
            Positioned(
              top: 50,
              right: 10,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: Text(
                  explanation,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),

          // Botão de ocultar chat
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(
                showChat ? Icons.close_fullscreen : Icons.open_in_full,
                color: Colors.black,
              ),
              tooltip: showChat ? 'Minimizar texto' : 'Mostrar texto',
              onPressed: _toggleChatVisibility,
            ),
          ),

          // Botão de áudio
          Positioned(
            top: 10,
            right: 60,
            child: IconButton(
              icon: Icon(
                isSpeaking ? Icons.volume_off : Icons.volume_up,
                color: Colors.black,
              ),
              tooltip: isSpeaking ? 'Desativar áudio' : 'Ativar áudio',
              onPressed: _toggleAudio,
            ),
          ),

          // Botão voltar
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                flutterTts.stop();
                Navigator.pop(context);
              },
            ),
          ),

          // Botão “Seguinte”
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: _goToNextStop,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Seguinte"),
            ),
          ),
        ],
      ),
    );
  }
}
