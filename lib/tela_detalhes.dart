import 'package:flutter/material.dart';
import 'treino.dart';
import 'treino_controller.dart';

// =============================================================================
// TELA 2 — DETALHES DO TREINO (Exercícios)
// =============================================================================

/// REQUISITO: Tela 2 — exercícios com TextField, CheckBox e ElevatedButton
class TelaDetalhes extends StatefulWidget {
  final Treino treino;
  final int treinoIndex;

  const TelaDetalhes({
    super.key,
    required this.treino,
    required this.treinoIndex,
  });

  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  /// REQUISITO: TextEditingController — campos de peso (kg) de cada exercício
  late List<TextEditingController> _pesoControllers;

  /// REQUISITO: CheckBox — controla quais exercícios foram concluídos
  late List<bool> _seriesConcluidas;

  late List<Exercicio> _exercicios;
  late int _qtdOriginal;

  @override
  void initState() {
    super.initState();
    _exercicios = treinos[widget.treinoIndex].exercicios;
    _qtdOriginal = _exercicios.length;
    _pesoControllers = List.generate(
      _exercicios.length,
      (i) => TextEditingController(text: _exercicios[i].pesoKg),
    );
    _seriesConcluidas = List.generate(_exercicios.length, (_) => false);
    _carregarDados();
  }

  @override
  void dispose() {
    for (var c in _pesoControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final dados = await TreinoController.carregarExercicios(
        widget.treinoIndex, _qtdOriginal);

    final List<Exercicio> extras = dados['extras'];
    final List<String> pesos = dados['pesos'];

    setState(() {
      for (var ex in extras) {
        _exercicios.add(ex);
        _pesoControllers.add(TextEditingController());
        _seriesConcluidas.add(false);
      }
      for (int i = 0; i < pesos.length && i < _exercicios.length; i++) {
        _exercicios[i].pesoKg = pesos[i];
        _pesoControllers[i].text = pesos[i];
      }
    });
  }

  Future<void> _salvarDados() async {
    final pesos = _pesoControllers.map((c) => c.text).toList();
    await TreinoController.salvarExercicios(
        widget.treinoIndex, _exercicios, pesos, _qtdOriginal);
  }

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
          /// REQUISITO: ElevatedButton — adiciona exercício ao treino
          ElevatedButton(
            onPressed: () {
              if (nomeCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Informe o nome do exercício!')),
                );
                return;
              }
              setState(() {
                _exercicios.add(Exercicio(
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
                ));
                _pesoControllers.add(TextEditingController());
                _seriesConcluidas.add(false);
              });
              _salvarDados();
              Navigator.pop(ctx);
              /// REQUISITO: SnackBar — feedback ao adicionar exercício
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF7B2FBE),
                  duration: const Duration(seconds: 2),
                  content: Text('"${nomeCtrl.text.trim()}" adicionado!'),
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
              itemBuilder: (context, index) => _cardExercicio(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                OutlinedButton.icon(
                  onPressed: _abrirCadastroExercicio,
                  icon: const Icon(Icons.add, color: Color(0xFF7B2FBE)),
                  label: const Text('Adicionar Exercício',
                      style: TextStyle(color: Color(0xFF7B2FBE))),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Color(0xFF7B2FBE)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                /// REQUISITO: ElevatedButton — finaliza treino e exibe SnackBar
                ElevatedButton(
                  onPressed: () async {
                    await _salvarDados();
                    if (context.mounted) {
                      /// REQUISITO: SnackBar — feedback ao finalizar treino
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF7B2FBE),
                          duration: const Duration(seconds: 3),
                          content: Text(
                              '${widget.treino.nome} finalizado! Pesos salvos.'),
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

  /// COMPONENTE INÉDITO: Dismissible
  /// Permite arrastar o card para remover o exercício.
  /// NÃO aparece em nenhum código do professor.
  Widget _cardExercicio(int index) {
    final exercicio = _exercicios[index];
    final bool concluido = _seriesConcluidas[index];

    return Dismissible(
      key: Key('ex_${widget.treinoIndex}_${index}_${exercicio.nome}'),
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
            Text('Remover', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Remover exercício?'),
            content: Text('Deseja remover "${exercicio.nome}"?'),
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
            content: Text('"$nome" removido.'),
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
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: concluido
                          ? Colors.green.shade100
                          : const Color(0xFF7B2FBE).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(exercicio.icone,
                        color: concluido ? Colors.green : const Color(0xFF7B2FBE),
                        size: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercicio.nome,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: concluido ? TextDecoration.lineThrough : null,
                            color: concluido ? Colors.grey : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _infoChip(Icons.sports_gymnastics, exercicio.musculo),
                            const SizedBox(width: 8),
                            _infoChip(Icons.repeat, '${exercicio.series} séries'),
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
                  Expanded(
                    child: TextField(
                      /// REQUISITO: TextEditingController — peso (kg)
                      controller: _pesoControllers[index],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Peso (kg)',
                        prefixIcon: const Icon(Icons.monitor_weight_outlined, size: 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                      onChanged: (value) => _exercicios[index].pesoKg = value,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      /// REQUISITO: CheckBox — marca exercício como concluído
                      Checkbox(
                        value: _seriesConcluidas[index],
                        activeColor: const Color(0xFF7B2FBE),
                        onChanged: (value) {
                          setState(() => _seriesConcluidas[index] = value!);
                          if (value == true) {
                            /// REQUISITO: SnackBar — feedback ao concluir
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                                content: Text('"${exercicio.nome}" concluído!'),
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
