DELIMITER //

CREATE PROCEDURE sp_processa_novo_entregavel (
    IN p_id_entregavel VARCHAR(45)
)
BEGIN
    DECLARE invalid_data BOOL DEFAULT FALSE;

    sp_processa_novo_entregavel_block: BEGIN
        -- Verifica condições relacionadas ao ID e status do entregável
        IF NOT EXISTS (SELECT 1 FROM entregaveis WHERE id_entregavel = p_id_entregavel) THEN
            -- Registra log informando que não há novos entregáveis
            INSERT INTO logs_processamento (id_entregavel, data_processamento, status, mensagem)
            VALUES (NULL, NOW(), 'NENHUM_ENTREGAVEL', 'Sem novos entregáveis para processar.');
            LEAVE sp_processa_novo_entregavel_block;
        ELSEIF EXISTS (SELECT 1 FROM entregaveis WHERE id_entregavel = p_id_entregavel AND status = 'PROCESSADO') THEN
            -- Não executa o processamento, mas registra log
            INSERT INTO logs_processamento (id_entregavel, data_processamento, status, mensagem)
            VALUES (p_id_entregavel, NOW(), 'IGNORADO', 'Entregável já processado anteriormente.');
            LEAVE sp_processa_novo_entregavel_block;
        END IF;

        -- Verifica integridade dos dados
        SELECT 1 INTO invalid_data
        FROM entregaveis
        WHERE id_entregavel = p_id_entregavel
          AND (id_avaliacao IS NULL OR data_recebimento IS NULL);

        IF invalid_data THEN
            -- Log de erro caso os dados estejam inválidos
            INSERT INTO logs_processamento (id_entregavel, data_processamento, status, mensagem)
            VALUES (p_id_entregavel, NOW(), 'ERRO', 'Dados inválidos ou incompletos no entregável.');
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Dados inválidos ou incompletos no entregável.';
        END IF;

        -- Atualiza status para PROCESSADO
        UPDATE entregaveis
        SET
            data_processamento = NOW(),
            status = 'PROCESSADO'
        WHERE id_entregavel = p_id_entregavel;

        -- Registra log de sucesso
        INSERT INTO logs_processamento (id_entregavel, data_processamento, status, mensagem)
        VALUES (p_id_entregavel, NOW(), 'PROCESSADO', 'Dados processados com sucesso.');
    END sp_processa_novo_entregavel_block;

END //

DELIMITER ;
