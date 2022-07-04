# O ID do Produtor foi fixado como sendo 3 nas queries para simular o fato de estar logado como tal Produtor.
PRODUTOR = 3


def insercao_faixa(nome, preco, duracao, contratos, generos, idiomas, instrumentos):
    comando =  f"DO $$ DECLARE                                                                                                                  \n"
    comando += f"    faixa INTEGER;                                                                                                             \n"
    comando += f"BEGIN                                                                                                                          \n"
    comando += f"    INSERT INTO Produto VALUES (DEFAULT, DEFAULT, '{nome}', 'Faixa de Audio', {preco :.2f}, NULL) RETURNING codigo INTO faixa; \n"
    comando += f"    INSERT INTO Faixa_Audio VALUES (faixa, '{duracao}');                                                                       \n"

    for contrato in contratos:       comando += f"    INSERT INTO Faixa_Contrato VALUES (faixa, {contrato});         \n"
    for genero in generos:           comando += f"    INSERT INTO Genero_Faixa VALUES (faixa, '{genero}');           \n"
    for idioma in idiomas:           comando += f"    INSERT INTO Idioma_Faixa VALUES (faixa, '{idioma}');           \n"
    for instrumento in instrumentos: comando += f"    INSERT INTO Instrumento_Faixa VALUES (faixa, '{instrumento}'); \n"

    return comando + "END $$"


def busca_faixa(nome = "", preco = (0, 99999999.99), duracao = ("0 secs", "178000000 years")):
    return f"""
        SELECT DISTINCT P.codigo, P.nome, P.preco, P.avaliacao, P.inclusao, F.duracao
            FROM Contrato C
            JOIN Faixa_Contrato FC ON C.id = FC.contrato
            JOIN Faixa_Audio    F  ON FC.faixa = F.produto
            JOIN Produto        P  ON F.produto = P.codigo
        WHERE C.produtor = {PRODUTOR}
            AND P.nome ILIKE '%{nome}%'
            AND P.preco BETWEEN {preco[0] :.2f} AND {preco[1] :.2f}
            AND F.duracao BETWEEN INTERVAL '{duracao[0]}' AND INTERVAL '{duracao[1]}'
        ORDER BY P.inclusao DESC;
    """


def busca_contrato():
    return f"""
        SELECT U.nome, C.id, C.valor, C.descricao
            FROM Contrato C
            JOIN Usuario U ON C.prestador = U.id
        WHERE C.produtor = {PRODUTOR} AND C."data" + C.duracao > NOW();
    """
