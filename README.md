# Projeto de Banco de Dados – Relacional e NoSQL

Este repositório contém o desenvolvimento completo de um projeto de Banco de Dados, contemplando as etapas de modelagem conceitual, projeto lógico relacional e adaptação para projeto lógico NoSQL, conforme proposto na disciplina.

---

##  Estrutura do Repositório

###  Parte 1 – Modelo Relacional
Localizada na pasta `Parte2_1`, contém os artefatos referentes ao modelo relacional:

- [**DER - Diagrama entidade relacionamento**](Parte2_1/DER.png)

- [**Projeto Lógico Relacional**](Parte2_1/modeloLogico.pdf)

- [**Script SQL (PostgreSQL)**](Parte2_1/script_banco_postgres.sql)

- **Arquivo do MySQL Workbench** - Para importação no MySQL-workbench

Esses arquivos representam a modelagem conceitual e lógica do banco relacional, incluindo entidades, relacionamentos e restrições.

---

### Parte 2 – Modelo NoSQL (MongoDB)
Localizada na pasta `Parte2_2/banco_nosql`, contém o mapeamento do modelo relacional para o paradigma NoSQL, utilizando **MongoDB**.

#### Schemas de Validação
Os schemas foram definidos utilizando `$jsonSchema` e estão disponíveis nos formatos:

- **YAML** (`ymlfiles/`)
- **JSON** (raiz da pasta)

Coleções modeladas:
- Campeonato
- Time
- Pessoas (com especializações)
- Jogador Contratado
- Penalidade
- Treino
- Plano Individual

### Relatórios
 **Projeto Lógico SQL**
    Adicionar o relatório
 **Projeto Lógico NoSQL e Discussão das Restrições**
   [**Relatório2_2**](Parte2_2/relatorio2_2.pdf)

---

##  Tecnologias Utilizadas

- PostgreSQL
- MySQL Workbench
- MongoDB
- JSON Schema
- YAML

---


