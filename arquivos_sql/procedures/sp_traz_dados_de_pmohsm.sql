DELIMITER //

CREATE PROCEDURE sp_traz_dados_de_pmohsm ()
BEGIN
    -- Atualiza total de participantes
    UPDATE avaliacoes a
    SET total_participantes = (
        SELECT quantidade_partici
        FROM pmohsm.checklist_avaliacao ca
        WHERE ca.id = a.id_avaliacao AND ca.turma = a.id_checklist
    );

    -- Atualiza informações de projetos
    UPDATE projetos p
    JOIN pmohsm.projects pr ON p.id_projeto = pr.project_id
    SET p.nome_projeto = pr.title;

    -- Atualiza informações de clientes
    UPDATE clientes c
    JOIN pmohsm.clients cl ON c.id_cliente = cl.client_id
    SET c.nome_cliente = cl.company_name;

    -- Atualiza informações de BU
    UPDATE business_unities bu
    JOIN pmohsm.business_unit b ON bu.nome_bu = b.bu
    SET bu.id_bu = b.id_bu;
END //

DELIMITER ;
