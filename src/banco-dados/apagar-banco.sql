-- -----------------------------------------------------
-- Arquivo: drop_tables.sql
-- Descrição: Remove todas as tabelas do banco de dados
--            na ordem correta para evitar erros de FK.
-- -----------------------------------------------------

-- Opcional: Desativa verificação para forçar exclusão mesmo fora de ordem
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Nível 4: Tabelas que dependem de CARONAS (e Usuários)
DROP TABLE IF EXISTS MENSAGENS;
DROP TABLE IF EXISTS SOLICITACOES_CARONA;
DROP TABLE IF EXISTS CARONA_PESSOAS;
DROP TABLE IF EXISTS PONTO_ENCONTROS;

-- 2. Nível 3: Tabela CARONAS (Depende de VEICULOS e CURSOS_USUARIOS)
-- Já removemos quem dependia dela acima.
DROP TABLE IF EXISTS CARONAS;

-- 3. Nível 2: Tabelas intermediárias
-- CURSOS_USUARIOS depende de CURSOS e USUARIOS
DROP TABLE IF EXISTS CURSOS_USUARIOS;
-- VEICULOS depende de USUARIOS (e era usada por CARONAS)
DROP TABLE IF EXISTS VEICULOS;

-- 4. Nível 1: Tabelas que dependem apenas de USUARIOS ou ESCOLAS
DROP TABLE IF EXISTS CURSOS;             -- Depende de ESCOLAS
DROP TABLE IF EXISTS SUGESTAO_DENUNCIA;  -- Depende de USUARIOS
DROP TABLE IF EXISTS PERFIL;             -- Depende de USUARIOS
DROP TABLE IF EXISTS DISPOSITIVOS;       -- Depende de USUARIOS
DROP TABLE IF EXISTS USUARIOS_REGISTROS; -- Depende de USUARIOS

-- 5. Nível 0: Tabelas Raiz (Não dependem de ninguém, mas são referenciadas)
DROP TABLE IF EXISTS USUARIOS;
DROP TABLE IF EXISTS ESCOLAS;

-- Reativa a verificação de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 1;

-- Confirmação visual
SELECT "Todas as tabelas foram removidas com sucesso." AS Status;