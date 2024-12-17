DELIMITER //

CREATE PROCEDURE sp_atualiza_dados_de_staging ()
BEGIN
    -- Atualiza informações na tabela avaliacoes a partir de checklist_avaliacao
    UPDATE avaliacoes a
    JOIN staging.checklist_avaliacao ca 
        ON CONVERT(CAST(ca.id AS CHAR CHARACTER SET latin1) USING utf8mb4) COLLATE utf8mb4_unicode_ci = a.id_avaliacao COLLATE utf8mb4_unicode_ci
        AND CONVERT(ca.id_turma USING utf8mb4) COLLATE utf8mb4_unicode_ci = a.id_checklist COLLATE utf8mb4_unicode_ci
    SET 
        a.total_participantes = ca.quantidade_participante;
        
    -- Atualiza informações em entregáveis a partir de checklist_avaliacao
    UPDATE entregaveis e
    JOIN staging.checklist_avaliacao ca 
        ON CAST(ca.id AS CHAR CHARACTER SET utf8mb4) COLLATE utf8mb4_unicode_ci = e.id_avaliacao COLLATE utf8mb4_unicode_ci
        AND ca.id_turma COLLATE utf8mb4_unicode_ci = e.id_checklist COLLATE utf8mb4_unicode_ci
    SET 
        e.id_projeto = ca.project_id;
        
    -- Atualiza informações em checklists a partir de checklist_avaliacao
    UPDATE checklists c
    JOIN staging.checklist_avaliacao ca 
        ON CAST(ca.id AS CHAR CHARACTER SET utf8mb4) COLLATE utf8mb4_unicode_ci = c.id_avaliacao COLLATE utf8mb4_unicode_ci
        AND ca.id_turma COLLATE utf8mb4_unicode_ci = c.id_checklist COLLATE utf8mb4_unicode_ci
    SET 
        c.id_projeto = ca.project_id;
        
    -- Insere novos projetos na tabela projetos apenas com o id_projeto
    INSERT IGNORE INTO projetos (id_projeto)
    SELECT DISTINCT 
        CONVERT(CAST(pf.project_id AS CHAR CHARACTER SET utf8mb3) USING utf8mb4) COLLATE utf8mb4_unicode_ci AS id_projeto
    FROM staging.TBL_project_full pf;              

    -- Atualiza informações na tabela projetos a partir de TBL_project_full
    UPDATE projetos p
    JOIN staging.TBL_project_full pf
        ON CONVERT(CAST(pf.project_id AS CHAR CHARACTER SET utf8mb3) USING utf8mb4) COLLATE utf8mb4_unicode_ci = p.id_projeto COLLATE utf8mb4_unicode_ci
    SET 
        p.nome_projeto = CONVERT(pf.title USING utf8mb4) COLLATE utf8mb4_unicode_ci,
        p.nome_bu = CONVERT(pf.Area USING utf8mb4) COLLATE utf8mb4_unicode_ci;

	-- Insere id_cliente na tabela clientes
	INSERT IGNORE INTO clientes (id_cliente)
	SELECT DISTINCT 
		p.client_id 
	FROM staging.projects p;

    -- Atualiza informações na tabela clientes a partir da tabela projects 
    UPDATE clientes c
    JOIN staging.clients cl
        ON cl.client_id COLLATE utf8mb4_unicode_ci = c.id_cliente COLLATE utf8mb4_unicode_ci
    SET 
        c.nome_cliente = CONVERT(cl.company_name USING utf8mb4) COLLATE utf8mb4_unicode_ci;
        
	-- Insere dados em clientes_projetos a partir de projects
	INSERT IGNORE INTO clientes_projetos (id_cliente, id_projeto)
	SELECT DISTINCT 
		p.client_id, 
		CONVERT(CAST(p.project_id AS CHAR CHARACTER SET utf8mb3) USING utf8mb4) COLLATE utf8mb4_unicode_ci
	FROM staging.projects p;
	
    -- Atualiza informações em business_unities a partir de business_unit 
    INSERT IGNORE INTO business_unities (nome_bu)
    SELECT DISTINCT 
        CONVERT(b.name USING utf8mb4) COLLATE utf8mb4_unicode_ci
    FROM staging.business_unit b;
      
END //

DELIMITER ;
