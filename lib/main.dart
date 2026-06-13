import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AcademiaApp());
}

// =============================================================================
// ROOT DO APP
// =============================================================================
class AcademiaApp extends StatelessWidget {
  const AcademiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Treinos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B2FBE),
          primary: const Color(0xFF7B2FBE),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7B2FBE),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B2FBE),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const TelaPrincipal(),
    );
  }
}

// =============================================================================
// MODELO DE DADOS
// =============================================================================

class Exercicio {
  final String nome;
  final String musculo;
  final int series;
  final String repeticoes;
  final String descanso;
  final IconData icone;
  String pesoKg; // persistido no SharedPreferences

  Exercicio({
    required this.nome,
    required this.musculo,
    required this.series,
    required this.repeticoes,
    required this.descanso,
    this.icone = Icons.fitness_center,
    this.pesoKg = '',
  });
}

class Treino {
  final String nome;
  final List<String> musculos;
  final List<Exercicio> exercicios;
  final Color cor;

  Treino({
    required this.nome,
    required this.musculos,
    required this.exercicios,
    required this.cor,
  });
}

// =============================================================================
// DADOS ESTÁTICOS DOS TREINOS (inspirados nos prints de referência)
// =============================================================================
List<Treino> treinos = [
  Treino(
    nome: 'Treino A',
    musculos: ['5. Bíceps', 'Dorsal', '4. Ombro', 'Outros', '2. Costas'],
    cor: const Color(0xFF7B2FBE),
    exercicios: [
      Exercicio(
        nome: 'Remada Articulada (Pronada)',
        musculo: '2. Costas',
        series: 3,
        repeticoes: '8-12',
        descanso: '40seg',
        icone: Icons.accessibility_new,
      ),
      Exercicio(
        nome: 'Crucifixo Inverso - Peck Deck',
        musculo: '4. Ombro',
        series: 3,
        repeticoes: '8-12',
        descanso: '40seg',
        icone: Icons.sports_gymnastics,
      ),
      Exercicio(
        nome: 'Pulley Supinado',
        musculo: 'Dorsal',
        series: 3,
        repeticoes: '12-15',
        descanso: '40seg',
        icone: Icons.arrow_downward,
      ),
      Exercicio(
        nome: 'Rosca Alternada',
        musculo: '5. Bíceps',
        series: 3,
        repeticoes: '12-15',
        descanso: '40seg',
        icone: Icons.fitness_center,
      ),
      Exercicio(
        nome: 'Bíceps Scott Unilateral',
        musculo: '5. Bíceps',
        series: 3,
        repeticoes: '8-12',
        descanso: '40seg',
        icone: Icons.fitness_center,
      ),
      Exercicio(
        nome: 'Bíceps Corda Cross',
        musculo: '5. Bíceps',
        series: 3,
        repeticoes: '8-12',
        descanso: '40seg',
        icone: Icons.sports,
      ),
    ],
  ),
  Treino(
    nome: 'Treino B',
    musculos: ['4. Ombro', '1. Peitoral', '6. Tríceps', 'Perna'],
    cor: const Color(0xFF7B2FBE),
    exercicios: [
      Exercicio(
        nome: 'Supino Reto',
        musculo: '1. Peitoral',
        series: 4,
        repeticoes: '8-10',
        descanso: '60seg',
        icone: Icons.airline_seat_flat,
      ),
      Exercicio(
        nome: 'Desenvolvimento com Halteres',
        musculo: '4. Ombro',
        series: 3,
        repeticoes: '10-12',
        descanso: '45seg',
        icone: Icons.sports_gymnastics,
      ),
      Exercicio(
        nome: 'Tríceps Pulley',
        musculo: '6. Tríceps',
        series: 3,
        repeticoes: '12-15',
        descanso: '40seg',
        icone: Icons.sports,
      ),
      Exercicio(
        nome: 'Leg Press 45°',
        musculo: 'Perna',
        series: 4,
        repeticoes: '10-12',
        descanso: '60seg',
        icone: Icons.directions_walk,
      ),
      Exercicio(
        nome: 'Elevação Lateral',
        musculo: '4. Ombro',
        series: 3,
        repeticoes: '12-15',
        descanso: '40seg',
        icone: Icons.accessibility_new,
      ),
    ],
  ),
  Treino(
    nome: 'Treino C',
    musculos: ['Coxa', '3. Pernas', 'Core', 'Posterior da coxa'],
    cor: const Color(0xFF7B2FBE),
    exercicios: [
      Exercicio(
        nome: 'Agachamento Livre',
        musculo: 'Coxa',
        series: 4,
        repeticoes: '8-12',
        descanso: '90seg',
        icone: Icons.directions_run,
      ),
      Exercicio(
        nome: 'Mesa Flexora',
        musculo: 'Posterior da coxa',
        series: 3,
        repeticoes: '10-12',
        descanso: '45seg',
        icone: Icons.airline_seat_recline_extra,
      ),
      Exercicio(
        nome: 'Cadeira Extensora',
        musculo: '3. Pernas',
        series: 3,
        repeticoes: '12-15',
        descanso: '40seg',
        icone: Icons.chair,
      ),
      Exercicio(
        nome: 'Prancha Abdominal',
        musculo: 'Core',
        series: 3,
        repeticoes: '30seg',
        descanso: '30seg',
        icone: Icons.self_improvement,
      ),
      Exercicio(
        nome: 'Abdominal Infra',
        musculo: 'Core',
        series: 3,
        repeticoes: '15-20',
        descanso: '30seg',
        icone: Icons.fitness_center,
      ),
    ],
  ),
];

// =============================================================================
// TELA 1 — HOME (Lista de Treinos)
// =============================================================================

/// REQUISITO: Tela 1 — Lista de treinos com RadioButton e navegação para Tela 2
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  /// REQUISITO: RadioButton — valor do treino "Atual" selecionado
  int? _treinoAtualIndex;

  /// REQUISITO: TextEditingController — campo do nome do usuário
  final TextEditingController _nomeCtrl = TextEditingController();
  String _nomeUsuario = '';
  bool _editandoNome = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    super.dispose();
  }

  /// REQUISITO: SharedPreferences — carrega treino atual e nome do usuário
  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _treinoAtualIndex = prefs.getInt('treinoAtual');
      _nomeUsuario = prefs.getString('nomeUsuario') ?? '';
      _nomeCtrl.text = _nomeUsuario;
    });
  }

  /// REQUISITO: SharedPreferences — salva o treino atual escolhido
  Future<void> _salvarTreinoAtual(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('treinoAtual', index);
  }

  /// REQUISITO: SharedPreferences — salva o nome do usuário
  Future<void> _salvarNome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nomeUsuario', _nomeCtrl.text.trim());
    setState(() {
      _nomeUsuario = _nomeCtrl.text.trim();
      _editandoNome = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF7B2FBE),
          duration: Duration(seconds: 2),
          content: Text('Nome salvo com sucesso!'),
        ),
      );
    }
  }

  /// Abre dialog para editar o nome do treino
  void _editarNomeTreino(int index) {
    final ctrl = TextEditingController(text: treinos[index].nome);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar nome do treino'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nome do treino',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          /// REQUISITO: ElevatedButton dentro do dialog para salvar edição
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() {
                  treinos[index] = Treino(
                    nome: ctrl.text.trim(),
                    musculos: treinos[index].musculos,
                    exercicios: treinos[index].exercicios,
                    cor: treinos[index].cor,
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF7B2FBE),
                    duration: const Duration(seconds: 2),
                    content: Text('Treino renomeado para "${ctrl.text.trim()}"!'),
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF7B2FBE),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo Treino'),
        onPressed: () => _abrirCadastroTreino(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Área do nome do usuário ──────────────────────────────────
            _editandoNome
                ? Row(
                    children: [
                      Expanded(
                        /// REQUISITO: TextEditingController — campo de nome
                        child: TextField(
                          controller: _nomeCtrl,
                          autofocus: true,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'Digite seu nome',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onSubmitted: (_) => _salvarNome(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.check_circle,
                            color: Color(0xFF7B2FBE), size: 32),
                        onPressed: _salvarNome,
                        tooltip: 'Salvar nome',
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          _nomeUsuario.isEmpty
                              ? 'Toque para inserir seu nome'
                              : 'Treino $_nomeUsuario',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: _nomeUsuario.isEmpty
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Color(0xFF7B2FBE)),
                        onPressed: () =>
                            setState(() => _editandoNome = true),
                        tooltip: 'Editar nome',
                      ),
                    ],
                  ),
            const SizedBox(height: 4),
            const Text(
              'Selecione seu treino',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            /// REQUISITO: ListView — lista de treinos com Expanded para ocupar a tela
            Expanded(
              child: ListView.builder(
                itemCount: treinos.length,
                itemBuilder: (context, index) {
                  return _cardTreino(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirCadastroTreino() {
    final nomeCtrl = TextEditingController();
    final musculoCtrl = TextEditingController();
    final List<String> musculosCadastrados = [];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Novo Treino'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo nome do treino
                /// REQUISITO: TextEditingController
                TextField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome do treino (ex: Treino D)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Grupos musculares',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Campo para adicionar músculo
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: musculoCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Ex: Peitoral',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          isDense: true,
                        ),
                        onSubmitted: (v) {
                          if (v.trim().isNotEmpty) {
                            setStateDialog(() {
                              musculosCadastrados.add(v.trim());
                              musculoCtrl.clear();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle,
                          color: Color(0xFF7B2FBE), size: 32),
                      onPressed: () {
                        if (musculoCtrl.text.trim().isNotEmpty) {
                          setStateDialog(() {
                            musculosCadastrados.add(musculoCtrl.text.trim());
                            musculoCtrl.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Lista dos músculos adicionados com chip
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: musculosCadastrados
                      .asMap()
                      .entries
                      .map(
                        (e) => Chip(
                          label: Text(e.value),
                          backgroundColor:
                              const Color(0xFF7B2FBE).withOpacity(0.15),
                          deleteIconColor: const Color(0xFF7B2FBE),
                          onDeleted: () => setStateDialog(
                              () => musculosCadastrados.removeAt(e.key)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            /// REQUISITO: ElevatedButton — confirma o cadastro do novo treino
            ElevatedButton(
              onPressed: () {
                if (nomeCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Informe o nome do treino!')),
                  );
                  return;
                }
                setState(() {
                  treinos.add(Treino(
                    nome: nomeCtrl.text.trim(),
                    musculos: musculosCadastrados.isNotEmpty
                        ? List.from(musculosCadastrados)
                        : ['Geral'],
                    exercicios: [],
                    cor: const Color(0xFF7B2FBE),
                  ));
                });
                Navigator.pop(ctx);
                /// REQUISITO: SnackBar — feedback ao cadastrar treino
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF7B2FBE),
                    duration: const Duration(seconds: 2),
                    content: Text(
                        '"${nomeCtrl.text.trim()}" cadastrado com sucesso!'),
                  ),
                );
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardTreino(int index) {
    final treino = treinos[index];
    final bool isAtual = _treinoAtualIndex == index;

    return GestureDetector(
      onTap: () {
        // Navega para Tela 2 ao clicar no card
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaDetalhesTreino(
              treino: treino,
              treinoIndex: index,
            ),
          ),
        ).then((_) => setState(() {}));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícone do treino
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B2FBE).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: const Color(0xFF7B2FBE),
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Informações do treino
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          treino.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: treino.musculos
                              .map((m) => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.sports_gymnastics,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 2),
                                      Text(m,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                    ],
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        // REQUISITO: RadioButton — marca o treino como "Atual"
                        Row(
                          children: [
                            /// REQUISITO: RadioButton
                            Radio<int>(
                              value: index,
                              groupValue: _treinoAtualIndex,
                              activeColor: const Color(0xFF7B2FBE),
                              onChanged: (value) async {
                                setState(() {
                                  _treinoAtualIndex = value;
                                });
                                await _salvarTreinoAtual(value!);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFF7B2FBE),
                                      duration: const Duration(seconds: 2),
                                      content: Text(
                                          '${treino.nome} definido como Atual!'),
                                    ),
                                  );
                                }
                              },
                            ),
                            const Text('Definir como Atual',
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Botão editar nome do treino
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Color(0xFF7B2FBE)),
                tooltip: 'Editar nome do treino',
                onPressed: () => _editarNomeTreino(index),
              ),
            ),
            // Badge "Atual"
            if (isAtual)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B2FBE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Atual',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

// =============================================================================
// TELA 2 — DETALHES DO TREINO (Exercícios)
// =============================================================================

/// REQUISITO: Tela 2 — Detalhes do treino com TextField, CheckBox e ElevatedButton
class TelaDetalhesTreino extends StatefulWidget {
  final Treino treino;
  final int treinoIndex;

  const TelaDetalhesTreino({
    super.key,
    required this.treino,
    required this.treinoIndex,
  });

  @override
  State<TelaDetalhesTreino> createState() => _TelaDetalhesTreinoState();
}

class _TelaDetalhesTreinoState extends State<TelaDetalhesTreino> {
  /// REQUISITO: TextEditingController — controla os campos de peso (kg)
  late List<TextEditingController> _pesoControllers;

  /// REQUISITO: CheckBox — controla quais séries foram concluídas
  late List<bool> _seriesConcluidas;

  // Lista de exercícios (pode ser alterada pelo Dismissible)
  late List<Exercicio> _exercicios;

  @override
  void initState() {
    super.initState();
    // Referência direta à lista global — adições e remoções persistem na sessão
    _exercicios = treinos[widget.treinoIndex].exercicios;
    _pesoControllers = List.generate(
      _exercicios.length,
      (i) => TextEditingController(text: _exercicios[i].pesoKg),
    );
    _seriesConcluidas = List.generate(_exercicios.length, (_) => false);
    _carregarPesos();
  }

  @override
  void dispose() {
    for (var c in _pesoControllers) {
      c.dispose();
    }
    super.dispose();
  }

  /// REQUISITO: SharedPreferences — carrega pesos salvos dos exercícios
  Future<void> _carregarPesos() async {
    final prefs = await SharedPreferences.getInstance();

    // Carrega exercícios extras que foram cadastrados pelo usuário
    final int qtdSalva =
        prefs.getInt('exQtd_t${widget.treinoIndex}') ?? _exercicios.length;
    final int qtdOriginal = widget.treino.exercicios.length;

    for (int i = qtdOriginal; i < qtdSalva; i++) {
      final nome = prefs.getString('exNome_t${widget.treinoIndex}_$i') ?? '';
      final musculo =
          prefs.getString('exMusculo_t${widget.treinoIndex}_$i') ?? 'Geral';
      final series =
          prefs.getInt('exSeries_t${widget.treinoIndex}_$i') ?? 3;
      final reps =
          prefs.getString('exReps_t${widget.treinoIndex}_$i') ?? '10-12';
      final descanso =
          prefs.getString('exDescanso_t${widget.treinoIndex}_$i') ?? '40seg';
      if (nome.isNotEmpty) {
        _exercicios.add(Exercicio(
          nome: nome,
          musculo: musculo,
          series: series,
          repeticoes: reps,
          descanso: descanso,
        ));
        _pesoControllers.add(TextEditingController());
        _seriesConcluidas.add(false);
      }
    }

    // Carrega pesos de todos os exercícios
    setState(() {
      for (int i = 0; i < _exercicios.length; i++) {
        final chave = 'peso_t${widget.treinoIndex}_ex$i';
        final peso = prefs.getString(chave) ?? '';
        _exercicios[i].pesoKg = peso;
        _pesoControllers[i].text = peso;
      }
    });
  }

  /// REQUISITO: SharedPreferences — salva o peso atualizado de cada exercício
  Future<void> _salvarPesos() async {
    final prefs = await SharedPreferences.getInstance();
    final int qtdOriginal = widget.treino.exercicios.length;

    // Salva pesos de todos os exercícios
    for (int i = 0; i < _exercicios.length; i++) {
      final chave = 'peso_t${widget.treinoIndex}_ex$i';
      await prefs.setString(chave, _pesoControllers[i].text);
    }

    // Salva exercícios extras cadastrados pelo usuário
    await prefs.setInt('exQtd_t${widget.treinoIndex}', _exercicios.length);
    for (int i = qtdOriginal; i < _exercicios.length; i++) {
      await prefs.setString(
          'exNome_t${widget.treinoIndex}_$i', _exercicios[i].nome);
      await prefs.setString(
          'exMusculo_t${widget.treinoIndex}_$i', _exercicios[i].musculo);
      await prefs.setInt(
          'exSeries_t${widget.treinoIndex}_$i', _exercicios[i].series);
      await prefs.setString(
          'exReps_t${widget.treinoIndex}_$i', _exercicios[i].repeticoes);
      await prefs.setString(
          'exDescanso_t${widget.treinoIndex}_$i', _exercicios[i].descanso);
    }
  }

  /// Remove exercício da lista (usado pelo Dismissible)
  void _removerExercicio(int index) {
    setState(() {
      _exercicios.removeAt(index);
      _pesoControllers.removeAt(index);
      _seriesConcluidas.removeAt(index);
    });
  }

  void _abrirCadastroExercicio() {
    final nomeCtrl = TextEditingController();
    final musculoCtrl = TextEditingController();
    final seriesCtrl = TextEditingController(text: '3');
    final repeticoesCtrl = TextEditingController(text: '10-12');
    final descansoCtrl = TextEditingController(text: '40seg');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo Exercício'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// REQUISITO: TextEditingController — campos do exercício
              TextField(
                controller: nomeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome do exercício',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: musculoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Grupo muscular',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: seriesCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Séries',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: repeticoesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Repetições',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descansoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descanso (ex: 40seg)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          /// REQUISITO: ElevatedButton — confirma o cadastro do exercício
          ElevatedButton(
            onPressed: () {
              if (nomeCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Informe o nome do exercício!')),
                );
                return;
              }
              final novoExercicio = Exercicio(
                nome: nomeCtrl.text.trim(),
                musculo: musculoCtrl.text.trim().isEmpty
                    ? 'Geral'
                    : musculoCtrl.text.trim(),
                series: int.tryParse(seriesCtrl.text) ?? 3,
                repeticoes: repeticoesCtrl.text.trim().isEmpty
                    ? '10-12'
                    : repeticoesCtrl.text.trim(),
                descanso: descansoCtrl.text.trim().isEmpty
                    ? '40seg'
                    : descansoCtrl.text.trim(),
                icone: Icons.fitness_center,
              );
              setState(() {
                _exercicios.add(novoExercicio);
                _pesoControllers.add(TextEditingController());
                _seriesConcluidas.add(false);
              });
              _salvarPesos(); // persiste imediatamente
              Navigator.pop(ctx);
              /// REQUISITO: SnackBar — feedback ao adicionar exercício
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF7B2FBE),
                  duration: const Duration(seconds: 2),
                  content: Text(
                      '"${nomeCtrl.text.trim()}" adicionado ao treino!'),
                ),
              );
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.treino.nome),
      ),
      body: Column(
        children: [
          /// REQUISITO: ListView — lista de exercícios do treino
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _exercicios.length,
              itemBuilder: (context, index) {
                return _cardExercicio(index);
              },
            ),
          ),

          // Botões de ação
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Botão adicionar exercício
                OutlinedButton.icon(
                  onPressed: _abrirCadastroExercicio,
                  icon: const Icon(Icons.add, color: Color(0xFF7B2FBE)),
                  label: const Text(
                    'Adicionar Exercício',
                    style: TextStyle(color: Color(0xFF7B2FBE)),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Color(0xFF7B2FBE)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                /// REQUISITO: ElevatedButton — finaliza o treino e exibe SnackBar
                ElevatedButton(
                  onPressed: () async {
                    await _salvarPesos();
                    if (context.mounted) {
                      /// REQUISITO: SnackBar — feedback ao finalizar o treino
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF7B2FBE),
                          duration: const Duration(seconds: 3),
                          content: Text(
                            '${widget.treino.nome} finalizado! Pesos salvos com sucesso.',
                          ),
                          action: SnackBarAction(
                            label: 'OK',
                            textColor: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Finalizar ${widget.treino.nome}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardExercicio(int index) {
    final exercicio = _exercicios[index];
    final bool concluido = _seriesConcluidas[index];

    /// COMPONENTE INÉDITO: Dismissible
    /// Permite arrastar o card para a direita para remover o exercício
    /// da sessão atual. O fundo vermelho com ícone de lixeira aparece
    /// ao arrastar, seguido de animação de remoção nativa do Flutter.
    /// Este widget NÃO aparece em nenhum código do professor.
    return Dismissible(
      key: Key('exercicio_${widget.treinoIndex}_$index\_${exercicio.nome}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text('Remover',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Remover exercício?'),
            content: Text(
                'Deseja remover "${exercicio.nome}" desta sessão de treino?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Remover',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        final nome = exercicio.nome;
        _removerExercicio(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"$nome" removido desta sessão.'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: concluido ? Colors.green.shade50 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícone do exercício
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: concluido
                          ? Colors.green.shade100
                          : const Color(0xFF7B2FBE).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      exercicio.icone,
                      color: concluido
                          ? Colors.green
                          : const Color(0xFF7B2FBE),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nome e detalhes
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercicio.nome,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: concluido
                                ? TextDecoration.lineThrough
                                : null,
                            color: concluido ? Colors.grey : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _infoChip(Icons.sports_gymnastics,
                                exercicio.musculo),
                            const SizedBox(width: 8),
                            _infoChip(
                                Icons.repeat, '${exercicio.series} séries'),
                            const SizedBox(width: 8),
                            _infoChip(Icons.swap_horiz, exercicio.repeticoes),
                            const SizedBox(width: 8),
                            _infoChip(Icons.timer, exercicio.descanso),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                children: [
                  // REQUISITO: TextField com TextEditingController — campo de peso
                  Expanded(
                    child: TextField(
                      /// REQUISITO: TextEditingController
                      controller: _pesoControllers[index],
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Peso (kg)',
                        prefixIcon: const Icon(Icons.monitor_weight_outlined,
                            size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        _exercicios[index].pesoKg = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // REQUISITO: Checkbox — marcar série como concluída
                  Column(
                    children: [
                      /// REQUISITO: CheckBox
                      Checkbox(
                        value: _seriesConcluidas[index],
                        activeColor: const Color(0xFF7B2FBE),
                        onChanged: (value) {
                          setState(() {
                            _seriesConcluidas[index] = value!;
                          });
                          if (value == true) {
                            /// REQUISITO: SnackBar — feedback ao concluir série
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                                content: Text(
                                    '"${exercicio.nome}" marcado como concluído!'),
                              ),
                            );
                          }
                        },
                      ),
                      const Text('Concluído',
                          style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        const SizedBox(width: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
