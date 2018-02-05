-- Drop the existing tables
DROP TABLE ROLURI CASCADE CONSTRAINTS;
DROP TABLE MOVIES_AWARDS CASCADE CONSTRAINTS;
DROP TABLE MOVIE_RATING CASCADE CONSTRAINTS;
DROP TABLE MOVIE_FORMAT CASCADE CONSTRAINTS;
DROP TABLE PERSONS_AWARDS CASCADE CONSTRAINTS;
DROP TABLE GENRE CASCADE CONSTRAINTS;
DROP TABLE LANGUAGES CASCADE CONSTRAINTS;
DROP TABLE MOVIE2LANGUAGES CASCADE CONSTRAINTS;
DROP TABLE MOVIE2GENRE CASCADE CONSTRAINTS;
DROP TABLE MOVIE2ROLES CASCADE CONSTRAINTS;
DROP TABLE MOVIE2PERSONS CASCADE CONSTRAINTS;
DROP TABLE PERSONS CASCADE CONSTRAINTS;
DROP TABLE MOVIES CASCADE CONSTRAINTS;

-- Drop existing clusters
DROP CLUSTER movies_cluster;
DROP CLUSTER persons_cluster;

-- Drop existing rollback segments
DROP ROLLBACK SEGMENT rbs_one;
DROP ROLLBACK SEGMENT rbs_two;

-- Creare segmente rollback
-- Create rollback segments in locally managed tablespaces with autoallocation disabled—in tablespaces 
-- created with the EXTENT MANAGEMENT LOCAL clause with the UNIFORM setting. 
-- The tablespace should not contain other objects such as tables and indexes; 
-- The AUTOALLOCATE setting is not supported.
CREATE ROLLBACK SEGMENT rbs_one
TABLESPACE data_TBS;

CREATE ROLLBACK SEGMENT rbs_two
TABLESPACE cluster_TBS;

-- Create movies cluster
CREATE CLUSTER movies_cluster(Movie_ID NUMERIC(10))
	PCTUSED 80
	PCTFREE 5
	SIZE 600
	TABLESPACE cluster_TBS
	STORAGE (MINEXTENTS 1
			 MAXEXTENTS 20);
-- Create index for movies cluster
CREATE INDEX idx_movies_cluster
	ON CLUSTER movies_cluster
	TABLESPACE index_TBS;
	
	
-- Create MOVIES table
CREATE TABLE MOVIES
(
    	Movie_ID                      		  NUMERIC(10) NOT NULL ,
    	Movie_Title                   		  VARCHAR2 (30) NOT NULL ,
    	Movie_Description             		  VARCHAR2 (50) ,
    	Movie_Release_Date            		  DATE ,
	Movie_Country				  VARCHAR2 (30),
	Movie_Budget				  NUMERIC (10),
	Movie_Duration				  NUMERIC (3),
	Movie_Rating_Stars 			  NUMERIC (1),
	Movie_Format 				  VARCHAR (7),
	CONSTRAINT ck_movie_title CHECK (SUBSTR(Movie_Title,1,1) = UPPER(SUBSTR(Movie_Title,1,1))),
	CONSTRAINT ck_movie_description CHECK (SUBSTR(Movie_Description,1,1) = UPPER(SUBSTR(Movie_Description,1,1))),
	CONSTRAINT ck_country CHECK (SUBSTR(Movie_Country,1,1) = UPPER(SUBSTR(Movie_Country,1,1))),
	CONSTRAINT ck_budget CHECK (Movie_Budget>0),
	CONSTRAINT ck_duration CHECK (Movie_Duration>0),
	CONSTRAINT ck_stars CHECK (Movie_Rating_Stars IN (1,2,3,4,5)),
	CONSTRAINT ck_format CHECK (Movie_Format IN ('2D','3D','4D','Blu-Ray','SD')),
	CONSTRAINT pk_movie_id PRIMARY KEY (Movie_ID) USING INDEX TABLESPACE index_TBS
) 
	PARTITION BY RANGE (Movie_Release_Date)
	(
		PARTITION movies_2k5 VALUES LESS THAN (TO_DATE('01/01/2005', 'DD/MM/YYYY')) TABLESPACE data_TBS,
		PARTITION movies_2k10 VALUES LESS THAN (TO_DATE('01/01/2010', 'DD/MM/YYYY')) TABLESPACE data_TBS,
		PARTITION movies_2k15 VALUES LESS THAN (TO_DATE('01/01/2015', 'DD/MM/YYYY')) TABLESPACE data_TBS,
		PARTITION movies_2k20 VALUES LESS THAN (TO_DATE('01/01/2020', 'DD/MM/YYYY')) TABLESPACE data_TBS
	);
	
	
	
--Create Movie_Awards table
CREATE TABLE MOVIES_AWARDS
(
	Award_ID	 			NUMERIC(10) NOT NULL,
	Award_Title	 			VARCHAR(50) NOT NULL,
	Award_Description	 		VARCHAR(100),
	Award_Year_Won	 			DATE,
	Movie_ID	 			NUMERIC(10) NOT NULL,
	CONSTRAINT ck_award_title CHECK (SUBSTR(Award_Title,1,1) = UPPER(SUBSTR(Award_Title,1,1))),
	CONSTRAINT fk_movie_award FOREIGN KEY (Movie_ID) REFERENCES MOVIES (Movie_ID),
	CONSTRAINT pk_movie_award PRIMARY KEY (Award_ID) USING INDEX TABLESPACE index_TBS
)
	CLUSTER movies_cluster (Movie_ID);
	
--------- Create Persons table
CREATE TABLE PERSONS
(
    Person_ID            	 	NUMERIC(10) NOT NULL ,
    Person_FirstName     	 	VARCHAR2 (15) NOT NULL ,
    Person_LastName      	 	VARCHAR2 (15) NOT NULL ,
    Person_FullName			VARCHAR (30) NOT NULL,
    Person_DOB           	 	DATE ,
    Person_CountryBirth  	 	CHAR (15),
    Person_Nationality			CHAR (15),
    Person_Gender			CHAR (7),
    IS_A 			 	CHAR(10),
	CONSTRAINT ck_fname CHECK (SUBSTR(Person_FirstName,1,1) = UPPER(SUBSTR(Person_FirstName,1,1))),
	CONSTRAINT ck_lname CHECK (SUBSTR(Person_LastName,1,1) = UPPER(SUBSTR(Person_LastName,1,1))),
	CONSTRAINT ck_countryb CHECK (SUBSTR(Person_CountryBirth,1,1) = UPPER(SUBSTR(Person_CountryBirth,1,1))),
	CONSTRAINT ck_gender CHECK (Person_Gender IN('M','F','unknown')),
	CONSTRAINT ck_isa CHECK (IS_A IN ('actor','director','producer','writer')),
	CONSTRAINT pk_persons PRIMARY KEY (Person_ID) USING INDEX TABLESPACE index_TBS
) 	
	TABLESPACE data_TBS;
	
------------ Create Persons_Awards table
CREATE TABLE  PERSONS_AWARDS 
(
	Award_ID			  	NUMERIC(10) NOT NULL ,
	Award_Title		 		VARCHAR(50) NOT NULL,
	Award_Description	 		VARCHAR(100),
	Award_Year_Won		 		DATE,
	Person_ID			 	NUMERIC(10) NOT NULL ,
	CONSTRAINT ck_award_titlep CHECK (SUBSTR(Award_Title,1,1) = UPPER(SUBSTR(Award_Title,1,1))),
	CONSTRAINT fk_person_award FOREIGN KEY (Person_ID) REFERENCES PERSONS (Person_ID),
	CONSTRAINT pk_person_award PRIMARY KEY (Award_ID) USING INDEX TABLESPACE index_TBS
)	
	TABLESPACE data_TBS;
	
---------------- Create Roluri (Roles) table	
 CREATE TABLE ROLURI
(
	Role_ID 			 NUMERIC(2) NOT NULL,
	Role_Title			 VARCHAR2(20),
	Quotes				 VARCHAR2(30),
	CONSTRAINT ck_role_title CHECK (SUBSTR(Role_Title,1,1) = UPPER(SUBSTR(Role_Title,1,1))),
	CONSTRAINT ck_quotes CHECK (SUBSTR(Quotes,1,1) = UPPER(SUBSTR(Quotes,1,1))),
	CONSTRAINT pk_role PRIMARY KEY (Role_ID) USING INDEX TABLESPACE index_TBS
)
	TABLESPACE data_TBS;
	
---------------- Create Genre table
CREATE TABLE GENRE 
(
	Genre_ID  	 	NUMERIC(2) NOT NULL,
	Genre 	 	 	VARCHAR2(20) NOT NULL,
	CONSTRAINT ck_genre CHECK (Genre IN ('comedy','action','adventure','crime','drama','thriller','horror')),
	CONSTRAINT pk_genre PRIMARY KEY (Genre_ID) USING INDEX TABLESPACE index_TBS
)
	TABLESPACE data_TBS;

------------------ Create Movie2Genre table	
CREATE TABLE MOVIE2GENRE 
(
	Un_ID 			NUMERIC(2) NOT NULL,
	Movie_ID    		NUMERIC(10) NOT NULL,
	Genre_ID    		NUMERIC(2) NOT NULL,
	CONSTRAINT pk_id PRIMARY KEY (Un_ID) USING INDEX TABLESPACE index_TBS,
	CONSTRAINT fk_genre FOREIGN KEY (Genre_ID) REFERENCES GENRE (Genre_ID),
	CONSTRAINT fk_movie FOREIGN KEY (Movie_ID) REFERENCES MOVIES (Movie_ID)
)
	CLUSTER movies_cluster (Movie_ID);
	
-------------------- Create Languages table	
CREATE TABLE LANGUAGES 
 (
	Language_ID   			NUMERIC(2) NOT NULL,
	Language_Name			VARCHAR2(30) NOT NULL,
	CONSTRAINT pk_lang PRIMARY KEY (Language_ID) USING INDEX TABLESPACE index_TBS,
	CONSTRAINT ck_lang CHECK (SUBSTR(Language_Name,1,1) = UPPER(SUBSTR(Language_Name,1,1)))	
 )
	TABLESPACE data_TBS;
	
-------------------- Create Movie2Languages table
CREATE TABLE MOVIE2LANGUAGES 
(
		Un_ID   			NUMERIC(2) NOT NULL,
		Movie_ID         		NUMERIC(10) NOT NULL,
		Language_ID      		NUMERIC(2) NOT NULL,
		CONSTRAINT pk_id2 PRIMARY KEY (Un_ID) USING INDEX TABLESPACE index_TBS,
		CONSTRAINT fk_movie_lang FOREIGN KEY (Movie_ID) REFERENCES MOVIES(Movie_ID),
		CONSTRAINT fk_lang FOREIGN KEY (Language_ID) REFERENCES LANGUAGES(Language_ID)
)
		CLUSTER movies_cluster (Movie_ID);
		
-------------------- Create Movie2Persons table
CREATE TABLE MOVIE2PERSONS	
(
	Un_ID               			NUMERIC(10) NOT NULL,
	Movie_ID         			NUMERIC(10) NOT NULL,
	Person_ID		 		NUMERIC(10) NOT NULL,
	Job_Title 		 		VARCHAR2(30) NOT NULL,
	CONSTRAINT pk_id3 PRIMARY KEY (Un_ID) USING INDEX TABLESPACE index_TBS,
	CONSTRAINT fk_movie_pers FOREIGN KEY (Movie_ID) REFERENCES MOVIES(Movie_ID),
	CONSTRAINT fk_persons FOREIGN KEY (Person_ID) REFERENCES PERSONS (Person_ID)
)
	CLUSTER movies_cluster (Movie_ID);
	
-------------------- Create Movie2Roles table
CREATE TABLE MOVIE2ROLES	
 (
	Un_ID            		NUMERIC(2) NOT NULL ,
	Movie_ID	 		NUMERIC(10) NOT NULL,
	Role_ID 		  	NUMERIC(2) NOT NULL,
	Person_ID		  	NUMERIC(10) NOT NULL,
	CONSTRAINT pk_id4 PRIMARY KEY (Un_ID) USING INDEX TABLESPACE index_TBS,
	CONSTRAINT fk_movier FOREIGN KEY (Movie_ID) REFERENCES MOVIES (Movie_ID),
	CONSTRAINT fk_role FOREIGN KEY (Role_ID) REFERENCES ROLURI (Role_ID),
	CONSTRAINT fk_person_role FOREIGN KEY (Person_ID) REFERENCES PERSONS(Person_ID)
 )	
	CLUSTER movies_cluster (Movie_ID);


------------ Create a backup for Movies table
------------ in bk_TBS tablespace
CREATE TABLE movies_bak 
TABLESPACE bk_TBS AS (SELECT * from MOVIES);
	