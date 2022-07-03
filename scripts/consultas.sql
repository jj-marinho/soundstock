-- Query 01 (Join, Where)
-- "Featuring"
-- Listar os dados de todos os músicos que participaram de uma faixa de aúdio, além dos detalhes de seu contrato
SELECT U.id, U.nome, M.omb, U.cpf, M.avaliacao, U.email, U.endereco, 
       U.telefone, C."data", C.duracao, C.descricao, C.valor
FROM faixa_contrato FC
JOIN contrato C on C.id = FC.contrato
JOIN musico M on C.prestador = M.usuario
JOIN usuario U on C.prestador = U.id
WHERE FC.faixa = 2;


-- Query 02 (Aggregators, Group By, Having, Order By)
-- "Produtores mais experientes"
-- Selecionar dados essenciais de todos os produtores que produziram pelo menos 3 músicas, ordernar por número de músicas produzidas
SELECT U.id, U.cpf, U.email, U.telefone, COUNT(DISTINCT faixa) as faixas_produzidas
FROM produtor P
JOIN contrato C on P.musico = C.produtor
JOIN faixa_contrato FC on FC.contrato = C.id
JOIN faixa_audio F on FC.faixa = F.produto
JOIN usuario U on P.musico = U.id
GROUP BY U.id, U.email, U.cpf, U.telefone
HAVING COUNT(DISTINCT faixa) >= 3
ORDER BY faixas_produzidas;


-- Query 03 (Outer Join, Window Functions)
-- "Destaques do músico"
-- Para cada prestador de servico, selecionar sua faixa de aúdio mais bem avaliada caso já tenha participado de alguma,
-- Se não houver música, mantenha o campo como null. Em casos de empate selecionar a faixa de áudio mais cara
SELECT D.musico, D.nome as nome_produto, D.avaliacao
FROM (
	SELECT PS.musico, P.nome, ROW_NUMBER() OVER (PARTITION BY PS.musico ORDER BY P.avaliacao DESC NULLS LAST) ranking, P.avaliacao
	FROM prestador_servico PS
	LEFT JOIN contrato C on PS.musico = C.prestador
	LEFT JOIN faixa_contrato FC on C.id = FC.contrato
	LEFT JOIN faixa_audio F on FC.faixa = F.produto
	LEFT JOIN produto P on F.produto = P.codigo
	WHERE P.tipo = 'Faixa de Audio' OR P.tipo IS NULL
) D
WHERE D.ranking = 1;


-- Query 04 (Subquery não-correlacionada, Union)
-- "Suas Faixas"
-- Listar todas as faixas de áudio que um usuário já comprou, seja diretamente ou via bundle
WITH produtos_usuario AS (
	SELECT CP.produto
	FROM compra C 
	JOIN compra_produto CP on C.nota_fiscal = CP.compra
	WHERE C.comprador = 1
)

SELECT faixa, duracao, nome, tipo, preco, avaliacao
FROM (
	SELECT BF.faixa 
	FROM produtos_usuario PU
	JOIN bundle B on B.produto = PU.produto
	JOIN bundle_faixa BF on B.produto = BF.bundle
	
	UNION 
	
	SELECT produto
	FROM produtos_usuario
) F
JOIN faixa_audio FA on F.faixa = FA.produto
JOIN produto P on FA.produto = P.codigo;


-- Query 05 (Subquery Correlacionada, Divisão)
-- "Produtores Majoritários"
-- Dado um bundle, checamos se há a presença de produtores majoritários (produtores envolvido na produção de todas as faixas do bundle)
SELECT DISTINCT C.produtor
FROM bundle_faixa BF
JOIN faixa_contrato FC on BF.faixa = FC.faixa
JOIN contrato C on FC.contrato = C.id
WHERE BF.bundle = 6 
AND NOT EXISTS ( (SELECT DISTINCT BF.faixa FROM bundle_faixa BF WHERE BF.bundle = 6)
                    
                  EXCEPT
                    
                 (SELECT DISTINCT BF.faixa
                  FROM bundle_faixa BF
                  JOIN faixa_contrato FC on BF.faixa = FC.faixa
                  JOIN contrato C1 on FC.contrato = C1.id
                  WHERE BF.bundle = 6 AND C1.produtor = C.produtor)
	           );


