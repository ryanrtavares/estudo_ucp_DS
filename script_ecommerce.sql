-- Exercícios Ecommerce
-- Aluno: Ryan Ramaldis Tavares


create table cliente (

	id SERIAL,
	nome VARCHAR(255) not null,
	cpf VARCHAR(255) not null,
	endereco VARCHAR not null

);


create table produto (

	id SERIAL,
	nome VARCHAR(255) not null,
	descricao VARCHAR(255) not null,
	preco decimal(10,2) not null

);

create table pedido (
    id SERIAL,
    cliente_id int not null,
    data_pedido date,
    status varchar(50) not null, 
    valor_total decimal(10, 2) not null
   
);

CREATE TABLE itens_pedido (
    id SERIAL,
    pedido_id int NOT NULL,
    produto_id int NOT NULL,
    quantidade int NOT null,
    preco_unitario decimal(10, 2) NOT NULL
    
);

CREATE TABLE pagamentos (
    id SERIAL,
    pedido_id int not null,
    data_pagamento date,
    valor decimal(10, 2) not null,
    metodo varchar(50) not null);
    
ALTER TABLE produto ADD PRIMARY KEY (id);
ALTER TABLE cliente ADD PRIMARY KEY (id);
ALTER TABLE pedido ADD PRIMARY KEY (id);
ALTER TABLE itens_pedido ADD PRIMARY KEY (id, pedido_id);
ALTER TABLE pagamentos ADD PRIMARY KEY (id);

ALTER TABLE pedido ADD CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id);

ALTER TABLE itens_pedido ADD CONSTRAINT fk_itens_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(id);

ALTER TABLE itens_pedido ADD CONSTRAINT fk_itens_produto FOREIGN KEY (produto_id) REFERENCES produto(id);

ALTER TABLE pagamentos ADD CONSTRAINT fk_pagamentos_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(id);

INSERT INTO cliente (nome, cpf, endereco) VALUES
('João da Silva', '111.111.111-11', 'Rua das Flores, 100, Centro'),
('Maria Souza', '222.222.222-22', 'Av. Principal, 50, Bairro Alto'),
('Pedro Alvares', '333.333.333-33', 'Alameda dos Anjos, 30, Vila Nova'),
('Ana Paula Santos', '444.444.444-44', 'Travessa Dez, 45, Boa Vista'),
('Carlos Rocha', '555.555.555-55', 'Estrada Velha, 789, Morro Azul');

INSERT INTO produto (nome, descricao, preco) VALUES
('Notebook Gamer', 'Notebook de alta performance para jogos', 5500.00),
('Mouse Sem Fio', 'Mouse ergonômico com tecnologia wireless', 85.50),
('Monitor 27 Polegadas', 'Monitor 4K com alta taxa de atualização', 1899.90),
('Teclado Mecânico', 'Teclado com switches azuis e layout ABNT2', 320.00),
('Webcam Full HD', 'Webcam para videoconferências de alta qualidade', 150.00);

INSERT INTO pedido (cliente_id, data_pedido, status, valor_total) VALUES
(1, CURRENT_DATE, 'Entregue', 5585.50),
(2, '2025-09-29', 'Enviado', 1899.90),
(3, '2025-09-25', 'Processando', 320.00),
(4, CURRENT_DATE, 'Pendente', 150.00),
(5, '2025-09-28', 'Entregue', 85.50);

INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 5500.00), 
(1, 2, 1, 85.50),   
(2, 3, 1, 1899.90), 
(3, 4, 1, 320.00),  
(4, 5, 1, 150.00);

INSERT INTO pagamentos (pedido_id, data_pagamento, valor, metodo) VALUES
(1, CURRENT_DATE, 5585.50, 'Cartão de Crédito'),
(2, '2025-09-29', 1899.90, 'Pix'),
(3, '2025-09-25', 320.00, 'Boleto'),
(4, CURRENT_DATE, 150.00, 'Cartão de Débito'),
(5, '2025-09-28', 85.50, 'Pix');

SELECT
    p.id AS pedido_id,
    p.data_pedido,
    c.nome AS nome_cliente
FROM
    pedido p
INNER JOIN
    cliente c ON p.cliente_id = c.id
ORDER BY
    p.data_pedido DESC;

SELECT
    c.nome AS nome_cliente,
    p.id AS pedido_id,
    p.status AS status_pedido
FROM
    cliente c
LEFT JOIN
    pedido p ON c.id = p.cliente_id
ORDER BY
    c.nome, p.data_pedido;

SELECT
    p.id AS pedido_id,
    p.data_pedido,
    pg.metodo AS metodo_pagamento,
    pg.valor AS valor_pago
FROM
    pedido p
RIGHT JOIN
    pagamentos pg ON p.id = pg.pedido_id
ORDER BY
    pg.data_pagamento DESC;

SELECT
    pe.id AS pedido_id,
    c.nome AS nome_cliente,
    pr.nome AS nome_produto,
    ip.quantidade
FROM
    pedido pe
INNER JOIN
    cliente c ON pe.cliente_id = c.id
INNER JOIN
    itens_pedido ip ON pe.id = ip.pedido_id
INNER JOIN
    produto pr ON ip.produto_id = pr.id
ORDER BY
    pe.id, pr.nome;

SELECT DISTINCT
    c.nome AS nome_cliente,
    p.valor_total
FROM
    cliente c
JOIN
    pedido p ON c.id = p.cliente_id
WHERE
    p.valor_total > (
        SELECT
            AVG(valor_total)
        FROM
            pedido
    )
ORDER BY
    p.valor_total DESC;  -- Não correlacionada
    
SELECT
    nome AS nome_produto,
    preco
FROM
    produto
WHERE
    id NOT IN (
        SELECT
            ip.produto_id  -- correlacionada
        FROM
            itens_pedido ip
        JOIN
            pedido p ON ip.pedido_id = p.id
        WHERE
            p.status = 'Entregue'
    )
ORDER BY
    nome_produto;


create view vw_entregue as 
SELECT
    id,
    cliente_id,
    valor_total,
    status
FROM
    pedido
WHERE
    status = 'Entregue';

select *
from pedido p 


    