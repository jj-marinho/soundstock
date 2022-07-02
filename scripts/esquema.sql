DROP TABLE IF EXISTS
    Usuario, Cartao, Administrador, Musico, Genero_Musico, Formacao, Portfolio, Experiencia, Servico, Produtor, Prestador_Servico, Software_Mixagem, Software_Edicao,
    Classe_Voz, Idioma_Prestador, Equipamento, Instrumento_Prestador, Contrato, Faixa_Audio, Genero_Faixa, Idioma_Faixa, Instrumento_Faixa, Bundle, Produtor_Bundle,
    Bundle_Faixa, Licenca, Produto, Produto_Licenciado, Compra, Compra_Produto
CASCADE;

DROP TYPE IF EXISTS servicos, sexos, classes, tipos, formas CASCADE;



-- Usuário

CREATE TABLE Usuario (
    id       SERIAL PRIMARY KEY,
    cpf      CHAR(14) NOT NULL UNIQUE CHECK(cpf ~ '^\d{3}\.\d{3}\.\d{3}\-\d{2}$'),
    email    VARCHAR(50) NOT NULL UNIQUE,
    nome     VARCHAR(50) NOT NULL,
    senha    VARCHAR(50) NOT NULL,
    endereco VARCHAR(50),
    telefone CHAR(15) CHECK(telefone ~ '^\(\d{2}\) \d{4, 5}\-\d{4}$')
);

CREATE TABLE Cartao (
    usuario    INTEGER REFERENCES Usuario(id) ON DELETE CASCADE,
    numero     NUMERIC(16),
    nome       VARCHAR(50) NOT NULL,
    vencimento DATE NOT NULL CHECK(vencimento > CURRENT_DATE),

    CONSTRAINT Cartao_pk PRIMARY KEY(usuario, numero)
);


-- Administrador

CREATE TABLE Administrador (
    usuario INTEGER PRIMARY KEY REFERENCES Usuario(id) ON DELETE CASCADE
);


-- Músico

CREATE TABLE Musico (
    usuario   INTEGER PRIMARY KEY REFERENCES Usuario(id) ON DELETE CASCADE,
    omb       NUMERIC(8) NOT NULL UNIQUE,
    avaliacao NUMERIC(3, 2) CHECK(avaliacao BETWEEN 0 AND 5)
);

CREATE TABLE Genero_Musico (
    musico INTEGER REFERENCES Musico(usuario) ON DELETE CASCADE,
    genero VARCHAR(50),

    CONSTRAINT Genero_Musico_pk PRIMARY KEY(musico, genero)
);

CREATE TABLE Formacao (
    musico      INTEGER REFERENCES Musico(usuario) ON DELETE CASCADE,
    curso       VARCHAR(50),
    instituicao VARCHAR(50),
    inicio      DATE NOT NULL,
    fim         DATE,

    CONSTRAINT Formacao_pk PRIMARY KEY(musico, curso, instituicao)
);

CREATE TABLE Portfolio (
    musico INTEGER REFERENCES Musico(usuario) ON DELETE CASCADE,
    "url"  VARCHAR(100),

    CONSTRAINT Portfolio_pk PRIMARY KEY(musico, "url")
);

CREATE TABLE Experiencia (
    musico    INTEGER REFERENCES Musico(usuario) ON DELETE CASCADE,
    "local"   VARCHAR(50),
    inicio    DATE CHECK(inicio <= CURRENT_DATE),
    fim       DATE,
    descricao TEXT,

    CONSTRAINT Experiencia_pk PRIMARY KEY(musico, "local", inicio)
);


-- Serviços

CREATE TYPE servicos AS ENUM('Produtor', 'Engenheiro de Mixagem', 'Editor', 'Vocalista', 'Instrumentista', 'Compositor');

CREATE TABLE Servico (
    musico  INTEGER REFERENCES Musico(usuario) ON DELETE CASCADE,
    servico servicos,

    CONSTRAINT Servico_pk PRIMARY KEY(musico, servico)
);


-- Produtor

CREATE TABLE Produtor (
    musico INTEGER PRIMARY KEY REFERENCES Musico(usuario) ON DELETE CASCADE
);


-- Prestador de Serviço

CREATE TYPE sexos AS ENUM('Masculino', 'Feminino', 'Outro');

CREATE TABLE Prestador_Servico (
    musico INTEGER PRIMARY KEY REFERENCES Musico(usuario) ON DELETE CASCADE,
    preco  NUMERIC(10, 2),
    sexo   sexos NOT NULL
);

CREATE TABLE Software_Mixagem (
    prestador INTEGER REFERENCES Prestador_Servico(musico) ON DELETE CASCADE,
    software  VARCHAR(50),

    CONSTRAINT Software_Mixagem_pk PRIMARY KEY(prestador, software)
);

CREATE TABLE Software_Edicao (
    prestador INTEGER REFERENCES Prestador_Servico(musico) ON DELETE CASCADE,
    software  VARCHAR(50),

    CONSTRAINT Software_Edicao_pk PRIMARY KEY(prestador, software)
);

CREATE TYPE classes AS ENUM('Baixo', 'Baritono', 'Tenor', 'Contralto', 'Mezzo Soprano', 'Soprano');

CREATE TABLE Classe_Voz (
    prestador INTEGER REFERENCES Prestador_Servico(musico) ON DELETE CASCADE,
    classe    classes,

    CONSTRAINT Software_Classe_pk PRIMARY KEY(prestador, classe)
);

CREATE TABLE Idioma_Prestador (
    prestador INTEGER REFERENCES Prestador_Servico(musico) ON DELETE CASCADE,
    idioma    VARCHAR(50),

    CONSTRAINT Idioma_Prestador_pk PRIMARY KEY(prestador, idioma)
);

CREATE TABLE Equipamento (
    prestador   INTEGER REFERENCES Prestador_Servico(musico) ON DELETE CASCADE,
    equipamento VARCHAR(50),

    CONSTRAINT Equipamento_pk PRIMARY KEY(prestador, equipamento)
);

CREATE TABLE Instrumento_Prestador (
    prestador   INTEGER REFERENCES Prestador_Servico(musico) ON DELETE CASCADE,
    instrumento VARCHAR(50),

    CONSTRAINT Instrumento_Prestador_pk PRIMARY KEY(prestador, instrumento)
);


-- Contrato

CREATE TABLE Contrato (
    id        SERIAL PRIMARY KEY,
    produtor  INTEGER REFERENCES Produtor(musico),
    prestador INTEGER REFERENCES Prestador_Servico(musico) CHECK(prestador != produtor),
    "data"    TIMESTAMP DEFAULT NOW() CHECK("data" <= NOW()),
    valor     NUMERIC(10, 2) NOT NULL,
    duracao   INTERVAL NOT NULL,
    descricao TEXT NOT NULL,
    
    CONSTRAINT Contrato_un UNIQUE(produtor, prestador, "data")
);


-- Licença

CREATE TABLE Licenca (
    nome      VARCHAR(50) PRIMARY KEY,
    criador   INTEGER NOT NULL REFERENCES Administrador(usuario),
    resumo    TEXT NOT NULL,
    descricao TEXT NOT NULL,
    ativa     BOOLEAN DEFAULT TRUE NOT NULL
);


-- Produto

CREATE TYPE tipos AS ENUM('Faixa de Audio', 'Bundle');

CREATE TABLE Produto (
    codigo    SERIAL PRIMARY KEY,
    inclusao  DATE NOT NULL DEFAULT CURRENT_DATE CHECK(inclusao <= CURRENT_DATE),
    nome      VARCHAR(50) NOT NULL,
    tipo      tipos NOT NULL,
    preco     NUMERIC(10, 2),
    avaliacao NUMERIC(3, 2) CHECK(avaliacao BETWEEN 0 AND 5)
);

CREATE TABLE Produto_Licenciado (
    licenca VARCHAR(50) REFERENCES Licenca(nome) ON DELETE CASCADE,
    produto INTEGER REFERENCES Produto(codigo) ON DELETE CASCADE,

    CONSTRAINT Produto_Licenciado_pk PRIMARY KEY(licenca, produto)
);


-- Faixa de Áudio

CREATE TABLE Faixa_Audio (
    produto  INTEGER PRIMARY KEY REFERENCES Produto(codigo) ON DELETE CASCADE,
    contrato INTEGER NOT NULL REFERENCES Contrato(id),
    preco    NUMERIC (10, 2) NOT NULL,
    duracao  INTERVAL NOT NULL
);

CREATE TABLE Genero_Faixa (
    faixa  INTEGER REFERENCES Faixa_Audio(produto) ON DELETE CASCADE,
    genero VARCHAR(50),

    CONSTRAINT Genero_Faixa_pk PRIMARY KEY(faixa, genero)
);


CREATE TABLE Idioma_Faixa (
    faixa  INTEGER REFERENCES Faixa_Audio(produto) ON DELETE CASCADE,
    idioma VARCHAR(50),

    CONSTRAINT Idioma_Faixa_pk PRIMARY KEY(faixa, idioma)
);

CREATE TABLE Instrumento_Faixa (
    faixa       INTEGER REFERENCES Faixa_Audio(produto) ON DELETE CASCADE,
    instrumento VARCHAR(50),

    CONSTRAINT Instrumento_Faixa_pk PRIMARY KEY(faixa, instrumento)
);


-- Bundle

CREATE TABLE Bundle (
    produto  INTEGER PRIMARY KEY REFERENCES Produto(codigo) ON DELETE CASCADE,
    desconto NUMERIC(10, 2) NOT NULL CHECk(desconto BETWEEN 0 AND 100),
    preco    NUMERIC (10, 2) NOT NULL
);

CREATE TABLE Produtor_Bundle (
    produtor INTEGER REFERENCES Produtor(musico) ON DELETE CASCADE,
    bundle   INTEGER REFERENCES Bundle(produto) ON DELETE CASCADE,

    CONSTRAINT Produtor_Bundle_pk PRIMARY KEY(produtor, bundle)
);

CREATE TABLE Bundle_Faixa (
    bundle INTEGER REFERENCES Bundle(produto) ON DELETE CASCADE,
    faixa  INTEGER REFERENCES Faixa_Audio(produto) ON DELETE CASCADE,

    CONSTRAINT Bundle_Faixa_pk PRIMARY KEY(bundle, faixa)
);


-- Compra

CREATE TYPE formas AS ENUM('Cartao de Credito', 'Cartao de Debito', 'Boleto', 'Pix');

CREATE TABLE Compra (
    nota_fiscal NUMERIC(14) PRIMARY KEY,
    comprador   INTEGER NOT NULL REFERENCES Usuario(id),
    "data"      TIMESTAMP DEFAULT NOW() NOT NULL,
    forma       formas NOT NULL,
    valor       NUMERIC(10, 2) NOT NULL,
    avaliacao   NUMERIC(5, 2) CHECK(avaliacao BETWEEN 0 AND 5),
    comentario  TEXT
);

CREATE TABLE Compra_Produto (
    compra  NUMERIC(14) REFERENCES Compra(nota_fiscal) ON DELETE CASCADE,
    licenca VARCHAR(50),
    produto INTEGER,

    CONSTRAINT Compra_Produto_pk PRIMARY KEY(compra, licenca, produto),
    CONSTRAINT Compra_Produto_fk FOREIGN KEY (licenca, produto) REFERENCES Produto_Licenciado(licenca, produto)
);
