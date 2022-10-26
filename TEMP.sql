SELECT 

CONCAT(u.firstname,' ',u.lastname) AS 'Learner'

FROM mdl_block_mitoassessor_quizstatus AS statusq
JOIN mdl_quiz_attempts AS attempts
    ON statusq.quizid = attempts.quiz
    AND statusq.userid = attempts.userid
JOIN mdl_quiz AS quiz
    ON statusq.quizid = quiz.id
JOIN mdl_course AS c
    ON quiz.course = c.id
JOIN mdl_user AS u 
    ON statusq.userid = u.id
ORDER BY attempts.timefinish DESC