-- 🧱 1. Criar banco
CREATE DATABASE IF NOT EXISTS sigaedu;
USE sigaedu;

-- 🧹 Limpeza (evita erro ao rodar mais de uma vez)
DROP TABLE IF EXISTS academico_matricula;
DROP TABLE IF EXISTS academico_turma;
DROP TABLE IF EXISTS academico_disciplina;
DROP TABLE IF EXISTS academico_professor;
DROP TABLE IF EXISTS academico_aluno;

-- 🧱 2. Tabelas (DDL) 

CREATE TABLE academico_aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico_professor (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico_disciplina (
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE academico_turma (
    id_turma INT AUTO_INCREMENT PRIMARY KEY,
    id_disciplina INT,
    id_professor INT,
    ciclo VARCHAR(10),

    FOREIGN KEY (id_disciplina) REFERENCES academico_disciplina(id_disciplina),
    FOREIGN KEY (id_professor) REFERENCES academico_professor(id_professor)
);

CREATE TABLE academico_matricula (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    id_turma INT,
    nota DECIMAL(4,2),
    ativo BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (id_aluno) REFERENCES academico_aluno(id_aluno),
    FOREIGN KEY (id_turma) REFERENCES academico_turma(id_turma)
);

-- 📥 3. Inserts (DML)

INSERT INTO academico_aluno (nome, email) VALUES
('João Silva', 'joao@email.com'),
('Maria Souza', 'maria@email.com');

INSERT INTO academico_professor (nome) VALUES
('Carlos Lima'),
('Ana Paula');

INSERT INTO academico_disciplina (nome) VALUES
('Banco de Dados'),
('Algoritmos');

INSERT INTO academico_turma (id_disciplina, id_professor, ciclo) VALUES
(1, 1, '2026/1'),
(2, 2, '2026/1');

INSERT INTO academico_matricula (id_aluno, id_turma, nota) VALUES
(1, 1, 8.5),
(2, 1, 5.5),
(1, 2, 7.0);

-- 🔐 4. Segurança (DCL)

CREATE USER IF NOT EXISTS 'professor'@'localhost' IDENTIFIED BY '123';
CREATE USER IF NOT EXISTS 'coordenador'@'localhost' IDENTIFIED BY '123';

-- Professor: só pode atualizar nota
GRANT UPDATE (nota) ON sigaedu.academico_matricula TO 'professor'@'localhost';

-- Coordenador: acesso total
GRANT ALL PRIVILEGES ON sigaedu.* TO 'coordenador'@'localhost';

FLUSH PRIVILEGES;

-- 📊 5. Consultas (DML)

-- 🔹 Matriculados
SELECT a.nome AS aluno, d.nome AS disciplina, t.ciclo
FROM academico_matricula m
JOIN academico_aluno a ON m.id_aluno = a.id_aluno
JOIN academico_turma t ON m.id_turma = t.id_turma
JOIN academico_disciplina d ON t.id_disciplina = d.id_disciplina
WHERE t.ciclo = '2026/1';

-- 🔹 Baixo desempenho
SELECT d.nome AS disciplina, AVG(m.nota) AS media
FROM academico_matricula m
JOIN academico_turma t ON m.id_turma = t.id_turma
JOIN academico_disciplina d ON t.id_disciplina = d.id_disciplina
GROUP BY d.nome
HAVING AVG(m.nota) < 6;

-- 🔹 Alocação de docentes (LEFT JOIN)
SELECT p.nome AS professor, d.nome AS disciplina
FROM academico_professor p
LEFT JOIN academico_turma t ON p.id_professor = t.id_professor
LEFT JOIN academico_disciplina d ON t.id_disciplina = d.id_disciplina;

-- 🔹 Destaque acadêmico (subconsulta)
SELECT a.nome AS aluno, m.nota
FROM academico_matricula m
JOIN academico_aluno a ON m.id_aluno = a.id_aluno
WHERE m.nota = (
    SELECT MAX(m2.nota)
    FROM academico_matricula m2
    JOIN academico_turma t2 ON m2.id_turma = t2.id_turma
    JOIN academico_disciplina d2 ON t2.id_disciplina = d2.id_disciplina
    WHERE d2.nome = 'Banco de Dados'
);

