-- Trigger que é acionada sempre que um item é inserido em pedido
-- Decrementa a quantidade de produtos pedidos do estoque 
-- Ela ocorre após a inserção
CREATE OR REPLACE FUNCTION atualiza_estoque()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE produtos
		SET quantidade_estoque = quantidade_estoque - NEW.quantidade
	WHERE id = NEW.produto_id;

	RETURN NEW;
END 
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualiza_estoque AFTER INSERT ON itens_pedidos
FOR EACH ROW EXECUTE FUNCTION atualiza_estoque();

-- Trigger que é acionada sempre há a tentativa de adicionar um item em pedido
-- Caso não tenha produtos suficientes no estoque ele executa
-- Ela ocorre antes da inserção
CREATE OR REPLACE FUNCTION verifica_estoque()
RETURNS TRIGGER AS $$
BEGIN
	IF (SELECT quantidade_estoque FROM produtos WHERE id = NEW.produto_id) < NEW.quantidade THEN
		RAISE EXCEPTION 'Estoque insuficiente para produto %', NEW.produto_id;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_estoque BEFORE INSERT ON itens_pedidos
FOR EACH ROW EXECUTE FUNCTION verifica_estoque();

-- Trigger que é acionada sempre que há tentativa de pagamento de um pedido
-- Caso o pedido já tenha sido pagado ela executa
-- Ela ocorre antes da inserção
CREATE OR REPLACE FUNCTION evitar_pagamento_duplicado()
RETURNS trigger AS $$
BEGIN
	IF EXISTS (SELECT 1 FROM pagamentos WHERE pedido_id = NEW.pedido_id) THEN
		RAISE EXCEPTION 'Pagamento já registrado para o pedido %', NEW.pedido_id;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER evitar_pagamento_duplicado BEFORE INSERT ON pagamentos
FOR EACH ROW EXECUTE FUNCTION evitar_pagamento_duplicado();
