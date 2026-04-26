import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/openrouter_service.dart';
import '../providers/task_provider.dart';
import '../widgets/mic_button.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final TextEditingController _controller = TextEditingController();
  final OpenRouterService _openRouterService = OpenRouterService();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTranscript(String text) {
    setState(() {
      _controller.text = _controller.text.isEmpty 
          ? text 
          : '${_controller.text} $text';
    });
  }

  Future<void> _handleOrganize() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite ou fale algo antes de organizar.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _openRouterService.organizeTasks(text);
      final List<dynamic> aiTasks = response['tasks'];
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      for (var taskData in aiTasks) {
        taskProvider.addTask(
          taskData['title'] ?? 'Nova Tarefa',
          taskData['priority'] ?? 'media',
          taskData['category'] ?? 'pessoal',
          taskData['duration_min'] ?? 0,
        );
      }

      _controller.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sucesso! ${aiTasks.length} tarefas organizadas.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: Verifique sua chave da API ou conexão.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'O que você precisa fazer?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque no microfone para falar ou digite livremente.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 4,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'Ex: Estudar matemática por 1 hora, comprar pão e ligar para o João.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 10),
            MicButton(
              onTranscript: _handleTranscript,
              disabled: _isLoading,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleOrganize,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'Organizar com IA',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
