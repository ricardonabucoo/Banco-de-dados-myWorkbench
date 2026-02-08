-- -----------------------------------------------------
-- Schema gestao_esportiva
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS gestao_esportiva;
SET search_path TO gestao_esportiva;


CREATE DOMAIN dm_uf AS CHAR(2) CHECK (VALUE ~ '^[A-Z]{2}$');


DROP TABLE IF EXISTS campeonato CASCADE;

CREATE TABLE IF NOT EXISTS campeonato (
  id_campeonato INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  ano INT NOT NULL,
  PRIMARY KEY (id_campeonato));



DROP TABLE IF EXISTS classificacao CASCADE;

CREATE TABLE IF NOT EXISTS classificacao (
  pontos INT NULL DEFAULT 0,
  saldo_gols INT NULL DEFAULT 0,
  qtd_jogos INT NULL DEFAULT 0,
  id_time INT NOT NULL,
  id_campeonato INT NOT NULL,
  PRIMARY KEY (id_time, id_campeonato));



DROP TABLE IF EXISTS composicao_plano CASCADE;

CREATE TABLE IF NOT EXISTS composicao_plano (
  id_plano INT NOT NULL,
  id_exercicio INT NOT NULL,
  series INT NOT NULL,
  repeticoes INT NOT NULL,
  PRIMARY KEY (id_plano, id_exercicio),
  CONSTRAINT chk_esforco CHECK (series > 0 AND repeticoes > 0));



DROP TABLE IF EXISTS empresa CASCADE;

CREATE TABLE IF NOT EXISTS empresa (
  id_empresa SERIAL,
  cnpj CHAR(14) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  razao_social VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_empresa),
  CONSTRAINT cnpj_UNIQUE UNIQUE (cnpj));



DROP TABLE IF EXISTS endereco CASCADE;

CREATE TABLE IF NOT EXISTS endereco (
  logradouro VARCHAR(100) NULL DEFAULT NULL,
  numero VARCHAR(10) NOT NULL,
  bairro VARCHAR(50) NOT NULL,
  cidade VARCHAR(50) NOT NULL,
  uf dm_uf,
  id_pessoa INT NOT NULL,
  id_endereco SERIAL,
  PRIMARY KEY (id_endereco));



DROP TABLE IF EXISTS exercicio CASCADE;

CREATE TABLE IF NOT EXISTS exercicio (
  id_exercicio SERIAL,
  nome VARCHAR(100) NOT NULL,
  grupo_muscular VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (id_exercicio));


DROP TABLE IF EXISTS jogador CASCADE;

CREATE TABLE IF NOT EXISTS jogador (
  id_jogador SERIAL,
  posicao VARCHAR(30) NULL DEFAULT NULL,
  altura DECIMAL(3,2) NULL DEFAULT NULL,
  peso DECIMAL(5,2) NULL DEFAULT NULL,
  id_time INT NOT NULL,
  id_pessoa INT NOT NULL,
  PRIMARY KEY (id_jogador),
  CONSTRAINT chk_fisico CHECK (altura > 0 AND peso > 0));



DROP TABLE IF EXISTS jogador_contratado CASCADE;

CREATE TABLE IF NOT EXISTS jogador_contratado (
  id_contrato SERIAL,
  id_jogador INT NOT NULL,
  inicio_contrato DATE NOT NULL,
  fim_contrato DATE NOT NULL,
  PRIMARY KEY (id_contrato),
  CONSTRAINT chk_datas CHECK (fim_contrato > inicio_contrato));



DROP TABLE IF EXISTS jogo CASCADE;

CREATE TABLE IF NOT EXISTS jogo (
  id_jogo SERIAL,
  id_campeonato INT NOT NULL,
  local VARCHAR(100) NULL DEFAULT NULL,
  data_jogo TIMESTAMP NULL,
  placar_mandante INT NULL DEFAULT 0,
  placar_visitante INT NULL DEFAULT 0,
  id_mandante INT NOT NULL,
  id_visitante INT NOT NULL,
  PRIMARY KEY (id_jogo));



DROP TABLE IF EXISTS medico CASCADE;

CREATE TABLE IF NOT EXISTS medico (
  crm VARCHAR(20) NOT NULL,
  especialidade VARCHAR(50) NULL DEFAULT NULL,
  id_pessoa INT NOT NULL,
  id_medico VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_medico),
  CONSTRAINT crm_UNIQUE UNIQUE (crm));



DROP TABLE IF EXISTS meus_times CASCADE;

CREATE TABLE IF NOT EXISTS meus_times (
  id_meu_time SERIAL,
  id_time INT NOT NULL,
  PRIMARY KEY (id_meu_time));



DROP TABLE IF EXISTS patrocinio CASCADE;

CREATE TABLE IF NOT EXISTS patrocinio (
  id_empresa INT NOT NULL,
  id_meu_time INT NOT NULL,
  valor_contrato DECIMAL(10,2) NOT NULL,
  data_contrato DATE NOT NULL,
  data_contrato_fim DATE NOT NULL,
  PRIMARY KEY (id_empresa, id_meu_time),
  CONSTRAINT chk_valor CHECK (valor_contrato >= 0));


DROP TABLE IF EXISTS penalidade CASCADE;

CREATE TABLE IF NOT EXISTS penalidade (
  tipo VARCHAR(20) NOT NULL,
  minuto INT NOT NULL,
  id_arbitro VARCHAR(45) NOT NULL,
  id_jogador INT NOT NULL,
  id_jogo INT NOT NULL,
  PRIMARY KEY (id_arbitro, id_jogador, id_jogo));



DROP TABLE IF EXISTS pessoa CASCADE;

CREATE TABLE IF NOT EXISTS pessoa (
  id_pessoa SERIAL,
  nome VARCHAR(100) NOT NULL,
  data_nascimento DATE NULL,
  PRIMARY KEY (id_pessoa),
  CONSTRAINT chk_data_nasc CHECK (data_nascimento < CURRENT_DATE));



DROP TABLE IF EXISTS plano_individual CASCADE;

CREATE TABLE IF NOT EXISTS plano_individual (
  id_plano SERIAL,
  data_criacao DATE NOT NULL DEFAULT CURRENT_DATE,
  objetivo TEXT NULL DEFAULT NULL,
  id_contrato INT NOT NULL,
  id_medico VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_plano));



DROP TABLE IF EXISTS tb_arbitro CASCADE;

CREATE TABLE IF NOT EXISTS tb_arbitro (
  id_arbitro VARCHAR(45) NOT NULL,
  federacao VARCHAR(50) NULL DEFAULT NULL,
  categoria VARCHAR(30) NULL DEFAULT NULL,
  id_pessoa INT NULL,
  PRIMARY KEY (id_arbitro));



DROP TABLE IF EXISTS tecnico CASCADE;

CREATE TABLE IF NOT EXISTS tecnico (
  id_tecnico SERIAL,
  licenca VARCHAR(50) NULL DEFAULT NULL,
  anos_experiencia INT NULL DEFAULT NULL,
  id_pessoa INT NOT NULL,
  PRIMARY KEY (id_tecnico));



DROP TABLE IF EXISTS telefone CASCADE;

CREATE TABLE IF NOT EXISTS telefone (
  numero VARCHAR(20) NOT NULL,
  id_pessoa INT NOT NULL,
  id_telefone SERIAL,
  PRIMARY KEY (id_telefone));



DROP TABLE IF EXISTS time CASCADE;

CREATE TABLE IF NOT EXISTS time (
  id_time SERIAL,
  nome VARCHAR(100) NOT NULL,
  ano_fundacao INT NOT NULL,
  cidade VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_time),
  CONSTRAINT chk_ano CHECK (ano_fundacao > 1800));



DROP TABLE IF EXISTS treino CASCADE;

CREATE TABLE IF NOT EXISTS treino (
  id_treino SERIAL,
  data TIMESTAMP NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  id_meu_time INT NOT NULL,
  id_tecnico INT NOT NULL,
  PRIMARY KEY (id_treino, id_meu_time, id_tecnico));

-- -----------------------------------------------------
-- Foreign Keys
-- -----------------------------------------------------

ALTER TABLE classificacao ADD CONSTRAINT fk_tb_classificacao_tb_time1
    FOREIGN KEY (id_time) REFERENCES time (id_time) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE classificacao ADD CONSTRAINT fk_classificacao_campeonato1
    FOREIGN KEY (id_campeonato) REFERENCES campeonato (id_campeonato) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE composicao_plano ADD CONSTRAINT fk_tb_plano_individual_has_exercicio_tb_plano_individual1
    FOREIGN KEY (id_plano) REFERENCES plano_individual (id_plano) ON DELETE CASCADE;

ALTER TABLE composicao_plano ADD CONSTRAINT fk_tb_plano_individual_has_exercicio_exercicio1
    FOREIGN KEY (id_exercicio) REFERENCES exercicio (id_exercicio) ON DELETE RESTRICT;

ALTER TABLE endereco ADD CONSTRAINT fk_Endereço_tb_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE jogador ADD CONSTRAINT fk_tb_jogador_tb_time1
    FOREIGN KEY (id_time) REFERENCES time (id_time) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE jogador ADD CONSTRAINT fk_jogador_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE jogador_contratado ADD CONSTRAINT fk_jogador_contratado_jogador1
    FOREIGN KEY (id_jogador) REFERENCES jogador (id_jogador) ON DELETE RESTRICT;

ALTER TABLE jogo ADD CONSTRAINT fk_tb_jogo_tb_time2
    FOREIGN KEY (id_mandante) REFERENCES time (id_time) ON DELETE RESTRICT;

ALTER TABLE jogo ADD CONSTRAINT fk_tb_jogo_campeonato1
    FOREIGN KEY (id_campeonato) REFERENCES campeonato (id_campeonato) ON DELETE CASCADE;

ALTER TABLE jogo ADD CONSTRAINT fk_jogo_time1
    FOREIGN KEY (id_visitante) REFERENCES time (id_time) ON DELETE RESTRICT;

ALTER TABLE medico ADD CONSTRAINT fk_tb_medico_tb_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa) ON DELETE RESTRICT;

ALTER TABLE meus_times ADD CONSTRAINT fk_meus_times_time1
    FOREIGN KEY (id_time) REFERENCES time (id_time) ON DELETE RESTRICT;

ALTER TABLE patrocinio ADD CONSTRAINT fk_tb_time_has_tb_empresa_tb_empresa1
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa) ON DELETE RESTRICT;

ALTER TABLE patrocinio ADD CONSTRAINT fk_patrocinio_meus_times1
    FOREIGN KEY (id_meu_time) REFERENCES meus_times (id_meu_time) ON DELETE CASCADE;

ALTER TABLE penalidade ADD CONSTRAINT fk_tb_penalidade_tb_arbitro1
    FOREIGN KEY (id_arbitro) REFERENCES tb_arbitro (id_arbitro) ON DELETE RESTRICT;

ALTER TABLE penalidade ADD CONSTRAINT fk_penalidade_jogador1
    FOREIGN KEY (id_jogador) REFERENCES jogador (id_jogador) ON DELETE RESTRICT;

ALTER TABLE penalidade ADD CONSTRAINT fk_penalidade_jogo1
    FOREIGN KEY (id_jogo) REFERENCES jogo (id_jogo) ON DELETE CASCADE;

ALTER TABLE plano_individual ADD CONSTRAINT fk_tb_plano_individual_jogador_contratado1
    FOREIGN KEY (id_contrato) REFERENCES jogador_contratado (id_contrato) ON DELETE RESTRICT;

ALTER TABLE plano_individual ADD CONSTRAINT fk_tb_plano_individual_medico1
    FOREIGN KEY (id_medico) REFERENCES medico (id_medico) ON DELETE RESTRICT;

ALTER TABLE tb_arbitro ADD CONSTRAINT fk_tb_arbitro_tb_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa) ON DELETE RESTRICT;

ALTER TABLE tecnico ADD CONSTRAINT fk_tb_tecnico_tb_pessoa1
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa) ON DELETE RESTRICT;

ALTER TABLE telefone ADD CONSTRAINT fk_tb_telefone_tb_pessoa
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE treino ADD CONSTRAINT fk_treino_meus_times1
    FOREIGN KEY (id_meu_time) REFERENCES meus_times (id_meu_time) ON DELETE CASCADE;

ALTER TABLE treino ADD CONSTRAINT fk_treino_tecnico1
    FOREIGN KEY (id_tecnico) REFERENCES tecnico (id_tecnico) ON DELETE RESTRICT;