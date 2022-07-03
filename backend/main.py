from sgbd import insercao_faixa, busca_faixa, busca_contrato
from flask import Flask, request, render_template, redirect
import psycopg2
import atexit
from decouple import config


try:
    # Conecta ao Banco de Dados
    print("Conectando com PostgreSQL...")
    conn = psycopg2.connect(host = config("HOST"), database = config("DATABASE"), user = config("USERNAME"), password = config("PASSWORD"))
    
    # Imprime a Versão do Banco de Dados
    cur = conn.cursor()
    cur.execute("SELECT version()")
    print(f"Versão: {cur.fetchone()}")

except (Exception, psycopg2.DatabaseError) as erro:
    conn = None
    print(erro)

def fecha_conexao():
    if conn is not None:
        conn.close()
        print("Conexão com PostgreSQL fechada")


app = Flask(__name__)

@app.route("/", methods=['GET'])
def home():    
    # cria um cursor e executa o sql
    cur = conn.cursor()
    print(busca_faixa())
    cur.execute(busca_faixa())
    recset = cur.fetchall()
    returnData = ""
    for rec in recset:
        returnData += f'<li class="list-group-item">Nome: {rec[1]}<br>Preço: R${rec[2]}<br>Avaliação: {rec[3]}<br>Duração: {rec[5]}</li>'

    return render_template('consulta_output.html', message=returnData)


@app.route("/nova-faixa")
def novaFaixa():    
    cur = conn.cursor()
    cur.execute(busca_contrato())
    recset = cur.fetchall()
    contratos = ""
    for rec in recset:
        print(rec)
        contratos += f"""<div class="mb-3 d-flex  flex-row justify-content-around">
                        <div class="form-check" style="width:300px;">
                        <input class="form-check-input" type="checkbox" value="{rec[1]}" id="check{rec[1]}" name="check{rec[1]}">
                        <label class="form-check-label" for="defaultCheck{rec[1]}">
                            Contrato com o {rec[0]} com a descrição {rec[3]}
                        </label>
                        </div>
                    </div>"""
    return render_template('insercao_input.html', contratos=contratos)

@app.route("/faixa-audio", methods=['POST'])
def novaFaixaPost():
    print(request.form.to_dict())
    form = request.form.to_dict()
    contratos = []
    for key in form:
        print(key, form[key])
        if "check" in key:
            print("checkbox", key)
            contratos.append(form[key])
    idiomas = []
    for idioma in form['idiomas'].split(","):
        if idioma != "":
            idiomas.append(idioma.strip())
    generos = []
    for genero in form['generos'].split(","):
        if genero != "":
            generos.append(genero.strip())
    instrumentos = []
    for instrumento in form['instrumentos'].split(","):
        if instrumento != "":
            instrumentos.append(instrumento.strip())
    nome = form['nome']
    try:
        preco = float(form['preco'])
    except:
        return redirect(f"/nova-faixa?error=dado invalido {form['preco']}", code=302)
    duracao = form['duracao'] + " seconds"
    

    print( insercao_faixa(nome, preco, duracao, contratos, generos, idiomas, instrumentos))
    cur = conn.cursor()
    try:
        # executa o sql
        cur.execute( insercao_faixa(nome, preco, duracao, contratos, generos, idiomas, instrumentos))
        # comita a operacao
        conn.commit()
    except Exception as err:
        conn.rollback()
        print(err)
        bs = "\n"
        return redirect(f"/nova-faixa?error=dado invalido {str(err).split(bs)[0].split(':')[1]}", code=302)
   
    return redirect("/", code=302)

# mostra todas as insercoes feitas na base
@app.route("/busca", methods=['GET'])
def formBuscarFaixa(): 
    return render_template('consulta_input.html')

@app.route("/busca-resultado", methods=['POST'])
def buscarFaixa():
    print(request.form.to_dict())
    form = request.form.to_dict()


    nome = form['nome']
    precoMin = form['preco-min']
    if precoMin == "":
        precoMin = 0
    else:
        precoMin = float(precoMin)
    precoMax = form['preco-max']
    if precoMax == "":
        precoMax = 99999999.99
    else:
        precoMax = float(precoMax)
    duracaoMin = form['duracao-min']
    if duracaoMin == "":
        duracaoMin = "0 secs"
    else:
        duracaoMin += " secs"
    duracaoMax = form['duracao-max']
    if duracaoMax == "":
        duracaoMax = "178000000 years"
    else:
        duracaoMax += " secs"

    
    # cria um cursor e executa o sql
    cur = conn.cursor()
    print(busca_faixa(nome=nome, duracao=(duracaoMin, duracaoMax), preco=(precoMin, precoMax)))
    cur.execute(busca_faixa(nome=nome, duracao=(duracaoMin, duracaoMax), preco=(precoMin, precoMax)))
    recset = cur.fetchall()
    returnData = ""
    # faz um loop entre todos os resultados e vai juntando em itens de uma lista para o html
    for rec in recset:
        returnData += f'<li class="list-group-item">Nome: {rec[1]}<br>Preço: R${rec[2]}<br>Avaliação: {rec[3]}<br>Duração: {rec[5]}</li>'

    return render_template('consulta_output.html', message=returnData)
    


if __name__ == "__main__":  
    app.run(debug = True)
    atexit.register(fecha_conexao)


