DELIMITER $$

CREATE PROCEDURE atualizar_dados_avaliacao(IN p_id_avaliacao INT)
BEGIN
    DECLARE v_id_projeto INT;
    DECLARE v_id_turma INT;
    DECLARE v_id_cliente INT;
    DECLARE v_id_bu INT;
    DECLARE v_nome_projeto VARCHAR(100);
    DECLARE v_nome_turma VARCHAR(100);
    DECLARE v_nome_cliente VARCHAR(100);
    DECLARE v_nome_bu VARCHAR(100);

    -- Obter id_turma e id_projeto a partir do id_avaliacao no db_sistema
    SELECT
        a.id_turma,
        t.id_projeto,
        p.nome_projeto,
        t.nome_turma
    INTO
        v_id_turma,
        v_id_projeto,
        v_nome_projeto,
        v_nome_turma
    FROM db_sistema.avaliacoes a
    JOIN db_sistema.turmas t ON a.id_turma = t.id_turma
    JOIN db_sistema.projetos p ON t.id_projeto = p.id_projeto
    WHERE a.id_avaliacao = p_id_avaliacao;

    -- Obter id_cliente e id_bu a partir do id_projeto no db_sistema
    SELECT
        cp.id_cliente,
        c.nome_cliente,
        c.id_bu,
        bu.nome_bu
    INTO
        v_id_cliente,
        v_nome_cliente,
        v_id_bu,
        v_nome_bu
    FROM db_sistema.clientes_projetos cp
    JOIN db_sistema.clientes c ON cp.id_cliente = c.id_cliente
    JOIN db_sistema.business_unities bu ON c.id_bu = bu.id_bu
    WHERE cp.id_projeto = v_id_projeto
    LIMIT 1; -- Considerando que cada projeto tem um cliente principal

    -- Atualizar ou inserir o projeto no pbavaliacoes
    IF NOT EXISTS (SELECT 1 FROM projetos WHERE id_projeto = v_id_projeto) THEN
        INSERT INTO projetos (id_projeto, nome_projeto)
        VALUES (v_id_projeto, v_nome_projeto);
    END IF;

    -- Atualizar ou inserir a turma no pbavaliacoes
    IF NOT EXISTS (SELECT 1 FROM turmas WHERE id_turma = v_id_turma) THEN
        INSERT INTO turmas (id_turma, nome_turma, id_projeto)
        VALUES (v_id_turma, v_nome_turma, v_id_projeto);
    END IF;

    -- Atualizar ou inserir o cliente no pbavaliacoes
    IF NOT EXISTS (SELECT 1 FROM clientes WHERE id_cliente = v_id_cliente) THEN
        INSERT INTO clientes (id_cliente, nome_cliente, id_bu)
        VALUES (v_id_cliente, v_nome_cliente, v_id_bu);
    END IF;

    -- Atualizar ou inserir a unidade de negócio no pbavaliacoes
    IF NOT EXISTS (SELECT 1 FROM business_unities WHERE id_bu = v_id_bu) THEN
        INSERT INTO business_unities (id_bu, nome_bu)
        VALUES (v_id_bu, v_nome_bu);
    END IF;

    -- Atualizar a avaliação com o id_turma
    UPDATE avaliacoes
    SET id_turma = v_id_turma
    WHERE id_avaliacao = p_id_avaliacao;

END$$

DELIMITER ;
