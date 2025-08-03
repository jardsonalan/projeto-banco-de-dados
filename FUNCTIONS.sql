-- Retorna o extrato das compras de um usuário específico
create or replace function verificar_extrato(nome_pesquisa text) returns table(
	nome_usuario text,
	metodo_pagamento text,
	status_pagamento text,
	nome_produto text,
	valor_produto decimal,
	quantidade integer
) as $$
	select u.nome, pg.metodos_pagamento, pg.status, prod.nome, prod.preco, ip.quantidade from usuarios u
		inner join pedidos p on p.usuario_id = u.id
		inner join pagamentos pg on pg.pedido_id = p.id
		inner join itens_pedidos ip on ip.pedido_id = p.id
		inner join produtos prod on prod.id = ip.produto_id
		where u.nome ilike '%' || nome_pesquisa || '%';
$$ language sql;

select * from verificar_extrato('Ana');

-- Verifica o total faturado em um produto e a quantidade de vendas
create or replace function verificar_faturamento() returns table(
	nome_produto text,
	preco_produto decimal,
	quantidade_vendida integer,
	faturamento decimal
) as $$
	select p.nome, p.preco, sum(ip.quantidade) as total_compras, (p.preco * sum(ip.quantidade)) from produtos p
		inner join itens_pedidos ip on ip.produto_id = p.id
		group by p.nome, p.preco
		order by total_compras desc;
$$ language sql;

select * from verificar_faturamento();