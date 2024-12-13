-- Procedure cast respostas da view perguntas_respostas

DELIMITER //

CREATE PROCEDURE sp_cast_respostas(
    IN p_id_entregavel VARCHAR(45)
)
BEGIN
    DECLARE v_csat_consultor DECIMAL(5, 2) DEFAULT NULL;
    DECLARE v_csat_evento DECIMAL(5, 2) DEFAULT NULL;
    DECLARE v_nps DECIMAL(5, 2) DEFAULT NULL;
    DECLARE v_nps_status ENUM('PROMOTOR', 'NEUTRO', 'DETRATOR');
    DECLARE v_csat_conteudo_opcao VARCHAR(20) DEFAULT NULL; -- Para armazenar o texto completo
    DECLARE v_csat_conteudo_opcao_online VARCHAR(20) DEFAULT NULL;
    DECLARE v_plataforma_acessivel VARCHAR(3) DEFAULT NULL;
    DECLARE v_tipo_avaliacao VARCHAR(20) DEFAULT NULL;
    DECLARE v_comentario_obrigatorio TEXT DEFAULT ''; -- Valor padrão vazio
    DECLARE v_comentario_opcional TEXT DEFAULT NULL;
    DECLARE v_nome_respondente VARCHAR(100) DEFAULT NULL;

    -- Pega os valores da view
    SELECT 
        MAX(CASE WHEN ref = 'csat_consultor' THEN CAST(valor_resposta AS DECIMAL(5, 2)) END),
        MAX(CASE WHEN ref = 'csat_evento' THEN CAST(valor_resposta AS DECIMAL(5, 2)) END),
        MAX(CASE WHEN ref = 'nps' THEN CAST(valor_resposta AS DECIMAL(5, 2)) END),
        MAX(CASE WHEN ref = 'csat_conteudo' THEN texto_resposta END),
        MAX(CASE WHEN ref = 'extra' THEN texto_resposta END),
        MAX(CASE WHEN ref = 'comentario_obrigatorio' THEN texto_resposta END),
        MAX(CASE WHEN ref = 'comentario_opcional' THEN texto_resposta END),
        MAX(CASE WHEN ref = 'nome' THEN texto_resposta END)
    INTO 
        v_csat_consultor, 
        v_csat_evento, 
        v_nps, 
        v_csat_conteudo_opcao, 
        v_plataforma_acessivel, 
        v_comentario_obrigatorio, 
        v_comentario_opcional, 
        v_nome_respondente
    FROM vw_perguntas_respostas
    WHERE id_entregavel = p_id_entregavel;
    
        -- Determina o tipo de avaliação
    IF v_plataforma_acessivel IS NOT NULL THEN
        SET v_tipo_avaliacao = 'Online';
    ELSE
        SET v_tipo_avaliacao = 'Presencial';
    END IF;

    -- Determina o status do NPS
    IF v_nps >= 9 THEN
        SET v_nps_status = 'PROMOTOR';
    ELSEIF v_nps BETWEEN 7 AND 8 THEN
        SET v_nps_status = 'NEUTRO';
    ELSEIF v_nps <= 6 THEN
        SET v_nps_status = 'DETRATOR';
    ELSE
        SET v_nps_status = NULL; -- Para casos de erro
    END IF;

    -- Atualiza os valores na tabela entregaveis
    UPDATE entregaveis
    SET
        csat_consultor = v_csat_consultor,
        csat_evento = v_csat_evento,
        nps = v_nps,
        nps_status = v_nps_status,
        csat_conteudo_opcao = v_csat_conteudo_opcao,
        plataforma_acessivel = v_plataforma_acessivel,
        tipo_avaliacao = v_tipo_avaliacao,
        comentario_obrigatorio = v_comentario_obrigatorio,
        comentario_opcional = v_comentario_opcional,
        nome_respondente = v_nome_respondente
    WHERE id_entregavel = p_id_entregavel;

END //

DELIMITER ;
