-- -----------------------------------------------------
-- Arquivo: seed_data.sql
-- Descrição: Popula o banco de dados com dados fictícios
--            para simulação de uso real.
-- -----------------------------------------------------

-- 1. Inserindo ESCOLAS
INSERT INTO ESCOLAS (Esc_nome, Esc_endereco) VALUES 
('Faculdade Tecnológica Inova', 'Av. Paulista, 1000, São Paulo - SP'),
('Universidade Estadual do Saber', 'Rua dos Estudos, 500, Campinas - SP');

-- 2. Inserindo CURSOS
-- ID 1 e 2 na Escola 1, ID 3 na Escola 2
INSERT INTO CURSOS (Cur_periodo, Cur_nome, Esc_id) VALUES 
(3, 'Análise e Desenvolvimento de Sistemas', 1),
(5, 'Engenharia de Produção', 1),
(2, 'Direito', 2);

-- 3. Inserindo USUARIOS
INSERT INTO USUARIOS (usu_nome, usu_telefone, usu_matricula, usu_senha, usu_verificacao, usu_status, usu_email, usu_endereco, usu_endereco_geom, usu_horario_habitual) VALUES 
('Carlos Silva', '11999991111', 'MAT2023001', 'hash_senha_secreta_1', 1, 1, 'carlos.silva@aluno.inova.br', 'Rua das Flores, 123, Centro', '-23.5505,-46.6333', '07:30:00'),
('Mariana Souza', '11988882222', 'MAT2023002', 'hash_senha_secreta_2', 1, 1, 'mariana.souza@aluno.inova.br', 'Av. Brasil, 456, Jardins', '-23.5599,-46.6400', '07:45:00'),
('Pedro Santos', '19977773333', 'MAT2022099', 'hash_senha_secreta_3', 1, 1, 'pedro.santos@uni.saber.br', 'Rua da Paz, 88, Vila Nova', '-22.9056,-47.0608', '18:30:00'),
('Ana Oliveira', '11966664444', 'MAT2024001', 'hash_senha_secreta_4', 0, 0, 'ana.oliveira@email.com', 'Rua Torta, 10, Bairro Fim', '-23.5000,-46.6000', NULL);

-- 4. Inserindo USUARIOS_REGISTROS (1:1 com Usuarios)
INSERT INTO USUARIOS_REGISTROS (usuario_id, usu_data_login, usu_criado_em, usu_atualizado_em) VALUES 
(1, NOW(), '2023-01-15 10:00:00', NOW()),
(2, NOW(), '2023-02-20 14:30:00', NOW()),
(3, '2023-10-01 08:00:00', '2022-08-10 09:00:00', '2023-10-01 08:00:00'),
(4, NULL, NOW(), NULL);

-- 5. Inserindo DISPOSITIVOS
INSERT INTO DISPOSITIVOS (Usuario_id, Dis_plataforma, Dis_ultimoLogin, Dis_mac, Dis_status) VALUES 
(1, 1, NOW(), 'AA:BB:CC:11:22:33', 1), -- Android do Carlos
(2, 2, NOW(), 'DD:EE:FF:44:55:66', 1), -- iOS da Mariana
(3, 1, '2023-10-01 08:00:00', '11:22:33:AA:BB:CC', 1);

-- 6. Inserindo PERFIL
INSERT INTO PERFIL (Usu_id, Per_nome, Per_data) VALUES 
(1, 'Motorista', NOW()),
(2, 'Passageiro', NOW()),
(3, 'Motorista', NOW());

-- 7. Inserindo VEICULOS
-- Carlos (1) tem um carro, Pedro (3) tem uma moto
INSERT INTO VEICULOS (Usu_id, Vei_marca_modelo, Vei_tipo, Vei_cor, Vei_vagas, Vei_status, Vei_Criado_em) VALUES 
(1, 'Chevrolet Onix Plus', 1, 1, 4, 1, '2023-01-20'), -- Tipo 1=Carro, Cor 1=Vermelho (exemplo)
(3, 'Honda CG 160', 0, 2, 1, 1, '2022-08-15'); -- Tipo 0=Moto, Cor 2=Azul, Vagas=1

-- 8. Inserindo CURSOS_USUARIOS (Matrículas)
-- Carlos e Mariana fazem ADS (Curso 1), Pedro faz Direito (Curso 3)
INSERT INTO CURSOS_USUARIOS (Usu_id, Cur_id, Cur_usu_dataFinal) VALUES 
(1, 1, '2024-12-31'),
(2, 1, '2024-12-31'),
(3, 3, '2025-12-31');

-- 9. Inserindo CARONAS
-- Carlos (Usu_id 1) cria uma carona usando seu Carro (Vei_id 1) e sua matricula (Cur_usu_id 1)
INSERT INTO CARONAS (Vei_id, Cur_usu_id, Car_desc, Car_data, Car_hor_saida, Car_Vagas_dispo, Car_status) VALUES 
(1, 1, 'Ida para a faculdade - Saio do centro', '2023-10-30 07:30:00', '07:30:00', 3, 0), -- Status 0=Aberta
(3, 3, 'Volta para casa - Passo no mercado', '2023-10-30 18:00:00', '18:00:00', 1, 0); -- Pedro (Carro ID 2 na verdade é ID 2 da tabela veiculos, corrigido abaixo na logica, id autoincrement é 2 para o Pedro)

-- *CORREÇÃO LÓGICA DO INSERT ACIMA*: O ID do veículo do Pedro é 2.
-- Ajustando o insert correto para garantir integridade se rodar em lote:
DELETE FROM CARONAS WHERE Car_id > 0; -- Limpa para reinserir corretamente
ALTER TABLE CARONAS AUTO_INCREMENT = 1;

INSERT INTO CARONAS (Vei_id, Cur_usu_id, Car_desc, Car_data, Car_hor_saida, Car_Vagas_dispo, Car_status) VALUES 
(1, 1, 'Ida para a faculdade - Saio do centro', DATE_ADD(NOW(), INTERVAL 1 DAY), '07:30:00', 3, 0), 
(2, 3, 'Volta da faculdade para Vila Nova', DATE_ADD(NOW(), INTERVAL 1 DAY), '18:00:00', 1, 0);

-- 10. Inserindo PONTO_ENCONTROS
-- Para a Carona 1 (Carlos)
INSERT INTO PONTO_ENCONTROS (Car_id, Pon_endereco, Pon_edereco_geom, Pon_tipo, Pon_nome, Pon_status) VALUES 
(1, 'Rua das Flores, 123', '-23.5505,-46.6333', 0, 'Minha Casa', 1), -- Ponto do Motorista
(1, 'Metro Consolação', '-23.5599,-46.6600', 1, 'Estação Metrô', 1); -- Ponto de encontro para passageiros

-- 11. Inserindo SOLICITACOES_CARONA
-- Mariana (Usu_id 2) pede carona para Carlos (Car_id 1)
INSERT INTO SOLICITACOES_CARONA (Usu_id_passageiro, Car_id, Sol_status, Sol_vaga_soli) VALUES 
(2, 1, 1, 1); -- Status 1 = Aceito

-- 12. Inserindo CARONA_PESSOAS
-- Como a solicitação foi aceita, Mariana entra na tabela de passageiros da carona
INSERT INTO CARONA_PESSOAS (Car_id, Usu_id, Car_pes_data, Car_pes_status) VALUES 
(1, 2, NOW(), 0); -- Status 0 = Confirmado/Aceito

-- 13. Inserindo MENSAGENS
-- Chat na Carona 1 entre Mariana (2) e Carlos (1)
INSERT INTO MENSAGENS (Car_id, Usu_id_remetente, Usu_id_destinatario, Men_texto, Men_status, Men_id_resposta) VALUES 
(1, 2, 1, 'Olá Carlos, você vai passar perto do metrô?', 3, NULL), -- Status 3 = Lida
(1, 1, 2, 'Oi Mariana, sim! Passo na Consolação às 07:40.', 0, 1); -- Respondendo a msg 1

-- 14. Inserindo SUGESTAO_DENUNCIA
INSERT INTO SUGESTAO_DENUNCIA (Usu_id, Sug_texto, Sug_data, Sug_status, Sug_tipo, Sug_id_resposta, Sug_resposta) VALUES 
(2, 'Poderia ter um filtro por horário de saída mais específico.', NOW(), 1, 0, 1, 'Obrigado pela sugestão, vamos implementar!'); -- Tipo 0 = Sugestão