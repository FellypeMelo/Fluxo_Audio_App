# Arquitetura de Segurança (Information Security Architecture)

Este documento especifica o modelo de segurança da informação e as diretrizes de arquitetura defensiva implementadas no **Fluxo_Audio_App**. Em conformidade com o design *local-first*, a segurança baseia-se na proteção física da sandbox do dispositivo móvel e na criptografia forte de dados em trânsito.

---

## 1. Segurança Física em Repouso (Sandbox de Armazenamento)

O aplicativo confia e apoia-se nas defesas físicas fornecidas pelos kernels dos sistemas operacionais móveis Android e iOS:
* **Isolamento de Sandbox:** O sistema operacional aloca uma conta de usuário do sistema exclusiva para o aplicativo no momento da instalação. Isso impede que qualquer outro aplicativo instalado leia, escreva ou inspecione o arquivo XML de preferências no `shared_preferences` ou os arquivos temporários do microfone.
* **Criptografia do Sistema de Arquivos (FBE):** Se o usuário final possuir um bloqueio de tela (PIN, senha ou biometria) ativo em seu celular, o sistema operacional ativa a **Criptografia Baseada em Arquivos (File-Based Encryption - FBE)**, protegendo as tarefas salvas fisicamente contra roubos de hardware com extração direta de chip de memória.

---

## 2. Segurança em Trânsito (Transport Layer Security)

Toda comunicação com a nuvem externa do OpenRouter adota protocolos seguros de trânsito:
* **Protocolo HTTPS Estrito:** O aplicativo bloqueia requisições HTTP em texto claro (porta 80). Todas as conexões utilizam o protocolo criptografado TLS (porta 443).
* **Prevenção contra Man-in-the-Middle (MitM):** O Flutter Engine valida os certificados de autoridade (CA) do servidor OpenRouter de forma automática utilizando a base de certificados confiáveis do sistema móvel, impedindo a interceptação de payloads em redes Wi-Fi públicas inseguras.

---

## 3. Diretrizes de Custódia de Tokens e Credenciais

A proteção da chave de API do OpenRouter do usuário final opera sob regras restritas de custódia técnica:
* **Armazenamento Privado:** A chave reside unicamente na base do SharedPreferences local do aplicativo na sandbox, sem replicação remota externa.
* **Higienização de Logs:** Como detalhado em `observability.md`, o aplicativo higieniza e bloqueia logs verbose em produção, de forma que a chave nunca seja registrada nos logs globais do sistema móvel (visíveis via `logcat` no Android ou `syslog` no iOS).
* **Ofuscação de Código:** A compilação em modo release aplica a ofuscação do Dart AOT, de forma que as instruções lógicas do parser do JSON e da injeção do Bearer Token fiquem camufladas no código compilado nativo, elevando o custo de engenharia reversa por hackers.