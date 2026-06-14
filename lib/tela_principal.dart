import 'package:flutter/material.dart';
import 'treino.dart';
import 'treino_controller.dart';
import 'tela_detalhes.dart';

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
  /// REQUISITO: RadioButton — índice do treino marcado como "Atual"
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

  Future<void> _carregarDados() async {
    final index = await TreinoController.carregarTreinoAtual();
    final nome = await TreinoController.carregarNomeUsuario();
    setState(() {
      _treinoAtualIndex = index;
      _nomeUsuario = nome;
      _nomeCtrl.text = nome;
    });
  }

  Future<void> _salvarNome() async {
    await TreinoController.salvarNomeUsuario(_nomeCtrl.text.trim());
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
          /// REQUISITO: ElevatedButton — salva o novo nome do treino
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() => treinos[index].nome = ctrl.text.trim());
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
                /// REQUISITO: TextEditingController — nome do treino
                TextField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome do treino (ex: Treino D)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Grupos musculares',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
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
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: musculosCadastrados
                      .asMap()
                      .entries
                      .map((e) => Chip(
                            label: Text(e.value),
                            backgroundColor:
                                const Color(0xFF7B2FBE).withOpacity(0.15),
                            deleteIconColor: const Color(0xFF7B2FBE),
                            onDeleted: () => setStateDialog(
                                () => musculosCadastrados.removeAt(e.key)),
                          ))
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
            /// REQUISITO: ElevatedButton — cadastra novo treino
            ElevatedButton(
              onPressed: () {
                if (nomeCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Informe o nome do treino!')),
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
                    content: Text('"${nomeCtrl.text.trim()}" cadastrado!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinos'),
        actions: [
          IconButton(icon: const Icon(Icons.assignment), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF7B2FBE),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo Treino'),
        onPressed: _abrirCadastroTreino,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _editandoNome ? _campoEditarNome() : _cabecalhoNome(),
            const SizedBox(height: 4),
            const Text('Selecione seu treino',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),

            /// REQUISITO: ListView — lista de treinos
            Expanded(
              child: ListView.builder(
                itemCount: treinos.length,
                itemBuilder: (context, index) => _cardTreino(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cabecalhoNome() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _nomeUsuario.isEmpty ? 'Toque para inserir seu nome' : 'Treino $_nomeUsuario',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: _nomeUsuario.isEmpty ? Colors.grey : Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Color(0xFF7B2FBE)),
          onPressed: () => setState(() => _editandoNome = true),
          tooltip: 'Editar nome',
        ),
      ],
    );
  }

  Widget _campoEditarNome() {
    return Row(
      children: [
        Expanded(
          /// REQUISITO: TextEditingController — campo de nome do usuário
          child: TextField(
            controller: _nomeCtrl,
            autofocus: true,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: 'Digite seu nome',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onSubmitted: (_) => _salvarNome(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.check_circle, color: Color(0xFF7B2FBE), size: 32),
          onPressed: _salvarNome,
          tooltip: 'Salvar nome',
        ),
      ],
    );
  }

  Widget _cardTreino(int index) {
    final treino = treinos[index];
    final bool isAtual = _treinoAtualIndex == index;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaDetalhes(
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
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B2FBE).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.fitness_center,
                        color: Color(0xFF7B2FBE), size: 36),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(treino.nome,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
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
                                              fontSize: 12, color: Colors.grey)),
                                    ],
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            /// REQUISITO: RadioButton — marca treino como Atual
                            Radio<int>(
                              value: index,
                              groupValue: _treinoAtualIndex,
                              activeColor: const Color(0xFF7B2FBE),
                              onChanged: (value) async {
                                setState(() => _treinoAtualIndex = value);
                                await TreinoController.salvarTreinoAtual(value!);
                                if (context.mounted) {
                                  /// REQUISITO: SnackBar — feedback ao marcar treino
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFF7B2FBE),
                                      duration: const Duration(seconds: 2),
                                      content: Text('${treino.nome} definido como Atual!'),
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
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Color(0xFF7B2FBE)),
                tooltip: 'Editar nome do treino',
                onPressed: () => _editarNomeTreino(index),
              ),
            ),
            if (isAtual)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B2FBE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Atual',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
