DELIMITER //

CREATE PROCEDURE sp_calcula_csat_nps_projeto ()
BEGIN
    UPDATE projetos p
    SET 
        csat_projeto = (
            SELECT AVG(a.csat_avaliacao)
            FROM avaliacoes a
            WHERE a.id_projeto = p.id_projeto
        ),
        nps_projeto = (
            SELECT AVG(a.nps)
            FROM avaliacoes a
            WHERE a.id_projeto = p.id_projeto
        );
END //

DELIMITER ;
