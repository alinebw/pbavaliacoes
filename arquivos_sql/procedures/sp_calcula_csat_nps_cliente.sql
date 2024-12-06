DELIMITER //

CREATE PROCEDURE sp_calcula_csat_nps_cliente ()
BEGIN
    UPDATE clientes cl
    SET 
        csat_cliente = (
            SELECT AVG(a.csat_avaliacao)
            FROM avaliacoes a
            WHERE a.id_cliente = cl.id_cliente
        ),
        nps_cliente = (
            SELECT AVG(a.nps)
            FROM avaliacoes a
            WHERE a.id_cliente = cl.id_cliente
        );
END //

DELIMITER ;
