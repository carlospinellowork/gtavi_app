import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String sender;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.sender,
    required this.timestamp,
  });
}

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  String currentCharacter = 'Lucia'; // Lucia or Jason
  final TextEditingController _messageController = TextEditingController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Ei! Sou a Lucia. Se precisar de dicas sobre planejamento de roubos, fuga de Vice City ou melhores carros, pode mandar!',
      isUser: false,
      sender: 'Lucia',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  void _switchCharacter(String name) {
    if (currentCharacter == name) return;
    setState(() {
      currentCharacter = name;
      _messages.add(
        ChatMessage(
          text: name == 'Lucia'
              ? 'Lucia assumindo o rádio. O que temos para hoje?'
              : 'Jason no comando! Precisa de rotas de fuga ou dicas de armamento?',
          isUser: false,
          sender: name,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _sendMessage([String? presetText]) {
    final text = presetText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          sender: 'Você',
          timestamp: DateTime.now(),
        ),
      );
      if (presetText == null) _messageController.clear();
    });

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      String response = '';
      final lower = text.toLowerCase();

      if (lower.contains('dinheiro') || lower.contains('lucro')) {
        response = currentCharacter == 'Lucia'
            ? 'Para ganhar dinheiro rápido em Vice City, invista no Malibu Club e execute os roubos de carga no porto de Biscayne!'
            : 'Foque nos assaltos a caixas eletrônicos e roubos de superesportivos raros para revender na Sunshine Autos.';
      } else if (lower.contains('carro') || lower.contains('veiculo')) {
        response = currentCharacter == 'Lucia'
            ? 'O Grotti Cheetah e o Pegassi Ignus X são os melhores para despistar a polícia nas vias expressas!'
            : 'Recomendo a Grotti Cheetah para aceleração rápida ou a picape Vapid Sandking para fugas na lama.';
      } else if (lower.contains('mapa') || lower.contains('local')) {
        response = 'No mapa interativo do app você encontra a localização de colecionáveis, safehouses e garagens ativas em Vice City!';
      } else {
        response = currentCharacter == 'Lucia'
            ? 'Excelente pergunta! Vice City tem muitos segredos escondidos nos becos e na costa. Fique atento às dicas do feed!'
            : 'Entendido! Fique sempre atento ao nível de procurado e garanta que o carro de fuga esteja pronto.';
      }

      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            isUser: false,
            sender: currentCharacter,
            timestamp: DateTime.now(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLucia = currentCharacter == 'Lucia';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('IA Companion • $currentCharacter'),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
            color: AppColors.surfaceLight,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _switchCharacter('Lucia'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isLucia ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isLucia ? null : Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/lucia_portrait.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(Icons.person_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('LUCIA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _switchCharacter('Jason'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isLucia ? AppColors.secondary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: !isLucia ? null : Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/jason_portrait.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(Icons.directions_car_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('JASON', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Preset Chips Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip('Como ganhar dinheiro?'),
                  _buildPresetChip('Melhores carros para fuga'),
                  _buildPresetChip('Segredos de Vice City'),
                ],
              ),
            ),
          ),

          // Message List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? AppColors.primary
                            : (msg.sender == 'Lucia' ? AppColors.surfaceLight : AppColors.surface),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: msg.isUser
                              ? AppColors.primary
                              : (msg.sender == 'Lucia' ? AppColors.primary.withAlpha(100) : AppColors.secondary.withAlpha(100)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg.sender,
                                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Pergunte algo sobre Vice City...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
        backgroundColor: AppColors.surfaceLight,
        onPressed: () => _sendMessage(text),
      ),
    );
  }
}
