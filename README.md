# avaliacoes_db - Documentação do Banco de Dados

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
      
#### 2. clientes

- **Descrição:** Armazena informações dos clientes.
- **Campos:**
    - id_cliente (INT, PK): Identificador único do cliente. Referenciado do sistema_db via procedure
    - nome_cliente (VARCHAR(100), NOT NULL): Nome do cliente. Referenciado do sistema_db via procedure
    - id_bu (INT, FK, NOT NULL): Chave estrangeira referenciando business_unities(id_bu)
    - csat_cliente (DECIMAL(5,2), DEFAULT NULL): Média CSAT do cliente
      
#### 3. projetos

- **Descrição:** Contém dados dos projetos.
- **Campos:**
    - id_projeto (INT, PK): Identificador único do projeto. Referenciado do sistema_db via procedure
    - nome_projeto (VARCHAR(100), NOT NULL): Nome do projeto. Referenciado do sistema_db via procedure
    - csat_projeto (DECIMAL(5,2), DEFAULT NULL): Média CSAT do projeto
      
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

#### 6. avaliacoes

- **Descrição:** Contém os diferentes tipos de avaliações.
- **Campos:**
    - id_avaliacao (INT, PK): Identificador único da avaliação. Gerado antes da aplicação do formulário. Recebe campo oculto do payload webhook
    - id_checklist (INT, FK, NOT NULL): Chave estrangeira referenciando checklists(id_checklists)
    - data_avaliacao (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Data da avaliação
    - tipo_avaliacao (VARCHAR(50), NOT NULL): Tipo de avaliação (e.g., 'CSAT', 'NPS')
    - csat_avaliacao (DECIMAL(5,2), DEFAULT NULL): Média CSAT da avaliação
    - total_entregaveis (INT, DEFAULT 0): Total de entregáveis recebidos
    - total_participantes (INT, DEFAULT 0): Total de participantes (preenchido manualmente)
    - status ENUM('Backlog', 'Em andamento', 'Encerrada') DEFAULT 'Backlog'


#### 7. entregaveis

- **Descrição:** Registra os formulários preenchidos (entregáveis).
- **Campos:**
    - id_entregavel (VARCHAR(255), PK): Identificador único do entregável. Recebe o 'token' do payload do webhook.
    - id_avaliacao (INT, FK, NOT NULL): Chave estrangeira referenciando avaliacoes(id_avaliacao). 
    - data_recebimento (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Data de recebimento do entregável (pode ser sobrescrita com 'submitted_at' do payload).
    - csat_entregavel (DECIMAL(5,2), DEFAULT NULL): Média CSAT do entregável.
    - id_typeform (VARCHAR(50)): ID do Typeform associado (proveniente do objeto 'definition' do payload).
    - nome_respondente (VARCHAR(100)): Nome do respondente (se coletado).

#### 8. perguntas

- **Descrição:** Armazena as perguntas dos formulários.
- **Campos:**
    - id_pergunta (INT, PK, AUTO_INCREMENT): Identificador único da pergunta. Recebe do webhook objeto definition/fields.
    - id_avaliacao (INT, FK, NOT NULL): Chave estrangeira referenciando avaliacoes(id_avaliacao).
    - texto_pergunta (VARCHAR(255), NOT NULL): Texto da pergunta.
    - tipo_pergunta (VARCHAR(50), NOT NULL): Tipo da pergunta. Recebe do webhook objeto definition.
    - opcional (BOOLEAN, DEFAULT FALSE): Indica se a pergunta é opcional.
    - ordem (INT, NOT NULL): Ordem da pergunta no formulário.

#### 9. respostas

- **Descrição:** Contém as respostas dadas pelos participantes.
- **Campos:**
    - id_resposta (INT, PK, AUTO_INCREMENT): Identificador único da resposta. Recebe do webhook objeto definition/answers.
    - id_entregavel (INT, FK, NOT NULL): Chave estrangeira referenciando entregaveis(id_entregavel).
    - id_pergunta (INT, FK, NOT NULL): Chave estrangeira referenciando perguntas(id_pergunta).
    - id_avaliacao (INT, FK, NOT NULL): Necessário para compor a chave estrangeira com id_pergunta.
    - valor_resposta (TINYINT, NOT NULL): Recebe do webhook se tipo da resposta é number.
    - texto_resposta (VARCHAR(500)): Recebe do webhook se tipo da resposta é text.
      
## Relacionamentos Chave

**Unidade de Negócio (BU) e Clientes:** Cada cliente está associado a uma única unidade de negócio por meio da chave estrangeira id_bu na tabela **clientes**. Uma unidade de negócio, por sua vez, pode ter múltiplos clientes. Isso estabelece um relacionamento de **um-para-muitos** entre unidades de negócio e clientes, onde uma unidade de negócio pode ter vários clientes, mas cada cliente está relacionado a uma única unidade de negócio.

**Clientes e Projetos:** A relação entre clientes e projetos é estabelecida através da tabela associativa **clientes_projetos**, que contém as chaves estrangeiras id_cliente e id_projeto. Isso permite que um cliente esteja associado a múltiplos projetos e um projeto esteja associado a múltiplos clientes. Esse arranjo configura um relacionamento de **muitos-para-muitos** entre clientes e projetos.

**Projetos e Checklists:** Cada checklist está associado a um único projeto por meio da chave estrangeira id_projeto na tabela **checklist**. Um projeto, por sua vez, pode ter múltiplos checklists. Isso estabelece um relacionamento de **um-para-muitos** entre projetos e checklists, onde um projeto pode ter vários checklists, mas cada checklist está relacionado a um único projeto.

**Checklists e Avaliações:** Cada avaliação está associada a um único checklist por meio da chave estrangeira id_checklist na tabela **avaliacoes**. Um checklist, por sua vez, pode ter múltiplas avaliações. Isso estabelece um relacionamento de **um-para-muitos** entre checklists e avaliações, onde um checklist pode ter várias avaliações, mas cada avaliação está relacionada a um único checklist.

**Avaliações e Entregáveis:** Cada entregável está associado a uma única avaliação por meio da chave estrangeira id_avaliacao na tabela **entregaveis**. Uma avaliação, por sua vez, pode ter múltiplos entregáveis (formulários preenchidos). Isso estabelece um relacionamento de **um-para-muitos** entre avaliações e entregáveis, onde uma avaliação pode ter vários entregáveis, mas cada entregável está relacionado a uma única avaliação.

**Entregáveis e Respostas:** Cada resposta está associada a um único entregável por meio da chave estrangeira id_entregavel na tabela **respostas**. Um entregável, por sua vez, pode conter múltiplas respostas. Isso estabelece um relacionamento de **um-para-muitos** entre entregáveis e respostas, onde um entregável pode ter várias respostas, mas cada resposta está relacionada a um único entregável.

**Respostas e Perguntas:** Cada resposta está associada a uma única pergunta por meio da chave estrangeira id_pergunta na tabela respostas. Uma pergunta, por sua vez, pode estar vinculada a múltiplas respostas provenientes de diferentes entregáveis (formulários preenchidos). Isso estabelece um relacionamento de um-para-muitos entre perguntas e respostas, onde uma pergunta pode ter várias respostas, mas cada resposta está relacionada a uma única pergunta.

## Fluxo de Dados e Integração

**Recebimento de Dados:** Quando um formulário é enviado, uma função Lambda recebe o payload do webhook do Typeform e envia os dados para as devidas tabelas.<br>
**Atualização de Dados:** Duas a trêz vezes ao dia, uma trigger é acionada e chama uma procedure que sincroniza o avaliacoes_db com o sistema_db.<br>
**Cálculo de Métricas:** Após a sincronização, são calculados os valores de CSAT e NPS.<br>
**Envio de Métricas:** As métricas calculadas são enviadas de volta ao sistema_db através de procedures.<br>

## Procedures e Triggers

**Procedure:** (em desenvolvimento)
**Trigger:** (em desenvolvimento)

## Boas Práticas Adotadas

- **Normalização:** O banco de dados foi projetado seguindo as regras de normalização para evitar redundâncias e inconsistências.
- **Chaves Primárias e Estrangeiras:** Uso adequado de PKs e FKs para manter a integridade referencial.
- **Procedures e Triggers:** Automação de processos repetitivos e críticos, garantindo a sincronização de dados entre bancos.
- **Comentários e Documentação:** Scripts comentados facilitam a manutenção e compreensão do código.
- **Integração com Sistemas Externos:** Uso de webhooks e integração com o database do sistema para um fluxo de dados eficiente.
