--
-- Table structure for table `avaliacoes`
--

DROP TABLE IF EXISTS `avaliacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avaliacoes` (
  `id_avaliacao` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_checklist` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_avaliacao` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo_avaliacao` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `csat_avaliacao` decimal(5,2) DEFAULT NULL,
  `total_entregaveis` int DEFAULT '0',
  `total_participantes` int DEFAULT '0',
  `status` enum('Backlog','Em andamento','Encerrada') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Backlog',
  `csat_conteudo` decimal(5,2) DEFAULT NULL,
  `csat_consultor` decimal(5,2) DEFAULT NULL,
  `csat_evento` decimal(5,2) DEFAULT NULL,
  `nps_avaliacao` decimal(5,2) DEFAULT NULL,
  `perc_promotores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de promotores na avaliação',
  `perc_neutros` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de neutros na avaliação',
  `perc_detratores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de detratores na avaliação',
  `response_a` int DEFAULT '0' COMMENT 'Percentual de respostas A (presencial)',
  `response_b` int DEFAULT '0' COMMENT 'Percentual de respostas B (presencial)',
  `response_c` int DEFAULT '0' COMMENT 'Percentual de respostas C (presencial)',
  `response_d` int DEFAULT '0' COMMENT 'Percentual de respostas D (presencial)',
  `response_media` int DEFAULT '0' COMMENT 'Média percentual das respostas (presencial)',
  `response_yes_online` int DEFAULT '0' COMMENT 'Percentual de respostas Sim (online)',
  `response_no_online` int DEFAULT '0' COMMENT 'Percentual de respostas Não (online)',
  `response_a_online` int DEFAULT '0' COMMENT 'Percentual de respostas A (online)',
  `response_b_online` int DEFAULT '0' COMMENT 'Percentual de respostas B (online)',
  `response_c_online` int DEFAULT '0' COMMENT 'Percentual de respostas C (online)',
  `response_d_online` int DEFAULT '0' COMMENT 'Percentual de respostas D (online)',
  `response_media_online` int DEFAULT '0' COMMENT 'Média percentual das respostas (online)',
  PRIMARY KEY (`id_avaliacao`),
  KEY `idx_avaliacoes_checklist` (`id_checklist`),
  KEY `idx_avaliacoes_status` (`status`),
  KEY `idx_avaliacoes_csat_avaliacao` (`csat_avaliacao`),
  KEY `idx_avaliacoes_idchecklist_idavaliacao` (`id_checklist`,`id_avaliacao`),
  KEY `idx_avaliacoes_nps_avaliacao` (`nps_avaliacao`),
  KEY `idx_avaliacoes_csat_conteudo` (`csat_conteudo`),
  KEY `idx_avaliacoes_csat_evento` (`csat_evento`),
  KEY `idx_avaliacoes_csat_consultor` (`csat_consultor`),
  CONSTRAINT `fk_avaliacoes_checklists` FOREIGN KEY (`id_checklist`) REFERENCES `checklists` (`id_checklist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `business_unities`
--

DROP TABLE IF EXISTS `business_unities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_unities` (
  `id_bu` int unsigned NOT NULL AUTO_INCREMENT,
  `nome_bu` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `csat_bu` decimal(5,2) DEFAULT NULL,
  `perc_promotores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de promotores na unidade de negócio',
  `perc_neutros` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de neutros na unidade de negócio',
  `perc_detratores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de detratores na unidade de negócio',
  PRIMARY KEY (`id_bu`),
  UNIQUE KEY `nome_bu` (`nome_bu`),
  KEY `idx_business_unities_csat_bu` (`csat_bu`),
  KEY `idx_business_unities_nome_bu` (`nome_bu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `checklists`
--

DROP TABLE IF EXISTS `checklists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checklists` (
  `id_checklist` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nome_checklist` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_projeto` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `csat_checklist` decimal(5,2) DEFAULT NULL,
  `total_entregaveis` int DEFAULT '0',
  `perc_promotores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de promotores do checklist',
  `perc_neutros` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de neutros do checklist',
  `perc_detratores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de detratores do checklist',
  PRIMARY KEY (`id_checklist`),
  KEY `idx_checklists_projeto` (`id_projeto`),
  KEY `idx_checklists_csat_checklist` (`csat_checklist`),
  KEY `idx_checklists_idprojeto_idchecklist` (`id_projeto`,`id_checklist`),
  KEY `idx_checklists_nome_checklist` (`nome_checklist`),
  CONSTRAINT `fk_checklists_projetos` FOREIGN KEY (`id_projeto`) REFERENCES `projetos` (`id_projeto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_cliente` int NOT NULL DEFAULT '0',
  `nome_cliente` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nome_bu` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `csat_cliente` decimal(5,2) DEFAULT NULL,
  `perc_promotores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de promotores do cliente',
  `perc_neutros` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de neutros do cliente',
  `perc_detratores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de detratores do cliente',
  PRIMARY KEY (`id_cliente`),
  KEY `idx_clientes_csat_cliente` (`csat_cliente`),
  KEY `idx_clientes_id_bu` (`nome_bu`),
  KEY `idx_clientes_nome_cliente` (`nome_cliente`),
  CONSTRAINT `fk_clientes_nome_bu` FOREIGN KEY (`nome_bu`) REFERENCES `business_unities` (`nome_bu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clientes_projetos`
--

DROP TABLE IF EXISTS `clientes_projetos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes_projetos` (
  `id_cliente` int NOT NULL DEFAULT '0',
  `id_projeto` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_cliente`,`id_projeto`),
  KEY `idx_clientes_projetos_idcliente_idprojeto` (`id_cliente`,`id_projeto`),
  KEY `idx_clientes_projetos_cliente` (`id_cliente`),
  KEY `idx_clientes_projetos_projeto` (`id_projeto`),
  CONSTRAINT `clientes_projetos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  CONSTRAINT `fk_clientes_projetos_projetos` FOREIGN KEY (`id_projeto`) REFERENCES `projetos` (`id_projeto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entregaveis`
--

DROP TABLE IF EXISTS `entregaveis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entregaveis` (
  `id_entregavel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_avaliacao` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_recebimento` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `csat_entregavel` decimal(5,2) DEFAULT NULL,
  `nome_respondente` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nps` decimal(5,2) DEFAULT NULL COMMENT 'Pontuação NPS do entregável',
  `csat_conteudo` decimal(5,2) DEFAULT NULL COMMENT 'Nota CSAT do conteúdo para o entregável',
  `csat_consultor` decimal(5,2) DEFAULT NULL COMMENT 'Nota CSAT do consultor para o entregável',
  `csat_evento` decimal(5,2) DEFAULT NULL COMMENT 'Nota CSAT do evento para o entregável',
  `nps_status` enum('Promotor','Neutro','Detrator') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Classificação do NPS do entregável',
  `comentario_obrigatorio` text COLLATE utf8mb4_unicode_ci COMMENT 'Comentário obrigatório do formulário',
  `comentario_opcional` text COLLATE utf8mb4_unicode_ci COMMENT 'Comentário opcional do formulário',
  `media_csat` decimal(5,2) DEFAULT NULL COMMENT 'Média geral de CSAT do entregável calculada com base nas notas específicas',
  `status` enum('PENDENTE','PROCESSADO') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDENTE',
  `data_processamento` datetime DEFAULT NULL,
  `id_projeto` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_checklist` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `csat_conteudo_opcao` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `csat_conteudo_online_opcao` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `plataforma_acessivel` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Indica se a plataforma foi considerada acessível pelo respondente',
  `tipo_avaliacao` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Indica se a avaliação é Presencial ou Online',
  PRIMARY KEY (`id_entregavel`),
  KEY `idx_entregaveis_idavaliacao_identregavel` (`id_avaliacao`,`id_entregavel`),
  KEY `idx_entregaveis_nps` (`nps`),
  KEY `idx_entregaveis_csat_conteudo` (`csat_conteudo`),
  KEY `idx_entregaveis_csat_evento` (`csat_evento`),
  KEY `idx_entregaveis_data_recebimento` (`data_recebimento`),
  KEY `idx_entregaveis_csat_consultor` (`csat_consultor`),
  KEY `idx_entregaveis_csat_entregavel` (`csat_entregavel`),
  KEY `fk_entregavel_projeto` (`id_projeto`),
  CONSTRAINT `fk_entregavel_avaliacao` FOREIGN KEY (`id_avaliacao`) REFERENCES `avaliacoes` (`id_avaliacao`),
  CONSTRAINT `fk_entregavel_projeto` FOREIGN KEY (`id_projeto`) REFERENCES `projetos` (`id_projeto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logs_processamento`
--

DROP TABLE IF EXISTS `logs_processamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_processamento` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `id_entregavel` int NOT NULL,
  `data_processamento` datetime NOT NULL,
  `status` enum('PROCESSADO','RECEBIDO','RESPOSTAS_CAST','DADOS_COPIADOS','DADOS_ENVIADOS','ERRO') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensagem` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `perguntas`
--

DROP TABLE IF EXISTS `perguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perguntas` (
  `id_pergunta` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_avaliacao` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `texto_pergunta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_pergunta` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ordem` int NOT NULL,
  `ref` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_pergunta`,`id_avaliacao`),
  KEY `idx_perguntas_tipo_pergunta` (`tipo_pergunta`),
  KEY `idx_perguntas_tipo_id` (`tipo_pergunta`,`id_pergunta`),
  KEY `idx_perguntas_idpergunta_idavaliacao` (`id_pergunta`,`id_avaliacao`),
  KEY `idx_perguntas_idpergunta` (`id_pergunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `perguntas_entregaveis`
--

DROP TABLE IF EXISTS `perguntas_entregaveis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perguntas_entregaveis` (
  `id_pergunta` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_entregavel` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_pergunta`,`id_entregavel`),
  KEY `perguntas_entregaveis_identregavel` (`id_entregavel`),
  CONSTRAINT `perguntas_entregaveis_identregavel` FOREIGN KEY (`id_entregavel`) REFERENCES `entregaveis` (`id_entregavel`),
  CONSTRAINT `perguntas_entregaveis_idpergunta` FOREIGN KEY (`id_pergunta`) REFERENCES `perguntas` (`id_pergunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `projetos`
--

DROP TABLE IF EXISTS `projetos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projetos` (
  `id_projeto` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `nome_projeto` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `csat_projeto` decimal(5,2) DEFAULT NULL,
  `nome_bu` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `perc_promotores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de promotores no projeto',
  `perc_neutros` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de neutros no projeto',
  `perc_detratores` decimal(5,2) DEFAULT NULL COMMENT 'Percentual de detratores no projeto',
  PRIMARY KEY (`id_projeto`),
  KEY `idx_projetos_id_bu` (`nome_bu`),
  KEY `idx_projetos_csat_projeto` (`csat_projeto`),
  KEY `idx_projetos_idbu_idprojeto` (`nome_bu`,`id_projeto`),
  KEY `idx_projetos_nome_projeto` (`nome_projeto`),
  CONSTRAINT `fk_projetos_nome_bu` FOREIGN KEY (`nome_bu`) REFERENCES `business_unities` (`nome_bu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `respostas`
--

DROP TABLE IF EXISTS `respostas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respostas` (
  `id_resposta` int NOT NULL AUTO_INCREMENT,
  `id_entregavel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_pergunta` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_avaliacao` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_resposta` decimal(5,2) DEFAULT NULL COMMENT 'Valor numérico da resposta (para cálculos, como CSAT e NPS)',
  `texto_resposta` text COLLATE utf8mb4_unicode_ci COMMENT 'Texto da resposta (comentários ou respostas abertas)',
  `tipo_resposta` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tipo da resposta (choice, rating, texto, etc.)',
  `resposta_json` json DEFAULT NULL COMMENT 'Armazena a resposta completa no formato JSON para tipos como choice',
  `csat_conteudo` decimal(5,2) DEFAULT NULL COMMENT 'Conversão de resposta JSON para valores numéricos no tipo choice',
  `ref` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_resposta`),
  KEY `idx_respostas_entregavel` (`id_entregavel`),
  KEY `idx_respostas_pergunta_avaliacao` (`id_pergunta`,`id_avaliacao`),
  KEY `idx_respostas_identregavel_idpergunta` (`id_entregavel`,`id_pergunta`),
  KEY `idx_respostas_idavaliacao_identregavel` (`id_avaliacao`,`id_entregavel`),
  KEY `idx_respostas_valor_resposta` (`valor_resposta`),
  KEY `idx_respostas_tipo_valor` (`tipo_resposta`,`valor_resposta`),
  FULLTEXT KEY `idx_respostas_texto_resposta` (`texto_resposta`),
  CONSTRAINT `fk_respostas_entregavel` FOREIGN KEY (`id_entregavel`) REFERENCES `entregaveis` (`id_entregavel`),
  CONSTRAINT `fk_respostas_pergunta_avaliacao` FOREIGN KEY (`id_pergunta`, `id_avaliacao`) REFERENCES `perguntas` (`id_pergunta`, `id_avaliacao`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
