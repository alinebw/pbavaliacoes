# pbavaliacoes - Documentação do Banco de Dados

## Visão Geral

Este banco de dados é projetado para se conectar com sistemas externos, permitindo a sincronização de dados essenciais, como informações de clientes e projetos. A integração utiliza webhooks para receber dados em tempo real de formulários e procedures (a serem desenvolvidas) para atualizar e enviar métricas de avaliação a outros sistemas, garantindo consistência e automação no fluxo de dados.

## Estrutura do Banco de Dados

### Tabelas e Relacionamentos
#### 1. business_unities
- **Descrição:** Armazena as unidades de negócio (Business Units).
- **Campos:** 
    - id_bu (INT, PK): Identificador único da unidade de negócio. Referenciado do sistema_db via procedure
    - nome_bu (VARCHAR(100), NOT NULL): Nome da unidade de negócio. Referenciado do sistema_db via procedure
    - csat_bu (DECIMAL(5,2), DEFAULT NULL): Média CSAT da unidade de negócio
    - perc_promotores (DECIMAL(5,2)): Porcentagem de promotores
    - perc_neutros (DECIMAL(5,2)): Porcentagem de neutros
    - perc_detratores (DECIMAL(5,2)): Porcentagem de detratores
      
#### 2. clientes

- **Descrição:** Armazena informações dos clientes.
- **Campos:**
    - id_cliente (INT, PK): Identificador único do cliente. Referenciado do sistema_db via procedure
    - nome_cliente (VARCHAR(100), NOT NULL): Nome do cliente. Referenciado do sistema_db via procedure
    - nome_bu (VARCHAR(255), FK, NOT NULL): Chave estrangeira referenciando business_unities(nome_bu)
    - csat_cliente (DECIMAL(5,2), DEFAULT NULL): Média CSAT do cliente
    - perc_promotores (DECIMAL(5,2)): Porcentagem de promotores
    - perc_neutros (DECIMAL(5,2)): Porcentagem de neutros
    - perc_detratores (DECIMAL(5,2)): Porcentagem de detratores
      
#### 3. projetos

- **Descrição:** Contém dados dos projetos.
- **Campos:**
    - id_projeto (INT, PK): Identificador único do projeto. Referenciado do sistema_db via procedure
    - nome_projeto (VARCHAR(100), NOT NULL): Nome do projeto. Referenciado do sistema_db via procedure
    - nome_bu (VARCHAR(255), FK): Referência a business_unities(nome_bu)
    - csat_projeto (DECIMAL(5,2), DEFAULT NULL): Média CSAT do projeto
    - perc_promotores (DECIMAL(5,2)): Porcentagem de promotores
    - perc_neutros (DECIMAL(5,2)): Porcentagem de neutros
    - perc_detratores (DECIMAL(5,2)): Porcentagem de detratores
      
#### 4. clientes_projetos

- **Descrição:** Tabela associativa para o relacionamento muitos-para-muitos entre clientes e projetos.
- **Campos:**
    - id_cliente (INT, PK, FK): Chave estrangeira referenciando clientes(id_cliente)
    - id_projeto (INT, PK, FK): Chave estrangeira referenciando projetos(id_projeto)

#### 5. checklists

- **Descrição:** Armazena informações de checklists (turmas)
- **Campos:**
    - id_checklist (INT, PK): Identificador único do checklist. Recebe campo oculto do payload webhook
    - nome_checklist (VARCHAR(100), NOT NULL): Nome do checklist. Referenciado do sistema_db via procedure
    - id_projeto (INT, FK, NOT NULL): Chave estrangeira referenciando projetos(id_projeto)
    - csat_checklist (DECIMAL(5,2), DEFAULT NULL): Média CSAT do checklist
    - total_entregaveis (INT, DEFAULT 0): Total de entregáveis recebidos
    - perc_promotores (DECIMAL(5,2)): Porcentagem de promotores
    - perc_neutros (DECIMAL(5,2)): Porcentagem de neutros
    - perc_detratores (DECIMAL(5,2)): Porcentagem de detratores

#### 6. avaliacoes

- **Descrição:** Contém os diferentes tipos de avaliações.
- **Campos:**
    - id_avaliacao (INT, PK): Identificador único da avaliação. Gerado antes da aplicação do formulário. Recebe campo oculto do payload webhook
    - id_checklist (INT, FK, NOT NULL): Chave estrangeira referenciando checklists(id_checklists)
    - data_avaliacao (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Data da avaliação
    - tipo_avaliacao (VARCHAR(50), NOT NULL): Tipo de avaliação (e.g., 'CSAT', 'NPS')
    - total_entregaveis (INT, DEFAULT 0): Total de entregáveis recebidos
    - total_participantes (INT, DEFAULT 0): Total de participantes (preenchido manualmente)
    - status ENUM('Backlog', 'Em andamento', 'Encerrada') DEFAULT 'Backlog'
    - id_avaliacao (PK, INT): Identificador único da avaliação
    - csat_avaliacao (DECIMAL(5,2), DEFAULT NULL): Média CSAT da avaliação
    - csat_conteudo (DECIMAL(5,2)): CSAT médio do conteúdo
    - csat_consultor (DECIMAL(5,2)): CSAT médio do consultor
    - csat_evento (DECIMAL(5,2)): CSAT médio do evento
    - nps_avaliacao (DECIMAL(5,2)): NPS calculado para a avaliação
    - perc_promotores (DECIMAL(5,2)): Porcentagem de promotores
    - perc_neutros (DECIMAL(5,2)): Porcentagem de neutros
    - perc_detratores (DECIMAL(5,2)): Porcentagem de detratores


#### 7. entregaveis

- **Descrição:** Registra os formulários preenchidos (entregáveis).
- **Campos:**
    - id_entregavel (PK, VARCHAR): Identificador único do entregável
    - id_avaliacao (FK, VARCHAR): Referência à avaliação
    - id_checklist (FK, VARCHAR): Referência ao checklist correspondente
    - id_projeto (VARCHAR(45)): Referência ao projeto correspondente
    - data_recebimento (DATETIME): Data de recebimento do entregável
    - csat_consultor (DECIMAL(5,2)): CSAT do consultor para o entregável
    - csat_conteudo (DECIMAL(5,2)): CSAT do conteúdo para o entregável
    - csat_conteudo_opcao (VARCHAR(10): CSAT do conteúdo para o entregável (avaliação presencial)
    - csat_conteudo_online_opcao (VARCHAR(10)): CSAT do conteúdo para o entregável (avaliação online)
    - plataforma_acessivel (VARCHAR(3)): Indica se a plataforma foi considerada acessível pelo respondente (avaliação online)
    - comentario_obrigatorio (VARCHAR): Comentário obrigatório do formulário enviado
    - comentario_opcional (VARCHAR): Comentário opcional do formulário enviado
    - nome_respondente (VARCHAR): Comentário opcional do formulário enviado
    - nps_status (ENUM): Opção promotor, neutro e detrator
    - nps (DECIMAL(5,2)): nps relacionado ao formulário
    - status (ENUM): Status do entregável ('PENDENTE', 'PROCESSADO')
    - data_processamento (DATETIME): Data de processamento do entregável

    Índices:
    idx_entregaveis_avaliacao em id_avaliacao.
    idx_entregaveis_data_recebimento em data_recebimento.


#### 8. perguntas

- **Descrição:** Armazena as perguntas dos formulários.
- **Campos:**
    - id_pergunta (INT, PK, AUTO_INCREMENT): Identificador único da pergunta. Recebe do webhook objeto definition/fields.
    - id_avaliacao (INT, FK, NOT NULL): Chave estrangeira referenciando avaliacoes(id_avaliacao)
    - texto_pergunta (VARCHAR(255), NOT NULL): Texto da pergunta
    - tipo_pergunta (VARCHAR(50), NOT NULL): Tipo da pergunta. Recebe do webhook objeto definition.
    - ref (VARCHAR(50)): Referência da pergunta no Typeform
    - ordem (INT, NOT NULL): Ordem da pergunta no formulário

#### 9. respostas

- **Descrição:** Contém as respostas dadas pelos participantes.
- **Campos:**
    - id_resposta (PK, INT, AI): Identificador único da resposta
    - id_entregavel (VARCHAR(255)): Referência ao entregável correspondente
    - id_pergunta (VARCHAR(50)): Identificador da pergunta correspondente
    - id_avaliacao (INT): Identificador da avaliação à qual a resposta pertence
    - valor_resposta (DECIMAL(5,2)): Valor numérico da resposta
    - texto_resposta (TEXT): Texto da resposta
    - tipo_resposta (VARCHAR(50)): Tipo da resposta
    - resposta_json (JSON): Representação JSON da resposta, se aplicável
    - csat_conteudo (DECIMAL(5,2)): Valor de CSAT para o conteúdo
    - ref (VARCHAR(50)): Referência da pergunta no Typeform

#### 10. log_processamento

- **Descrição:** Registra o status de processamentos no banco
- **Campos:**
    - id_log (PK, INT): Identificador único do log
    - id_entregavel (VARCHAR(255), FK): Referência ao entregável relacionado ao log.
    - status (ENUM): Status do processamento ('PROCESSADO', 'RECEBIDO', 'ERRO').
    - data_hora (DATETIME): Data e hora do registro.
      
## Relacionamentos Chave

**Unidade de Negócio (BU) e Clientes:** Cada cliente está associado a uma única unidade de negócio por meio da chave estrangeira id_bu na tabela **clientes**. Uma unidade de negócio, por sua vez, pode ter múltiplos clientes. Isso estabelece um relacionamento de **um-para-muitos** entre unidades de negócio e clientes, onde uma unidade de negócio pode ter vários clientes, mas cada cliente está relacionado a uma única unidade de negócio.

**Clientes e Projetos:** A relação entre clientes e projetos é estabelecida através da tabela associativa **clientes_projetos**, que contém as chaves estrangeiras id_cliente e id_projeto. Isso permite que um cliente esteja associado a múltiplos projetos e um projeto esteja associado a múltiplos clientes. Esse arranjo configura um relacionamento de **muitos-para-muitos** entre clientes e projetos.

**Projetos e Checklists:** Cada checklist está associado a um único projeto por meio da chave estrangeira id_projeto na tabela **checklist**. Um projeto, por sua vez, pode ter múltiplos checklists. Isso estabelece um relacionamento de **um-para-muitos** entre projetos e checklists, onde um projeto pode ter vários checklists, mas cada checklist está relacionado a um único projeto.

**Checklists e Avaliações:** Cada avaliação está associada a um único checklist por meio da chave estrangeira id_checklist na tabela **avaliacoes**. Um checklist, por sua vez, pode ter múltiplas avaliações. Isso estabelece um relacionamento de **um-para-muitos** entre checklists e avaliações, onde um checklist pode ter várias avaliações, mas cada avaliação está relacionada a um único checklist.

**Avaliações e Entregáveis:** Cada entregável está associado a uma única avaliação por meio da chave estrangeira id_avaliacao na tabela **entregaveis**. Uma avaliação, por sua vez, pode ter múltiplos entregáveis (formulários preenchidos). Isso estabelece um relacionamento de **um-para-muitos** entre avaliações e entregáveis, onde uma avaliação pode ter vários entregáveis, mas cada entregável está relacionado a uma única avaliação.

**Entregáveis e Respostas:** Cada resposta está associada a um único entregável por meio da chave estrangeira id_entregavel na tabela **respostas**. Um entregável, por sua vez, pode conter múltiplas respostas. Isso estabelece um relacionamento de **um-para-muitos** entre entregáveis e respostas, onde um entregável pode ter várias respostas, mas cada resposta está relacionada a um único entregável.

**Respostas e Perguntas:** Cada resposta está associada a uma única pergunta por meio da chave estrangeira id_pergunta na tabela respostas. Uma pergunta, por sua vez, pode estar vinculada a múltiplas respostas provenientes de diferentes entregáveis (formulários preenchidos). Isso estabelece um relacionamento de um-para-muitos entre perguntas e respostas, onde uma pergunta pode ter várias respostas, mas cada resposta está relacionada a uma única pergunta.

**Entregáveis e Checklists:** Cada entregável está associado a um único checklist por meio da chave estrangeira id_checklist na tabela entregaveis. Um checklist, por sua vez, pode ter múltiplos entregáveis. Isso estabelece um relacionamento de um-para-muitos entre checklists e entregáveis, onde um checklist pode ter vários entregáveis, mas cada entregável está relacionado a um único checklist.

**Entregáveis e Projetos:** Cada entregável pode estar associado a um único projeto por meio da chave estrangeira id_projeto na tabela entregaveis. Um projeto, por sua vez, pode ter múltiplos entregáveis. Isso estabelece um relacionamento de um-para-muitos entre projetos e entregáveis, onde um projeto pode ter vários entregáveis, mas cada entregável está relacionado a um único projeto.

## Fluxo de Dados e Integração

**Recebimento de Dados:** Quando um formulário é enviado, uma função Lambda recebe o payload do webhook do Typeform e envia os dados para as devidas tabelas.<br>
**Atualização de Dados:** Duas a trêz vezes ao dia, uma trigger é acionada e chama uma procedure que sincroniza o avaliacoes_db com o sistema_db.<br>
**Cálculo de Métricas:** Após a sincronização, são calculados os valores de CSAT e NPS.<br>
**Envio de Métricas:** As métricas calculadas são enviadas de volta ao sistema_db através de procedures.<br>

## Procedures e Events Implementados

1. **sp_processa_entregavel** 
**Descrição:** Marca um entregável como "PROCESSADO", calculando as métricas (CSAT e NPS) a partir das respostas recebidas. Atualiza os campos correspondentes nas tabelas relacionadas e registra a data de processamento.
**Disparo:** Chamado manualmente ou por um event agendado

2. **sp_cast_respostas** 
**Descrição:** Converte as respostas recebidas do formulário em valores processáveis, como a transformação de respostas opcionais (A, B, C, D) em percentuais e atualiza os campos na tabela entregaveis.
**Disparo:** Integrada ao fluxo de processamento do webhook

3. **sp_atualiza_avaliacoes** 
**Descrição:** Calcula e atualiza os valores agregados de CSAT e NPS nas tabelas avaliacoes, checklists, clientes, projetos e business_unities, considerando os dados processados nos entregáveis.
**Disparo:** Chamado a cada 2 horas.

4. **sp_relaciona_perguntas_entregaveis** 
**Descrição:** Associa as perguntas às respostas correspondentes com base no id_entregavel e atualiza a tabela intermediária perguntas_entregaveis.
**Disparo:** Chamado manualmente ou por um event agendado.

5. **sp_atualiza_dados_de_pmohsm** 
**Descrição:** Sincroniza dados do banco de pmohsm para o banco pbavaliacoes, atualizando informações de clientes, projetos e checklists.
**Disparo:** Event agendado para execução em batch (2-3 vezes ao dia).

## Boas Práticas Adotadas

- **Normalização:** O banco de dados foi projetado seguindo as regras de normalização para evitar redundâncias e inconsistências.
- **Chaves Primárias e Estrangeiras:** Uso adequado de PKs e FKs para manter a integridade referencial.
- **Procedures e Triggers:** Automação de processos repetitivos e críticos, garantindo a sincronização de dados entre bancos.
- **Comentários e Documentação:** Scripts comentados para facilitar a manutenção e compreensão do código.
- **Integração com Sistemas Externos:** Uso de webhooks e integração com o database do sistema para um fluxo de dados eficiente.
