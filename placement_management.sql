-- ===============================================================================================================================================================================================================================================================================================================================================================
-- Placement Management System
-- ===============================================================================================================================================================================================================================================================================================================================================================
-- Database Creation
create database placement_management;
use placement_management;
show databases;

-- Creating students table
create table students(student_id int primary key auto_increment, student_name varchar(100) not null, email varchar(100) unique,batch int);

-- Creating skills table
create table skills(skill_id int primary key auto_increment, skill_name varchar(50) not null unique);

-- Creating students skills table
create table student_skills(student_id int, skill_id int, primary key(student_id, skill_id),foreign key (student_id) references students(student_id), foreign key (skill_id) references skills(skill_id));

-- Creating companies table
create table companies(company_id int primary key auto_increment, company_name varchar(100) not null unique);

-- Creating Jobs table
create table jobs(job_id int primary key auto_increment,company_id int,job_title varchar(100) not null, salary decimal(10,2), foreign key (company_id) references companies(company_id));

-- Creating applications table
create table applications(application_id int primary key auto_increment, student_id int,job_id int,application_date date, status varchar(30), foreign key (student_id) references students(student_id), foreign key(job_id) references jobs(job_id));

-- Creating interviwes table
create table interviews(interview_id int primary key auto_increment, application_id int, interview_date date,status varchar(30), foreign key(application_id) references applications(application_id));

-- Creating placements table
create table placements(placement_id int primary key auto_increment,student_id int,job_id int, placement_date date, foreign key(job_id) references jobs(job_id));
show tables;

-- ==================================================================================================================================================================================================================================================================================================================================================================================================================================
-- Data Insertion
-- ===============================================================================================================================================================================================================================================================================================================================================================================================================================================

-- Inserting student data
insert into students (student_name, email, batch)values('Rahul','rahul@gamil.com',2026),('Kiran','kiran@gamil.com',2026),('Sai','sai@gamil.com',2026),('Ravi','ravi@gamil.com',2026),('Anil','anil@gamil.com',2026),('Suresh','suresh@gamil.com',2026),('Prakash','prakash@gamil.com',2026),('Arjun','arjun@gamil.com',2026),('Vamsi','vamsi@gamil.com',2026),('Naveen','naveen@gamil.com',2026);
select * from students;

-- Inserting skill data
insert into skills(skill_name) values('python'),('HTML'),('SQL'),('React'),('AWS'),('JavaScript');
select * from skills;

-- Assigning skiils to students
insert into student_skills (student_id,skill_id) values(1,1),(1,3),(1,4),(2,1),(2,3),(3,2),(3,4),(4,1),(4,5),(5,3),(5,6),(6,1),(6,3),(7,2),(7,6),(8,1),(8,4),(9,3),(9,5),(10,1),(10,3);
select * from student_skills;

-- Inserting company data
insert into companies(company_name) values('TCS'),('Infosys'),('Wipro'),('Accenture'),('Deloitte');
select * from companies;

-- Inserting job data
insert into jobs (company_id,job_title,salary) values(1,'Python Developer',600000),(1,'Java Developer',550000),(2,'Data Analyst',600000),(2,'Python Developer',650000),(3,'Java Developer',600000),(4,'Python Developer',800000),(4,'Data Analyst',750000),(5,'Cloud Engineer',600000),(5,'Software Developer',850000);
select * from jobs;

-- Inserting application data
insert into applications(student_id,job_id,application_date,status) values(1,1, '2026-01-10', 'Applied'),(1,2, '2026-01-11', 'Applied'),(1,3, '2026-01-12', 'Shortlisted'),(1,4, '2026-01-13', 'Applied'),(1,5, '2026-01-14', 'Rejected'),(1,6, '2026-01-15', 'Shortlisted');
select * from applications;

-- Inserting remaining application data
insert into applications(student_id,job_id,application_date,status) values(2,1, '2026-01-16', 'Applied'),(2,4, '2026-01-17', 'Shortlisted'),(2,7, '2026-01-18', 'Applied'),(3,3, '2026-01-19', 'Applied'),(3,5, '2026-01-20', 'Rejected'),(4,1, '2026-01-21', 'Applied'),(4,6, '2026-01-22', 'Shortlisted'),(4,8, '2026-01-23', 'Applied'),(5,2, '2026-01-24', 'Applied'),(5,9, '2026-01-25', 'Shortlisted');
select * from applications;

-- Inserting interview data
insert into interviews (application_id,interview_date, status) values(1,'2026-02-01','Attended'),(2,'2026-02-03','Attended'),(3,'2026-02-05','Attended'),(4,'2026-02-07','Not Attended'),(7,'2026-02-10','Attended'),(8,'2026-02-12','Attended'),(10,'2026-02-15','Not Attended'),(11,'2026-02-17','Attended');
select * from interviews;

-- Inserting placement data
insert into placements(student_id,job_id,placement_date) values(1,6, '2026-03-01'),(2,4, '2026-03-03'),(4,7, '2026-03-05'),(5,9, '2026-03-07');
select * from placements;

-- =======================================================================================================================================================================================================================================================================================================================================================================================
-- Data retrival from the above tables
-- ======================================================================================================================================================================================================================================================================================================================================================================================

/* Find Students who applied to more than 5 jobs */
select student_id,count(job_id) as total_applications from applications group by student_id having count(job_id)>5;

-- Display student name also 
select s.student_id,s.student_name,count(a.job_id) as total_applications from students s join applications a on s.student_id =a.student_id group by s.student_id,s.student_name having count(a.job_id)>5;

/* Find Companies offering the highest salary */
select max(salary) from jobs;
select c.company_name,j.job_title,j.salary from companies c join jobs j on c.company_id =j.company_id where j.salary =(select max(salary) from jobs);

/* Students who applied but never attended an interview */
select s.student_id,s.student_name from students s join applications a on s.student_id = a.student_id where not exists (select 1 from applications a2 join interviews i on a2.application_id=i.application_id where a2.student_id=s.student_id and i.status = 'Attended') group by s.student_id,s.student_name;

/* Find students who have Python skill and applied for Python jobs */
select distinct s.student_id,s.student_name from students s join student_skills ss on s.student_id = ss.student_id join skills sk on ss.skill_id =sk.skill_id join applications a on s.student_id =a.student_id join jobs j on a.job_id =j.job_id where lower(sk.skill_name)='python' and lower(j.job_title) like '%python%';

/* Find the company with the highest number of selected students */
select c.company_name,count(p.student_id) as selected_students from companies c join jobs j on c.company_id=j.company_id join placements p on j.job_id =p.job_id group by c.company_id,c.company_name;

/* Find the Placement percentage batch-wise */
select s.batch,count(distinct p.student_id) as placed_students,count(distinct s.student_id) as total_students,round(count(distinct p.student_id) *100.0/count(distinct s.student_id),2) as placement_percentage from students s left join placements p on s.student_id =p.student_id group by s.batch;