-- Retorna o extrato das compras de um usuário
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
		where u.nome like '%' || nome_pesquisa || '%';
$$ language sql;

select * from verificar_extrato('Ana');

-- Verifica o total faturado em um produto e a quantidade de vendas
create or replace function verificar_faturamento(produto_pesquisa text) returns table(
	nome_produto text,
	preco_produto decimal,
	quantidade_vendida integer,
	faturamento decimal
) as $$
	select p.nome, p.preco, sum(ip.quantidade) as total_compras, (p.preco * sum(ip.quantidade)) from produtos p
		inner join itens_pedidos ip on ip.produto_id = p.id
		group by p.nome, p.preco
		having p.nome like '%' || produto_pesquisa || '%'
		order by total_compras desc;
$$ language sql;

select * from verificar_faturamento('Livro');

-- Verificar pedidos com status pendente por cidade
create or replace function verificar_pedidos_pendentes(cidade_pesquisa text) returns table(
	nome_usuario text,
	endereco text,
	cidade text,
	estado text,
	status_pedido text
) as $$
	select u.nome, ee.endereco, ee.cidade, ee.estado, p.status from pedidos p
	inner join usuarios u on u.id = p.usuario_id
	inner join enderecos_entrega ee on ee.pedido_id = p.id
	where p.status in ('espera', 'rota_entrega')
	and ee.cidade ilike '%' || cidade_pesquisa || '%';
$$ language sql;

select * from verificar_pedidos_pendentes('Natal');