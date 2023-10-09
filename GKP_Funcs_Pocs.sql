CREATE PROCEDURE Taking_Medications_Insert(name_med CHARACTER VARYING)
LANGUAGE 'plpgsql'
as $$
BEGIN
 insert into Taking_Medications(Name_Taking_Medications) values (name_med);
END;
$$;

CREATE PROCEDURE position_edit(id integer, name_pos CHARACTER VARYING)
LANGUAGE 'plpgsql'
as $$
BEGIN
 update Position set Name_Position = name_pos where Id_Position = id;
END;
$$;

CREATE PROCEDURE client_delete(id integer)
LANGUAGE 'plpgsql'
as $$
 declare card_numb integer;
 declare diag integer;
 declare sd integer;
 declare tic integer;
 declare ser integer;
BEGIN
    select Id_Personal_Outpatient_Card into card_numb from Personal_Outpatient_Card join Clients on Client_Id = Id_Client where Id_Client = id;
 delete from Outpatient_Card_Employee where Personal_Outpatient_Card_Id = card_numb;
    select all Id_Diagnosis into diag from Diagnosis where Personal_Outpatient_Card_Id = card_numb;
    select all Id_Service_Diagnosis into sd from Service_Diagnosis where Diagnosis_Id = diag;
 delete from Service_Recomended_Treatment where Service_Diagnosis_Id = sd;
    delete from Service_Diagnosis where Diagnosis_Id = diag;
    delete from Diagnosis where Personal_Outpatient_Card_Id = card_numb;
    select all Id_Ticket into tic from Ticket where Personal_Outpatient_Card_Id = card_numb;
 select all Id_Service into ser from Service where Ticket_Id = tic;
    delete from Service_Treatment where Service_Id = ser;
    delete from Service where Ticket_Id = tic;
    delete from Sick_List where Ticket_Id = tic;
    
    delete from Ticket where Personal_Outpatient_Card_Id = card_numb;
    delete from Personal_Outpatient_Card where Id_Personal_Outpatient_Card = card_numb;
    delete from Clients where Id_Client = id;
END;
$$;

CREATE FUNCTION appointment_count(id integer) RETURNS integer
LANGUAGE 'plpgsql'
as $$
	declare count integer;
BEGIN
    select count(id_ticket) into count from Ticket join Treatment_Employee on Treatment_Employee_Id = Id_Treatment_Employee join Medical_Departments on Medical_Departments_Id = Id_Medical_Departments where Id_Medical_Departments=id;
RETURN count;
END;
$$;

CREATE FUNCTION sick_duration(id integer) RETURNS integer
LANGUAGE 'plpgsql'
as $$
	declare date_op TIMESTAMP;
	declare date_cl TIMESTAMP;
    declare days integer;
	declare dur integer;
BEGIN
    select Sick_List_Opening_Date into date_op from Sick_List where Id_Sick_List = id;
    select Sick_List_Closing_Date into date_cl from Sick_List where Id_Sick_List = id;
    select Date_part('days', date_cl - date_op) into days;
RETURN days;
END;
$$;

CREATE FUNCTION emp_info(id integer) RETURNS varchar(100)
LANGUAGE 'plpgsql'
as $$
	declare fio varchar(100);
	declare degr varchar(100);
	declare pos varchar(100);
	declare dep varchar(100); 
BEGIN
    
    select CONCAT(Second_Name_Empl,' ', First_Name_Empl,Middle_Name_Empl) into fio from Treatment_Employee where Id_Treatment_Employee = id;
    
    select Name_Medical_Degree into degr from Medical_Degree JOIN Treatment_Employee
    ON Medical_Degree_Id = Id_Medical_Degree where Id_Treatment_Employee = id;
    
    select Name_Position into pos from Employee_Position JOIN Position
    ON Position_Id = Id_Position where Treatment_Employee_Id = id;
    
    select Name_Medical_Departments into dep from Treatment_Employee JOIN Medical_Departments
    ON Medical_Departments_Id = Id_Medical_Departments where Id_Treatment_Employee = id;
RETURN CONCAT(fio,'|', degr, '|', pos, '|', dep);
END;
$$;

select emp_info(1);
select appointment_count(1);
select sick_duration(5);

call Taking_Medications_Insert('Грамидин');
select * from Taking_Medications;
call client_delete(5);
select * from Clients;
call position_edit(1, 'Хирург');
select * from Position;