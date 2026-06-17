# Documentação Detalhada: `main.dart`

O arquivo `main.dart` é o ponto de entrada principal (entrypoint) do aplicativo Flutter. Ele é responsável por inicializar dependências globais, configurar injeção de dependência e definir o tema do aplicativo.

## Explicação Linha a Linha

```dart
// Importa o framework Material Design nativo do Flutter para construção da UI.
import 'package:flutter/material.dart';

// Importa o pacote Provider, utilizado para gerenciamento de estado da aplicação.
import 'package:provider/provider.dart';

// Importa a formatação de datas do pacote intl (necessário para Pt-BR no calendário).
import 'package:intl/date_symbol_data_local.dart';

// Importa o leitor de variáveis de ambiente (.env) para carregar chaves de API com segurança.
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Importações dos módulos internos do projeto (constantes, estado e telas).
import 'constants/colors.dart';
import 'providers/task_provider.dart';
import 'screens/main_screen.dart';

// Função principal, executada assincronamente devido às inicializações do Flutter.
void main() async {
  // Garante que a ponte (binding) entre o framework Flutter e o motor em C++ esteja inicializada.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa a formatação de datas no padrão pt_BR para exibição nos cards.
  await initializeDateFormatting('pt_BR', null);
  
  // Carrega as variáveis de ambiente do arquivo .env (ex: OPENROUTER_API_KEY).
  await dotenv.load(fileName: ".env");
  
  // Inicia o loop do framework do aplicativo passando o widget raiz (FluxoRoot).
  runApp(const FluxoRoot());
}

// Widget Raiz que não possui estado próprio (StatelessWidget).
class FluxoRoot extends StatelessWidget {
  const FluxoRoot({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider permite instanciar múltiplos provedores de estado na raiz da árvore de widgets.
    return MultiProvider(
      providers: [
        // Instancia o TaskProvider globalmente para que qualquer widget possa escutar suas mudanças.
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      // O widget filho passa a ter acesso ao estado gerado pelo MultiProvider.
      child: const FluxoApp(),
    );
  }
}

// Widget de configuração do MaterialApp (Rotas, Temas e Configurações globais).
class FluxoApp extends StatelessWidget {
  const FluxoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta ativamente as mudanças do TaskProvider (como a troca de tema para modo escuro).
    final taskProvider = Provider.of<TaskProvider>(context);

    // O MaterialApp é o widget que encapsula uma aplicação Material Design.
    return MaterialApp(
      title: 'Fluxo', // Nome do app (usado no gerenciador de tarefas do SO).
      debugShowCheckedModeBanner: false, // Esconde a faixa de "DEBUG" no canto superior direito.
      
      // Definição do tema claro (Light Mode).
      theme: ThemeData(
        useMaterial3: true, // Habilita os novos componentes visuais do Material 3.
        // Cria um esquema de cores a partir da cor raiz (deepBlue).
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.deepBlue,
          primary: AppColors.deepBlue,
          secondary: AppColors.brightBlue,
          surface: AppColors.white,
          brightness: Brightness.light,
        ),
        // Customização global para a AppBar.
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.deepBlue,
          elevation: 0, // Remove a sombra padrão da barra.
        ),
      ),
      
      // Definição do tema escuro (Dark Mode).
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.brightBlue,
          primary: AppColors.brightBlue,
          secondary: AppColors.accentDark,
          surface: AppColors.backgroundDark,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
      ),
      
      // Controla dinamicamente qual tema deve ser usado com base na variável isDarkMode do provedor.
      themeMode: taskProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Define a MainScreen (com a Bottom Navigation Bar) como a tela principal do app.
      home: const MainScreen(),
    );
  }
}
```
