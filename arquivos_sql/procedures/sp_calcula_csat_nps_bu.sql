DELIMITER //

CREATE PROCEDURE sp_calcula_csat_nps_bu ()
BEGIN
    UPDATE business_unities bu
    SET 
        csat_bu = (
            SELECT AVG(a.csat_avaliacao)
            FROM avaliacoes a
            WHERE a.id_bu = bu.id_bu
        ),
        nps_bu = (
            SELECT AVG(a.nps)
            FROM avaliacoes a
            WHERE a.id_bu = bu.id_bu
        );
END //

DELIMITER ;
