-- Mostra os usuários com pedidos em status de "espera"
CREATE OR REPLACE VIEW vw_usuarios_em_espera AS
	SELECT 
	  u.id AS usuario_id,
	  u.nome,
	  u.email,
	  p.id AS pedido_id,
	  p.status
	FROM usuarios u
	JOIN pedidos p ON u.id = p.usuario_id
	WHERE p.status = 'espera';

select * from vw_usuarios_em_espera;

-- Lista produtos com menos de 10 unidades no estoque
CREATE OR REPLACE VIEW vw_estoque_baixo AS
	SELECT 
	  id,
	  nome,
	  quantidade_estoque
	FROM produtos
	WHERE quantidade_estoque < 10;

select * from vw_estoque_baixo;