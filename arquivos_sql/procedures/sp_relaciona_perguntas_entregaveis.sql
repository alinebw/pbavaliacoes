-- Procedure para relacionar perguntas_entregaveis

DELIMITER //

CREATE PROCEDURE sp_relaciona_perguntas_entregaveis (
    IN p_id_entregavel VARCHAR(45)
)
BEGIN
    -- Insere relacionamentos únicos entre perguntas e entregáveis
    INSERT IGNORE INTO perguntas_entregaveis (id_pergunta, id_entregavel)
    SELECT DISTINCT p.id_pergunta, e.id_entregavel
    FROM perguntas p
    JOIN entregaveis e 
        ON e.id_avaliacao = p.id_avaliacao
    WHERE e.id_entregavel = p_id_entregavel;
END //

DELIMITER ;
