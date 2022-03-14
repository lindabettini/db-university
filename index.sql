---------------- ESERCIZIO I PARTE ----------------


-- Selezionare tutti gli studenti nati nel 1990 
SELECT * FROM `students` WHERE `date_of_birth` LIKE '1990-%'

-- Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * FROM `courses` WHERE `cfu` >= 10

-- Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * FROM `students` WHERE 2022 - YEAR(`date_of_birth`) >= 30

-- Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * FROM `courses` WHERE `period` = 'I semestre' AND `year` = 1

-- Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * FROM `exams` WHERE `hour` > '14:00:00' AND `date` = `2020-06-20`

-- Selezionare tutti i corsi di laurea magistrale (38)
SELECT * FROM `degrees` WHERE `level` = 'magistrale'

-- Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) FROM `departments` 

-- Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(*) FROM `teachers` WHERE `phone` IS NULL

-- Contare quanti iscritti ci sono stati ogni anno
SELECT COUNT(*) FROM `students` GROUP BY YEAR(`enrolment_date`)

-- Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT COUNT(*) FROM `teachers` GROUP BY `office_address`

-- Calcolare la media dei voti di ogni appello d'esame
SELECT AVG(`vote`) FROM `exams, exam_student` GROUP BY `exams(`date`)`

-- Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(*) AS 'total_courses', `department_id` FROM `degrees` GROUP BY `department_id`;



---------------- ESERCIZIO II PARTE ----------------


-- Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT `students`.`surname`, `students`.`name`,  `degrees`.`name`
FROM `students`
JOIN `degrees`
ON `students`.`degree_id` = `degrees`.`department_id`
HAVING `degrees`.`name` = 'Corso di Laurea in Economia';


-- Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT `degrees`.`name`, `departments`.`name`
FROM `degrees`
JOIN `departments`
ON `departments`.`id`= `degrees`.`department_id`
WHERE `departments`.`name` = 'Dipartimento di Neuroscienze';


-- Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT `courses`.`name`, `teachers`.`surname`, `teachers`.`name`
FROM `courses`
JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`teacher_id`
JOIN `teachers`
ON `course_teacher`.`teacher_id` = `teachers`.`id`
WHERE `teachers`.`id` = '44';


-- Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT `students`.`surname`, `students`.`name`, `degree_id`, `degrees`.`name`, `departments`.`name`
FROM `students` 
JOIN `degrees`
ON `students`.`degree_id` = `degrees`.`id`
JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
ORDER BY `students`.`surname` , `students`.`name`;


-- Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT *
FROM `degrees`
JOIN `courses`
ON `degrees`.`id` = `courses`.`id` 
JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `teachers`
ON `course_teacher`.`course_id` = `teachers`.`id`;


-- Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT `teachers`.*, `departments`.`name` 
FROM `departments` 
JOIN `degrees` 
ON `departments`.`id` = `degrees`.`department_id` 
JOIN `courses` 
ON `degrees`.`id` = `courses`.`degree_id` 
JOIN `course_teacher` 
ON `courses`.`id` = `course_teacher`.`course_id` 
JOIN `teachers` 
ON `teachers`.`id` = `course_teacher`.`teacher_id` 
WHERE `departments`.`name` = 'Dipartimento di Matematica';

-- Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami
SELECT `students`.`surname`, `students`.`name`, COUNT(`exam_student`.`vote`) AS `attempts`, MAX(`exam_student`.`vote`) AS `max_vote`
FROM `exam_student` 
JOIN `students`
ON `exam_student`.`student_id` = `students`.`id`
JOIN `exams`
ON `exams`.`id` = `exam_student`.`exam_id`
JOIN `courses`
ON `courses`.`id` = `exams`.`course_id`
GROUP BY `students`.`id`, `courses`.`id`
HAVING `max_vote` >= 18;  