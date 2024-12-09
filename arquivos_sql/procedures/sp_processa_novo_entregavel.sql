DELIMITER //

CREATE PROCEDURE sp_processa_novo_entregavel (
    IN p_id_entregavel VARCHAR(255)
)
BEGIN
    DECLARE invalid_data BOOL DEFAULT FALSE;

    -- Verifica condições relacionadas ao ID e status do entregável
    IF NOT EXISTS (SELECT 1 FROM entregaveis WHERE id_entregavel = p_id_entregavel) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Entregável não encontrado.';
    ELSEIF EXISTS (SELECT 1 FROM entregaveis WHERE id_entregavel = p_id_entregavel AND status = 'PROCESSADO') THEN
        -- Não executa o processamento
        LEAVE sp_processa_novo_entregavel;
    END IF;

    -- Start Transaction
    START TRANSACTION;

    -- Verifica integridade dos dados
    SELECT 1 INTO invalid_data
    FROM entregaveis
    WHERE id_entregavel = p_id_entregavel
      AND (id_avaliacao IS NULL OR data_recebimento IS NULL);

    IF invalid_data THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Dados inválidos ou incompletos no entregável.';
    END IF;

    -- Preenche campo status
    UPDATE entregaveis
    SET
        data_processamento = NOW(),
        status = 'PROCESSADO'
    WHERE id_entregavel = p_id_entregavel;

    -- Insere um novo log de processamento com o status 'PROCESSADO'
    INSERT INTO log_processamento (id_entregavel, data_processamento, status, mensagem)
    VALUES (p_id_entregavel, NOW(), 'PROCESSADO', 'Dados processados com sucesso.');

    -- Commit Transaction
    COMMIT;

END//

DELIMITER ;
