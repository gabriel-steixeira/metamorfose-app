--
-- File: schema.sql
-- Description: Script DDL (Data Definition Language) para criar a estrutura do banco de dados Oracle do projeto Metamorfose.
--
-- Responsabilidades:
-- - Criar a tabela META_USUARIOS para armazenar dados dos usuários.
-- - Criar a tabela META_PLANTAS para o registro das plantas virtuais/reais.
-- - Criar a tabela META_PROGRESSO para acompanhar a jornada do usuário.
-- - Definir as SEQUENCES (SEQ_USUARIOS, SEQ_PLANTAS, SEQ_PROGRESSO) para geração automática de IDs.
--
-- Author: Ester Silva
-- Created on: 29-11-2025
-- Last modified: 03-11-2025
-- Version: 1.2.0
-- Squad: Metamorfose
--

-- Tabela de Usuários
CREATE TABLE META_USUARIOS (
    id NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Plantas
CREATE TABLE META_PLANTAS (
    id NUMBER PRIMARY KEY,
    usuario_id NUMBER REFERENCES META_USUARIOS(id),
    nome VARCHAR2(50),
    tipo VARCHAR2(50),
    data_inicio DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'ATIVA'
);

-- Tabela de Progresso
CREATE TABLE META_PROGRESSO (
    id NUMBER PRIMARY KEY,
    usuario_id NUMBER REFERENCES META_USUARIOS(id),
    tipo_vicio VARCHAR2(50),
    dias_limpo NUMBER DEFAULT 0,
    data_registro DATE DEFAULT SYSDATE
);

-- Sequences
CREATE SEQUENCE SEQ_USUARIOS START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_PLANTAS START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_PROGRESSO START WITH 1 INCREMENT BY 1;