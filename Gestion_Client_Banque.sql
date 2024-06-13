--Creation des Tables
create table T_VILLE(
code_ville varchar(32),
nom_ville varchar(32),
constraint pk_code_ville primary key (code_ville)
);


create table T_EMPLOYE_CHARGE_CLIENT(
code_charge varchar(32),
nom_charge varchar(32),
constraint pk_code_charge primary key (code_charge)
);

create table T_CLIENT(
numero_client int,
nom_client varchar(32),
date_naissance_client date,
code_ville_residence_client varchar(32),
code_charge_client varchar(32),
nombre_comptes_client int,
constraint pk_numero_client primary key (numero_client),
foreign key (code_charge_client) references T_EMPLOYE_CHARGE_CLIENT(code_charge),
foreign key (code_ville_residence_client) references T_VILLE(code_ville)
);

create table T_COMPTE (
numero_compte int,
sold_compte number(8,2),
date_derniere_operation_compte date,
nombre_operation_mensuel_compte int,
client_compte int,
constraint pk_numero_compte primary key (numero_compte),
foreign key (client_compte) references T_CLIENT (numero_client)
);

--Création des séquence
create sequence  T_sequence_client
minvalue 100 maxvalue 1000
start with 200 increment by 1 cycle;

create sequence seq_num_compt
minvalue 1 maxvalue 1000
start with 1 increment by 1 cycle;


--Remplissage des Table 
insert into T_VILLE(code_ville,nom_ville) values ('VL1001','Tunis');
insert into T_VILLE(code_ville,nom_ville) values ('VL1201','Sousse');
insert into T_VILLE(code_ville,nom_ville) values ('VL1311','Sfax');

insert into T_EMPLOYE_CHARGE_CLIENT(code_charge,nom_charge) values('CH0001','Joe');
insert into T_EMPLOYE_CHARGE_CLIENT(code_charge,nom_charge) values('CH0101','Brad');
insert into T_EMPLOYE_CHARGE_CLIENT(code_charge,nom_charge) values('CH0301','Clarck');

insert into T_CLIENT(numero_client,nom_client,date_naissance_client,code_ville_residence_client,code_charge_client,nombre_comptes_client) values(T_sequence_client.NEXTVAL,'Brad','2/02/1992','VL1001','CH0001',4);
insert into T_CLIENT(numero_client,nom_client,date_naissance_client,code_ville_residence_client,code_charge_client,nombre_comptes_client) values(T_sequence_client.NEXTVAL,'Clarck','21/10/1998','VL1001','CH0001',4);
insert into T_CLIENT(numero_client,nom_client,date_naissance_client,code_ville_residence_client,code_charge_client,nombre_comptes_client) values(T_sequence_client.NEXTVAL,'Boby','16/12/2003','VL1311','CH0301',2);
insert into T_CLIENT(numero_client,nom_client,date_naissance_client,code_ville_residence_client,code_charge_client,nombre_comptes_client) values(T_sequence_client.NEXTVAL,'Lex','14/12/2000','VL1311','CH0301',2);


--Affichage des Table 
select * from T_CLIENT;
select * from T_EMPLOYE_CHARGE_CLIENT;
select * from T_VILLE;
select * from T_COMPTE;


--Début des block PL/SQL
SET SERVEROUTPUT ON

accept v_age  prompt'Quel est votre age: ';
accept v_nom  prompt'Nom: ';
ACCEPT v_date_naiss prompt 'Quel est votre date de naissance: ';


DECLARE
v_age number(3);
v_nom varchar(32);
v_date_naiss date;
mineur exception;
v_reçoit int;
CURSOR client_cursor (code_ville_cli varchar2 ,code_du_charge varchar2) is SELECT * from T_CLIENT join  T_EMPLOYE_CHARGE_CLIENT
on T_EMPLOYE_CHARGE_CLIENT.code_charge =  code_du_charge and T_CLIENT.code_charge_client = code_du_charge
where T_CLIENT.code_ville_residence_client = code_ville_cli  ;
client_record  client_cursor%rowtype; 

BEGIN
v_age := '&v_age';
v_nom := '&v_nom';
v_date_naiss := '&v_date_naiss';
if v_age < 18 then
raise mineur;
else 
insert into T_CLIENT(numero_client,nom_client,date_naissance_client,code_ville_residence_client,code_charge_client,nombre_comptes_client) values(T_sequence_client.NEXTVAL,v_nom,v_date_naiss,'VL1201','CH0101',4);
insert into T_CLIENT(numero_client,nom_client,date_naissance_client,code_ville_residence_client,code_charge_client,nombre_comptes_client) values(T_sequence_client.NEXTVAL,v_nom,v_date_naiss,'VL1311','CH0301',4);
insert into T_COMPTE (numero_compte, sold_compte, date_derniere_operation_compte, nombre_operation_mensuel_compte, client_compte) values ( seq_num_compt.nextval, 2000.00, sysdate, 3, 201);

open client_cursor ('VL1201','CH0101');
loop
fetch client_cursor into client_record;
exit when client_cursor%notfound;
dbms_output.put_line('Nom client: '|| client_record.nom_client);
dbms_output.put_line('N° client: '|| client_record.numero_client);
dbms_output.put_line('Date naissance client: '|| client_record.date_naissance_client);
dbms_output.put_line('Code ville client: '|| client_record.code_ville_residence_client);
dbms_output.put_line('Code charge client: '|| client_record.code_charge_client);
dbms_output.put_line('Nombre de client: '|| client_record.nombre_comptes_client);
dbms_output.put_line('Nom charger client: '|| client_record.nom_charge);
end loop;

close client_cursor;


open client_cursor ('VL1311','CH0301');
loop
fetch client_cursor into client_record;
exit when client_cursor%notfound;
update T_client set nombre_comptes_client = nombre_comptes_client+2;
dbms_output.put_line('Nom client: '|| client_record.nom_client);
dbms_output.put_line('N° client: '|| client_record.numero_client);
dbms_output.put_line('Date naissance client: '|| client_record.date_naissance_client);
dbms_output.put_line('Code ville client: '|| client_record.code_ville_residence_client);
dbms_output.put_line('Code charge client: '|| client_record.code_charge_client);
dbms_output.put_line('Nombre de client: '|| client_record.nombre_comptes_client);
dbms_output.put_line('Nom charger client: '|| client_record.nom_charge);
end loop;

close client_cursor;
end if;
dbms_output.put_line('Tres bien vous pouvez crée un compt sans probleme');

exception

when mineur then
dbms_output.put_line('Il faut avoir au minimum 18');
END;
/




--Suppression des Tables
drop table T_COMPTE;
drop table T_CLIENT;
drop table T_VILLE;
drop table T_EMPLOYE_CHARGE_CLIENT;

--Suppression des séquences
drop sequence T_sequence_client;
drop sequence seq_num_compt;
