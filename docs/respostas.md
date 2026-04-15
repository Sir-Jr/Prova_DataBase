# 📚 Sistema SigaEdu - Respostas Teóricas

## 🧠 1. SGBD Relacional

A escolha de um SGBD relacional (como MySQL) é ideal para o sistema acadêmico, pois garante integridade, consistência e segurança dos dados.

As propriedades ACID garantem:

- **Atomicidade:** operações são concluídas totalmente ou desfeitas
- **Consistência:** regras de integridade são respeitadas (PK, FK)
- **Isolamento:** evita conflitos entre usuários simultâneos
- **Durabilidade:** dados permanecem mesmo após falhas

Diferente do NoSQL, o modelo relacional é mais adequado para dados estruturados e com muitos relacionamentos, como alunos, disciplinas e matrículas.

---

## 🏗️ 2. Uso de Schemas

Em ambientes profissionais, o uso de schemas melhora:

- Organização do banco
- Segurança (controle de acesso)
- Separação de responsabilidades
- Escalabilidade

No MySQL, schemas são equivalentes a databases, então utilizamos prefixos como:

- academico_
- seguranca_

---

## 📊 3. Modelo Lógico

### Entidades:

- **Aluno** (id_aluno, nome, email, ativo)
- **Professor** (id_professor, nome, ativo)
- **Disciplina** (id_disciplina, nome)
- **Turma** (id_turma, id_disciplina, id_professor, ciclo)
- **Matricula** (id_matricula, id_aluno, id_turma, nota, ativo)

### Relacionamentos:

- Aluno → Matricula (1:N)
- Turma → Matricula (1:N)
- Professor → Turma (1:N)
- Disciplina → Turma (1:N)

---

## 🔐 4. Concorrência e ACID

Quando dois usuários tentam alterar a mesma nota ao mesmo tempo, o SGBD utiliza:

- **Isolamento:** impede que uma transação veja dados inconsistentes
- **Locks (bloqueios):** um usuário bloqueia o registro até finalizar

Isso garante que:
- não haja sobrescrita de dados
- o banco permaneça consistente
- o valor final seja correto