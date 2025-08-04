-- Atualiza dados de um usuário
create or replace procedure atualizar_dados_usuario(
	usuario_id integer,
	novo_nome text,
	novo_email text,
	nova_senha text
) as $$
	begin
		update usuarios
			set nome = novo_nome,
				email = novo_email,
				senha = nova_senha
		where usuarios.id = usuario_id;
	end;
$$ language plpgsql;

call atualizar_dados_usuario(20, 'Bruno Carvalho', 'bruno.carvalho@email.com', 'senha123');

-- Confirma o pagamento e atualiza o estado do pedido
create or replace procedure confirmar_pagamento(pagamento_id integer)
as $$
	declare
		pedido_id integer;
	begin
		update pagamentos
			set status = 'completo'
		where pagamentos.id = pagamento_id;

		select p.id into pedido_id from pedidos p where p.id in (
			select pg.pedido_id from pagamentos pg where pg.id = pagamento_id
		);

		update pedidos
			set status = 'rota_entrega'
		where pedidos.id = pedido_id;
	end;
$$ language plpgsql;

call confirmar_pagamento(4);