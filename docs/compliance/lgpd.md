# Conformidade com a LGPD (Lei Geral de Proteção de Dados)

Este documento especifica as medidas de conformidade e privacidade implementadas no **Fluxo_Audio_App** para atender às diretrizes da Lei Geral de Proteção de Dados Pessoais do Brasil (**LGPD - Lei nº 13.709/2018**).

---

## 1. Agentes de Tratamento de Dados (Artigo 5º, IX)

A LGPD define agentes de tratamento cujos papéis se enquadram na arquitetura da aplicação da seguinte forma:

* **Controlador (Artigo 5º, VI):** O **Usuário Final** é o controlador absoluto de seus dados pessoais. Ele decide quais informações deseja gravar por voz ou digitar, e os dados resultantes permanecem armazenados unicamente no seu dispositivo físico local, sem transmissão para servidores do mantenedor do app.
* **Operador (Artigo 5º, VII):** A API do **OpenRouter** atua como operador no processamento de dados sob demanda. O aplicativo despacha as strings de texto das tarefas para a API para realizar o enriquecimento semântico. Os termos de serviço da OpenRouter garantem o processamento seguro em trânsito com criptografia HTTPS TLS.

---

## 2. Bases Legais para Tratamento (Artigo 7º)

O aplicativo apoia o processamento de áudio e texto nas seguintes hipóteses legais autorizadas pela LGPD:

1. **Consentimento do Titular (Artigo 7º, I):** Obtido de forma clara no momento em que o usuário aceita conceder permissão de acesso ao microfone ao aplicativo via pop-up do sistema operacional Android ou iOS.
2. **Execução de Contrato ou Procedimentos Preliminares (Artigo 7º, V):** O envio das transcrições de voz à API externa é necessário para a execução dos serviços de estruturação de tarefas solicitados diretamente pelo usuário final.

---

## 3. Direitos do Titular dos Dados (Artigo 18)

O **Fluxo_Audio_App** viabiliza o exercício pleno dos direitos de privacidade previstos no Artigo 18 da LGPD por meio de ferramentas nativas na interface do usuário:

* **I. Confirmação da existência de tratamento e II. Acesso aos dados:** O usuário pode visualizar a totalidade de seus dados de tarefas na tela inicial do aplicativo em tempo real.
* **III. Correção de dados incompletos, inexatos ou desatualizados:** O usuário pode tocar em qualquer card de tarefa para abrir o editor manual e realizar as retificações necessárias imediatamente.
* **IV. Anonimização, bloqueio ou eliminação de dados desnecessários/excessivos:**
  * O aplicativo pratica a minimização de dados, não coletando dados demográficos, telemetria identificada ou IDs de hardware.
  * O áudio do usuário é mantido em memória temporária apenas pelo tempo da transcrição, sendo eliminado imediatamente em seguida, garantindo a exclusão de dados de voz brutos.
* **VI. Eliminação dos dados pessoais tratados com o consentimento do titular:** Ao excluir tarefas (via swipe lateral) ou ao selecionar a opção "Limpar Dados do Aplicativo" no menu de configurações do Android/iOS, todos os dados de tarefas e chaves de API são excluídos permanentemente da memória do dispositivo físico, sem possibilidade de recuperação.