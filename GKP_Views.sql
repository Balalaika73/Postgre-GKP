#Полный профиль лечебных услуг
CREATE VIEW Profile_Of_Medical_Services AS select concat(Second_Name_Empl,' ', First_Name_Empl,' ',Middle_Name_Empl),
Name_Medical_Degree, Name_Treatment_Profiles from Employee_Profile
inner join Treatment_Employee on Treatment_Employee_Id = Id_Treatment_Employee
inner join Medical_Degree on Medical_Degree_id = Id_Medical_Degree
inner join Treatment_Profiles on Treatment_Profiles_Id = Id_Treatment_Profiles
group by Second_Name_Empl,First_Name_Empl,Middle_Name_Empl,
Name_Medical_Degree, Name_Treatment_Profiles;

#Данные, который должен выбрать пользователь для записи
CREATE VIEW Creating_Ticket AS
select Name_Treatment_Profiles, concat(Second_Name_Empl,' ',First_Name_Empl,' ',Middle_Name_Empl), Date_Of_Reception, Time_Of_Reception,
Ticket_Number from Ticket
inner join Treatment_Employee on Treatment_Employee_Id = Id_Treatment_Employee
inner join Employee_Profile on Id_Employee_Profile =
Id_Treatment_Employee
inner join Treatment_Profiles on Treatment_Profiles_Id =
Id_Treatment_Profiles;

#Диагноз и лечение пациента после приема
CREATE VIEW All_Service AS
select Code_Of_Service,
CONCAT(Unique_Diagnosis_Number,' ',Name_Of_Diagnosis), Exercise_Program,
Name_Taking_Medications from Service_Recomended_Treatment
inner join Recommended_Taking_Medications on
Recommended_Taking_Medications_Id = Id_Recommended_Taking_Medications
inner join Service_Diagnosis on Service_Diagnosis_Id = Id_Service_Diagnosis
inner join Service on Service_Id = Id_Service
inner join Diagnosis on Diagnosis_Id = Id_Diagnosis
inner join Recommended_Treatment on Recommended_Treatment_Id =
Id_Recommended_Treatment
inner join Taking_Medications on Taking_Medications_Id =
Id_Taking_Medications
group by Code_Of_Service, Unique_Diagnosis_Number, Name_Of_Diagnosis, Exercise_Program, Name_Taking_Medications;

#Данные для создания больничного листа
CREATE VIEW Creating_Sick_list AS 
select Second_Name || First_Name|| Middle_Name,
concat('Номер: ', Sick_List_Number, ' Дата открытия: ', Sick_List_Opening_Date,
' Дата след. посещения: ', Date_Of_Next_Visit) from Sick_List
inner join Ticket on Ticket_Id = Id_Ticket
inner join Personal_Outpatient_Card on Personal_Outpatient_Card_Id =
Id_Personal_Outpatient_Card
inner join clients on Client_Id = Id_Client
group by Sick_List_Number, Second_Name, First_Name, Middle_Name, Sick_List_Opening_Date, Date_Of_Next_Visit;

#Формирование амбулаторной карты
CREATE VIEW Creating_Card AS
select Personal_Outpatient_Card_Number, Card_Registration_Date,
concat(Second_Name, ' ',First_Name,' ',Middle_Name), Passport_Used_By,
Date_Of_Issue, Division_Code, Gender, Date_Of_Burth, Place_Of_Burth,
Passport_Serries, Id_Passport, Details_Of_Snils, Details_Of_The_Mhif_Police,
Contact_Number, Gmail_Cl, Login_Cl from Personal_Outpatient_Card
inner join Clients on Client_Id = Id_Client
group by Personal_Outpatient_Card_Number, Card_Registration_Date,
Second_Name,First_Name,Middle_Name, Passport_Used_By,
Date_Of_Issue, Division_Code, Gender, Date_Of_Burth, Place_Of_Burth,
Passport_Serries, Id_Passport, Details_Of_Snils, Details_Of_The_Mhif_Police,
Contact_Number, Gmail_Cl, Login_Cl;

#Предстоящие записи
CREATE VIEW new_visit AS select Ticket_Number, Date_Of_Reception, Time_Of_Reception from ticket where Date_Of_Reception > now();

#Вывод больничных с продолжительностью большей средней
CREATE VIEW sickl_dur AS
select Sick_List_Number, Sick_List_Opening_Date, Sick_List_Closing_Date
from Sick_List
where (select DATE_PART('days', Sick_List_Closing_Date::date) - DATE_PART('days', Sick_List_Opening_Date::date)) > (select avg(DATE_PART('days', Sick_List_Closing_Date::date) - DATE_PART('days', Sick_List_Opening_Date::date)) from Sick_list);
