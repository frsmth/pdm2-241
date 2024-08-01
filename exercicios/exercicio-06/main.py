from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import sqlite3
from typing import List

app = FastAPI()

# Defina o modelo de dados para o aluno
class Aluno(BaseModel):
    nome: str
    idade: int
    curso: str

# Crie uma conexão com o banco de dados
def get_db():
    conn = sqlite3.connect('alunos.db')
    cursor = conn.cursor()
    return conn, cursor

# Crie a tabela tb_aluno se ela não existir
def criar_tabela():
    conn, cursor = get_db()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS tb_aluno (
            id INTEGER PRIMARY KEY,
            nome TEXT NOT NULL,
            idade INTEGER NOT NULL,
            curso TEXT NOT NULL
        )
    ''')
    conn.commit()
    conn.close()

# Endpoint para criar um novo aluno
@app.post("/criar_aluno")
def criar_aluno(aluno: Aluno):
    conn, cursor = get_db()
    cursor.execute("INSERT INTO tb_aluno (nome, idade, curso) VALUES (?, ?, ?)", (aluno.nome, aluno.idade, aluno.curso))
    conn.commit()
    conn.close()
    return {"mensagem": "Aluno criado com sucesso"}

# Endpoint para listar todos os alunos
@app.get("/listar_alunos")
def listar_alunos():
    conn, cursor = get_db()
    cursor.execute("SELECT * FROM tb_aluno")
    alunos = cursor.fetchall()
    conn.close()
    return [{"id": aluno[0], "nome": aluno[1], "idade": aluno[2], "curso": aluno[3]} for aluno in alunos]

# Endpoint para listar um aluno específico
@app.get("/listar_um_aluno/{id}")
def listar_um_aluno(id: int):
    conn, cursor = get_db()
    cursor.execute("SELECT * FROM tb_aluno WHERE id = ?", (id,))
    aluno = cursor.fetchone()
    conn.close()
    if aluno:
        return {"id": aluno[0], "nome": aluno[1], "idade": aluno[2], "curso": aluno[3]}
    else:
        raise HTTPException(status_code=404, detail="Aluno não encontrado")

# Endpoint para atualizar um aluno
@app.put("/atualizar_aluno/{id}")
def atualizar_aluno(id: int, aluno: Aluno):
    conn, cursor = get_db()
    cursor.execute("UPDATE tb_aluno SET nome = ?, idade = ?, curso = ? WHERE id = ?", (aluno.nome, aluno.idade, aluno.curso, id))
    conn.commit()
    conn.close()
    return {"mensagem": "Aluno atualizado com sucesso"}

# Endpoint para excluir um aluno
@app.delete("/excluir_aluno/{id}")
def excluir_aluno(id: int):
    conn, cursor = get_db()
    cursor.execute("DELETE FROM tb_aluno WHERE id = ?", (id,))
    conn.commit()
    conn.close()
    return {"mensagem": "Aluno excluído com sucesso"}

# Crie a tabela tb_aluno se ela não existir
criar_tabela()