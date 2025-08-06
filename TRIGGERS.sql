-- Trigger que é acionada sempre que um item é inserido em pedido
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
