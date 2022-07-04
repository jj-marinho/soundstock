import atexit
import psycopg2

from decouple import config
from flask import Flask, request, render_template, redirect
from sgbd import insercao_faixa, busca_faixa, busca_contrato


try:
    # Conecta ao Banco de Dados
    print("Conectando com PostgreSQL...")
    conexao = psycopg2.connect(host = config("HOST"), database = config("DATABASE"), user = config("USERNAME"), password = config("PASSWORD"))
    
    # Imprime a Versão do Banco de Dados
    cursor = conexao.cursor()
    cursor.execute("SELECT version()")
    print(f"Versão: {cursor.fetchone()}")

except (Exception, psycopg2.DatabaseError) as erro:
    conexao = None
    print(erro)


def fecha_conexao():
    if conexao is not None:
        conexao.close()
        print("Conexão com PostgreSQL fechada")


app = Flask(__name__)


@app.route('/', methods = ["GET"])
def inicio():
    cursor = conexao.cursor()
    cursor.execute(busca_faixa())
    resultados = cursor.fetchall()

    faixas = ""

    for resultado in resultados:
        faixas += f"""
            <li class="list-group-item">
                Nome:      {resultado[1]}   <br>
                Preço:     R${resultado[2]} <br>
                Avaliação: {resultado[3]}   <br>
                Duração:   {resultado[5]}
            </li>
        """

    return render_template("faixas.html", faixas = faixas)


@app.route("/insercao", methods = ["GET"])
def insercao_get():
    cursor = conexao.cursor()
    cursor.execute(busca_contrato())
    resultados = cursor.fetchall()

    contratos = ""

    for resultado in resultados:
        contratos += f"""
            <div class="mb-3 d-flex  flex-row justify-content-around">
                <div class="form-check" style="width: 300px;">
                    <input class="form-check-input" type="checkbox" value="{resultado[1]}" id="check{resultado[1]}" name="check{resultado[1]}">
                    <label class="form-check-label" for="defaultCheck{resultado[1]}">
                        <strong> {resultado[0]} (R${resultado[2]}): </strong> {resultado[3]}
                    </label>
                </div>
            </div>
        """

    return render_template("insercao.html", contratos = contratos)


@app.route("/insercao", methods = ["POST"])
def insercao_post():
    formulario = request.form.to_dict()

    contratos = [valor for chave, valor in formulario.items() if "check" in chave]
    if not contratos: return redirect("/insercao?erro=Nenhum+contrato+selecionado", code = 302)

    idiomas = []
    for idioma in map(lambda x: x.strip().capitalize(), formulario["idiomas"].split(',')):
        if len(idioma) > 50: return redirect("/insercao?erro=Idioma+excedendo+50+caracteres", code = 302)
        if idioma: idiomas.append(idioma)

    generos = []
    for genero in map(lambda x: x.strip().capitalize(), formulario["generos"].split(',')):
        if len(genero) > 50: return redirect("/insercao?erro=Genero+excedendo+50+caracteres", code = 302)
        if genero: generos.append(genero)

    instrumentos = []
    for instrumento in map(lambda x: x.strip().capitalize(), formulario["instrumentos"].split(',')):
        if len(instrumento) > 50: return redirect("/insercao?erro=Instrumento+excedendo+50+caracteres", code = 302)
        if instrumento: instrumentos.append(instrumento.strip())

    nome = formulario["nome"]
    if not nome: return redirect("/insercao?erro=Nome+vazio", code = 302)

    try:
        preco = float(formulario["preco"])
        if preco < 0 or preco > 99999999.99: return redirect("/insercao?erro=Preco+negativo", code = 302)
    except:
        return redirect("/insercao?erro=Preco+invalido", code = 302)

    if not formulario["duracao"].isdigit(): return redirect("/insercao?erro=Duracao+invalida", code = 302)
    duracao = formulario["duracao"] + " secs"

    try:
        cursor = conexao.cursor()
        cursor.execute(insercao_faixa(nome, preco, duracao, contratos, generos, idiomas, instrumentos))
        conexao.commit()
    except Exception as erro:
        conexao.rollback()
        print(erro)
        return redirect(f"/insercao?erro=Falha+na+insercao", code = 302)

    return redirect('/', code = 302)


@app.route("/busca", methods = ["GET"])
def busca_get():
    return render_template("busca.html")


@app.route("/busca", methods = ["POST"])
def busca_post():
    formulario = request.form.to_dict()

    nome = formulario["nome"]

    preco_minimo = float(formulario["preco-min"]) if formulario["preco-min"] else 0.0
    preco_maximo = float(formulario["preco-max"]) if formulario["preco-max"] else 99999999.99

    duracao_minima = formulario["duracao-min"] + " secs" if formulario["duracao-min"] else "0 secs"
    duracao_maxima = formulario["duracao-max"] + " secs" if formulario["duracao-max"] else "178000000 years"

    cursor = conexao.cursor()
    cursor.execute(busca_faixa(nome = nome, duracao = (duracao_minima, duracao_maxima), preco = (preco_minimo, preco_maximo)))
    resultados = cursor.fetchall()

    faixas = ""

    for resultado in resultados:
        faixas += f"""
            <li class="list-group-item">
                Nome:      {resultado[1]}   <br>
                Preço:     R${resultado[2]} <br>
                Avaliação: {resultado[3]}   <br>
                Duração:   {resultado[5]}
            </li>
        """

    return render_template("faixas.html", faixas = faixas)


if __name__ == "__main__":  
    app.run(debug = True)
    atexit.register(fecha_conexao)
