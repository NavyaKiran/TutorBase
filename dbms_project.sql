
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_paychecks_paycheck_tutor_id')
    alter table paychecks drop constraint fk_paychecks_paycheck_tutor_id;

drop table if exists paychecks;

-- if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
--     where CONSTRAINT_NAME = 'fk_ratings_rating_for_id')
--     alter table ratings drop constraint fk_ratings_rating_for_id;

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_ratings_rating_tutor_id')
    alter table ratings drop constraint fk_ratings_rating_tutor_id;

drop table if exists ratings;

-- if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
--     where CONSTRAINT_NAME = 'fk_jobs_job_for_course')
--     alter table jobs drop constraint fk_jobs_job_for_course;

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_jobs_job_tutor_id')
    alter table jobs drop constraint fk_jobs_job_tutor_id;

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_jobs_job_student_id')
    alter table jobs drop constraint fk_jobs_job_student_id;

drop table if exists jobs;

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_student_courses_student_id')
    alter table student_courses drop constraint fk_student_courses_student_id;

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_student_courses_course_id')
    alter table student_courses drop constraint fk_student_courses_course_id;

drop table if exists student_courses;


if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_NAME = 'fk_students_student_course_id')
alter table students drop constraint fk_students_student_course_id;

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_NAME = 'fk_students_student_dept_id')
alter table students drop constraint fk_students_student_dept_id;

drop table if exists students; 

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_NAME = 'fk_tutors_tutor_course_id')
alter table tutors drop constraint fk_tutors_tutor_course_id;

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_NAME = 'fk_tutors_tutor_dept_id')
alter table tutors drop constraint fk_tutors_tutor_dept_id;

drop table if exists tutors; 

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_courses_course_dept_id')
    alter table courses drop constraint fk_courses_course_dept_id;

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_courses_course_tutor_id')
    alter table courses drop constraint fk_courses_course_tutor_id;

drop table if exists courses;

drop table if exists departments;

drop database if exists dbms_project 
use [master]
GO
if exists (select name from sys.databases where name='dbms_project')
    alter database dbms_project set single_user with rollback IMMEDIATE
GO
drop database if exists dbms_project;
GO

create database dbms_project;

go

use dbms_project;

GO

CREATE TABLE departments (
  dept_id INT IDENTITY NOT NULL,
--   dept_uni_id INT NOT NULL,
  dept_name VARCHAR(255) NOT NULL,
  dept_email VARCHAR(50) NOT NULL, 
  CONSTRAINT pk_departments_dept_id PRIMARY KEY (dept_id), 
  CONSTRAINT u_departments_dept_email UNIQUE(dept_email)
--   CONSTRAINT fk_departments_dept_uni_id FOREIGN KEY (dept_uni_id) REFERENCES universities (uni_id)
);


CREATE TABLE courses (
  course_id INT IDENTITY NOT NULL,
  course_name VARCHAR(255) NOT NULL,
--   course_uni_id INT NOT NULL,
  course_dept_id INT NOT NULL,
  course_level VARCHAR(50) NOT NULL,
--   course_tutor_id INT NOT NULL, 
  CONSTRAINT pk_courses_course_id PRIMARY KEY (course_id),
  --CONSTRAINT fk_courses_course_tutor_id FOREIGN KEY (course_tutor_id) REFERENCES tutors(tutor_id), 
--   CONSTRAINT fk_courses_course_uni_id FOREIGN KEY (course_uni_id) REFERENCES universities (uni_id),
  CONSTRAINT fk_courses_course_dept_id FOREIGN KEY (course_dept_id) REFERENCES departments (dept_id)
);

CREATE TABLE tutors (
    tutor_id INT IDENTITY NOT NULL, 
    tutor_email VARCHAR(50) NOT NULL, 
    tutor_firstname VARCHAR(25) NOT NULL, 
    tutor_lastname VARCHAR(25) NOT NULL, 
    tutor_dept_id INT NOT NULL, 
    tutor_city VARCHAR(15) NOT NULL, 
    tutor_state VARCHAR(15) NOT NULL, 
    tutor_zip_code CHAR(5) NOT NULL, 
    tutor_course_id INT NOT NULL, 
    CONSTRAINT pk_tutors_tutor_id PRIMARY KEY(tutor_id), 
    CONSTRAINT u_tutors_tutor_email UNIQUE(tutor_email), 
    CONSTRAINT fk_tutors_tutor_dept_id FOREIGN KEY (tutor_dept_id) REFERENCES departments(dept_id),
    CONSTRAINT fk_tutors_tutor_course_id FOREIGN KEY (tutor_course_id) REFERENCES courses(course_id)
);

CREATE TABLE students (
    student_id INT IDENTITY NOT NULL, 
    student_email VARCHAR(50) NOT NULL, 
    student_firstname VARCHAR(25) NOT NULL, 
    student_lastname VARCHAR(25) NOT NULL, 
    student_dept_id INT NOT NULL, 
    student_city VARCHAR(15) NOT NULL, 
    student_state VARCHAR(15) NOT NULL, 
    student_zip_code CHAR(5) NOT NULL, 
    student_course_id INT NOT NULL, 
    CONSTRAINT pk_students_student_id PRIMARY KEY(student_id), 
    CONSTRAINT u_students_student_email UNIQUE(student_email), 
    CONSTRAINT fk_students_student_dept_id FOREIGN KEY (student_dept_id) REFERENCES departments(dept_id),
    CONSTRAINT fk_students_student_course_id FOREIGN KEY (student_course_id) REFERENCES courses(course_id)
);


CREATE TABLE student_courses (
    bridge_id INT IDENTITY NOT NULL, 
    course_id INT NOT NULL, 
    student_id INT NOT NULL, 
    CONSTRAINT pk_student_courses_bridge_id PRIMARY KEY (bridge_id), 
    CONSTRAINT fk_student_courses_course_id FOREIGN KEY (course_id) REFERENCES courses(course_id), 
    CONSTRAINT fk_student_courses_student_id FOREIGN KEY (student_id) REFERENCES students (student_id)
)

CREATE TABLE jobs (
  job_id INT IDENTITY NOT NULL,
  job_day varchar(10) NOT NULL,  
  job_session_length INT NOT NULL, 
  job_description VARCHAR(125) NOT NULL, 
  job_student_id INT NOT NULL, 
  job_tutor_id INT NOT NULL, 
--   job_requested_by INT NOT NULL,
--   job_accepted_by INT,
--   job_for_course INT NOT NULL,
  CONSTRAINT pk_jobs_job_id PRIMARY KEY(job_id), 
  CONSTRAINT fk_jobs_job_student_id FOREIGN KEY(job_student_id) REFERENCES students(student_id), 
  CONSTRAINT fk_jobs_job_tutor_id FOREIGN KEY(job_tutor_id) REFERENCES tutors(tutor_id)
--   CONSTRAINT fk_jobs_job_requested_by FOREIGN KEY(job_requested_by) REFERENCES students(student_id), 
--   CONSTRAINT fk_jobs_job_accepted_by FOREIGN KEY(job_accepted_by) REFERENCES tutors (tutor_id), 
--   CONSTRAINT fk_jobs_job_for_course FOREIGN KEY(job_for_course) REFERENCES courses (course_id)
);


CREATE TABLE ratings (
  rating_id INT IDENTITY NOT NULL,
  rating_value INT NOT NULL,
--   rating_by_id INT NOT NULL,
  rating_tutor_id INT NOT NULL,
  rating_comment VARCHAR(255),
  CONSTRAINT pk_ratings_rating_id PRIMARY KEY (rating_id),
--   CONSTRAINT fk_ratings_rating_by_id FOREIGN KEY(rating_by_id) REFERENCES students(student_id), 
  CONSTRAINT fk_ratings_rating_tutor_id FOREIGN KEY(rating_tutor_id) REFERENCES tutors(tutor_id)
);

CREATE TABLE paychecks (
  paycheck_id INT IDENTITY NOT NULL,
  paycheck_rate DECIMAL(10, 2) NOT NULL,
  paycheck_tutor_id INT NOT NULL,
--   paycheck_by_id INT NOT NULL,
  paycheck_amount MONEY NOT NULL,
  paycheck_time INT NOT NULL, 
  paycheck_date DATE NOT NULL,
  --paycheck_job INT NOT NULL,
  CONSTRAINT pk_paychecks_paycheck_id PRIMARY KEY(paycheck_id), 
  CONSTRAINT fk_paychecks_paycheck_tutor_id FOREIGN KEY(paycheck_tutor_id) REFERENCES tutors (tutor_id), 
--   CONSTRAINT fk_paychecks_paycheck_by_id FOREIGN KEY(paycheck_by_id) REFERENCES users (user_id),
--   CONSTRAINT fk_paychecks_paycheck_job FOREIGN KEY(paycheck_job) REFERENCES jobs(job_id)
);


--


INSERT INTO departments (dept_name, dept_email)
VALUES 
('Government and Politics', 'governmentpolitics@tatu.edu'), 
('Political Studies', 'polstudies@tatu.edu'), 
('Business', 'business@tatu.edu'), 
('Engineering', 'engineering@tatu.edu'), 
('Computer Science', 'csc@tatu.edu'), 
('History', 'history@tatu.edu');

select * from departments;

INSERT INTO courses (course_name, course_dept_id, course_level)
VALUES 
('Introduction to Engineering', 4, 'undergraduate'), 
('Political Relations', 2, 'graduate'), 
('History of the Empire', 6, 'undergraduate'), 
('Introduction to Computer Science', 5, 'undergraduate');

select * from courses;

INSERT INTO tutors (tutor_email, tutor_firstname, tutor_lastname, tutor_dept_id, tutor_city, tutor_state, tutor_zip_code, 
tutor_course_id) 
VALUES 
('lorgana123@tatu.edu', 'Leia', 'Organa', 4, 'Syracuse', 'New York', 13201, 1), 
('obwken@coru.edu', 'Obi-Wan', 'Kenobi', 2, 'Syracuse', 'New York', 13244, 2), 
('candor41@fest.edu', 'Cassian', 'Andor', 5, 'Syracuse', 'New York', 13214, 4), 
('borook@fest.edu', 'Bodhi', 'Rook', 6, 'Syracuse', 'New York', 13210, 3);

select * from tutors;

INSERT INTO students (student_email, student_firstname, 
student_lastname, student_dept_id, student_city, student_state, student_zip_code, student_course_id)
VALUES
('lsky123@tatu.edu', 'Luke', 'Skywalker', 2, 'Syracuse', 'New York', 13210, 3),
('hsolo@tatu.edu', 'Han', 'Solo', 3, 'Colts Neck', 'New Jersey', 07722, 2),
('ahtan@coru.edu', 'Ahsoka', 'Tano', 2, 'Syracuse', 'New York', 13214, 1),
('jerso5@fest.edu', 'Jyn', 'Erso', 6, 'New York City', 'New York', 10002, 3),
('kesso2@fest.edu', 'Kay', 'Esso', 5, 'Lansing', 'Michigan', 48840, 3);

select * from students;

INSERT INTO jobs (job_day, job_session_length, job_description, job_student_id, job_tutor_id) 
VALUES 
('Monday', 20, 'Course Introduction', 1, 2),
('Monday', 45, 'Chapter 5', 3, 2), 
('Wednesday', 30, 'Assignment review', 2, 3), 
('Friday', 50, 'Exam review', 4, 3);

select * from jobs;

INSERT INTO ratings (rating_value, rating_tutor_id, rating_comment)
VALUES 
(5, 1, 'Good Tutor'), 
(5, 1, 'Excellent'), 
(4, 3, 'Adequate'), 
(5, 2, 'In depth teaching, excellent'), 
(1, 4, 'Tutor was rude'), 
(3, 4, 'Could be better');

select * from ratings;

INSERT INTO paychecks (paycheck_rate, paycheck_tutor_id, paycheck_amount, paycheck_time, paycheck_date)
VALUES 
(20.00, 4, 40.00, 2, '01 April 2023'), 
(40.00, 2, 80.00, 2, '06 April 2023'), 
(15.00, 3, 45.00, 3, '03 April 2023');

select * from paychecks;

--QUERY 1

--As a student, I want to be able to request a tutor for a specific course, so that I can receive additional help and support in my studies.


go

DROP FUNCTION IF EXISTS find_tutors;
GO
CREATE FUNCTION find_tutors (@course_name varchar(255))
RETURNS TABLE AS
RETURN
    SELECT b.course_name, a.tutor_firstname, a.tutor_lastname, a.tutor_email
    from tutors a 
    JOIN courses b on b.course_id = a.tutor_course_id
    where course_name = @course_name;
GO

SELECT * FROM find_tutors('Political Relations');

--QUERY 2

--As a student, I want to be able to view the list of enrolled students for each course, so that I can see who else is taking the same course.

DROP FUNCTION IF EXISTS find_students;
GO
CREATE FUNCTION find_students (@course_name varchar(255))
RETURNS TABLE AS 
RETURN 
    SELECT a.course_name, b.student_firstname, b.student_lastname, b.student_email, b.student_dept_id 
    FROM students b 
    JOIN courses a ON a.course_id = b.student_course_id
    WHERE course_name = @course_name
GO

SELECT * FROM find_students('History of the Empire');

--As a user, I want to see the top three tutors overall by rating 

SELECT TOP 3 a.tutor_firstname+' '+a.tutor_lastname as tutor_name, a.tutor_email, avg(b.rating_value) as average_rating
FROM tutors a 
JOIN ratings b ON a.tutor_id = b.rating_tutor_id
GROUP BY tutor_email, a.tutor_firstname+' '+a.tutor_lastname
ORDER BY average_rating;

--As a university administrator, I want to be able to view the tutors, the feedback they have received and their rating based 
--on their email. 

DROP FUNCTION IF EXISTS tutor_performance;

GO

CREATE FUNCTION tutor_performance (@tutor_email VARCHAR(50))
RETURNS TABLE AS 
RETURN 
SELECT a.tutor_firstname+' '+a.tutor_lastname as tutor_name, a.tutor_email, b.rating_value, b.rating_comment
FROM tutors a 
JOIN ratings b ON a.tutor_id = b.rating_tutor_id
WHERE tutor_email = @tutor_email;

GO

SELECT * FROM tutor_performance('lorgana123@tatu.edu');


--As a student, I want to view all the courses offered in every department (even if departments do not have courses)

SELECT a.dept_name, a.dept_email, b.course_name, b.course_level
FROM departments a LEFT JOIN courses b 
ON a.dept_id = b.course_dept_id
order by dept_name;

--As a student/university administrator, I want to view the average rating of tutors in descending order 

SELECT a.tutor_id, a.tutor_email, a.tutor_firstname + ' '+ a.tutor_lastname as 'Name', round(avg(b.rating_value), 2) as 'Average Rating'
FROM tutors a 
JOIN ratings b ON a.tutor_id = b.rating_tutor_id
GROUP BY a.tutor_id, a.tutor_email, a.tutor_firstname + ' '+ a.tutor_lastname
ORDER BY 'Average Rating' DESC, 'Name' ASC;



GO

--TRIGGER 
GO
DROP TRIGGER IF EXISTS dept_insert;
GO

CREATE TRIGGER dept_insert 
ON departments  
AFTER INSERT   
AS 
  BEGIN 
      PRINT('Inserted into departments')
  END

GO 

--TESTING TRIGGER 
INSERT INTO departments (dept_name, dept_email)
VALUES 
('Science', 'sci@tatu.edu');
GO

--STORED PROCEDURES 
GO
DROP PROCEDURE IF EXISTS SPInsert;

GO

CREATE PROCEDURE SPInsert (@student_email VARCHAR(50), @student_firstname VARCHAR(25), @student_lastname VARCHAR(25), @student_dept_id INT, 
@student_city VARCHAR(15), @student_state VARCHAR(15), @student_zip_code CHAR(5), @student_course_id INT)
AS 
  BEGIN 
            INSERT INTO students (student_email, student_firstname, student_lastname, student_dept_id, student_city, student_state,
            student_zip_code, student_course_id)
            VALUES (@student_email, @student_firstname, @student_lastname, @student_dept_id, @student_city, @student_state,
            @student_zip_code, @student_course_id)
  END

GO

exec SPInsert @student_email = 'damonsalvatore@tatu.edu', @student_firstname = 'Damon', @student_lastname = 'Salvatore', @student_dept_id = 5, 
@student_city = 'Mystic Falls', @student_state = 'Virginia', @student_zip_code = 22428, @student_course_id = 3;

select * from students;

