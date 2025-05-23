import 'package:flutter_blue/flutter_blue.dart';

class BeaconInfo {
  final String uuid;
  final int major;
  final int minor;

  BeaconInfo(this.uuid, this.major, this.minor);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeaconInfo &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid &&
          major == other.major &&
          minor == other.minor;

  @override
  int get hashCode => uuid.hashCode ^ major.hashCode ^ minor.hashCode;
}

class NavigationManager {
  final Map<BeaconInfo, String> beaconLocations = {
    BeaconInfo('fda50693-a4e2-4fb1-afcf-c6eb07647825', 10001, 19641): 'Entrada',
    BeaconInfo('fda50693-a4e2-4fb1-afcf-c6eb07647825', 10005, 19645): 'Patio',
    // adiciona os teus beacons aqui
  };

  final Map<String, Map<String, int>> mapaFaculdade = {
    'Entrada': {'Corredor1': 2},
    'Corredor1': {'Entrada': 2, 'Sala50': 3, 'Sala30': 2},
    'Sala30': {'Corredor1': 2, 'Sala50': 4},
    'Sala50': {'Corredor1': 3, 'Sala30': 4},
    'Patio': {'Entrada': 1}
  };

  final Map<List<String>, String> instrucoesPersonalizadas = {
    ['Patio', 'Entrada']: 'Vire à direita e suba as escadas.',
    ['Entrada', 'Corredor1']: 'Siga em frente pelo corredor.',
    ['Corredor1', 'Sala50']: 'Vire à esquerda para a Sala 50.',
    ['Corredor1', 'Sala30']: 'A Sala 30 está à direita.',
    ['Sala30', 'Sala50']: 'Continue em frente até à Sala 50.',
  };

  String? getLocalizacao(BeaconInfo beacon) {
    return beaconLocations[beacon];
  }

  List<String>? dijkstra(String origem, String destino) {
    final dist = <String, int>{};
    final prev = <String, String?>{};
    final nodes = mapaFaculdade.keys.toSet();
    final unvisited = Set<String>.from(nodes);

    for (var node in nodes) {
      dist[node] = node == origem ? 0 : 1 << 30;
      prev[node] = null;
    }

    while (unvisited.isNotEmpty) {
      final current = unvisited.reduce((a, b) => dist[a]! < dist[b]! ? a : b);
      if (current == destino) break;
      unvisited.remove(current);

      mapaFaculdade[current]?.forEach((neighbor, weight) {
        if (unvisited.contains(neighbor)) {
          final alt = dist[current]! + weight;
          if (alt < dist[neighbor]!) {
            dist[neighbor] = alt;
            prev[neighbor] = current;
          }
        }
      });
    }

    final path = <String>[];
String? u = destino;
while (u != null) {
  path.insert(0, u);
  u = prev[u];
}
return path.isNotEmpty && path.first == origem ? path : null;
  }

  List<String> getInstrucoes(List<String> caminho) {
    final instr = <String>[];
    for (var i = 0; i < caminho.length - 1; i++) {
      final par = [caminho[i], caminho[i + 1]];
      instr.add(instrucoesPersonalizadas[par] ?? 'Dirija-se de ${par[0]} para ${par[1]}.');
    }
    return instr;
  }

  // Exemplo simples para converter manufacturer data em BeaconInfo
  // Aqui tens que fazer a extração correta conforme o formato do teu beacon
  BeaconInfo? parseBeaconData(ScanResult result) {
    // A lógica depende do beacon - para iBeacon, precisas extrair UUID/Major/Minor do manufacturerData
    // Esta é só uma ideia genérica, tens de adaptar ao teu beacon real
    final md = result.advertisementData.manufacturerData;
    if (md.isEmpty) return null;

    // Exemplo para iBeacon (Apple) - verificar se manufacturerData tem chave 76 (Apple)
    if (!md.containsKey(76)) return null;
    final data = md[76]!;

    if (data.length < 23) return null;
    // uuid: bytes 2 a 17
    final uuidBytes = data.sublist(2, 18);
    final uuid = uuidBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    final formattedUuid =
        '${uuid.substring(0, 8)}-${uuid.substring(8, 12)}-${uuid.substring(12, 16)}-${uuid.substring(16, 20)}-${uuid.substring(20)}';

    final major = (data[18] << 8) + data[19];
    final minor = (data[20] << 8) + data[21];

    return BeaconInfo(formattedUuid, major, minor);
  }
}