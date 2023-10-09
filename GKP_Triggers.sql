create or replace FUNCTION insert_position()
RETURNS TRIGGER
Language PLPGSQL
As $$
BEGIN
  IF (EXISTS(SELECT 1 FROM position WHERE Name_Position = NEW.Name_Position)) THEN
    return SQLSTATE '45000', 'Данная запись уже есть в таблице' = MESSAGE_TEXT;
  END IF;
END;
$$

create trigger insert_pos
BEFORE INSERT ON position
for each row
execute procedure  insert_position();

create or replace FUNCTION update_sick_list()
RETURNS TRIGGER
Language PLPGSQL
As $$
BEGIN
  IF OLD.Sick_List_Number = new.Sick_List_Number THEN
        update sick_list 
        set Sick_List_Number = old.Sick_List_Number, Sick_List_Opening_Date = new.Sick_List_Opening_Date, Sick_List_Closing_Date = new.Sick_List_Closing_Date, Date_Of_Next_Visit = new.Date_Of_Next_Visit, Name_Organisation = new.Name_Organisation, Ticket_Id = new.Ticket_Id
        where old.Id_Sick_List = Id_Sick_List;
    END IF;
END;
$$

create trigger update_sck_l
BEFORE INSERT ON position
for each row
execute procedure  update_sick_list();


create or replace FUNCTION del_client()
RETURNS TRIGGER
Language PLPGSQL
As $$
BEGIN
  INSERT INTO Del_Clients(OldClient_Id,DelSecond_Name, DelFirst_Name, DelMiddle_Name, DelPassport_Used_By, DelDate_Of_Issue, DelDivision_Code,
    DelGender, DelDate_Of_Burth, DelPlace_Of_Burth, DelPassport_Serries, DelId_Passport, DelDetails_Of_Snils, DelDetails_Of_The_Mhif_Police,
    DelContact_Number, DelGmail_Cl, DelLogin_Cl, DelPassword_Cl)
        VALUES(old.Id_Client, old.Second_Name, old.First_Name, old.Middle_Name , old.Passport_Used_By , old.Date_Of_Issue , old.Division_Code , 
        old.Gender , old.Date_Of_Burth , old.Place_Of_Burth , old.Passport_Serries , old.Id_Passport , old.Details_Of_Snils , 
        old.Details_Of_The_Mhif_Police , old.Contact_Number , old.Gmail_Cl , old.Login_Cl , old.Password_Cl);
    call client_delete(Id_Client);
END;
$$

create trigger del_cl
BEFORE INSERT ON position
for each row
execute procedure  del_client();


create or replace FUNCTION insert_ticket()
RETURNS TRIGGER
Language PLPGSQL
As $$
BEGIN
  IF Date_Of_Reception > sysdate() THEN
    insert into ticket (Date_Of_Reception, Treatment_Employee_Id, Personal_Outpatient_Card_Id, Time_Of_Reception, Ticket_Number)
    values (new.Date_Of_Reception, new.Treatment_Employee_Id, new.Personal_Outpatient_Card_Id, new.Time_Of_Reception, new.Ticket_Number);
  END IF;
END;
$$

create trigger insert_tick
BEFORE INSERT ON position
for each row
execute procedure  insert_ticket();