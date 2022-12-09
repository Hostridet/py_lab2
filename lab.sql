pragma foreign_keys = on;

DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS RESULT_EGE;
DROP TABLE IF EXISTS EDUCATION_DIRECTION;
DROP TABLE IF EXISTS REQUIRED_POINTS;
DROP TABLE IF EXISTS RECEIVED_STUDENTS;


CREATE TABLE IF NOT EXISTS subject
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS student
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fio VARCHAR(40) NOT NULL,
    age INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS result_ege
(
    id INTEGER not null PRIMARY KEY,
    point INTEGER not null,

    student_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES  subject (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS education_direction
(
    id NUMERIC not null PRIMARY KEY,
    name VARCHAR(60) not null,
    student_count NUMERIC not null
);

CREATE TABLE IF NOT EXISTS required_point
(
    id NUMERIC not null PRIMARY KEY,
    min_point NUMERIC not null,

    direction_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    FOREIGN KEY (direction_id) REFERENCES EDUCATION_DIRECTION(id),
    FOREIGN KEY (subject_id) REFERENCES  SUBJECT(id)
);

CREATE TABLE IF NOT EXISTS received_students
(
    id NUMERIC not null PRIMARY KEY,
    student_id INTEGER,
    direction_id INTEGER,
    FOREIGN KEY (student_id) REFERENCES STUDENT(ID),
    FOREIGN KEY (direction_id) REFERENCES  EDUCATION_DIRECTION(ID)
);

INSERT INTO SUBJECT(ID, NAME) VALUES (0, 'Математика');
INSERT INTO SUBJECT(ID, NAME) VALUES (1, 'Русский язык');
INSERT INTO SUBJECT(ID, NAME) VALUES (2, 'Английский язык');
INSERT INTO SUBJECT(ID, NAME) VALUES (3, 'География');
INSERT INTO SUBJECT(ID, NAME) VALUES (4, 'Биология');
INSERT INTO SUBJECT(ID, NAME) VALUES (5, 'Химия');

INSERT INTO STUDENT(ID, FIO, AGE) VALUES (0, 'Л.О. Лебедев', 18);
INSERT INTO STUDENT(ID, FIO, AGE) VALUES (1, 'П.О. Лазарев', 19);
INSERT INTO STUDENT(ID, FIO, AGE) VALUES (2, 'П.О. Деменко', 18);
INSERT INTO STUDENT(ID, FIO, AGE) VALUES (3, 'П.О. Ялден', 18);
INSERT INTO STUDENT(ID, FIO, AGE) VALUES (4, 'П.О. Михалко', 18);

INSERT INTO EDUCATION_DIRECTION(ID, NAME, STUDENT_COUNT)
VALUES (0, 'Программная инженерия', 22);
INSERT INTO EDUCATION_DIRECTION(ID, NAME, STUDENT_COUNT)
VALUES (1, 'МОАИС', 26);
INSERT INTO EDUCATION_DIRECTION(ID, NAME, STUDENT_COUNT)
VALUES (2, 'Робототехника', 18);
INSERT INTO EDUCATION_DIRECTION(ID, NAME, STUDENT_COUNT)
VALUES (3, 'Горное дело', 30);
INSERT INTO EDUCATION_DIRECTION(ID, NAME, STUDENT_COUNT)
VALUES (4, 'Медицинское дело', 30);

INSERT INTO received_students(id, student_id, direction_id)
VALUES(0, 2, 0);
INSERT INTO received_students(id, student_id, direction_id)
VALUES(1, 1, 1);
INSERT INTO received_students(id, student_id, direction_id)
VALUES(2, 3, 3);

INSERT INTO result_ege(id, point, student_id, subject_id)
VALUES(0, 67, 0, 2);
INSERT INTO result_ege(id, point, student_id, subject_id)
VALUES(1, 98, 0, 3);
INSERT INTO result_ege(id, point, student_id, subject_id)
VALUES(2, 78, 1, 1);
INSERT INTO result_ege(id, point, student_id, subject_id)
VALUES(3, 92, 2, 0);
INSERT INTO result_ege(id, point, student_id, subject_id)
VALUES(4, 91, 2, 2);

-- два запроса на выборку для связанных таблиц с условиями и сортировкой;
SELECT fio AS 'ФИО', name AS 'Предмет', point as 'Баллы'
FROM student
    JOIN result_ege r on student.id = r.student_id
    JOIN subject s on r.subject_id = s.id
ORDER BY name;

SELECT fio as 'ФИО', name as 'Направление'
FROM received_students
    JOIN student s on s.id = received_students.student_id
    JOIN education_direction d on d.id = received_students.direction_id
ORDER BY fio;

-- два запроса с группировкой и групповыми функциями;
SELECT name as 'Название предмета'
    FROM subject
GROUP BY subject.name;

SELECT fio as "Студент", count(subject_id) as 'Количество предметов'
FROM student
    JOIN result_ege re on student.id = re.student_id
GROUP BY fio
HAVING COUNT(subject_id) >= 2;



-- два запроса со вложенными запросами или табличными выражениями;
SELECT fio as 'ФИО', point as 'Количество баллов'
FROM student
    JOIN result_ege re on student.id = re.student_id
WHERE re.point = (SELECT point FROM result_ege WHERE result_ege.point = 92);

SELECT name as 'Направление'
FROM received_students
    JOIN education_direction d on received_students.direction_id = d.id
WHERE d.id in (SELECT id FROM education_direction WHERE education_direction.student_count > 25);

-- два запроса корректировки данных (обновление, добавление, удаление и пр)
DELETE FROM student WHERE student.fio = 'Л.О. Лебедев';

UPDATE student SET age = 25 WHERE student.id = 0;
















