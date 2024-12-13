DELIMITER //

CREATE PROCEDURE sp_processa_novo_entregavel_batch(
    IN batch_size INT
)
BEGIN
    DECLARE v_id_entregavel VARCHAR(45);
    DECLARE done INT DEFAULT FALSE;

    -- Cursor para buscar um lote de entregáveis pendentes
    DECLARE cur CURSOR FOR
    SELECT id_entregavel
    FROM entregaveis
    WHERE status = 'PENDENTE'
    LIMIT batch_size;

    -- Tratador para quando o cursor atingir o fim
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Abrir o cursor
    OPEN cur;

    process_loop: LOOP
        -- Buscar próximo id_entregavel
        FETCH cur INTO v_id_entregavel;

        -- Se não houver mais registros, encerrar o loop
        IF done THEN
            LEAVE process_loop;
        END IF;

        -- Processa o entregável individualmente
        CALL sp_processa_novo_entregavel(v_id_entregavel);
    END LOOP;

    -- Fechar o cursor
    CLOSE cur;
END //

DELIMITER ;


-- Event para evento em batch - corrigir nomes antes de subir para pbavaliacoes

DELIMITER //

CREATE EVENT evt_processa_entregaveis
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    CALL sp_processa_novo_entregavel_batch(30); -- Processa 30 registros por execução
END //

DELIMITER ;
