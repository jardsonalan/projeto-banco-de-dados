-- Mostra os usuários com pedidos em rota de entrega
SELECT u.nome FROM usuarios u 
WHERE u.id IN (SELECT p.usuario_id  
	FROM pedidos p 
	WHERE p.status = 'rota_entrega');

-- Mostra os usuários e a quantidade de pedidos em espera de cada um
SELECT u.nome, (SELECT count(p.status) 
	FROM pedidos p 
	WHERE p.status = 'espera' AND u.id = p.usuario_id  
	GROUP BY p.usuario_id) AS pedidos_em_espera
FROM usuarios u;

-- Mostra o valor gasto de um usuário em específico
SELECT u.nome, (SELECT SUM(valor_pagamento)
	FROM pagamentos p
	WHERE p.pedido_id IN (SELECT s.id 
		FROM pedidos s
		WHERE s.usuario_id = u.id)) AS total_gasto
FROM usuarios u
WHERE u.id = 1; -- [ID DO USUÁRIO]