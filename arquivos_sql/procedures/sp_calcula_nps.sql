- Procedure para calcular nps e preencher perc_detratores, perc_neutros e perc_promotores
DELIMITER //

CREATE PROCEDURE sp_calcula_nps (
    IN p_id_entregavel VARCHAR(45)
)
BEGIN
    DECLARE total_respostas INT DEFAULT 0;
    DECLARE promotores INT DEFAULT 0;
    DECLARE detratores INT DEFAULT 0;
    DECLARE neutros INT DEFAULT 0;
    DECLARE id_avaliacao INT;

    sp_calcula_nps_block: BEGIN
        -- Pegar id_avaliacao do entregavel
        SELECT id_avaliacao
        INTO id_avaliacao
        FROM entregaveis
        WHERE id_entregavel = p_id_entregavel;

        -- Sair se id_avaliacao não é encontrado
        IF id_avaliacao IS NULL THEN
            LEAVE sp_calcula_nps_block;
        END IF;

        -- Unificar resultados em uma única query
        SELECT 
            COUNT(*) AS total,
            SUM(CASE WHEN CAST(valor_resposta AS DECIMAL) >= 9 THEN 1 ELSE 0 END) AS promotores_count,
            SUM(CASE WHEN CAST(valor_resposta AS DECIMAL) BETWEEN 7 AND 8 THEN 1 ELSE 0 END) AS neutros_count,
            SUM(CASE WHEN CAST(valor_resposta AS DECIMAL) <= 6 THEN 1 ELSE 0 END) AS detratores_count
        INTO total_respostas, promotores, neutros, detratores
        FROM vw_perguntas_respostas
        WHERE ref = 'nps' AND id_entregavel = p_id_entregavel;

        -- Atualizar nps e perc_promotores, perc_neutros, perc_detratores
        IF total_respostas > 0 THEN
            UPDATE avaliacoes
            SET 
                nps = ((promotores - detratores) * 100 / total_respostas),
                perc_promotores = (promotores * 100 / total_respostas),
                perc_detratores = (detratores * 100 / total_respostas),
                perc_neutros = (neutros * 100 / total_respostas),
                total_respostas = total_respostas
            WHERE id_avaliacao = id_avaliacao;
        END IF;

        -- Atualizar total_entregaveis em avaliacoes
        UPDATE avaliacoes
        SET total_entregaveis = (
            SELECT COUNT(*)
            FROM entregaveis
            WHERE id_avaliacao = avaliacoes.id_avaliacao
        )
        WHERE id_avaliacao = id_avaliacao;

    END sp_calcula_nps_block;

END //

DELIMITER ;

-- Trigger para disparar procedure sempre que um novo entregavel é atualizado

DELIMITER //

CREATE TRIGGER trg_calcula_nps
AFTER UPDATE ON entregaveis
FOR EACH ROW
BEGIN
    -- Verifica se o nps precisa ser calculado
    IF NEW.nps != OLD.nps THEN
        CALL sp_calcula_nps(NEW.id_entregavel);
    END IF;
END //

DELIMITER ;
