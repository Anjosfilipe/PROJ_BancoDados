CREATE DATABASE Faculdade;

USE Faculdade;

CREATE TABLE ALuno(
RA int NOT NULL,
Nome varchar(50) NOT NULL,
CONSTRAINT PK_RA PRIMARY KEY(RA)
);

CREATE TABLE Disciplina(
Sigla char(3) NOT NULL,
Nome varchar(30) NOT NULL,
Carga_horaria int NOT NULL,
CONSTRAINT PK_SIGLA PRIMARY KEY(Sigla)
);

CREATE  TABLE Matricula(
Semestre int NOT NULL,
DATA_Ano int NOT NULL,
RA int NOT NULL,
Sigla char(3) NOT NULL,
Falta int NULL,
Nota_N1 float NULL,
Nota_N2 float NULL,
Nota_Sub float NULL,
Nota_Media float NULL,
Situacao varchar(50) NULL,

CONSTRAINT PK_MATRICULA PRIMARY KEY(RA,Sigla,Semestre,DATA_Ano),
FOREIGN KEY(RA) REFERENCES Aluno(RA),
FOREIGN KEY(Sigla) REFERENCES Disciplina(Sigla),
);

CREATE TRIGGER Situacao
ON Matricula
AFTER UPDATE
AS
BEGIN
    DECLARE
	@Falta int,
    @Nota_N1 float,
    @Nota_N2  float,
	@Media float,
	@RA  int,
	@CH int,
	@Semestre int,
	@Sigla char(3),
	@Sub float
	SELECT @Semestre = Semestre FROM INSERTED
	SELECT @Falta = Falta FROM INSERTED
	SELECT @Sigla = Sigla FROM INSERTED
	SELECT @RA = RA FROM INSERTED
	SELECT @Nota_N1 = Nota_N1 FROM INSERTED
	SELECT @Nota_N2 = Nota_N2 FROM INSERTED
	SELECT @Sub = Nota_sub FROM INSERTED
	SELECT @CH = Carga_horaria FROM Disciplina
	SELECT @Media = (@Nota_N1+@Nota_N2)/2

   IF(@Media >= 5 AND @Falta <= (@CH * 0.25))
		BEGIN
		UPDATE Matricula SET Situacao = 'APROVADO',Nota_Media = @Media WHERE RA = @RA AND Sigla = @Sigla AND DATA_Ano = 2021 
		END
   ELSE
		BEGIN
		UPDATE Matricula SET Nota_Media = @Media WHERE RA = @RA AND Sigla = @Sigla AND DATA_Ano = 2021 
		END
   IF((@Nota_N1+@Sub)/2 < 5 OR (@Nota_N2+@Sub)/2 < 5) 
		BEGIN
		UPDATE Matricula SET Situacao = 'REPROVADO' WHERE RA = @RA AND Sigla = @Sigla AND DATA_Ano = 2021 
		END
END;

CREATE TRIGGER Rematricula
ON Matricula
FOR UPDATE, INSERT
AS
BEGIN
    DECLARE 
    @Data_Ano int,
    @RA int,
    @Sigla char(3),
    @Data_Semestre int,
    @Situacao varchar(50)

    SELECT @Data_Ano = Data_Ano + 1 from INSERTED
    SELECT @RA = RA FROM INSERTED
    SELECT @Sigla = Sigla FROM INSERTED
    SELECT @Data_Semestre = Semestre FROM INSERTED
    SELECT @Situacao = Situacao FROM INSERTED
   
   IF (@Situacao = 'REPROVADO')
		BEGIN
    INSERT INTO Matricula (RA, Sigla, Data_Ano,Semestre)
    VALUES (@RA, @Sigla, @Data_Ano, @Data_Semestre)
END
END;

INSERT INTO Aluno(RA,Nome)
VALUES(1,'Filipe'),(2,'Jhow'),(3,'Arthur'),(4,'Larissa'),(5,'Maickon'),(6,'Luis'),(7,'Alexandre'),(8,'Moranguinho'),(10,'Baratox'),(11,'J.J');

INSERT INTO Disciplina(Sigla,Nome,Carga_Horaria)
VALUES('MT','Matematica',50),('IN','Informatica',60),('CI','Ciencia',80),('PT','Portugues',90),('ED','Estrutura de dados',100),('GE','Geografia',20),('LOG','Logaritimo',50),('FA','Fundamentos analiticos',50),('TCC','Conclusao de curso',100),('LB','Laboratorio',50);

INSERT INTO Matricula(RA,Sigla,Data_Ano,Semestre)
VALUES(1,'MT',2021,1),(1,'GE',2021,2),(2,'MT',2021,1),(2,'GE',2021,2),(3,'MT',2021,1),(3,'GE',2021,2),(4,'MT',2021,1),(4,'GE',2021,2),(5,'MT',2021,1),(5,'GE',2021,2),
	  (1,'IN',2021,1),(1,'LOG',2021,2),(2,'IN',2021,1),(2,'LOG',2021,2),(3,'IN',2021,1),(3,'LOG',2021,2),(4,'IN',2021,1),(4,'LOG',2021,2),(5,'IN',2021,1),(5,'LOG',2021,2),
	  (1,'CI',2021,1),(1,'FA',2021,2),(2,'CI',2021,1),(2,'FA',2021,2),(3,'CI',2021,1),(3,'FA',2021,2),(4,'CI',2021,1),(4,'FA',2021,2),(5,'CI',2021,1),(5,'FA',2021,2),
	  (1,'PT',2021,1),(1,'TCC',2021,2),(2,'PT',2021,1),(2,'TCC',2021,2),(3,'PT',2021,1),(3,'TCC',2021,2),(4,'PT',2021,1),(4,'TCC',2021,2),(5,'PT',2021,1),(5,'TCC',2021,2),
	  (1,'ED',2021,1),(1,'LB',2021,2),(2,'ED',2021,1),(2,'LB',2021,2),(3,'ED',2021,1),(3,'LB',2021,2),(4,'ED',2021,1),(4,'LB',2021,2),(5,'ED',2021,1),(5,'LB',2021,2);

UPDATE Matricula
SET Nota_N1 = 8
WHERE RA = 3 AND Sigla = 'CI' AND DATA_Ano = 2021; 

UPDATE Matricula 
SET Nota_N2 = 5
WHERE RA = 3 AND Sigla = 'CI' AND DATA_Ano = 2021; 

UPDATE Matricula
SET Falta = 1
WHERE RA = 3 AND Sigla = 'CI' AND DATA_Ano = 2021; 

UPDATE Matricula 
SET Nota_Sub = 4
WHERE RA = 3 AND Sigla = 'CI' AND DATA_Ano = 2021; 

SELECT Sigla,DATA_Ano,Semestre,Nota_N1,Nota_N2,Nota_Sub,Nota_Media,Falta,Situacao,Matricula.RA,ALuno.Nome
FROM Matricula,ALuno
WHERE Sigla = 'CI' AND Matricula.RA = Aluno.RA 

SELECT Matricula.RA,Sigla,Aluno.Nome,Semestre,Nota_N1,Nota_N2,Situacao,Falta
FROM Matricula,Aluno
WHERE Aluno.Nome = 'Filipe' AND Aluno.RA = Matricula.RA AND Semestre = 2

SELECT Matricula.RA,Aluno.Nome,DATA_Ano,Sigla,Nota_N1,Nota_N2,Nota_Media,Situacao
FROM Matricula,Aluno
WHERE Nota_Media < 5 AND Aluno.RA = Matricula.RA AND DATA_Ano = 2021