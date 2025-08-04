-- Enums
create type status_pedido as enum ('espera', 'rota_entrega', 'cancelado', 'entregue');
create type metodos_pagamento as enum ('cartao_credito', 'pix', 'boleto');
create type status_pagamento as enum ('espera', 'completo', 'falhou');

create table categorias (
	id serial primary key,
	nome varchar(100)
);

create table produtos (
	id serial primary key,
	nome varchar(150),
	descricao text,
	preco decimal(10, 2),
	quantidade_estoque integer,
	categoria_id integer not null,
	
	foreign key (categoria_id) references categorias(id)
	on delete cascade
	on update cascade
);

create table usuarios (
	id serial primary key,
	nome varchar(100),
	email varchar(100),
	senha varchar(250)
);

create table pedidos (
	id serial primary key,
	usuario_id integer not null,
	status status_pedido not null default 'espera',
	total decimal(10, 2),

	foreign key (usuario_id) references usuarios(id)
	on delete cascade
	on update cascade
);

create table itens_pedidos (
	id serial primary key,
	pedido_id integer not null,
	produto_id integer not null,
	quantidade integer,

	foreign key(pedido_id) references pedidos(id)
	on delete cascade
	on update cascade,

	foreign key(produto_id) references produtos(id)
	on delete cascade
	on update cascade
);

create table pagamentos (
	id serial primary key,
	pedido_id integer not null,
	metodos_pagamento metodos_pagamento not null default 'pix',
	status status_pagamento not null default 'espera',
	valor_pagamento decimal(10, 2),

	foreign key(pedido_id) references pedidos(id)
	on delete cascade
	on update cascade
);

create table enderecos_entrega (
	id serial primary key,
	usuario_id integer not null,
	pedido_id integer not null,
	endereco varchar(250),
	cidade varchar(150),
	estado varchar(150),
	caixa_postal varchar(20),
	pais varchar(150),

	foreign key(usuario_id) references usuarios(id)
	on delete cascade
	on update cascade,

	foreign key(pedido_id) references pedidos(id)
	on delete cascade
	on update cascade
);