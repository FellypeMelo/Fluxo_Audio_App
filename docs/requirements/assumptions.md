# Premissas do Projeto (Assumptions)

Este documento detalha as premissas fundamentais estabelecidas para o desenvolvimento, execução e implantação do **Fluxo_Audio_App**. Estas premissas servem como base para as decisões de arquitetura de software, design de interface e planejamento de capacidade.

---

## 1. Premissas de Hardware e Dispositivo Móvel

Para que o aplicativo funcione conforme projetado, assume-se que o dispositivo de execução do usuário atenda aos seguintes requisitos de hardware:
* **Microfone Operacional:** O dispositivo do usuário final possui um microfone integrado ou conectado (via cabo ou Bluetooth) em perfeito estado físico e operacional.
* **Capacidade de Processamento de Áudio:** O processamento inicial de áudio digital (gravação e empacotamento) é suportado nativamente pelo hardware do dispositivo, sem latências severas que causem distorção na amostragem.
* **Resolução e Tela:** O dispositivo atende a padrões modernos de tela (resolução mínima de 360x640 logical pixels) com suporte à renderização de layouts responsivos em formato retrato (portrait).

## 2. Premissas de Sistema Operacional e Software Nativo

A arquitetura do **Fluxo_Audio_App** apoia-se em APIs nativas de Speech-to-Text (STT) integradas pelo sistema operacional:
* **Serviços de Reconhecimento de Voz:**
  * No **Android**, assume-se que os *Google Play Services* ou os *Google Voice Services* estão instalados, ativos e atualizados, fornecendo suporte à transcrição em segundo plano.
  * No **iOS**, assume-se que a API nativa `SFSpeechRecognizer` está disponível e possui as permissões necessárias configuradas no arquivo `Info.plist`.
* **Disponibilidade de Idioma Local:** O dicionário e o modelo de processamento de linguagem natural nativo para o idioma **Português (Brasil) - pt_BR** estão instalados localmente no dispositivo (offline) ou são acessíveis via serviço em nuvem padrão do sistema operacional.
* **Suporte de SDK Mínimo:** A base de código assume compatibilidade com Android API level 21 (Lollipop) ou superior, e iOS 12.0 ou superior.

## 3. Premissas de Conectividade de Rede e Serviços Externos

Embora o aplicativo adote uma filosofia *local-first* para o armazenamento de tarefas, a inteligência artificial para estruturação semântica depende da nuvem:
* **Conexão com a Internet:** Para realizar a extração e estruturação de tarefas, o dispositivo deve possuir conectividade ativa (via rede de dados celular 3G/4G/5G ou Wi-Fi) estável o suficiente para realizar requisições HTTPS (porta 443) com timeout superior a 15 segundos.
* **Acessibilidade do Endpoint OpenRouter:** O endpoint da API do `OpenRouter` (`https://openrouter.ai/api/v1/chat/completions`) é acessível e não é bloqueado por restrições geográficas, firewalls de rede corporativos, proxies ou regras de ISP locais.
* **Disponibilidade do Modelo:** Assume-se que o modelo de processamento semântico (como `meta-llama/llama-3.2-3b-instruct` ou similar configurado no código) esteja disponível e operacional no catálogo do OpenRouter.

## 4. Premissas de Credenciais e Faturamento da API

O ciclo de chamadas ao modelo de inteligência artificial generativa pressupõe a existência de credenciais ativas:
* **Validade da API Key:** O token de autenticação (Bearer Token) da API do OpenRouter configurado internamente ou fornecido pelo usuário está ativo, é válido e possui saldo financeiro em créditos de tokens suficiente para a requisição de novos comandos.
* **Sem Limitação de Quotas Severas:** Assume-se que o limite de requisições por minuto (RPM) e requisições por dia (RPD) associado à chave de API seja compatível com a taxa média de uso de um usuário individual (cerca de 5 a 10 requisições por hora).

## 5. Premissas de Segurança e Ciclo de Vida de Dados

Considerando que o aplicativo lida com dados pessoais e anotações diárias:
* **Concessão de Permissões pelo Usuário:** O usuário aceita e concede as permissões de acesso ao microfone (`RECORD_AUDIO`) nas telas de consentimento do sistema operacional.
* **Isolamento de Sandbox:** O sistema operacional móvel garante o isolamento seguro da sandbox do aplicativo, impedindo que outros apps instalados leiam os arquivos de preferências locais (`SharedPreferences` / XML de configuração) onde as chaves e dados de tarefas são salvos.
* **Envio Consensual para a Nuvem:** O usuário compreende que, embora as tarefas sejam salvas localmente, o texto gerado por sua voz ou entrada escrita é transmitido para os servidores da API do OpenRouter para fins de enriquecimento e inteligência semântica.