CREATE OR REPLACE FUNCTION get_total_registros() 
RETURNS INT AS $$
	BEGIN
		RETURN 10000;
	END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela EDITORA
DO $$ 
BEGIN 
    FOR i IN 1..get_total_registros() LOOP 
        INSERT INTO EDITORA (NOME) 
        VALUES ('Editora ' || i); 
    END LOOP; 
END; 
$$;

-- Inserindo dados na tabela NACIONALIDADE
DO $$ 
BEGIN 
    FOR i IN 1..get_total_registros() LOOP 
        INSERT INTO NACIONALIDADE (NOME) 
        VALUES ('Nacionalidade ' || i); 
    END LOOP; 
END; 
$$;

-- Inserindo dados na tabela AUTOR
DO $$ 
BEGIN 
    FOR i IN 1..get_total_registros() LOOP 
        INSERT INTO AUTOR (NOME, ID_NACIONALIDADE) 
        VALUES ('Autor ' || i, (SELECT ID FROM NACIONALIDADE ORDER BY RANDOM() LIMIT 1)); 
    END LOOP; 
END; 
$$;

-- Inserindo dados na tabela USUARIO
DO $$ 
BEGIN 
    FOR i IN 1..get_total_registros() LOOP 
        INSERT INTO USUARIO (NOME, EMAIL, TELEFONE, ENDERECO) 
        VALUES ('Usuário ' || i, 'usuario' || i || '@example.com', '1234-5678', 'Endereço ' || i); 
    END LOOP; 
END; 
$$;

-- Inserindo dados na tabela LIVRO
DO $$ 
BEGIN 
    FOR i IN 1..get_total_registros() LOOP 
        INSERT INTO LIVRO (NOME, ID_EDITORA, QUANTIDADE_TOTAL, QUANTIDADE_DISPONIVEL) 
        VALUES ('Livro ' || i, 
                (SELECT ID FROM EDITORA ORDER BY RANDOM() LIMIT 1), 
                100, 
                100); 
    END LOOP; 
END; 
$$;

-- Inserindo dados na tabela EMPRESTIMO
DO $$ 
BEGIN 
    FOR i IN 1..get_total_registros() LOOP 
        INSERT INTO EMPRESTIMO (ID_USUARIO, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA) 
        VALUES ( 
            (SELECT ID FROM USUARIO ORDER BY RANDOM() LIMIT 1), 
            CURRENT_DATE, 
            CURRENT_DATE + INTERVAL '1 day' * (RANDOM() * 30)::INT 
        ); 
    END LOOP; 
END; 
$$;

-- Inserindo dados na tabela EDICOES
DO $$ 
DECLARE
    v_inserted_count INT := 0;  -- Contador de inserções bem-sucedidas
    v_id_livro INT;
    v_nome_edicao VARCHAR(50);
BEGIN
    -- Enquanto o contador de inserções for menor que 10.000, continua tentando
    WHILE v_inserted_count < get_total_registros() LOOP
        -- Gera um ID de livro e um nome de edição
        SELECT ID INTO v_id_livro FROM LIVRO ORDER BY RANDOM() LIMIT 1;
        v_nome_edicao := 'Edição ' || (RANDOM() * 5 + 1)::INT;

        -- Verifica se a combinação (id_livro, nome_edicao) já existe
        IF NOT EXISTS (
            SELECT 1 
            FROM EDICOES
            WHERE ID_LIVRO = v_id_livro AND NOME_EDICAO = v_nome_edicao
        ) THEN
            -- Se não existe, realiza a inserção
            INSERT INTO EDICOES (ID_LIVRO, NOME_EDICAO, DATA_LANCAMENTO, QUANTIDADE)
            VALUES (
                v_id_livro,
                v_nome_edicao,
                CURRENT_DATE + INTERVAL '1 year' * (RANDOM() * 10)::INT,
                (RANDOM() * 50 + 1)::INT
            );

            -- Incrementa o contador de inserções bem-sucedidas
            v_inserted_count := v_inserted_count + 1;
        END IF;
    END LOOP;
END;
$$;



-- Inserindo dados na tabela EMPRESTIMO_LIVRO
DO $$ 
DECLARE
    inserted_count INT := 0;  -- Inicializa o contador de inserções
    v_id_emprestimo INT;
    v_id_livro INT;
    v_id_edicao INT;
BEGIN 
    -- Enquanto o contador de inserções for menor que 10.000, continua tentando
    WHILE inserted_count < get_total_registros() LOOP
        -- Seleciona os valores de ID_EMPRESTIMO, ID_LIVRO e ID_EDICAO
        SELECT ID INTO v_id_emprestimo FROM EMPRESTIMO ORDER BY RANDOM() LIMIT 1;
        SELECT ID INTO v_id_livro FROM LIVRO ORDER BY RANDOM() LIMIT 1;
        SELECT ID INTO v_id_edicao FROM EDICOES ORDER BY RANDOM() LIMIT 1;
        
        -- Verifica se a combinação de EMPRESTIMO, LIVRO e EDICAO já existe
        IF NOT EXISTS (
            SELECT 1 
            FROM EMPRESTIMO_LIVRO 
            WHERE ID_EMPRESTIMO = v_id_emprestimo
              AND ID_LIVRO = v_id_livro
              AND ID_EDICAO = v_id_edicao
        ) THEN
            -- Realiza a inserção com os valores armazenados nas variáveis
            INSERT INTO EMPRESTIMO_LIVRO (ID_EMPRESTIMO, ID_LIVRO, ID_EDICAO) 
            VALUES (v_id_emprestimo, v_id_livro, v_id_edicao);
            
            -- Incrementa o contador após uma inserção bem-sucedida
            inserted_count := inserted_count + 1;
        END IF;
    END LOOP; 
END; 
$$;

