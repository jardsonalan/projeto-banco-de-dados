-- 1. Percorre usuários e mostra quem tem mais de 2 pedidos em espera.
CREATE OR REPLACE FUNCTION verificar_pedidos_espera()
RETURNS void AS $$
DECLARE
    usuario_record RECORD;  -- Armazena temporariamente os dados de cada usuário
    cursor_usuarios CURSOR FOR
        SELECT u.id, u.nome
        FROM usuarios u;  -- Cursor para percorrer todos os usuários

    pedidos_espera_count INT;  -- Contador de pedidos com status 'espera'
BEGIN
    OPEN cursor_usuarios;  -- Abre o cursor

    LOOP
        FETCH cursor_usuarios INTO usuario_record;  -- Pega o próximo usuário
        EXIT WHEN NOT FOUND;  -- Sai do loop quando não houver mais registros

        SELECT COUNT(*) INTO pedidos_espera_count
        FROM pedidos
        WHERE usuario_id = usuario_record.id AND status = 'espera';  -- Conta os pedidos em espera

        IF pedidos_espera_count > 2 THEN
            RAISE NOTICE 'Usuário: %, Pedidos em espera: %', usuario_record.nome, pedidos_espera_count;
        END IF;  -- Exibe aviso se houver mais de 2 pedidos em espera
    END LOOP;

    CLOSE cursor_usuarios;  -- Fecha o cursor
END;
$$ LANGUAGE plpgsql;


-- 2. Percorre todos os pedidos com pagamentos em status "espera" e exibe: nome do usuário, 
-- valor do pagamento pendente, e status do pedido.
CREATE OR REPLACE FUNCTION verificar_pagamentos_pendentes()
RETURNS void AS $$
DECLARE
    pedido_record RECORD;  -- Armazena temporariamente os dados de cada pagamento pendente

    cursor_pagamentos_pendentes CURSOR FOR
        SELECT 
            u.nome AS usuario,
            p.id AS pedido_id,
            pg.valor_pagamento,
            pg.metodos_pagamento,
            pg.status AS status_pagamento,
            p.status AS status_pedido
        FROM pagamentos pg
        JOIN pedidos p ON pg.pedido_id = p.id
        JOIN usuarios u ON p.usuario_id = u.id
        WHERE pg.status = 'espera';  -- Seleciona apenas pagamentos em espera
BEGIN
    OPEN cursor_pagamentos_pendentes;

    LOOP
        FETCH cursor_pagamentos_pendentes INTO pedido_record;
        EXIT WHEN NOT FOUND;

        -- Exibe as informações do pagamento pendente
        RAISE NOTICE 
            'Usuário: %, Pedido: %, Valor pendente: R$ %, Método: %, Status Pagamento: %, Status Pedido: %',
            pedido_record.usuario,
            pedido_record.pedido_id,
            pedido_record.valor_pagamento,
            pedido_record.metodos_pagamento,
            pedido_record.status_pagamento,
            pedido_record.status_pedido;
    END LOOP;

    CLOSE cursor_pagamentos_pendentes;
END;
$$ LANGUAGE plpgsql;
