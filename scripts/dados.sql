BEGIN;


INSERT INTO Usuario VALUES 
    (DEFAULT, '111.111.111-11', 'usuario@email.com',        'Usuario',        'senha', 'Cidade dos Usuarios',        '(11) 11111-1111'),
    (DEFAULT, '222.222.222-22', 'administrador@email.com',  'Administrador',  'senha', 'Cidade dos Administradores', '(22) 22222-2222'),
    (DEFAULT, '333.333.333-33', 'produtor@email.com',       'Produtor',       'senha', 'Cidade dos Produtores',      '(33) 33333-3333'),
    (DEFAULT, '444.444.444-44', 'mixagem@email.com',        'Mixagem',        'senha', 'Cidade das Mixagens',        '(44) 44444-4444'),
    (DEFAULT, '555.555.555-55', 'editor@email.com',         'Editor',         'senha', 'Cidade dos Editores',        '(55) 55555-5555'),
    (DEFAULT, '666.666.666-66', 'vocalista@email.com',      'Vocalista',      'senha', 'Cidade dos Vocalistas',      '(66) 66666-6666'),
    (DEFAULT, '777.777.777-77', 'instrumentista@email.com', 'Instrumentista', 'senha', 'Cidade dos Instrumentistas', '(77) 77777-7777'),
    (DEFAULT, '888.888.888-88', 'compositor@email.com',     'Compositor',     'senha', 'Cidade dos Compositores',    '(88) 88888-8888');

INSERT INTO Cartao VALUES 
    (1, 1111111111111111, 'USUARIO', '2025-01-01'),
    (1, 2222222222222222, 'USUARIO', '2025-01-01');


INSERT INTO Administrador VALUES 
    (1),
    (2);


INSERT INTO Musico VALUES 
    (1, 11111111, 5.0 ),
    (3, 33333333, 5.0 ),
    (4, 44444444, NULL),
    (5, 55555555, NULL),
    (6, 66666666, 5.0 ),
    (7, 77777777, 5.0 ),
    (8, 88888888, 5.0 );

INSERT INTO Genero_Musico VALUES 
    (1, 'Rock' ),
    (3, 'Forro'),
    (4, 'Forro'),
    (5, 'Rock' ),
    (6, 'Forro'),
    (7, 'Rock' ),
    (7, 'Forro'),
    (8, 'Forro');

INSERT INTO Formacao VALUES 
    (3, 'Instituto Musical',   'Producao Musical', '2019-01-01', '2022-01-01'),
    (6, 'Instituto Musical',   'Canto',            '2021-01-01', '2022-01-01'),
    (8, 'Faculdade de Musica', 'Composicao',       '2018-01-01', NULL        );

INSERT INTO Portfolio VALUES 
    (3, 'https://youtu.be/dQw4w9WgXcQ'),
    (3, 'https://youtu.be/091JASyKcB8'),
    (4, 'https://youtu.be/QDAHMMMtFBI');

INSERT INTO Experiencia VALUES 
    (5, 'Lollapalooza', '2020-01-01', '2020-12-31', NULL                     ),
    (7, 'Rock in Rio',  '2020-01-01', NULL,         'Trabalha no Rock in Rio');


INSERT INTO Servico VALUES 
    (1, 'Vocalista'            ),
    (1, 'Produtor'             ),
    (3, 'Produtor'             ),
    (4, 'Engenheiro de Mixagem'),
    (5, 'Editor'               ),
    (6, 'Vocalista'            ),
    (7, 'Instrumentista'       ),
    (8, 'Compositor'           );


INSERT INTO Produtor VALUES 
    (1),
    (3);


INSERT INTO Prestador_Servico VALUES 
    (1, 'Outro'    ),
    (4, 'Masculino'),
    (5, 'Masculino'),
    (6, 'Feminino' ),
    (7, NULL       ),
    (8, NULL       );

INSERT INTO Software_Mixagem VALUES 
    (4, 'FL Studio'),
    (4, 'Logic Pro');

INSERT INTO Software_Edicao VALUES 
    (5, 'Waveform Pro'     ),
    (5, 'Magix Music Maker');

INSERT INTO Classe_Voz VALUES 
    (1,  'Tenor'        ),
    (6,  'Mezzo Soprano');

INSERT INTO Idioma_Vocalista VALUES 
    (1, 'Ingles'   ),
    (6, 'Ingles'   ),
    (6, 'Portugues');

INSERT INTO Idioma_Compositor VALUES 
    (8, 'Ingles'   ),
    (8, 'Portugues');

INSERT INTO Equipamento VALUES 
    (4, 'Behringer MX264'),
    (4, 'Yamaha MW10C'   );

INSERT INTO Instrumento_Prestador VALUES 
    (7, 'Sanfona' ),
    (7, 'Guitarra');


INSERT INTO Contrato VALUES 
    (DEFAULT, 1, 7, DEFAULT,      7000.00,  '3 mons', 'Contrato de um instrumentista para produções...'),
    (DEFAULT, 3, 7, DEFAULT,      10000.00, '6 mons', 'Contrato de um instrumentista para produções...'),
    (DEFAULT, 3, 6, DEFAULT,      6000.00,  '6 mons', 'Contrato de um vocalista para produções...'     ),
    (DEFAULT, 3, 8, '2022-01-01', 8000.00,  '1 year', 'Contrato de um compositor para produções...'    );


INSERT INTO Licenca VALUES 
    ('Direitos reservados', 2, 'Comprador terá uso reservado das faixas',                     'Este contrato elenca as responsabilidades do comprador...',           TRUE),
    ('Direitos divididos',  2, 'Produtor, músicos e compradores tem direito sobre as faixas', 'Este contrato elenca as responsabilidades do comprador e músicos...', TRUE);


INSERT INTO Produto VALUES 
    (DEFAULT, DEFAULT, 'Xote da Alegria',       'Faixa de Audio', 100.00, NULL),
    (DEFAULT, DEFAULT, 'Xote das Meninas',      'Faixa de Audio', 200.00, NULL),
    (DEFAULT, DEFAULT, 'Rindo a Toa A capella', 'Faixa de Audio', 300.00, 5.0 ),
    (DEFAULT, DEFAULT, 'Asas Instrumental',     'Faixa de Audio', 400.00, 5.0 ),
    (DEFAULT, DEFAULT, 'Melhores Xotes',        'Bundle',         270.00, NULL),
    (DEFAULT, DEFAULT, 'Melhores do Forró',     'Bundle',         600.00, NULL);

INSERT INTO Produto_Licenciado VALUES 
    ('Direitos reservados', 1),
    ('Direitos divididos',  1),
    ('Direitos reservados', 3),
    ('Direitos divididos',  4),
    ('Direitos divididos',  5),
    ('Direitos divididos',  6);


INSERT INTO Faixa_Audio VALUES 
    (1, '2 mins'        ),
    (2, '3 mins 30 secs'),
    (3, '2 mins 40 secs'),
    (4, '3 mins'        );
    
INSERT INTO Genero_Faixa VALUES 
    (1, 'Forró'),
    (2, 'Forró'),
    (3, 'Forró'),
    (4, 'Forró'),
    (4, 'Rock' );

INSERT INTO Idioma_Faixa VALUES 
    (1, 'Português'),
    (2, 'Português'),
    (3, 'Português');

INSERT INTO Instrumento_Faixa VALUES 
    (1, 'Sanfona' ),
    (2, 'Sanfona' ),
    (4, 'Sanfona' ),
    (4, 'Guitarra');
    
INSERT INTO Faixa_Contrato VALUES
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 2),
    (2, 3),
    (2, 4),
    (3, 3),
    (3, 4),
    (4, 1);


INSERT INTO Bundle VALUES 
    (5, 10.00),
    (6, 40.00);

INSERT INTO Produtor_Bundle VALUES 
    (3, 5),
    (3, 6),
    (1, 6);

INSERT INTO Bundle_Faixa VALUES 
    (5, 1),
    (5, 2),
    (6, 1),
    (6, 2),
    (6, 3),
    (6, 4);


INSERT INTO Compra VALUES
    (11111111111111, 1, DEFAULT, 'Cartao de Credito', 700.00, 5.0, 'Produtos muito bons, ótimas músicas'),
    (22222222222222, 2, DEFAULT, 'Boleto',            570.00, NULL, NULL                                );

INSERT INTO Compra_Produto VALUES 
    (11111111111111, 'Direitos reservados', 3),
    (11111111111111, 'Direitos divididos',  4),
    (22222222222222, 'Direitos reservados', 3),
    (22222222222222, 'Direitos divididos',  5);


COMMIT;
