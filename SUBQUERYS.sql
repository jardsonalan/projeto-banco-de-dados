SELECT u.nome 
FROM usuarios u 
WHERE u.id IN (SELECT p.usuario_id  
				FROM pedidos p 
				WHERE p.status = 'rota_entrega');

SELECT u.nome, (SELECT count(p.status) 
	FROM pedidos p 
	WHERE p.status = 'espera' AND u.id = p.usuario_id  
	GROUP BY p.usuario_id) AS pedidos_em_spera
FROM usuarios u;

SELECT u.nome, (SELECT SUM(valor_pagamento)
	FROM pagamentos p
	WHERE p.pedido_id IN (SELECT s.id 
						FROM pedidos s
						WHERE s.usuario_id = u.id)) AS total_gasto
FROM usuarios u
WHERE u.id = 1;
