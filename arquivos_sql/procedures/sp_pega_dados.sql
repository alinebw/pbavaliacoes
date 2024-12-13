DELIMITER //

CREATE PROCEDURE sp_pega_dados ()
BEGIN
    -- Atualiza total de participantes e id_projeto na tabela avaliacoes
    UPDATE avaliacoes a
    JOIN pmohsm.checklist_avaliacao ca 
        ON ca.id = a.id_avaliacao AND ca.id_turma = a.id_checklist
    SET 
        a.total_participantes = ca.quantidade_participante,
        a.id_projeto = ca.project_id;

    -- Atualiza informações de projetos a partir da tabela TBL_project_full
    UPDATE projetos p
    JOIN pmohsm.TBL_project_full pf
        ON pf.project_id = p.id_projeto
    SET 
        p.nome_projeto = pf.title,
        p.nome_cliente = pf.Cliente,
        p.nome_bu = pf.Area;

    -- Atualiza informações de clientes a partir da tabela TBL_project_full
    UPDATE clientes c
    JOIN stagingpmohsm.TBL_project_full pf
        ON pf.client_id = c.id_cliente
    SET 
        c.nome_cliente = pf.Cliente,
        c.nome_bu = pf.Area;

    -- Atualiza informações de business_unities a partir da tabela TBL_project_full
    UPDATE business_unities bu
    JOIN pmohsm.TBL_project_full pf
        ON pf.Area = bu.nome_bu
    SET 
        bu.nome_bu = pf.Area;

    -- Atualiza entregáveis com id_projeto
    UPDATE entregaveis e
    JOIN pmohsm.TBL_project_full pf
        ON pf.project_id = e.id_projeto
    SET 
        e.id_projeto = pf.project_id;

    -- Atualiza entregáveis com id_cliente
    UPDATE entregaveis e
    JOIN pmohsm.TBL_project_full pf
        ON pf.client_id = e.id_cliente
    SET 
        e.id_cliente = pf.client_id;

    -- Atualiza entregáveis com nome_bu
    UPDATE entregaveis e
    JOIN pmohsm.TBL_project_full pf
        ON pf.Area = e.nome_bu
    SET 
        e.nome_bu = pf.Area;
END //

DELIMITER ;
