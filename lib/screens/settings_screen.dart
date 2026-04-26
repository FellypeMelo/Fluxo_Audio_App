import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    _nameController = TextEditingController(text: taskProvider.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _confirmClearData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Tudo'),
        content: const Text('Isso apagará permanentemente todas as suas tarefas e histórico. Tem certeza?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).clearAllData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todos os dados foram removidos.')),
              );
            },
            child: const Text('Sim, Apagar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('PERFIL'),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Seu nome',
                ),
                onChanged: (val) => taskProvider.setUsername(val),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('APARÊNCIA'),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Modo Escuro'),
              value: taskProvider.isDarkMode,
              onChanged: (bool value) => taskProvider.setDarkMode(value),
              activeColor: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('DADOS'),
          Card(
            elevation: 0,
            color: theme.colorScheme.errorContainer.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              title: Text('Limpar Todos os Dados', style: TextStyle(color: theme.colorScheme.error)),
              onTap: _confirmClearData,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Text(
                  'Fluxo v1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Desenvolvido para Projeto Escolar',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.grey,
        ),
      ),
    );
  }
}
