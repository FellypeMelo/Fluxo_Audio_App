# Política de Retenção de Dados (Data Retention Policy)

Este documento define a política de retenção e descarte de dados do **Fluxo_Audio_App**. Ele estabelece os períodos máximos de armazenamento permitidos para cada categoria de informação tratada pela aplicação, em conformidade com as diretrizes de proteção de dados (LGPD e GDPR).

---

## 1. Tabela de Prazos de Retenção de Dados

O aplicativo pratica a minimização de armazenamento de dados pessoais, limitando a custódia das informações estritamente ao tempo necessário para o cumprimento das finalidades operacionais:

| Categoria de Dado | Tipo de Retenção | Período de Retenção | Mecanismo de Descarte |
| :--- | :--- | :--- | :--- |
| **Áudio (Gravação de voz)** | Volátil / Efêmero | **Imediato (Retenção Zero)** | Exclusão do buffer de gravação e liberação imediata do arquivo de cache temporário após a transcrição do texto correspondente. |
| **Texto Bruto Digitado/Transcrito** | Volátil / Temporário | Durabilidade da sessão de envio (segundos) | Limpeza da variável de memória RAM após o parsing da IA do OpenRouter ou criação da tarefa de fallback. |
| **Tarefas e Metas Persistidas** | Permanente (Custódia do Usuário) | Indefinido (até ação explícita) | Operação de exclusão física efetuada diretamente pelo usuário final via interface (gesto swipe de remoção). |
| **Chaves de API do OpenRouter** | Permanente (Configurações) | Indefinido (até redefinição) | Sobrescrita direta da chave ou exclusão manual nas configurações do aplicativo. |
| **Erros e Logs Técnicos** | Temporário (Cache de Execução) | Ciclo de execução da sessão móvel | Limpeza automática efetuada pelo sistema operacional ao encerrar o aplicativo na RAM do dispositivo. |

---

## 2. Detalhes das Operações de Descarte Seguro

### A. Descarte do Arquivo de Áudio
Para garantir que as gravações de voz brutas não se acumulem no armazenamento local do dispositivo, o fluxo de Speech-to-Text em [capture_screen.dart](file:///G:/Programas/Fluxo_Audio_App/lib/screens/capture_screen.dart):
1. Inicia o motor STT nativo escrevendo a amostragem em buffer de memória.
2. Finaliza a gravação convertendo os buffers locais em texto String.
3. Invoca coletores de lixo (Garbage Collector do Dart) para desalocar imediatamente buffers de áudio criados na memória RAM.
4. Garante que nenhum arquivo de áudio compactado (ex: `.wav`, `.mp3` ou `.aac`) seja salvo de forma intencional no disco rígido do dispositivo.

### B. Descarte e Exclusão Irreversível de Tarefas
Quando o usuário desliza o card da tarefa para a esquerda e confirma a exclusão (ou clica no botão excluir no editor):
1. O `TaskProvider` remove o objeto da lista de dados ativa na RAM.
2. O `TaskProvider` converte a lista restante de tarefas em uma string de array JSON.
3. A nova string JSON higienizada sobrescreve integralmente o arquivo XML/JSON local de preferências mantido pelo `SharedPreferences`.
4. Os dados apagados são fisicamente desvinculados do mapeamento de chaves do sistema de arquivos do dispositivo, não restando backups ocultos mantidos pelo aplicativo.