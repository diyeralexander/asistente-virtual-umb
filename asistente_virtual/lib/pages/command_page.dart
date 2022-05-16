import 'package:asistente_virtual/dependency_injection/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommandPage extends ConsumerStatefulWidget {
  const CommandPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommandPageState();
}

class _CommandPageState extends ConsumerState<CommandPage> {
  @override
  Widget build(BuildContext context) {
    final assistance = ref.watch(asistanceNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ListView(
            children: const [
              ListTile(
                title: Text('Comando youtube'),
                subtitle: Text('Busca en youtube ...'),
              ),
              ListTile(
                title: Text('Comando internet'),
                subtitle: Text('Busca en internet ...'),
              ),
              ListTile(
                title: Text('Comando hora '),
                subtitle: Text('Qué hora es ...'),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(assistance.lastWords),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: assistance.isListening
                      ? const CircularProgressIndicator()
                      : assistance.isSpeaking
                          ? const FloatingActionButton(
                              heroTag: 'speakingFloatingActionButton',
                              onPressed: null,
                              child: Icon(Icons.speaker),
                            )
                          : FloatingActionButton(
                              heroTag: 'listeningFloatingActionButton',
                              onPressed: () {
                                ref
                                    .read(asistanceNotifierProvider.notifier)
                                    .start();
                              },
                              child: const Icon(Icons.mic),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
