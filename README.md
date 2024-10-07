# pbavaliacoes - Documentação do Banco de Dados

## Visão Geral

O banco de dados pbavaliacoes foi projetado para gerenciar avaliações e feedbacks coletados via Typeform. Ele é alimentado por webhooks do Typeform e integra-se com o db_sistema para sincronizar dados essenciais, como informações de clientes, projetos, turmas e unidades de negócio. O objetivo principal é calcular métricas como CSAT (Customer Satisfaction Score) e NPS (Net Promoter Score) e enviar esses valores para o db_sistema através de procedures, já que ambos estão hospedados na mesma instância RDS da AWS.

## Estrutura do Banco de Dados

### Tabelas e Relacionamentos
#### 1. business_unities
- **Descrição:** Armazena as unidades de negócio (Business Units).
- **Campos:** 
    - id_bu (INT, PK): Identificador único da unidade de negócio. Referenciado do db_sistema via procedure.
    - nome_bu (VARCHAR(100), NOT NULL): Nome da unidade de negócio.
    - csat_bu (DECIMAL(5,2), DEFAULT NULL): Média CSAT da unidade de negócio.
      
#### 2. clientes

- **Descrição:** Armazena informações dos clientes.
- **Campos:**
    - id_cliente (INT, PK): Identificador único do cliente. Referenciado do db_sistema via procedure.
    - nome_cliente (VARCHAR(100), NOT NULL): Nome do cliente.
    - id_bu (INT, FK, NOT NULL): Chave estrangeira referenciando business_unities(id_bu).
    - csat_cliente (DECIMAL(5,2), DEFAULT NULL): Média CSAT do cliente.
      
#### 3. projetos

- **Descrição:** Contém dados dos projetos.
- **Campos:**
    - id_projeto (INT, PK): Identificador único do projeto. Referenciado do db_sistema via procedure.
    - nome_projeto (VARCHAR(100), NOT NULL): Nome do projeto.
    - csat_projeto (DECIMAL(5,2), DEFAULT NULL): Média CSAT do projeto.
      
#### 4. clientes_projetos

- **Descrição:** Tabela associativa para o relacionamento muitos-para-muitos entre clientes e projetos.
- **Campos:**
    - id_cliente (INT, PK, FK): Chave estrangeira referenciando clientes(id_cliente).
    - id_projeto (INT, PK, FK): Chave estrangeira referenciando projetos(id_projeto).

#### 5. turmas

- **Descrição:** Armazena informações das turmas. O id_turma corresponde ao id_checklist no db_sistema.
- **Campos:**
    - id_turma (INT, PK): Identificador único da turma. Vem do db_sistema.
    - nome_turma (VARCHAR(100), NOT NULL): Nome da turma.
    - id_projeto (INT, FK, NOT NULL): Chave estrangeira referenciando projetos(id_projeto).
    - csat_turma (DECIMAL(5,2), DEFAULT NULL): Média CSAT da turma.

#### 6. avaliacoes

- **Descrição:** Contém os diferentes tipos de avaliações.
- **Campos:**
    - id_avaliacao (INT, PK): Identificador único da avaliação. Gerado antes da aplicação do formulário.
    - id_turma (INT, FK, NOT NULL): Chave estrangeira referenciando turmas(id_turma).
    - data_avaliacao (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Data da avaliação.
    - tipo_avaliacao (VARCHAR(50), NOT NULL): Tipo de avaliação (e.g., 'CSAT', 'NPS').
    - csat_avaliacao (DECIMAL(5,2), DEFAULT NULL): Média CSAT da avaliação.

#### 7. entregaveis

- **Descrição:** Registra os formulários preenchidos (entregáveis).
- **Campos:**
    - id_entregavel (INT, PK, AUTO_INCREMENT): Identificador único do entregável.
    - id_avaliacao (INT, FK, NOT NULL): Chave estrangeira referenciando avaliacoes(id_avaliacao).
    - data_recebimento (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP): Data de recebimento do entregável.
    - csat_entregavel (DECIMAL(5,2), DEFAULT NULL): Média CSAT do entregável.

#### 8. perguntas

- **Descrição:** Armazena as perguntas dos formulários.
- **Campos:**
    - id_pergunta (INT, PK, AUTO_INCREMENT): Identificador único da pergunta.
    - id_avaliacao (INT, FK, NOT NULL): Chave estrangeira referenciando avaliacoes(id_avaliacao).
    - texto_pergunta (VARCHAR(255), NOT NULL): Texto da pergunta.
    - tipo_pergunta (VARCHAR(50), NOT NULL): Tipo da pergunta (e.g., 'csat_conteudo', 'sugestoes').
    - ordem (INT, NOT NULL): Ordem da pergunta no formulário.

#### 9. respostas

- **Descrição:** Contém as respostas dadas pelos participantes.
- **Campos:**
    - id_resposta (INT, PK, AUTO_INCREMENT): Identificador único da resposta.
    - id_entregavel (INT, FK, NOT NULL): Chave estrangeira referenciando entregaveis(id_entregavel).
    - id_pergunta (INT, FK, NOT NULL): Chave estrangeira referenciando perguntas(id_pergunta).
    - valor_resposta (TINYINT, NOT NULL): Valor numérico da resposta (e.g., nota de 1 a 5).
    - texto_resposta (VARCHAR(500)): Comentário textual, se aplicável.
      
## Relacionamentos Chave

**Unidade de Negócio (BU) e Clientes:** Cada cliente está associado a uma única unidade de negócio por meio da chave estrangeira id_bu na tabela **clientes**. Uma unidade de negócio, por sua vez, pode ter múltiplos clientes. Isso estabelece um relacionamento de **um-para-muitos** entre unidades de negócio e clientes, onde uma unidade de negócio pode ter vários clientes, mas cada cliente está relacionado a uma única unidade de negócio.

**Clientes e Projetos:** A relação entre clientes e projetos é estabelecida através da tabela associativa **clientes_projetos**, que contém as chaves estrangeiras id_cliente e id_projeto. Isso permite que um cliente esteja associado a múltiplos projetos e um projeto esteja associado a múltiplos clientes. Esse arranjo configura um relacionamento de **muitos-para-muitos** entre clientes e projetos.

**Projetos e Turmas:** Cada turma está associada a um único projeto por meio da chave estrangeira id_projeto na tabela **turmas**. Um projeto, por sua vez, pode ter múltiplas turmas. Isso estabelece um relacionamento de **um-para-muitos** entre projetos e turmas, onde um projeto pode ter várias turmas, mas cada turma está relacionada a um único projeto.

**Turmas e Avaliações:** Cada avaliação está associada a uma única turma por meio da chave estrangeira id_turma na tabela **avaliacoes**. Uma turma, por sua vez, pode ter múltiplas avaliações. Isso estabelece um relacionamento de **um-para-muitos** entre turmas e avaliações, onde uma turma pode ter várias avaliações, mas cada avaliação está relacionada a uma única turma.

**Avaliações e Entregáveis:** Cada entregável está associado a uma única avaliação por meio da chave estrangeira id_avaliacao na tabela **entregaveis**. Uma avaliação, por sua vez, pode ter múltiplos entregáveis (formulários preenchidos). Isso estabelece um relacionamento de **um-para-muitos** entre avaliações e entregáveis, onde uma avaliação pode ter vários entregáveis, mas cada entregável está relacionado a uma única avaliação.

**Entregáveis e Respostas:** Cada resposta está associada a um único entregável por meio da chave estrangeira id_entregavel na tabela **respostas**. Um entregável, por sua vez, pode conter múltiplas respostas. Isso estabelece um relacionamento de **um-para-muitos** entre entregáveis e respostas, onde um entregável pode ter várias respostas, mas cada resposta está relacionada a um único entregável.

**Respostas e Perguntas:** Cada resposta está associada a uma única pergunta por meio da chave estrangeira id_pergunta na tabela respostas. Uma pergunta, por sua vez, pode estar vinculada a múltiplas respostas provenientes de diferentes entregáveis (formulários preenchidos). Isso estabelece um relacionamento de um-para-muitos entre perguntas e respostas, onde uma pergunta pode ter várias respostas, mas cada resposta está relacionada a uma única pergunta.

## Fluxo de Dados e Integração

**Recebimento de Dados:** O Typeform envia dados via webhook para o pbavaliacoes.
**Atualização de Dados:** Uma trigger é acionada após a inserção de um novo entregável, chamando uma procedure que sincroniza dados com o db_sistema.
**Cálculo de Métricas:** Após a sincronização, são calculados os valores de CSAT e NPS.
**Envio de Métricas:** As métricas calculadas são enviadas de volta ao db_sistema através de procedures.

## Procedures e Triggers

**Procedure:** atualizar_dados_avaliacao<br>
**Descrição:** Sincroniza dados de avaliações, turmas, projetos, clientes e unidades de negócio entre o pbavaliacoes e o db_sistema.

**Trigger:** after_insert_entregaveis<br>
**Descrição:** Aciona a procedure atualizar_dados_avaliacao após a inserção de um novo entregável.

## Boas Práticas Adotadas

- **Normalização:** O banco de dados foi projetado seguindo as regras de normalização para evitar redundâncias e inconsistências.
- **Chaves Primárias e Estrangeiras:** Uso adequado de PKs e FKs para manter a integridade referencial.
- **Procedures e Triggers:** Automação de processos repetitivos e críticos, garantindo a sincronização de dados entre bancos.
- **Comentários e Documentação:** Scripts comentados facilitam a manutenção e compreensão do código.
- **Integração com Sistemas Externos:** Uso de webhooks e integração com o db_sistema para um fluxo de dados eficiente.
