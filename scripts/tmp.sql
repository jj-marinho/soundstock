-- Bundle
CREATE TABLE Bundle (
    produto SERIAL RIMARY KEY,
    REFERENCES Produto(codigo) desconto NUMERIC(5, 2),
    preco_total NUMERIC (10, 2) NOT NULL
);
CREATE TABLE ProdutorBundle (
    produtor INTEGER REFERENCES Produtor(musico) bundle INTEGER REFERENCES Bundle(produto),
    CONSTRAINT ProdutorBundle_pk PRIMARY KEY(produtor, bundle)
);
CREATE TABLE BundleFaixa (
    bundle INTEGER REFERENCES Bundle(produto),
    faixa_audio INTEGER REFERENCES FaixaAudio(produto),
    CONSTRAINT BundleFaixa_pk PRIMARY KEY(bundle, faixa_audio)
);
-- Faixa de Áudio
CREATE TABLE FaixaAudio (
    produto SERIAL PRIMARY KEY,
    contrato INTEGER REFERENCES Bundle(produto) NOT NULL,
    preco NUMERIC (10, 2) NOT NULL,
    duracao INTEGER NOT NULL,
);

CREATE TABLE GeneroFaixa (
    faixa_audio INTEGER REFERENCES FaixaAudio(produto),
    genero VARCHAR(50) NOT NULL,
    CONSTRAINT GeneroFaixa_pk PRIMARY KEY(faixa_audio, genero)
);
CREATE TABLE IdiomaFaixa (
    faixa_audio INTEGER REFERENCES FaixaAudio(produto),
    idioma VARCHAR(50) NOT NULL,
    CONSTRAINT IdiomaFaixa_pk PRIMARY KEY(faixa_audio, idioma)
);


CREATE TABLE InstrumentoFaixa (
    faixa_audio INTEGER REFERENCES FaixaAudio(produto),
    instrumento VARCHAR(50) NOT NULL,
    CONSTRAINT InstrumentoFaixa_pk PRIMARY KEY(faixa_audio, instrumento)
);