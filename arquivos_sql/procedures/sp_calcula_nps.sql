DELIMITER //

CREATE PROCEDURE sp_calcula_nps (
    IN p_id_entregavel VARCHAR(255)
)
BEGIN
    DECLARE total_respostas INT DEFAULT 0;
    DECLARE promotores INT DEFAULT 0;
    DECLARE detratores INT DEFAULT 0;

    -- Calcula o total de respostas
    SELECT COUNT(*)
    INTO total_respostas
    FROM vw_perguntas_respostas
    WHERE ref = 'nps' AND id_entregavel = p_id_entregavel;

    -- Calcula o total de promotores
    SELECT SUM(CASE WHEN CAST(valor_resposta AS INT) >= 9 THEN 1 ELSE 0 END)
    INTO promotores
    FROM vw_perguntas_respostas
    WHERE ref = 'nps' AND id_entregavel = p_id_entregavel;

    -- Calcula o total de detratores
    SELECT SUM(CASE WHEN CAST(valor_resposta AS INT) <= 6 THEN 1 ELSE 0 END)
    INTO detratores
    FROM vw_perguntas_respostas
    WHERE ref = 'nps' AND id_entregavel = p_id_entregavel;

    -- Atualiza os valores no entregável
    UPDATE entregaveis
    SET 
        nps = ((promotores - detratores) * 100 / total_respostas),
        total_respostas = total_respostas -- Atualiza o campo total de respostas
    WHERE id_entregavel = p_id_entregavel;

    -- Atualiza o total de entregáveis na avaliação correspondente
    UPDATE avaliacoes a
    SET total_entregaveis = (
        SELECT COUNT(*)
        FROM entregaveis e
        WHERE e.id_avaliacao = a.id_avaliacao
    )
    WHERE a.id_avaliacao = (
        SELECT id_avaliacao
        FROM entregaveis
        WHERE id_entregavel = p_id_entregavel
    );
END //

DELIMITER ;
