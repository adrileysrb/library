BEGIN;

INSERT INTO EDITORA (NOME) VALUES
('EDITORA A'),
('EDITORA B'),
('EDITORA C');

INSERT INTO nacionalidade (nome) VALUES
  ('Brasileiro'),
  ('Argentino'),
  ('Chileno');

INSERT INTO autor (nome, id_nacionalidade) VALUES
  ('Autor 1', 1),
  ('Autor 2', 2),
  ('Autor 3', 3);

INSERT INTO livro (titulo, id_editora, quantidade_total, quantidade_disponivel) VALUES
  ('Livro A', 1, 10, 8),
  ('Livro B', 2, 5, 5),
  ('Livro C', 3, 15, 12);

INSERT INTO usuario (nome, email, telefone, endereco) VALUES
  ('Usuário 1', 'usuario1@example.com', '123456789', 'Endereço 1'),
  ('Usuário 2', 'usuario2@example.com', '987654321', 'Endereço 2'),
  ('Usuário 3', 'usuario3@example.com', '123123123', 'Endereço 3');

INSERT INTO emprestimo (id_usuario, data_emprestimo, data_devolucao_prevista) VALUES
  (1, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 Week'),
  (2, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 Day'),
  (3, CURRENT_DATE, CURRENT_DATE + INTERVAL '96 Hours');

INSERT INTO emprestimo_livro (id_emprestimo, id_livro) VALUES
  (1, 1),
  (2, 2),
  (3, 3);

INSERT INTO livro_autor (id_livro, id_autor) VALUES
  (1, 1),
  (2, 2),
  (3, 3);

COMMIT;