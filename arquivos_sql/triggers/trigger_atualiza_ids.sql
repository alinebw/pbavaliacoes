DELIMITER $$

CREATE EVENT IF NOT EXISTS evt_atualiza_ids_relacionados
ON SCHEDULE EVERY 6 HOUR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    CALL atualiza_ids_relacionados_batch();
END$$

DELIMITER ;



