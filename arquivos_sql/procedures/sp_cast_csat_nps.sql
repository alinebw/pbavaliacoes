-- Atualiza entregaveis fazendo cast de csat e nps da view perguntas_respostas

DELIMITER //

CREATE PROCEDURE sp_cast_csat_nps (
    IN p_id_entregavel VARCHAR(255)
)
BEGIN
    DECLARE v_csat_consultor DECIMAL(10, 2) DEFAULT NULL;
    DECLARE v_csat_conteudo DECIMAL(10, 2) DEFAULT NULL;
    DECLARE v_csat_evento DECIMAL(10, 2) DEFAULT NULL;
    DECLARE v_nps DECIMAL(10, 2) DEFAULT NULL;
    DECLARE v_nps_status ENUM('PROMOTOR', 'NEUTRO', 'DETRATOR');

    -- Start Transaction
    START TRANSACTION;

    -- Pega nps e csat na view 
    SELECT 
        MAX(CASE WHEN ref = 'csat_consultor' THEN CAST(valor_resposta AS DECIMAL(10, 2)) END),
        MAX(CASE WHEN ref = 'csat_conteúdo' THEN CAST(valor_resposta AS DECIMAL(10, 2)) END),
        MAX(CASE WHEN ref = 'csat_evento' THEN CAST(valor_resposta AS DECIMAL(10, 2)) END),
        MAX(CASE WHEN ref = 'nps' THEN CAST(valor_resposta AS DECIMAL(10, 2)) END)
    INTO 
        v_csat_consultor, v_csat_conteudo, v_csat_evento, v_nps
    FROM vw_perguntas_respostas
    WHERE id_entregavel = p_id_entregavel;

    -- Determina nps status com base na nota nps
    IF v_nps >= 9 THEN
        SET v_nps_status = 'PROMOTOR';
    ELSEIF v_nps BETWEEN 7 AND 8 THEN
        SET v_nps_status = 'NEUTRO';
    ELSEIF v_nps <= 6 THEN
        SET v_nps_status = 'DETRATOR';
    ELSE
        SET v_nps_status = NULL; -- Lida edge case nps null (em caso de erro no form)
    END IF;

    -- Atualiza valores na tabela entregaveis
    UPDATE entregaveis
    SET
        csat_consultor = v_csat_consultor,
        csat_conteúdo = v_csat_conteudo,
        csat_evento = v_csat_evento,
        nps = v_nps,
        nps_status = v_nps_status
    WHERE id_entregavel = p_id_entregavel;

    -- Commit Transaction
    COMMIT;
    
END //

DELIMITER ;
