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
    (3, 33333333, NULL),
    (4, 44444444, NULL),
    (5, 55555555, NULL),
    (6, 66666666, NULL),
    (7, 77777777, NULL),
    (8, 88888888, NULL);

INSERT INTO Genero_Musico VALUES 
    (3, 'Forro'),
    (4, 'Forro'),
    (5, 'Rock' ),
    (6, 'Forro'),
    (7, 'Rock' ),
    (7, 'Forro'),
    (8, 'Forro');

INSERT INTO Formacao VALUES 
    (3, 'Instituto Musical',   'Produção Músical', '2019-01-01', '2022-01-01'),
    (6, 'Instituto Musical',   'Canto',            '2021-01-01', '2022-01-01'),
    (8, 'Faculdade de Musica', 'Composição',       '2018-01-01', NULL        );

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
    (1, 100.00, 'Outro'    ),
    (4, 400.00, 'Masculino'),
    (5, 500.00, 'Masculino'),
    (6, 600.00, 'Feminino' ),
    (7, 700.00, 'Feminino' ),
    (8, 800.00, 'Feminino' );

INSERT INTO Software_Mixagem VALUES 
    (4, 'FL Studio'),
    (4, 'Logic Pro');

INSERT INTO Software_Edicao VALUES 
    (5, 'Waveform Pro'     ),
    (5, 'Magix Music Maker');

INSERT INTO Classe_Voz VALUES 
    (1,  'Tenor'        ),
    (6,  'Mezzo Soprano');

INSERT INTO Idioma_Prestador VALUES 
    (6, 'Ingles'   ),
    (6, 'Portugues'),
    (8, 'Portugues');

INSERT INTO Equipamento VALUES 
    (4, 'Behringer MX264'),
    (4, 'Yamaha MW10C'   );

INSERT INTO Instrumento_Prestador VALUES 
    (7, 'Sanfona'),
    (7, 'Zabumba');


INSERT INTO Contrato VALUES 
    (DEFAULT, 3, 6, DEFAULT,      500.00, '6 mons', 'Contrato de uma vocalista para produções por 6 meses'     ),
    (DEFAULT, 3, 7, DEFAULT,      700.00, '3 mons', 'Contrato de uma instrumentista para produções por 3 meses'),
    (DEFAULT, 3, 8, '2022-01-01', 900.00, '1 year', 'Contrato de uma compositora para produções por 1 ano'     );


INSERT INTO Licenca VALUES 
    ('Direitos reservados', 2, 'Comprador terá uso reservado das faixas',                     'Este contrato elenca as responsabilidades do comprador...',           DEFAULT),
    ('Direitos divididos',  2, 'Produtor, músicos e compradores tem direito sobre as faixas', 'Este contrato elenca as responsabilidades do comprador e músicos...', DEFAULT);


INSERT INTO Produto VALUES 
    (DEFAULT, DEFAULT, 'Melhores Xotes',          'Bundle',         5),
    (DEFAULT, DEFAULT, 'Melhores do Forró',       'Bundle',         5),
    (DEFAULT, DEFAULT, 'Xote da Alegria',         'Faixa de Audio', 5),
    (DEFAULT, DEFAULT, 'Rindo a Toa (A capella)', 'Faixa de Audio', 5),
    (DEFAULT, DEFAULT, 'Xote das Meninas',        'Faixa de Audio', 5),
    (DEFAULT, DEFAULT, 'Asas (Instrumental)',     'Faixa de Audio', 5);

INSERT INTO Produto_Licenciado VALUES 
    ('Direitos reservados', 1, 10000.00),
    ('Direitos divididos',  1, 2000.00 ),
    ('Direitos reservados', 2, 1200.00 ),
    ('Direitos divididos',  2, 350.00  ),
    ('Direitos divididos',  4, 200.00  ),
    ('Direitos divididos',  5, 300.00  );


INSERT INTO Faixa_Audio VALUES 
    (3, 100.00, '2 mins'        ),
    (4, 200.00, '3 mins 30 secs'),
    (5, 300.00, '2 mins 40 secs'),
    (6, 400.00, '3 mins'        );
    
INSERT INTO Genero_Faixa VALUES 
    (3, 'Forró'),
    (4, 'Forró'),
    (5, 'Forró'),
    (6, 'Forró');

INSERT INTO Idioma_Faixa VALUES 
    (3, 'Português'),
    (4, 'Português'),
    (5, 'Português'),

INSERT INTO Instrumento_Faixa VALUES 
    (3, 'Sanfona'),
    (5, 'Sanfona'),
    (6, 'Zabumba'),
    (6, 'Sanfona'),
    (6, 'Zabumba');
    
INSERT INTO Faixa_Contrato VALUES
    (3, 1),
    (3, 2),
    (3, 3),
    (4, 1),
    (4, 3),
    (5, 1),
    (5, 2),
    (5, 3),
    (6, 2);

INSERT INTO Bundle VALUES 
    (1, 30, 400.00 );
    (2, 40, 1000.00);

INSERT INTO Produtor_Bundle VALUES 
    (3, 1),
    (3, 2);

INSERT INTO Bundle_Faixa VALUES 
    (1, 1),
    (1, 3),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4);


INSERT INTO Compra VALUES
    (12345678901234, 1, DEFAULT, 'Cartao de Debito', 1000.00, 5.0, 'Produto muito bom, ótimas músicas'),
    (43210987654321, 1, DEFAULT, 'Cartao de Debito', 500.00,  NULL, NULL);

INSERT INTO Compra_Produto VALUES 
    (12345678901234, 'Direitos reservados', 1),
    (12345678901234, 'Direitos divididos',  4),
    (12345678901234, 'Direitos divididos',  5);


COMMIT;
