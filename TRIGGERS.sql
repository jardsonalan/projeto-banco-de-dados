-- Trigger que é acionada sempre que um item é inserido em pedido
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


