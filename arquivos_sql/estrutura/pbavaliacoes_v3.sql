USE pbavaliacoes;

-- Tabela de Unidades de Negócio (Business Unities)
CREATE TABLE business_unities (
    id_bu INT NOT NULL PRIMARY KEY, -- Referenciado do pmohsm por procedure
    nome_bu VARCHAR(100) NOT NULL,
    csat_bu DECIMAL(5, 2) DEFAULT NULL -- Média CSAT da unidade de negócio
);

-- Tabela de Clientes
CREATE TABLE clientes (
    id_cliente INT NOT NULL PRIMARY KEY, -- Referenciado do pmohsm por procedure
    nome_cliente VARCHAR(100) NOT NULL,
    id_bu INT NOT NULL, -- FK referenciando id_bu na tabela local
    csat_cliente DECIMAL(5, 2) DEFAULT NULL, -- Média CSAT do cliente
    FOREIGN KEY (id_bu) REFERENCES business_unities(id_bu)
);

-- Tabela de Projetos
CREATE TABLE projetos (
    id_projeto INT NOT NULL PRIMARY KEY, -- Referenciado do pmohsm por procedure
    nome_projeto VARCHAR(100) NOT NULL,
    csat_projeto DECIMAL(5, 2) DEFAULT NULL -- Média CSAT do projeto
);

-- Tabela Associativa entre Clientes e Projetos (Relacionamento muitos-para-muitos)
CREATE TABLE clientes_projetos (
    id_cliente INT NOT NULL, -- Referenciado do pmohsm
    id_projeto INT NOT NULL, -- Referenciado do pmohsm
    PRIMARY KEY (id_cliente, id_projeto),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_projeto) REFERENCES projetos(id_projeto)
);

-- Tabela de Checklists 
CREATE TABLE checklists (
    id_checklist INT NOT NULL PRIMARY KEY, -- id_checklist vem do pmohsm
    nome_checklist VARCHAR(100) NOT NULL,
    id_projeto INT NOT NULL, -- FK referenciando projeto na tabela local
    csat_checklist DECIMAL(5, 2) DEFAULT NULL, -- Média CSAT do checklist
    total_entregaveis INT DEFAULT 0, -- Total de entregáveis recebidos
    FOREIGN KEY (id_projeto) REFERENCES projetos(id_projeto)
);

-- Tabela de Avaliações
CREATE TABLE avaliacoes (
    id_avaliacao INT NOT NULL PRIMARY KEY, -- Gerado antes do formulário ser aplicado
    id_checklist INT NOT NULL, -- FK referenciando a checklist na tabela local
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_avaliacao VARCHAR(50) NOT NULL, -- Ex: 'CSAT', 'NPS'
    csat_avaliacao DECIMAL(5, 2) DEFAULT NULL, -- Média CSAT por avaliação
    total_entregaveis INT DEFAULT 0, -- Total de entregáveis recebidos
    total_participantes INT DEFAULT 0, -- Total de participantes (preenchido manualmente)
    FOREIGN KEY (id_checklist) REFERENCES checklists(id_checklist)
);

-- Tabela de Entregáveis (Formulários preenchidos)
CREATE TABLE entregaveis (
    id_entregavel VARCHAR(255) NOT NULL PRIMARY KEY, -- Recebe o 'token' do webhook payload
    id_avaliacao INT NOT NULL, -- FK para a avaliação
    data_recebimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Pode ser sobrescrito com 'submitted_at' do payload
    csat_entregavel DECIMAL(5, 2) DEFAULT NULL, -- Média CSAT do entregável
    id_typeform VARCHAR(50), -- ID do Typeform associado (from 'definition' object)
    nome_respondente VARCHAR(100), -- Nome do respondente (se coletado)
    FOREIGN KEY (id_avaliacao) REFERENCES avaliacoes(id_avaliacao)
);

-- Tabela de Perguntas
CREATE TABLE perguntas (
    id_pergunta VARCHAR(50) NOT NULL, -- ID proveniente do 'fields' object in webhook payload
    id_avaliacao INT NOT NULL, -- FK para a avaliação
    texto_pergunta VARCHAR(255) NOT NULL, -- 'title' from 'fields' object
    tipo_pergunta VARCHAR(50) NOT NULL, -- Tipo de pergunta (e.g., 'picture_choice', 'rating', 'text', 'nps')
    ordem INT NOT NULL, -- Ordem da pergunta no formulário
    opcional BOOLEAN DEFAULT FALSE, -- Indica se a pergunta é opcional
    PRIMARY KEY (id_pergunta, id_avaliacao), -- Composto para permitir mesmas perguntas em avaliações diferentes
    FOREIGN KEY (id_avaliacao) REFERENCES avaliacoes(id_avaliacao)
);

-- Tabela de Respostas
CREATE TABLE respostas (
    id_resposta INT AUTO_INCREMENT PRIMARY KEY,
    id_entregavel VARCHAR(255) NOT NULL, -- FK para o entregável (formulário), 'token' from payload
    id_pergunta VARCHAR(50) NOT NULL, -- FK para a pergunta, 'id' from 'fields' object
    id_avaliacao INT NOT NULL, -- Necessário para compor a chave estrangeira com id_pergunta
    valor_resposta DECIMAL(5,2), -- Valor da resposta (e.g., nota de 1 a 5, 0 a 10)
    texto_resposta VARCHAR(500), -- Comentário textual (se aplicável)
    FOREIGN KEY (id_entregavel) REFERENCES entregaveis(id_entregavel),
    FOREIGN KEY (id_pergunta, id_avaliacao) REFERENCES perguntas(id_pergunta, id_avaliacao)
);
