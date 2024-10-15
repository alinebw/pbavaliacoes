
USE pbavaliacoes_v3;

-- Adicionando os indexes às tabelas para melhorar a performance
-- Tabela avaliacoes:
CREATE INDEX idx_avaliacoes_checklist ON avaliacoes(id_checklist); -- Relaciona avaliações com checklists, frequentemente utilizado em consultas
CREATE INDEX idx_avaliacoes_status ON avaliacoes(status); -- Importante para identificar avaliações encerradas ou em andamento

-- Tabela entregaveis:
CREATE INDEX idx_entregaveis_avaliacao ON entregaveis(id_avaliacao); -- Relaciona entregáveis às avaliações
CREATE INDEX idx_entregaveis_data_recebimento ON entregaveis(data_recebimento); -- Facilita consultas temporais

-- Tabela respostas:
CREATE INDEX idx_respostas_entregavel ON respostas(id_entregavel); -- Relaciona cada resposta ao entregável; facilita consultas que buscam todas as respostas de um entregável; melhora desempenho de joins
CREATE INDEX idx_respostas_pergunta ON respostas(id_pergunta); -- Relaciona cada resposta à pergunta específica; otimiza consultas que agrupam respostas por pergunta; acelera joins entre as tabelas

-- Tabela perguntas:
CREATE INDEX idx_perguntas_avaliacao ON perguntas(id_avaliacao); -- Relaciona perguntas à avaliação correspondente; ajuda na consulta das perguntas de uma avaliação; otimiza desempenho de joins

-- Tabela checklists:
CREATE INDEX idx_checklists_projeto ON checklists(id_projeto); -- Relaciona cada checklist ao projeto associado; otimiza consultas que buscam todos os checklists de um projeto; melhora o desempenho de joins

-- Tabela projetos:
CREATE INDEX idx_projetos_id_bu ON projetos(id_bu); -- Relaciona projetos à unidade de negócio; melhora desempenho em consultas e joins

-- Tabela clientes_projetos:
CREATE INDEX idx_clientes_projetos_cliente ON clientes_projetos(id_cliente);
CREATE INDEX idx_clientes_projetos_projeto ON clientes_projetos(id_projeto);

-- Tabela business_unities:
CREATE INDEX idx_business_unities_csat_bu ON business_unities(csat_bu); -- Melhora consultas em csat_bu
CREATE INDEX idx_business_unities_nome_bu ON business_unities(nome_bu); -- Melhora consultas que envolvam o nome da BU