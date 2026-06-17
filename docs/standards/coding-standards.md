# Padrões de Codificação (Coding Standards)

Este documento define os padrões de estilo, formatação e arquitetura de código-fonte Dart e Flutter a serem seguidos de forma estrita no desenvolvimento do **Fluxo_Audio_App**. A aderência às boas práticas de **Effective Dart** é obrigatória.

---

## 1. Convenções de Nomenclatura (Naming Conventions)

De acordo com as diretrizes oficiais de desenvolvimento em Dart:

### A. UpperCamelCase
Usado para tipos, classes, enums, mixins, types e extensões.
```dart
class TaskRepository { ... }
enum TaskPriority { high, medium, low }
```

### B. lowerCamelCase
Usado para membros de classes, métodos, variáveis, parâmetros e constantes de escopo.
```dart
final String apiEndpoint;
void updateTaskStatus(String taskId) { ... }
```

### C. lowercase_with_underscores
Usado para nomes de diretórios, pacotes, arquivos e prefixes de imports.
```dart
// Nome do arquivo: task_provider.dart
// Nome do diretório: screens/
import 'package:flutter/material.dart';
```

---

## 2. Formatação e Layout de Código

Para garantir que o código seja legível por qualquer membro da equipe, as seguintes regras são mandatórias:

* **Formatação Automática:** Todos os arquivos de código-fonte Dart devem ser formatados utilizando a ferramenta nativa do SDK.
  ```bash
  dart format .
  ```
* **Vírgulas à Direita (Trailing Commas):** O uso de vírgulas ao final de argumentos aninhados em parâmetros de widgets do Flutter é obrigatório. Isso permite que o formatador automático idente e estruture o layout em árvore de forma legível.
  ```dart
  // Correto (com trailing commas):
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Olá Mundo',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
  ```
* **Comprimento de Linha:** O limite padrão de caracteres por linha é de **80 caracteres**. Linhas que ultrapassem este limite devem ser quebradas pelo formatador automático utilizando as trailing commas adequadas.

---

## 3. Ordenação e Organização de Imports

Para evitar poluição visual e conflitos de dependências, organize a seção de importações de cada arquivo Dart na seguinte ordem, separando cada bloco por uma linha em branco:

1. **Imports de Bibliotecas Core do Dart:**
   ```dart
   import 'dart:convert';
   import 'dart:io';
   ```
2. **Imports de Pacotes Externos do Flutter/Pub (dependencies):**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:provider/provider.dart';
   ```
3. **Imports Locais do Projeto (arquivos relativos):**
   ```dart
   import '../models/task_model.dart';
   import '../services/openrouter_service.dart';
   ```

---

## 4. Boas Práticas Dart e Flutter

* **Tipagem Estática Forte:** Evite declarar variáveis usando `dynamic`. Sempre use tipos explícitos (`String`, `int`, `DateTime`, etc.) ou a inferência do compilador (`final`) sempre que possível.
* **Interpolação de Strings:** Use interpolação de strings em vez de concatenação com operador `+`.
  ```dart
  final String status = 'Concluído';
  // Correto:
  print('O status da tarefa é: $status');
  // Incorreto:
  print('O status da tarefa é: ' + status);
  ```
* **Coleções Literais:** Inicialize coleções (Listas, Sets e Mapas) de forma direta usando colchetes ou chaves literais, evitando construtores de classe.
  ```dart
  final List<String> tasks = []; // Correto
  final List<String> tasks = List<String>(); // Incorreto
  ```
* **Isolamento de Estado:** Não manipule variáveis globais diretamente. Todo o gerenciamento de dados de tarefas e estados de UI deve residir dentro das classes Provider correspondentes.