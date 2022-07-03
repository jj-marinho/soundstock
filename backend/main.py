from flask import Flask, request

from flask import Flask
from flask import render_template
from flask import redirect

import atexit

import psycopg2

# conecta na base
try:
    # cria a conexao
    print('Connecting to the PostgreSQL database...')
    conn = psycopg2.connect(host='localhost', database='postgres',user='postgres', password='mysecretpassword')
    
    
    # busca a versao do postgres para imprimir
    print('PostgreSQL database version:')
    cur = conn.cursor()
    cur.execute('SELECT version()')

    # imprime a versao do postgres
    db_version = cur.fetchone()
    print(db_version)
    
except (Exception, psycopg2.DatabaseError) as error:
    print(error)

def closeConnection():
    # fecha a conexao com o banco
    if conn is not None:
        conn.close()
        print('Database connection closed.')

# cria um app flask
app = Flask(__name__)

# mostra a pagina de inserir dados 
@app.route("/")
def index():
    return render_template('insercao_input.html')

# recebe os dados da pagina de insercao e insere na base
@app.route("/denuncia", methods=['POST'])
def newFireReport():
    # busca os dados da requisicao e cria o sql para insercao, aqui seria necessario evitar sql injection
    sql = """INSERT INTO public.denuncia(timestamp_den, descricao_endereco, descricao_ocorrencia, cpf, modo_acesso, ip, n_contato) 
    VALUES (current_timestamp, '{address}', '{description}', '{cpf}', 'INTERNET', '0.0.0.0', NULL);""".format(address=request.form['address'], 
    description=request.form['description'], cpf=request.form['cpf'])
    # executa o sql
    cur.execute(sql)
    # comita a operacao
    conn.commit()
    # redireciona para a pagina onde mostra que a insercao foi bem sucedida
    return redirect("/denuncia", code=302)

# mostra todas as insercoes feitas na base
@app.route("/denuncia", methods=['GET'])
def getFireReport(): 
    # sql com todas as insercoes
    sql = 'SELECT timestamp_den, descricao_endereco, descricao_ocorrencia, cpf, modo_acesso, ip, n_contato FROM public.denuncia;'
    # cria um cursor e executa o sql
    cur = conn.cursor()
    cur.execute(sql)
    recset = cur.fetchall()
    returnData = ""
    # faz um loop entre todos os resultados e vai juntando em itens de uma lista para o html
    for rec in recset:
        returnData += '<li class="list-group-item">{row}</li>'.format(row=rec)
    # retorna para o usuario a pagina
    return render_template('insercao_output.html', message=returnData)

# mostra a consulta escolhida pelo grupo
@app.route("/consulta", methods=['GET'])
def getSelect(): 
    # sql escolhido
    sql = """select C.nome, extract (year from Q.timestamp_finalizacao) as "ano", count(distinct Q.id) as "quantidade"
                from corpo_bombeiros C join veiculos V on C.cnpj = V.corpo_bombeiros
                       join despacho_veiculo D on V.placa = D.veiculo
					   join queimada Q on D.queimada = Q.id
					   where upper(Q.status) = 'FINALIZADO' 
					   group by C.cnpj, extract (year from Q.timestamp_finalizacao);"""
    # cria um cursor e executa o sql
    cur = conn.cursor()
    cur.execute(sql)
    recset = cur.fetchall()
    returnData = ""
    # faz um loop entre todos os resultados e vai juntando em itens de uma lista para o html
    for rec in recset:
        returnData += '<li class="list-group-item">{row}</li>'.format(row=rec)
    # retorna para o usuario a pagina
    return render_template('consulta.html', message=returnData)
    


if __name__ == "__main__":
    # roda a aplicacao  
    app.run(debug=True)
    # quando acabar, fecha a conexao
    atexit.register(closeConnection)