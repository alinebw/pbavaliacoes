use pbavaliacoes_testes;

-- Tabela de Unidades de Negócio (Business Unities)
CREATE TABLE business_unities (
    id_bu INT NOT NULL PRIMARY KEY, -- Referenciado do db_sistema por procedure
    nome_bu VARCHAR(100) NOT NULL,
    csat_bu DECIMAL(5, 2) DEFAULT NULL -- Média CSAT da unidade de negócio
);

-- Tabela de Clientes
CREATE TABLE clientes (
    id_cliente INT NOT NULL PRIMARY KEY, -- Referenciado do db_sistema por procedure
    nome_cliente VARCHAR(100) NOT NULL,
    id_bu INT NOT NULL, -- FK referenciando id_bu na tabela local
    csat_cliente DECIMAL(5, 2) DEFAULT NULL, -- Média CSAT do cliente
    FOREIGN KEY (id_bu) REFERENCES business_unities(id_bu)
);

-- Tabela de Projetos
CREATE TABLE projetos (
    id_projeto INT NOT NULL PRIMARY KEY, -- Referenciado do db_sistema por procedure
    nome_projeto VARCHAR(100) NOT NULL,
    csat_projeto DECIMAL(5, 2) DEFAULT NULL -- Média CSAT do projeto
);

-- Tabela Associativa entre Clientes e Projetos (Relacionamento muitos-para-muitos)
CREATE TABLE clientes_projetos (
    id_cliente INT NOT NULL, -- Referenciado do db_sistema
    id_projeto INT NOT NULL, -- Referenciado do db_sistema
    PRIMARY KEY (id_cliente, id_projeto),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_projeto) REFERENCES projetos(id_projeto)
);

-- Tabela de Turmas (id_turma é o id_checklist do db_sistema)
CREATE TABLE turmas (
    id_turma INT NOT NULL PRIMARY KEY, -- id_turma vem do db_sistema (id_checklist)
    nome_turma VARCHAR(100) NOT NULL,
    id_projeto INT NOT NULL, -- FK referenciando projeto na tabela local
    csat_turma DECIMAL(5, 2) DEFAULT NULL, -- Média CSAT da turma
    FOREIGN KEY (id_projeto) REFERENCES projetos(id_projeto)
);

-- Tabela de Avaliações
CREATE TABLE avaliacoes (
    id_avaliacao INT NOT NULL PRIMARY KEY, -- Gerado antes do formulário ser aplicado
    id_turma INT NOT NULL, -- FK referenciando a turma na tabela local
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_avaliacao VARCHAR(50) NOT NULL, -- Ex: 'CSAT', 'NPS'
    csat_avaliacao DECIMAL(5, 2) DEFAULT NULL, -- Média CSAT por avaliação
    FOREIGN KEY (id_turma) REFERENCES turmas(id_turma)
);

-- Tabela de Entregáveis (Formulários preenchidos)
CREATE TABLE entregaveis (
    id_entregavel INT AUTO_INCREMENT PRIMARY KEY,
    id_avaliacao INT NOT NULL, -- FK para a avaliação
    data_recebimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    csat_entregavel DECIMAL(5, 2) DEFAULT NULL, -- Média CSAT do entregável
    FOREIGN KEY (id_avaliacao) REFERENCES avaliacoes(id_avaliacao)
);

-- Tabela de Perguntas
CREATE TABLE perguntas (
    id_pergunta INT AUTO_INCREMENT PRIMARY KEY,
    id_avaliacao INT NOT NULL, -- FK para a avaliação
    texto_pergunta VARCHAR(255) NOT NULL,
    tipo_pergunta VARCHAR(50) NOT NULL, -- Ex: 'csat_conteudo', 'sugestoes'
    ordem INT NOT NULL, -- Ordem da pergunta no formulário
    FOREIGN KEY (id_avaliacao) REFERENCES avaliacoes(id_avaliacao)
);

-- Tabela de Respostas
CREATE TABLE respostas (
    id_resposta INT AUTO_INCREMENT PRIMARY KEY,
    id_entregavel INT NOT NULL, -- FK para o entregável (formulário)
    id_pergunta INT NOT NULL, -- FK para a pergunta
    valor_resposta TINYINT NOT NULL, -- Valor da resposta (ex: nota de 1 a 5)
    texto_resposta VARCHAR(500), -- Comentário textual (se aplicável)
    FOREIGN KEY (id_entregavel) REFERENCES entregaveis(id_entregavel),
    FOREIGN KEY (id_pergunta) REFERENCES perguntas(id_pergunta)
);
