SELECT
CONCAT(u.firstname,' ',u.lastname) AS 'Learner',
CONCAT('<a target="_new" href = "%%WWWROOT%%/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a>') AS 'Course',
quiz.name,
attempts.attempt AS 'Attempt',
attempts.id,
attempts.attempt AS 'Attempts allocated',
CONCAT('<a target="_new" href = "%%WWWROOT%%/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">View attempt</a>') AS 'View attempt',
CONCAT('Submitted - ', '<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y')) AS Submitted,
DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d/%m/%Y') AS D,
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS 'Grade',
CONCAT(IF(attempts.timefinish = 0, 'In progress', ''), IF(attempts.timefinish != 0 AND attempts.sumgrades IS NULL, 'Submitted', ''), IF(attempts.sumgrades IS NOT NULL, 'Graded', '')) AS 'Status'

FROM mdl_block_mitoassessor_tobegraded AS gquiz
LEFT JOIN mdl_quiz_overrides AS qover
    ON gquiz.quizid = qover.quiz
    AND gquiz.userid = qover.userid
JOIN mdl_quiz_attempts AS attempts
	ON gquiz.attemptid = attempts.id
JOIN mdl_course AS c
	ON gquiz.courseid = c.id
JOIN mdl_quiz AS quiz
	ON gquiz.quizid = quiz.id
JOIN mdl_user AS u
	ON gquiz.userid = u.id
    AND u.suspended = 0
    
WHERE quiz.preferredbehaviour = 'deferredfeedback'
AND u.username != 'elearning.admin'
ORDER BY attempts.timefinish DESC