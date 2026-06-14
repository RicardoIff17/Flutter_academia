import 'package:shared_preferences/shared_preferences.dart';
import 'treino.dart';

// =============================================================================
// CONTROLLER — Persistência com SharedPreferences
// Padrão igual ao ContatoController do professor
// =============================================================================

class TreinoController {
  /// REQUISITO: SharedPreferences — salva o índice do treino atual
  static Future<void> salvarTreinoAtual(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('treinoAtual', index);
  }

  /// REQUISITO: SharedPreferences — carrega o índice do treino atual
  static Future<int?> carregarTreinoAtual() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('treinoAtual');
  }

  /// REQUISITO: SharedPreferences — salva o nome do usuário
  static Future<void> salvarNomeUsuario(String nome) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nomeUsuario', nome);
  }

  /// REQUISITO: SharedPreferences — carrega o nome do usuário
  static Future<String> carregarNomeUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nomeUsuario') ?? '';
  }

  /// REQUISITO: SharedPreferences — salva pesos e exercícios extras de um treino
  static Future<void> salvarExercicios(int treinoIndex, List<Exercicio> exercicios, List<String> pesos, int qtdOriginal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Salva pesos de todos os exercícios
    for (int i = 0; i < exercicios.length; i++) {
      await prefs.setString('peso_t${treinoIndex}_ex$i', pesos[i]);
    }

    // Salva exercícios extras cadastrados pelo usuário
    await prefs.setInt('exQtd_t$treinoIndex', exercicios.length);
    for (int i = qtdOriginal; i < exercicios.length; i++) {
      await prefs.setString('exNome_t${treinoIndex}_$i', exercicios[i].nome);
      await prefs.setString('exMusculo_t${treinoIndex}_$i', exercicios[i].musculo);
      await prefs.setInt('exSeries_t${treinoIndex}_$i', exercicios[i].series);
      await prefs.setString('exReps_t${treinoIndex}_$i', exercicios[i].repeticoes);
      await prefs.setString('exDescanso_t${treinoIndex}_$i', exercicios[i].descanso);
    }
  }

  /// REQUISITO: SharedPreferences — carrega pesos e exercícios extras de um treino
  static Future<Map<String, dynamic>> carregarExercicios(int treinoIndex, int qtdOriginal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final int qtdSalva = prefs.getInt('exQtd_t$treinoIndex') ?? qtdOriginal;
    List<Exercicio> extras = [];

    for (int i = qtdOriginal; i < qtdSalva; i++) {
      final nome = prefs.getString('exNome_t${treinoIndex}_$i') ?? '';
      if (nome.isNotEmpty) {
        extras.add(Exercicio(
          nome: nome,
          musculo: prefs.getString('exMusculo_t${treinoIndex}_$i') ?? 'Geral',
          series: prefs.getInt('exSeries_t${treinoIndex}_$i') ?? 3,
          repeticoes: prefs.getString('exReps_t${treinoIndex}_$i') ?? '10-12',
          descanso: prefs.getString('exDescanso_t${treinoIndex}_$i') ?? '40seg',
        ));
      }
    }

    List<String> pesos = [];
    for (int i = 0; i < qtdSalva; i++) {
      pesos.add(prefs.getString('peso_t${treinoIndex}_ex$i') ?? '');
    }

    return {'extras': extras, 'pesos': pesos};
  }
}
