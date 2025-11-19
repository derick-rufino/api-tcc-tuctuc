use bd_tcc_des_125_caronas;

-- -----------------------------------------------------
-- Arquivo: caronas_schema.sql
-- Descrição: Comandos SQL para criação das tabelas e
--             relacionamentos no esquema de caronas.
-- Ambiente: MySQL Workbench
-- -----------------------------------------------------

-- Desativa a verificação de chaves estrangeiras temporariamente para permitir
-- a exclusão e recriação das tabelas sem problemas de dependência.
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- 1. Tabela ESCOLAS (Quadro 6)
-- -----------------------------------------------------
DROP TABLE IF EXISTS ESCOLAS;
CREATE TABLE ESCOLAS (
    Esc_id INT(5) NOT NULL AUTO_INCREMENT COMMENT 'Identificador da Escola (PK)',
    Esc_nome VARCHAR(255) NOT NULL COMMENT 'Nome da Escola',
    Esc_endereco VARCHAR(255) NOT NULL COMMENT 'Endereço escolar',
    PRIMARY KEY (Esc_id)
) ENGINE = InnoDB;
-- Definindo o AUTO_INCREMENT para INT(5) como uma boa prática, embora MySQL use INT (10) por padrão.


-- -----------------------------------------------------
-- 2. Tabela CURSOS (Quadro 5)
-- -----------------------------------------------------
DROP TABLE IF EXISTS CURSOS;
CREATE TABLE CURSOS (
    Cur_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do Curso (PK)',
    Cur_periodo TINYINT NOT NULL COMMENT 'Período/Módulo (1, 2, 3...)',
    Cur_nome VARCHAR(255) NOT NULL COMMENT 'Nome do Curso',
    Esc_id INT(5) NOT NULL COMMENT 'Identificador da Escola (FK)',
    PRIMARY KEY (Cur_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 3. Tabela USUARIOS (Quadro 1)
-- -----------------------------------------------------
DROP TABLE IF EXISTS USUARIOS;
CREATE TABLE USUARIOS (
    usu_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do Usuário (PK)',
    usu_nome VARCHAR(80) NOT NULL COMMENT 'Nome do Usuário',
    usu_foto VARCHAR(100) COMMENT 'Foto do Usuário (NULL)',
    usu_telefone VARCHAR(11) NOT NULL COMMENT 'Telefone de Contato',
    usu_matricula VARCHAR(100) NOT NULL COMMENT 'Foto/Comprovante da Matrícula',
    usu_senha VARCHAR(50) NOT NULL COMMENT 'Senha de acesso',
    usu_verificacao TINYINT(1) NOT NULL COMMENT 'Status de verificação (0=Não Verificado, 1=Verificado)',
    usu_status TINYINT(1) NOT NULL COMMENT 'Status de Atividade (0=Inativo, 1=Ativo)',
    usu_email VARCHAR(180) NOT NULL UNIQUE COMMENT 'Email Institucional para acesso (UNIQUE)',
    usu_descricao VARCHAR(255) COMMENT 'Descrição do Usuário (NULL)',
    usu_endereco VARCHAR(255) NOT NULL COMMENT 'Endereço Descrito',
    usu_endereco_geom VARCHAR(255) NOT NULL COMMENT 'Endereço com localização geométrica',
    usu_horario_habitual TIME COMMENT 'Horários Habituais (NULL) (HH:MM:SS)',
    PRIMARY KEY (usu_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 4. Tabela USUARIOS_REGISTROS (Quadro 2 - Metadados)
-- A chave primária é também a chave estrangeira (1:1 com USUARIOS)
-- -----------------------------------------------------
DROP TABLE IF EXISTS USUARIOS_REGISTROS;
CREATE TABLE USUARIOS_REGISTROS (
    usuario_id INT NOT NULL COMMENT 'Identificador do Usuário (PK e FK)',
    usu_data_login DATETIME COMMENT 'Data do Último Login (NULL, conforme Quadro 2)',
    usu_criado_em DATETIME NOT NULL COMMENT 'Data de Criação do Usuário',
    usu_atualizado_em DATETIME COMMENT 'Data de Última Atualização (NULL)',
    PRIMARY KEY (usuario_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 5. Tabela DISPOSITIVOS (Quadro 3)
-- -----------------------------------------------------
DROP TABLE IF EXISTS DISPOSITIVOS;
CREATE TABLE DISPOSITIVOS (
    dis_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do Dispositivo (PK)',
    Usuario_id INT NOT NULL COMMENT 'Identificador do Usuário (FK)',
    Dis_plataforma TINYINT NOT NULL COMMENT 'Plataforma (1=Android, 2=IOS, etc.)',
    Dis_ultimoLogin DATETIME COMMENT 'Data do Último Login (NULL)',
    Dis_mac VARCHAR(17) NOT NULL UNIQUE COMMENT 'Identificador físico (MAC Address, UNIQUE)',
    Dis_status TINYINT(1) NOT NULL COMMENT 'Status (0=Inativo, 1=Ativo)',
    PRIMARY KEY (dis_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 6. Tabela PERFIL (Quadro 7)
-- -----------------------------------------------------
DROP TABLE IF EXISTS PERFIL;
CREATE TABLE PERFIL (
    Per_id TINYINT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do Perfil (PK)',
    Usu_id INT NOT NULL COMMENT 'Identificador do Usuário (FK)',
    Per_nome VARCHAR(20) NOT NULL COMMENT 'Nome presente no Perfil',
    Per_data DATETIME NOT NULL COMMENT 'Data de Acesso ao Perfil',
    PRIMARY KEY (Per_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 7. Tabela CURSOS_USUARIOS (Quadro 4 - Tabela de Junção N:M)
-- -----------------------------------------------------
DROP TABLE IF EXISTS CURSOS_USUARIOS;
CREATE TABLE CURSOS_USUARIOS (
    Cur_usu_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da Inscrição (PK)',
    Usu_id INT NOT NULL COMMENT 'Identificador do Usuário (FK) (Renomeado de Usua_id)',
    Cur_id INT NOT NULL COMMENT 'Identificador do Curso (FK)',
    Cur_usu_dataFinal DATE NOT NULL COMMENT 'Data Final do Curso (aamm)',
    PRIMARY KEY (Cur_usu_id),
    UNIQUE KEY UQ_CursoUsuario (Usu_id, Cur_id) -- Garante que o usuário não se inscreva no mesmo curso 2x
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 8. Tabela SUGESTAO_DENUNCIA (Quadro 8)
-- -----------------------------------------------------
DROP TABLE IF EXISTS SUGESTAO_DENUNCIA;
CREATE TABLE SUGESTAO_DENUNCIA (
    Sug_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da Sugestão/Denúncia (PK)',
    Usu_id INT NOT NULL COMMENT 'Usuário que enviou (FK)',
    Sug_texto VARCHAR(255) NOT NULL COMMENT 'Conteúdo da Sugestão ou Denúncia',
    Sug_data DATETIME NOT NULL COMMENT 'Data de Envio',
    Sug_status TINYINT NOT NULL COMMENT 'Status (0=Aberto, 1=Fechado, 2=Em análise)',
    Sug_tipo TINYINT NOT NULL COMMENT 'Tipo de Notificação (Sugestão ou Denúncia)',
    Sug_id_resposta INT COMMENT 'Usuário que respondeu (FK, NULL)',
    Sug_resposta VARCHAR(255) COMMENT 'Resposta da sugestão (NULL)',
    PRIMARY KEY (Sug_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 9. Tabela VEICULOS (Quadro 9)
-- -----------------------------------------------------
DROP TABLE IF EXISTS VEICULOS;
CREATE TABLE VEICULOS (
    Vei_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do Veículo (PK)',
    Usu_id INT NOT NULL COMMENT 'Proprietário do Veículo (FK)',
    Vei_marca_modelo VARCHAR(100) NOT NULL COMMENT 'Descrição do veiculo',
    Vei_tipo TINYINT(1) NOT NULL COMMENT 'Tipo (0=Moto, 1=Carro)',
    Vei_cor TINYINT NOT NULL COMMENT 'Cor (1=vermelho, 2=azul, etc.)',
    Vei_vagas TINYINT NOT NULL COMMENT 'Capacidade de Vagas (1, 2, 3, 4, etc.)',
    Vei_status TINYINT(1) NOT NULL COMMENT 'Status (0=Ativo, 1=Inutilizado)',
    Vei_Criado_em DATE NOT NULL COMMENT 'Data de Criação',
    Vei_atualizado_em DATETIME COMMENT 'Data de atualização (NULL)',
    Vei_apagado_em DATETIME COMMENT 'Data de Remoção (NULL)',
    PRIMARY KEY (Vei_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 10. Tabela CARONAS (Quadro 10)
-- -----------------------------------------------------
DROP TABLE IF EXISTS CARONAS;
CREATE TABLE CARONAS (
    Car_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da Carona (PK)',
    Vei_id INT NOT NULL COMMENT 'Veículo utilizado na carona (FK)',
    Cur_usu_id INT NOT NULL COMMENT 'Inscrição do Usuário que oferece a carona (FK)',
    Car_desc VARCHAR(255) NOT NULL COMMENT 'Detalhes da carona',
    Car_data DATETIME NOT NULL COMMENT 'Data e hora da carona',
    Car_hor_saida TIME NOT NULL COMMENT 'Horário de saída',
    Car_Vagas_dispo TINYINT NOT NULL COMMENT 'Vagas no veículo para carona',
    Car_status TINYINT NOT NULL COMMENT 'Status (0=Aberta, 1=Em espera, 2=Cancelada, 3=Finalizada)',
    PRIMARY KEY (Car_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 11. Tabela PONTO_ENCONTROS (Quadro 11)
-- -----------------------------------------------------
DROP TABLE IF EXISTS PONTO_ENCONTROS;
CREATE TABLE PONTO_ENCONTROS (
    Pon_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do Ponto de Encontro (PK)',
    Car_id INT NOT NULL COMMENT 'Carona relacionada (FK)',
    Pon_endereco VARCHAR(255) NOT NULL COMMENT 'Endereço de Saída/Encontro (Descritivo)',
    Pon_edereco_geom VARCHAR(255) NOT NULL COMMENT 'Endereço de Saída/Encontro (Geométrico)',
    Pon_tipo TINYINT(1) NOT NULL COMMENT 'Tipo de localização (0=Motorista, 1=Passageiro)',
    Pon_nome VARCHAR(25) NOT NULL COMMENT 'Descrição do ponto de encontro',
    Pon_ordem TINYINT COMMENT 'Ordem dos Endereços (NULL)',
    Pon_status TINYINT(1) NOT NULL COMMENT 'Status (0=Usados, 1=Inativos)',
    PRIMARY KEY (Pon_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 12. Tabela MENSAGENS (Quadro 12)
-- -----------------------------------------------------
DROP TABLE IF EXISTS MENSAGENS;
CREATE TABLE MENSAGENS (
    Men_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da Mensagem (PK)',
    Car_id INT NOT NULL COMMENT 'Carona (Contexto da Conversa) (FK)',
    Usu_id_remetente INT NOT NULL COMMENT 'Remetente da Mensagem (FK)',
    Usu_id_destinatario INT NOT NULL COMMENT 'Destinatário da Mensagem (FK)',
    Men_texto VARCHAR(255) NOT NULL,
    Men_status TINYINT NOT NULL COMMENT 'Status (0=Enviada, 1=Não Lida, 2=Não Enviada, 3=Lida)',
    Men_id_resposta INT COMMENT 'Mensagem que esta sendo respondida (FK de auto-referência, NULL)',
    PRIMARY KEY (Men_id)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 13. Tabela SOLICITACOES_CARONA (Quadro 13)
-- -----------------------------------------------------
DROP TABLE IF EXISTS SOLICITACOES_CARONA;
CREATE TABLE SOLICITACOES_CARONA (
    Sol_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da Solicitação (PK)',
    Usu_id_passageiro INT NOT NULL COMMENT 'Passageiro Solicitante (FK)',
    Car_id INT NOT NULL COMMENT 'Carona Solicitada (FK)',
    Sol_status TINYINT NOT NULL COMMENT 'Status (0=Enviado, 1=Aceito, 2=Negado, 3=Cancelado)',
    Sol_vaga_soli TINYINT NOT NULL COMMENT 'Quantidade de vagas solicitadas',
    PRIMARY KEY (Sol_id),
    UNIQUE KEY UQ_Solicitacao (Usu_id_passageiro, Car_id) -- Garante apenas uma solicitação por carona/passageiro
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- 14. Tabela CARONA_PESSOAS (Quadro 14 - Participantes da Carona)
-- -----------------------------------------------------
DROP TABLE IF EXISTS CARONA_PESSOAS;
CREATE TABLE CARONA_PESSOAS (
    Car_pes_id INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da Pessoa na Carona (PK)',
    Car_id INT NOT NULL COMMENT 'Carona (FK)',
    Usu_id INT NOT NULL COMMENT 'Passageiro Participante (FK)',
    Car_pes_data DATETIME NOT NULL COMMENT 'Data de Inclusão na Carona',
    Car_pes_status TINYINT NOT NULL COMMENT 'Status (0=Aceito, 1=Negado, 2=Cancelado)',
    PRIMARY KEY (Car_pes_id),
    UNIQUE KEY UQ_CaronaPessoa (Car_id, Usu_id) -- Garante que o passageiro esteja na carona apenas uma vez
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Seção de Chaves Estrangeiras (FOREIGN KEYS)
-- -----------------------------------------------------

-- CURSOS
ALTER TABLE CURSOS
ADD CONSTRAINT FK_Cursos_Escolas
    FOREIGN KEY (Esc_id)
    REFERENCES ESCOLAS (Esc_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- USUARIOS_REGISTROS (1:1 com USUARIOS)
ALTER TABLE USUARIOS_REGISTROS
ADD CONSTRAINT FK_Registros_Usuarios
    FOREIGN KEY (usuario_id)
    REFERENCES USUARIOS (usu_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- DISPOSITIVOS
ALTER TABLE DISPOSITIVOS
ADD CONSTRAINT FK_Dispositivos_Usuarios
    FOREIGN KEY (Usuario_id)
    REFERENCES USUARIOS (usu_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- PERFIL
ALTER TABLE PERFIL
ADD CONSTRAINT FK_Perfil_Usuarios
    FOREIGN KEY (Usu_id)
    REFERENCES USUARIOS (usu_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- CURSOS_USUARIOS
ALTER TABLE CURSOS_USUARIOS
ADD CONSTRAINT FK_CursosUsuarios_Usuarios
    FOREIGN KEY (Usu_id)
    REFERENCES USUARIOS (usu_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
ADD CONSTRAINT FK_CursosUsuarios_Cursos
    FOREIGN KEY (Cur_id)
    REFERENCES CURSOS (Cur_id)
    ON DELETE RESTRICT -- Não apaga um curso se ele estiver sendo usado
    ON UPDATE CASCADE;

-- SUGESTAO_DENUNCIA
ALTER TABLE SUGESTAO_DENUNCIA
ADD CONSTRAINT FK_SugestaoDenuncia_UsuarioEnvio
    FOREIGN KEY (Usu_id)
    REFERENCES USUARIOS (usu_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
ADD CONSTRAINT FK_SugestaoDenuncia_UsuarioResposta
    FOREIGN KEY (Sug_id_resposta)
    REFERENCES USUARIOS (usu_id)
    ON DELETE SET NULL -- Se o usuário que respondeu for apagado, o campo fica NULL
    ON UPDATE CASCADE;

-- VEICULOS
ALTER TABLE VEICULOS
ADD CONSTRAINT FK_Veiculos_Usuarios
    FOREIGN KEY (Usu_id)
    REFERENCES USUARIOS (usu_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- CARONAS
ALTER TABLE CARONAS
ADD CONSTRAINT FK_Caronas_Veiculos
    FOREIGN KEY (Vei_id)
    REFERENCES VEICULOS (Vei_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
ADD CONSTRAINT FK_Caronas_CursosUsuarios
    FOREIGN KEY (Cur_usu_id)
    REFERENCES CURSOS_USUARIOS (Cur_usu_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- PONTO_ENCONTROS
ALTER TABLE PONTO_ENCONTROS
ADD CONSTRAINT FK_PontoEncontros_Caronas
    FOREIGN KEY (Car_id)
    REFERENCES CARONAS (Car_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- MENSAGENS
ALTER TABLE MENSAGENS
ADD CONSTRAINT FK_Mensagens_Carona
    FOREIGN KEY (Car_id)
    REFERENCES CARONAS (Car_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
ADD CONSTRAINT FK_Mensagens_Remetente
    FOREIGN KEY (Usu_id_remetente)
    REFERENCES USUARIOS (usu_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
ADD CONSTRAINT FK_Mensagens_Destinatario
    FOREIGN KEY (Usu_id_destinatario)
    REFERENCES USUARIOS (usu_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
ADD CONSTRAINT FK_Mensagens_Resposta
    FOREIGN KEY (Men_id_resposta)
    REFERENCES MENSAGENS (Men_id)
    ON DELETE SET NULL -- Auto-referência
    ON UPDATE CASCADE;

-- SOLICITACOES_CARONA
ALTER TABLE SOLICITACOES_CARONA
ADD CONSTRAINT FK_SolicitacoesCarona_Passageiro
    FOREIGN KEY (Usu_id_passageiro)
    REFERENCES USUARIOS (usu_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
ADD CONSTRAINT FK_SolicitacoesCarona_Carona
    FOREIGN KEY (Car_id)
    REFERENCES CARONAS (Car_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- CARONA_PESSOAS
ALTER TABLE CARONA_PESSOAS
ADD CONSTRAINT FK_CaronaPessoas_Carona
    FOREIGN KEY (Car_id)
    REFERENCES CARONAS (Car_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
ADD CONSTRAINT FK_CaronaPessoas_Usuario
    FOREIGN KEY (Usu_id)
    REFERENCES USUARIOS (usu_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- Reativa a verificação de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 1;