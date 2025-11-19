-- -----------------------------------------------------
-- Arquivo: caronas_queries.sql
-- Descrição: Consultas de seleção simples e com JOINs
--            para o esquema de caronas.
-- -----------------------------------------------------

-- =====================================================
-- 1. Tabela ESCOLAS
-- =====================================================
-- Seleção Simples
SELECT * FROM ESCOLAS;

-- (Não possui chaves estrangeiras para JOIN)

-- =====================================================
-- 2. Tabela CURSOS
-- =====================================================
-- Seleção Simples
SELECT * FROM CURSOS;

-- Seleção com Relacionamento (Escola)
SELECT 
    c.Cur_id,
    c.Cur_nome,
    c.Cur_periodo,
    e.Esc_nome AS Nome_Escola
FROM CURSOS c
INNER JOIN ESCOLAS e ON c.Esc_id = e.Esc_id;

-- =====================================================
-- 3. Tabela USUARIOS
-- =====================================================
-- Seleção Simples
SELECT * FROM USUARIOS;

-- (Geralmente é a tabela "pai", mas podemos verificar relacionamentos inversos se necessário no futuro)

-- =====================================================
-- 4. Tabela USUARIOS_REGISTROS
-- =====================================================
-- Seleção Simples
SELECT * FROM USUARIOS_REGISTROS;

-- Seleção com Relacionamento (Usuário)
SELECT 
    ur.usuario_id,
    u.usu_nome,
    u.usu_email,
    ur.usu_criado_em,
    ur.usu_data_login
FROM USUARIOS_REGISTROS ur
INNER JOIN USUARIOS u ON ur.usuario_id = u.usu_id;

-- =====================================================
-- 5. Tabela DISPOSITIVOS
-- =====================================================
-- Seleção Simples
SELECT * FROM DISPOSITIVOS;

-- Seleção com Relacionamento (Usuário)
SELECT 
    d.dis_id,
    d.Dis_plataforma,
    d.Dis_mac,
    u.usu_nome AS Dono_Dispositivo
FROM DISPOSITIVOS d
INNER JOIN USUARIOS u ON d.Usuario_id = u.usu_id;

-- =====================================================
-- 6. Tabela PERFIL
-- =====================================================
-- Seleção Simples
SELECT * FROM PERFIL;

-- Seleção com Relacionamento (Usuário)
SELECT 
    p.Per_id,
    p.Per_nome,
    u.usu_nome AS Usuario,
    p.Per_data
FROM PERFIL p
INNER JOIN USUARIOS u ON p.Usu_id = u.usu_id;

-- =====================================================
-- 7. Tabela CURSOS_USUARIOS
-- =====================================================
-- Seleção Simples
SELECT * FROM CURSOS_USUARIOS;

-- Seleção com Relacionamento (Usuário e Curso)
SELECT 
    cu.Cur_usu_id,
    u.usu_nome AS Aluno,
    c.Cur_nome AS Curso,
    e.Esc_nome AS Escola,
    cu.Cur_usu_dataFinal
FROM CURSOS_USUARIOS cu
INNER JOIN USUARIOS u ON cu.Usu_id = u.usu_id
INNER JOIN CURSOS c ON cu.Cur_id = c.Cur_id
INNER JOIN ESCOLAS e ON c.Esc_id = e.Esc_id; -- Join extra para contexto

-- =====================================================
-- 8. Tabela SUGESTAO_DENUNCIA
-- =====================================================
-- Seleção Simples
SELECT * FROM SUGESTAO_DENUNCIA;

-- Seleção com Relacionamento (Usuário Autor e Usuário Resposta)
SELECT 
    sd.Sug_id,
    sd.Sug_tipo,
    sd.Sug_texto,
    u_autor.usu_nome AS Autor,
    sd.Sug_status,
    sd.Sug_resposta,
    u_resp.usu_nome AS Respondido_Por
FROM SUGESTAO_DENUNCIA sd
INNER JOIN USUARIOS u_autor ON sd.Usu_id = u_autor.usu_id
LEFT JOIN USUARIOS u_resp ON sd.Sug_id_resposta = u_resp.usu_id; -- LEFT JOIN pois resposta pode ser NULL

-- =====================================================
-- 9. Tabela VEICULOS
-- =====================================================
-- Seleção Simples
SELECT * FROM VEICULOS;

-- Seleção com Relacionamento (Dono)
SELECT 
    v.Vei_id,
    v.Vei_marca_modelo,
    v.Vei_cor,
    u.usu_nome AS Proprietario,
    v.Vei_vagas
FROM VEICULOS v
INNER JOIN USUARIOS u ON v.Usu_id = u.usu_id;

-- =====================================================
-- 10. Tabela CARONAS
-- =====================================================
-- Seleção Simples
SELECT * FROM CARONAS;

-- Seleção com Relacionamento (Veículo e Motorista via Curso_Usuario)
SELECT 
    c.Car_id,
    c.Car_desc,
    c.Car_data,
    c.Car_hor_saida,
    v.Vei_marca_modelo AS Veiculo,
    u.usu_nome AS Motorista,
    curso.Cur_nome AS Curso_Motorista
FROM CARONAS c
INNER JOIN VEICULOS v ON c.Vei_id = v.Vei_id
INNER JOIN CURSOS_USUARIOS cu ON c.Cur_usu_id = cu.Cur_usu_id
INNER JOIN USUARIOS u ON cu.Usu_id = u.usu_id
INNER JOIN CURSOS curso ON cu.Cur_id = curso.Cur_id;

-- =====================================================
-- 11. Tabela PONTO_ENCONTROS
-- =====================================================
-- Seleção Simples
SELECT * FROM PONTO_ENCONTROS;

-- Seleção com Relacionamento (Carona)
SELECT 
    pe.Pon_id,
    pe.Pon_nome,
    pe.Pon_endereco,
    pe.Pon_tipo, -- 0=Motorista, 1=Passageiro
    c.Car_desc AS Descricao_Carona,
    c.Car_data
FROM PONTO_ENCONTROS pe
INNER JOIN CARONAS c ON pe.Car_id = c.Car_id;

-- =====================================================
-- 12. Tabela MENSAGENS
-- =====================================================
-- Seleção Simples
SELECT * FROM MENSAGENS;

-- Seleção com Relacionamento (Carona, Remetente, Destinatário)
SELECT 
    m.Men_id,
    c.Car_desc AS Carona_Contexto,
    u_rem.usu_nome AS Remetente,
    u_dest.usu_nome AS Destinatario,
    m.Men_texto,
    m.Men_status
FROM MENSAGENS m
INNER JOIN CARONAS c ON m.Car_id = c.Car_id
INNER JOIN USUARIOS u_rem ON m.Usu_id_remetente = u_rem.usu_id
INNER JOIN USUARIOS u_dest ON m.Usu_id_destinatario = u_dest.usu_id;

-- =====================================================
-- 13. Tabela SOLICITACOES_CARONA
-- =====================================================
-- Seleção Simples
SELECT * FROM SOLICITACOES_CARONA;

-- Seleção com Relacionamento (Passageiro e Carona)
SELECT 
    s.Sol_id,
    u.usu_nome AS Passageiro_Solicitante,
    c.Car_desc AS Carona_Solicitada,
    c.Car_data AS Data_Carona,
    s.Sol_status,
    s.Sol_vaga_soli
FROM SOLICITACOES_CARONA s
INNER JOIN USUARIOS u ON s.Usu_id_passageiro = u.usu_id
INNER JOIN CARONAS c ON s.Car_id = c.Car_id;

-- =====================================================
-- 14. Tabela CARONA_PESSOAS
-- =====================================================
-- Seleção Simples
SELECT * FROM CARONA_PESSOAS;

-- Seleção com Relacionamento (Passageiro Confirmado e Carona)
SELECT 
    cp.Car_pes_id,
    u.usu_nome AS Passageiro,
    c.Car_desc AS Carona,
    cp.Car_pes_data AS Data_Entrada,
    cp.Car_pes_status
FROM CARONA_PESSOAS cp
INNER JOIN USUARIOS u ON cp.Usu_id = u.usu_id
INNER JOIN CARONAS c ON cp.Car_id = c.Car_id;