# SoundStock

## Scripts
- consultas.sql - 5 consultas de média e alta complexidade
- esquema.sql - Criação das tabelas e seus constraints
- dados.sql - Inserção de dados

OBS: Executar os comandos do esquema.sql e dados.sql antes de executar o projeto

## Executando o projeto
Requisitos: Python >= 3.8, PIP >= 20.0.2, PostgreSQL >= 14.3

```
# Criar arquivo .env na raíz do projeto, alterar variáveis conforme a instalação local do Postgres.

soundstock/.env
--
HOST=localhost
DATABASE=postgres
USERNAME=postgres
PASSWORD=123
--

# Instalar dependências
pip install flask psycopg2 python-decouple

# Rodar aplicação
python backend/main.py

```