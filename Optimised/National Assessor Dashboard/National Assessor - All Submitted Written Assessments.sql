SELECT
CONCAT(u.firstname, ' ', u.lastname) AS Learner,
/*CONCAT('<a target="_new" href = "%%WWWROOT%%/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a>') AS 'Course',*/
gquiz.quizid,
attempts.attempt AS 'Attempt',
attempts.id
/*
IF(qover.attempts IS NULL, '1', qover.attempts) AS 'Attempts allocated',
CONCAT('<a target="_new" href = "%%WWWROOT%%/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">View attempt</a>') AS 'View attempt',
CONCAT('Submitted - ', '<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y')) AS Submitted,
DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d/%m/%Y') AS D,
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS 'Grade',
CONCAT(IF(attempts.timefinish = 0, 'In progress', ''), IF(attempts.timefinish != 0 AND attempts.sumgrades IS NULL, 'Submitted', ''), IF(attempts.sumgrades IS NOT NULL, 'Graded', '')) AS 'Status'
*/

FROM mdl_block_mitoassessor_tobegraded AS gquiz

JOIN mdl_quiz_attempts AS attempts
	ON gquiz.attemptid = attempts.id
	AND gquiz.quizid = attempts.quiz
	AND gquiz.userid = attempts.userid

JOIN mdl_user AS u
	ON gquiz.userid = u.id

