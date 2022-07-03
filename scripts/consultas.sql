-- 1. Listar todos os Prestadores de Serviço que participaram da criação de uma Faixa de Áudio e detalhes dos Contratos em questão

SELECT U.id AS usuario, U.nome, U.cpf, U.email, U.endereco, U.telefone, M.omb, C.id AS contrato, C."data", C.duracao, C.descricao, C.valor
	FROM Faixa_Contrato FC
	JOIN Contrato C ON FC.contrato = C.id
	JOIN Usuario  U ON C.prestador = U.id
	JOIN Musico   M ON C.prestador = M.usuario
WHERE FC.faixa = 2;



-- 2. Listar todos os Produtores "Experientes", ou seja, aqueles que já produziram pelo menos 3 Faixas de Áudio através da plataforma

SELECT U.id, U.nome, U.email, COUNT(DISTINCT FC.faixa) as faixas
	FROM Produtor P
	JOIN Usuario        U  ON P.musico = U.id
	JOIN Contrato       C  ON P.musico = C.produtor
	JOIN Faixa_Contrato FC ON C.id = FC.contrato
GROUP BY U.id, U.nome, U.email
	HAVING COUNT(DISTINCT FC.faixa) >= 3
ORDER BY faixas DESC;



-- 3. Para cada Prestador de Serviço, exibir sua Faixa de Áudio mais bem avaliada, utilizando a de maior preço como desempate e exibindo os Prestadores sem nenhuma Faixa

SELECT id, nome, produto, avaliacao FROM (
	SELECT U.nome, U.id, P.nome as produto, P.avaliacao, ROW_NUMBER() OVER(PARTITION BY PS.musico ORDER BY P.avaliacao, P.preco DESC NULLS LAST) AS ranking
		FROM Prestador_Servico PS
		JOIN      Usuario        U  ON PS.musico = U.id
		LEFT JOIN Contrato       C  ON PS.musico = C.prestador
		LEFT JOIN Faixa_Contrato FC ON C.id = FC.contrato
		LEFT JOIN Produto        P  ON FC.faixa = P.codigo
) RES
WHERE ranking = 1;



-- 4. Listar todas as Faixas de Áudio que um Usuário possui, tendo sido comprada diretamente ou via Bundle

WITH Produtos_Usuario AS (
	SELECT CP.produto
		FROM Compra C 
		JOIN Compra_Produto CP ON C.nota_fiscal = CP.compra
	WHERE C.comprador = 2
)

SELECT P.codigo, P.nome, P.avaliacao, FA.duracao FROM (
	SELECT BF.faixa
		FROM Produtos_Usuario PU
		JOIN Bundle B        ON PU.produto = B.produto
		JOIN Bundle_Faixa BF ON B.produto = BF.bundle
	
	UNION 
	
	SELECT produto FROM Produtos_Usuario
) RES
	JOIN Produto     P  ON RES.faixa = P.codigo
	JOIN Faixa_Audio FA ON RES.faixa = FA.produto;



-- 5. Dado um Bundle, listar todos os seus Produtores "Majoritários", ou seja, Produtores que produziram todas as Faixas de Áudio presentes no Bundle

SELECT DISTINCT U.id, U.nome, U.email
	FROM Bundle_Faixa BF
	JOIN Faixa_Contrato FC ON BF.faixa = FC.faixa
	JOIN Contrato       C  ON FC.contrato = C.id
	JOIN Usuario        U  ON C.produtor = U.id
WHERE BF.bundle = 5 AND NOT EXISTS (
	SELECT faixa FROM Bundle_Faixa WHERE bundle = BF.bundle
    
    EXCEPT
    
    SELECT iBF.faixa
        FROM Bundle_Faixa iBF
        JOIN Faixa_Contrato iFC ON iBF.faixa = iFC.faixa
        JOIN Contrato       iC  ON iFC.contrato = iC.id
    WHERE iBF.bundle = BF.bundle AND iC.produtor = C.produtor
);
