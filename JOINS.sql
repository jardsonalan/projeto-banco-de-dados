
-- 1. Listar todos os pedidos com nome do usuário e status
SELECT 
  p.id AS pedido_id,
  u.nome AS usuario,
  p.status,
  p.total
FROM pedidos p
JOIN usuarios u ON p.usuario_id = u.id;

-- 2. Listar produtos de cada pedido (com nome do produto, quantidade e valor unitário)
SELECT 
  p.id AS pedido_id,
  pr.nome AS produto,
  ip.quantidade,
  pr.preco AS preco_unitario,
  (ip.quantidade * pr.preco) AS subtotal
FROM pedidos p
JOIN itens_pedidos ip ON p.id = ip.pedido_id
JOIN produtos pr ON ip.produto_id = pr.id;

-- 3. Exibir os pagamentos realizados com nome do cliente, valor e método
SELECT 
  u.nome AS usuario,
  pg.valor_pagamento,
  pg.metodos_pagamento,
  pg.status
FROM pagamentos pg
JOIN pedidos p ON pg.pedido_id = p.id
JOIN usuarios u ON p.usuario_id = u.id;

-- 4. Listar pedidos com endereço de entrega completo
SELECT 
  u.nome AS usuario,
  p.id AS pedido_id,
  ee.endereco,
  ee.cidade,
  ee.estado,
  ee.caixa_postal,
  ee.pais
FROM enderecos_entrega ee
JOIN pedidos p ON ee.pedido_id = p.id
JOIN usuarios u ON ee.usuario_id = u.id;

-- 5. Listar todos os produtos com suas categorias
SELECT 
  pr.nome AS produto,
  pr.descricao,
  pr.preco,
  pr.quantidade_estoque,
  c.nome AS categoria
FROM produtos pr
JOIN categorias c ON pr.categoria_id = c.id;

-- 6. Listar total gasto por cada usuário em pedidos já entregues
SELECT 
  u.nome AS usuario,
  SUM(p.total) AS total_gasto
FROM pedidos p
JOIN usuarios u ON p.usuario_id = u.id
WHERE p.status = 'entregue'
GROUP BY u.nome;
