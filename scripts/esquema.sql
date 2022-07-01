DROP TABLE IF EXISTS
    Usuario, Cartao, Administrador, Musico, GeneroMusico, Formacao, Portfolio, Experiencia, Servico, Produtor, PrestadorServico, SoftwareMixagem, SoftwareEdicao,
    ClasseVoz, IdiomaPrestador, Equipamento, InstrumentoPrestador, Contrato, FaixaAudio, GeneroFaixa, IdiomaFaixa, InstrumentoFaixa, Bundle, ProdutorBundle,
    BundleFaixa, Licenca, Produto, ProdutoLicenciado, Compra, CompraProduto
CASCADE;


-- Usuário

CREATE TABLE Usuario (
    id       SERIAL PRIMARY KEY,
    cpf      CHAR(14) NOT NULL UNIQUE CHECK(cpf ~ '^\d{3}\.\d{3}\.\d{3}\-\d{2}$'),
    email    VARCHAR(50) NOT NULL UNIQUE,
    nome     VARCHAR(50) NOT NULL,
    senha    VARCHAR(20) NOT NULL,
    endereco VARCHAR(50),
    telefone CHAR(15) CHECK(telefone ~ '^\(\d{2}\) \d{4, 5}\-\d{4}$')
);

CREATE TABLE Cartao (
    usuario    INTEGER REFERENCES Usuario(id) ON DELETE CASCADE,
    numero     NUMERIC(3),
    nome       VARCHAR(50),
    vencimento DATE CHECK(vencimento > CURRENT_DATE),

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
    avaliacao REAL -- TODO
);

CREATE TABLE GeneroMusico (
    musico INTEGER REFERENCES Musico(usuario) ON DELETE CASCADE,
    genero VARCHAR(20),

    CONSTRAINT GeneroMusico_pk PRIMARY KEY(musico, genero)
);

CREATE TABLE Formacao (
    musico      INTEGER REFERENCES Musico(usuario) ON DELETE CASCADE,
    curso       VARCHAR(20),
    instituicao VARCHAR(20),
    inicio      DATE NOT NULL,
    fim         DATE,

    CONSTRAINT Formacao_pk PRIMARY KEY(musico, curso, instatuicao)
);

CREATE TABLE Portfolio (
    musico INTEGER REFERENCES Musico(usuario) ON DELETE CASCADE,
    "url"  VARCHAR(100),

    CONSTRAINT Portfolio_pk PRIMARY KEY(musico, "url")
);

CREATE TABLE Experiencia (
    musico    INTEGER REFERENCES Musico(usuario) ON DELETE CASCADE,
    "local"   VARCHAR(30),
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

CREATE TYPE sexos AS ENUM('homem', 'mulher');

CREATE TABLE PrestadorServico (
    musico INTEGER PRIMARY KEY REFERENCES Musico(usuario) ON DELETE CASCADE,
    preco_medio NUMERIC(10, 2)
    sexo sexos,
);

CREATE TABLE SoftwareMixagem (
    prestador INTEGER REFERENCES PrestadorServico(musico) ON DELETE CASCADE,
    software VARCHAR(30),

    CONSTRAINT PK_SoftwareMixagem PRIMARY KEY(prestador, software)
);

CREATE TABLE SoftwareEdicao (
    prestador INTEGER REFERENCES PrestadorServico(musico) ON DELETE CASCADE,
    software VARCHAR(30),

    CONSTRAINT PK_SoftwareEdicao PRIMARY KEY(prestador, software)
);

CREATE TABLE ClasseVoz (
    prestador INTEGER REFERENCES PrestadorServico(musico) ON DELETE CASCADE,
    classe VARCHAR(30),

    CONSTRAINT PK_SoftwareClasse PRIMARY KEY(prestador, classe)
);

CREATE TABLE IdiomaPrestador (
    prestador INTEGER REFERENCES PrestadorServico(musico) ON DELETE CASCADE,
    idioma VARCHAR(30),

    CONSTRAINT PK_IdiomaPrestador PRIMARY KEY(prestador, idioma)
);

CREATE TABLE Equipamento (
    prestador INTEGER REFERENCES PrestadorServico(musico) ON DELETE CASCADE,
    equipamento VARCHAR(30),

    CONSTRAINT PK_Equipamento PRIMARY KEY(prestador, equipamento)
);

CREATE TABLE InstrumentoPrestador (
    prestador INTEGER REFERENCES PrestadorServico(musico) ON DELETE CASCADE,
    instrumento VARCHAR(30),

    CONSTRAINT PK_InstrumentoPrestador PRIMARY KEY(prestador, instrumento)
);


-- Contrato

CREATE TABLE Contrato (
    id        SERIAL PRIMARY KEY,
    produtor  INTEGER NOT NULL REFERENCES Produtor(musico),
    prestador INTEGER NOT NULL REFERENCES PrestadorServico(musico) CHECK(prestador != produtor),
    "data"    DATE DEFAULT CURRENT_DATE CHECK("data" <= CURRENT_DATE),
    valor     NUMERIC(10, 2) NOT NULL,
    duracao   INTERVAL NOT NULL,
    descricao TEXT NOT NULL,
    
    CONSTRAINT Contrato_un UNIQUE(produtor, prestador, "data")
);


-- Licença

CREATE TABLE Licenca (
    nome VARCHAR(30) PRIMARY KEY,
    criador INTEGER NOT NULL REFERENCES Administrador(usuario),
    resumo TEXT NOT NULL,
    descricao TEXT NOT NULL,
    ativa BOOLEAN NOT NULL
);


-- Produto

CREATE TYPE tipos AS ENUM('Faixa de Audio', 'Bundle');

CREATE TABLE Produto (
    codigo    SERIAL PRIMARY KEY,
    inclusao  DATE NOT NULL DEFAULT CURRENT_DATE CHECK(inclusao <= CURRENT_DATE),
    nome      VARCHAR(50) NOT NULL,
    tipo      tipos NOT NULL,
    preco     NUMERIC(10, 2),
    avaliacao real
);

CREATE TABLE ProdutoLicenciado (

);


-- Faixa de Áudio

CREATE TABLE FaixaAudio (

);

CREATE TABLE GeneroFaixa (

);

CREATE TABLE IdiomaFaixa (

);

CREATE TABLE InstrumentoFaixa (

);


-- Bundle

CREATE TABLE Bundle (

);

CREATE TABLE ProdutorBundle (

);

CREATE TABLE BundleFaixa (

);



-- Compra

CREATE TABLE Compra (

);

CREATE TABLE CompraProduto (

);
