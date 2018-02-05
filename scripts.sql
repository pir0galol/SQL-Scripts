------------------ Movies (1kk)

declare 
v_id number := 1;
v_title varchar2(30);
v_description varchar2(50);
v_release_date date;
v_country varchar2(30);
v_budget numeric(10);
v_duration number(3);
v_rating number(1);
v_format varchar(7);
TYPE strArray IS VARRAY(6) of VARCHAR2(10);
v_myarray strArray := strArray('USA', 'Russia', 'Sweeden','Romania', 'China', 'Italy');
TYPE strArray2 IS VARRAY(5) of VARCHAR2(7);
v_myarray2 strArray2 := strArray2('2D', '3D','4D','Blu-Ray','SD');

begin
while (v_id <= 1000000) loop
v_title := 'The Movie' || v_id;
v_description := 'This is a great movie' || v_id;
v_release_date := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(date '2000-01-01','J'),TO_CHAR(SYSDATE,'J'))),'J');
v_country := v_myarray(DBMS_RANDOM.value(1,6));
v_budget := (DBMS_RANDOM.value(1000000,500000000));
v_duration := (DBMS_RANDOM.value(60,250));
v_rating := (DBMS_RANDOM.value(1,5));
v_format := v_myarray2(DBMS_RANDOM.value(1,5));

INSERT INTO MOVIES VALUES (v_id, v_title, v_description, v_release_date,v_country, v_budget,v_duration, v_rating, v_format );
v_id := v_id+1;
end loop;
commit;
end;

select * from movies;
delete from movies;


---- Persons (300k)

declare 
v_id number := 1;
v_fname varchar2(15);
v_lname varchar2(15);
v_fullname varchar(30);
v_dob date;
v_country varchar(15);
v_nation char(15);
v_gender char(7);
v_isa char(10);
TYPE strArray IS VARRAY(10) of VARCHAR2(10);
v_myarray strArray := strArray('Jon', 'Mike', 'Paulo','Gege', 'Xai', 'Marcus','Jean','Donald','Vladmir','Ben');
TYPE strArray2 IS VARRAY(10) of VARCHAR2(10);
v_myarray2 strArray2 := strArray2('Weed', 'Snow', 'Ferguson','Ming', 'Aurelius', 'Van Damme','Truck','Punk','Carrey','Big');
TYPE strArray3 IS VARRAY(10) of VARCHAR2(10);
v_myarray3 strArray3 := strArray3('USA', 'Russia', 'Sweeden','Romania', 'China', 'Italy','Singapore','France','Canada','Japan');
TYPE strArray4 IS VARRAY(4) of VARCHAR2(10);
v_myarray4 strArray4 := strArray4('actor', 'director','producer','writer');
TYPE strArray5 IS VARRAY(8) of VARCHAR2(9);
v_myarray5 strArray5 := strArray5('russian', 'romanian','american','chinese','french','turk','brasilian','spanish');
TYPE strArray6 IS VARRAY(3) of VARCHAR2(7);
v_myarray6 strArray6 := strArray6('M', 'F','unknown');

begin
while (v_id <= 300000) loop
v_fname := v_myarray(DBMS_RANDOM.value(1,10));
v_lname := v_myarray2(DBMS_RANDOM.value(1,10));
v_fullname := v_fname||''||v_lname;
v_dob := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(date '1930-01-01','J'),TO_CHAR(date '1980-01-01','J'))),'J');
v_country := v_myarray3(DBMS_RANDOM.value(1,10));
v_nation :=v_myarray5 (DBMS_RANDOM.value(1,8));
v_gender := v_myarray6 (DBMS_RANDOM.value(1,3));
v_isa := v_myarray4(DBMS_RANDOM.value(1,4));

INSERT INTO PERSONS VALUES (v_id, v_fname, v_lname,v_fullname, v_dob, v_country, v_nation, v_gender, v_isa);
v_id := v_id+1;
end loop;
commit;
end;

-------- Insert another line in PERSONS
-------- INSERT INTO PERSONS VALUES (300001,'Ion','Popescu','Ion Popescu',DATE'1990-05-08','Romania','romanian','F','writer');


------------- Movie awards (500k)
	
declare 
v_id number := 1;
v_title varchar(50);
v_description varchar(100);
v_year date;
v_movie_id numeric(10);
TYPE strArray IS VARRAY(9) of VARCHAR2(20);
v_myarray strArray := strArray('WFCC Award', 'ASCAP Award', 'MTV Movie Award','Stinker Award', 'ACCA', 'DFCS Award','Golden Schmoes','OFTA Film Award','Critics Choice Award');


begin
while (v_id <= 500000) loop
v_title := v_myarray(DBMS_RANDOM.value(1,9));
v_description := 'Nice award' || v_id;
v_year := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(date '1950-01-01','J'),TO_CHAR(date '2017-01-01','J'))),'J');
v_movie_id := (DBMS_RANDOM.value(1,500000));

INSERT INTO MOVIES_AWARDS VALUES (v_id, v_title, v_description, v_year,v_movie_id);
v_id := v_id+1;

end loop;
commit;
end;	


------------- Persons awards (200k)

	
declare 
v_id number := 1;
v_title varchar(50);
v_description varchar(100);
v_year date;
v_person_id numeric(10);
TYPE strArray IS VARRAY(8) of VARCHAR2(20);
v_myarray strArray := strArray('Golden Globe', 'Blockbuster', 'ICS Award','Primetime Emmy', 'Chlotrudis Award', 'Oscar','Critics Choice Award','CinemaCon Award');

begin
while (v_id <= 200000) loop
v_title := v_myarray(DBMS_RANDOM.value(1,8));
v_description := 'Super award' || v_id;
v_year := TO_DATE(TRUNC(DBMS_RANDOM.value(TO_CHAR(date '1950-01-01','J'),TO_CHAR(date '2017-01-01','J'))),'J');
v_person_id := (DBMS_RANDOM.value(1,200000));

INSERT INTO PERSONS_AWARDS VALUES (v_id, v_title, v_description, v_year,v_person_id);
v_id := v_id+1;

end loop;
commit;
end;


--------------- MOVIE2PERSONS (150k)
	
declare 
v_id number := 1;
v_movie_id numeric(10);
v_person_id numeric(10);
v_job varchar2(30);
TYPE strArray IS VARRAY(4) of VARCHAR2(8);
v_myarray strArray := strArray('actor', 'director','producer','writer');

begin
while (v_id <= 150000) loop
v_movie_id := (DBMS_RANDOM.value(1,150000));
v_person_id := (DBMS_RANDOM.value(1,150000));
v_job := v_myarray(DBMS_RANDOM.value(1,4));

INSERT INTO MOVIE2PERSONS VALUES (v_id, v_movie_id, v_person_id, v_job);
v_id := v_id+1;

end loop;
commit;
end;

