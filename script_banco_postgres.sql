-- -----------------------------------------------------
-- Schema gestao_esportiva
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS gestao_esportiva;
SET search_path TO gestao_esportiva;


CREATE TABLE campeonato (
  id_campeonato INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  ano INT NOT NULL,
  PRIMARY KEY (id_campeonato)
);

CREATE TABLE classificacao (
  pontos INT NULL DEFAULT 0,
  saldo_gols INT NULL DEFAULT 0,
  qtd_jogos INT NULL DEFAULT 0,
  id_time INT NOT NULL,
  id_campeonato INT NOT NULL,
  PRIMARY KEY (id_time, id_campeonato)
);

CREATE TABLE composicao_plano (
  id_plano INT NOT NULL,
  id_exercicio INT NOT NULL,
  series INT NOT NULL,
  repeticoes INT NOT NULL,
  PRIMARY KEY (id_plano, id_exercicio)
);

CREATE TABLE empresa (
  id_empresa SERIAL PRIMARY KEY,
  cnpj CHAR(14) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  razao_social VARCHAR(100) NOT NULL
);

CREATE TABLE endereco (
  id_endereco SERIAL PRIMARY KEY,
  logradouro VARCHAR(100) NULL DEFAULT NULL,
  numero VARCHAR(10) NOT NULL,
  bairro VARCHAR(50) NOT NULL,
  cidade VARCHAR(50) NOT NULL,
  uf CHAR(2) NULL DEFAULT NULL,
  id_pessoa INT NOT NULL
);

CREATE TABLE exercicio (
  id_exercicio SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  grupo_muscular VARCHAR(50) NULL DEFAULT NULL
);

CREATE TABLE jogador (
  id_jogador SERIAL PRIMARY KEY,
  posicao VARCHAR(30) NULL DEFAULT NULL,
  altura DECIMAL(3,2) NULL DEFAULT NULL,
  peso DECIMAL(5,2) NULL DEFAULT NULL,
  id_time INT NOT NULL,
  id_pessoa INT NOT NULL
);

CREATE TABLE jogador_contratado (
  id_contrato SERIAL PRIMARY KEY,
  id_jogador INT NOT NULL,
  inicio_contrato DATE NOT NULL,
  fim_contrato DATE NOT NULL
);

CREATE TABLE jogo (
  id_jogo SERIAL PRIMARY KEY,
  id_campeonato INT NOT NULL,
  local VARCHAR(100) NULL DEFAULT NULL,
  data_jogo TIMESTAMP NULL,
  placar_mandante INT NULL DEFAULT 0,
  placar_visitante INT NULL DEFAULT 0,
  id_mandante INT NOT NULL,
  id_visitante INT NOT NULL
);

CREATE TABLE medico (
  id_medico VARCHAR(45) NOT NULL,
  crm VARCHAR(20) NOT NULL,
  especialidade VARCHAR(50) NULL DEFAULT NULL,
  id_pessoa INT NOT NULL,
  PRIMARY KEY (id_medico)
);

CREATE TABLE meus_times (
  id_meu_time SERIAL PRIMARY KEY,
  id_time INT NOT NULL
);

CREATE TABLE patrocinio (
  id_empresa INT NOT NULL,
  id_meu_time INT NOT NULL,
  valor_contrato DECIMAL(10,2) NOT NULL,
  data_contrato DATE NOT NULL,
  data_contrato_fim DATE NOT NULL,
  PRIMARY KEY (id_empresa, id_meu_time)
);

CREATE TABLE penalidade (
  tipo VARCHAR(20) NOT NULL,
  minuto INT NOT NULL,
  id_arbitro VARCHAR(45) NOT NULL,
  id_jogador INT NOT NULL,
  id_jogo INT NOT NULL,
  PRIMARY KEY (id_arbitro, id_jogador, id_jogo)
);

CREATE TABLE pessoa (
  id_pessoa SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  data_nascimento DATE NULL
);

CREATE TABLE plano_individual (
  id_plano SERIAL PRIMARY KEY,
  data_criacao DATE NOT NULL,
  objetivo TEXT NULL DEFAULT NULL,
  id_contrato INT NOT NULL,
  id_medico VARCHAR(45) NOT NULL
);

CREATE TABLE tb_arbitro (
  id_arbitro VARCHAR(45) NOT NULL,
  federacao VARCHAR(50) NULL DEFAULT NULL,
  categoria VARCHAR(30) NULL DEFAULT NULL,
  id_pessoa INT NULL,
  PRIMARY KEY (id_arbitro)
);

CREATE TABLE tecnico (
  id_tecnico SERIAL PRIMARY KEY,
  licenca VARCHAR(50) NULL DEFAULT NULL,
  anos_experiencia INT NULL DEFAULT NULL,
  id_pessoa INT NOT NULL
);

CREATE TABLE telefone (
  id_telefone SERIAL PRIMARY KEY,
  numero VARCHAR(20) NOT NULL,
  id_pessoa INT NOT NULL
);

CREATE TABLE time (
  id_time SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  ano_fundacao INT NOT NULL,
  cidade VARCHAR(50) NOT NULL
);

CREATE TABLE treino (
  id_treino SERIAL,
  data TIMESTAMP NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  id_meu_time INT NOT NULL,
  id_tecnico INT NOT NULL,
  PRIMARY KEY (id_treino, id_meu_time, id_tecnico)
);

-- -----------------------------------------------------
-- (Foreign Keys)
-- -----------------------------------------------------

ALTER TABLE classificacao ADD CONSTRAINT fk_tb_classificacao_tb_time1
    FOREIGN KEY (id_time) REFERENCES time (id_time);
ALTER TABLE classificacao ADD CONSTRAINT fk_classificacao_campeonato1
    FOREIGN KEY (id_campeonato) REFERENCES campeonato (id_campeonato);

ALTER TABLE composicao_plano ADD CONSTRAINT fk_tb_plano_individual_has_exercicio_tb_plano_individual1
    FOREIGN KEY (id_plano) REFERENCES plano_individual (id_plano);
ALTER TABLE composicao_plano ADD CONSTRAINT fk_tb_plano_individual_has_exercicio_exercicio1
    FOREIGN KEY (id_exercicio) REFERENCES exercicio (id_exercicio);

ALTER TABLE endereco ADD CONSTRAINT fk_Endereço_tb_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa);

ALTER TABLE jogador ADD CONSTRAINT fk_tb_jogador_tb_time1
    FOREIGN KEY (id_time) REFERENCES time (id_time);
ALTER TABLE jogador ADD CONSTRAINT fk_jogador_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa);

ALTER TABLE jogador_contratado ADD CONSTRAINT fk_jogador_contratado_jogador1
    FOREIGN KEY (id_jogador) REFERENCES jogador (id_jogador);

ALTER TABLE jogo ADD CONSTRAINT fk_tb_jogo_tb_time2
    FOREIGN KEY (id_mandante) REFERENCES time (id_time);
ALTER TABLE jogo ADD CONSTRAINT fk_tb_jogo_campeonato1
    FOREIGN KEY (id_campeonato) REFERENCES campeonato (id_campeonato);
ALTER TABLE jogo ADD CONSTRAINT fk_jogo_time1
    FOREIGN KEY (id_visitante) REFERENCES time (id_time);

ALTER TABLE medico ADD CONSTRAINT fk_tb_medico_tb_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa);

ALTER TABLE meus_times ADD CONSTRAINT fk_meus_times_time1
    FOREIGN KEY (id_time) REFERENCES time (id_time);

ALTER TABLE patrocinio ADD CONSTRAINT fk_tb_time_has_tb_empresa_tb_empresa1
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa);
ALTER TABLE patrocinio ADD CONSTRAINT fk_patrocinio_meus_times1
    FOREIGN KEY (id_meu_time) REFERENCES meus_times (id_meu_time);

ALTER TABLE penalidade ADD CONSTRAINT fk_tb_penalidade_tb_arbitro1
    FOREIGN KEY (id_arbitro) REFERENCES tb_arbitro (id_arbitro);
ALTER TABLE penalidade ADD CONSTRAINT fk_penalidade_jogador1
    FOREIGN KEY (id_jogador) REFERENCES jogador (id_jogador);
ALTER TABLE penalidade ADD CONSTRAINT fk_penalidade_jogo1
    FOREIGN KEY (id_jogo) REFERENCES jogo (id_jogo);

ALTER TABLE plano_individual ADD CONSTRAINT fk_tb_plano_individual_jogador_contratado1
    FOREIGN KEY (id_contrato) REFERENCES jogador_contratado (id_contrato);
ALTER TABLE plano_individual ADD CONSTRAINT fk_tb_plano_individual_medico1
    FOREIGN KEY (id_medico) REFERENCES medico (id_medico);

ALTER TABLE tb_arbitro ADD CONSTRAINT fk_tb_arbitro_tb_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa);

ALTER TABLE tecnico ADD CONSTRAINT fk_tb_tecnico_tb_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa);

ALTER TABLE telefone ADD CONSTRAINT fk_tb_telefone_tb_pessoa
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa);

ALTER TABLE treino ADD CONSTRAINT fk_treino_meus_times1
    FOREIGN KEY (id_meu_time) REFERENCES meus_times (id_meu_time);
ALTER TABLE treino ADD CONSTRAINT fk_treino_tecnico1
    FOREIGN KEY (id_tecnico) REFERENCES tecnico (id_tecnico);