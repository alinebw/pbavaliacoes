DELIMITER $$

-- Ativar o event scheduler no MySQL
SET GLOBAL event_scheduler = ON$$

-- Criar um evento que roda duas vezes por dia para disparar a procedure
CREATE EVENT IF NOT EXISTS executar_atualizar_dados_avaliacao
ON SCHEDULE EVERY 12 HOUR
DO
BEGIN
    -- Variável local para armazenar o id_avaliacao durante o loop
    DECLARE v_id_avaliacao INT;

    DECLARE done INT DEFAULT FALSE;

    DECLARE cur CURSOR FOR SELECT id_avaliacao FROM avaliacoes WHERE id_turma IS NULL;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_avaliacao;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Executar a procedure para cada id_avaliacao que ainda não tem turma associada
        CALL atualizar_dados_avaliacao(v_id_avaliacao);
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;
