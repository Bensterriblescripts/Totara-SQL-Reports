SELECT
CONCAT(u.firstname, ' ', u.lastname) AS Learner,
CONCAT('<a target="_new" href = "%%WWWROOT%%/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a>') AS 'Course',
quiz.name,
attempts.attempt AS 'Attempt',
attempts.id,
lprog.programid
/*
IF(qover.attempts IS NULL, '1', qover.attempts) AS 'Attempts allocated',
CONCAT('<a target="_new" href = "%%WWWROOT%%/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">View attempt</a>') AS 'View attempt',
CONCAT('Submitted - ', '<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y')) AS Submitted,
DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d/%m/%Y') AS D,
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS 'Grade',
CONCAT(IF(attempts.timefinish = 0, 'In progress', ''), IF(attempts.timefinish != 0 AND attempts.sumgrades IS NULL, 'Submitted', ''), IF(attempts.sumgrades IS NOT NULL, 'Graded', '')) AS 'Status'
*/

FROM prefix_block_mitoassessor_quizstatus AS quizattempt

JOIN prefix_user AS u
	ON quizattempt.userid = u.id
JOIN prefix_quiz AS quiz
	ON quizattempt.quizid = quiz.id
JOIN prefix_block_mitoassessor_learnercompl AS lprog
	ON c.id = lprog.courseid
	AND quizattempt.userid = lprog.userid
JOIN prefix_course AS c
	ON quiz.course = c.id
LEFT JOIN prefix_quiz_attempts AS attempts
	ON u.id = attempts.userid
	AND quiz.id = attempts.quiz

ORDER BY attempts.timemodified DESC