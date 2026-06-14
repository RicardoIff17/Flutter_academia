import 'package:flutter/material.dart';

// =============================================================================
// MODELOS DE DADOS
// =============================================================================

class Exercicio {
  final String nome;
  final String musculo;
  final int series;
  final String repeticoes;
  final String descanso;
  final IconData icone;
  String pesoKg;

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
  String nome;
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
// DADOS DOS TREINOS
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
