SELECT
attempts.id AS 'attempt id',
CONCAT(u.firstname,' ',u.lastname) AS 'learner',
attempts.attempt AS 'attempt number',
qover.attempts AS 'overrides',
attempts.timefinish AS 'completed on',
quiz.id AS 'quiz',
progpath.course AS 'course',
prog.fullname AS 'program'

FROM prefix_quiz_attempts AS attempts

JOIN prefix_user AS u
	ON attempts.userid = u.id
	
LEFT JOIN prefix_quiz_overrides AS qover
	ON attempts.quiz = qover.quiz
	AND attempts.userid = qover.userid
	AND (qover.attempts IS NULL OR attempts.attempt = qover.attempts)

JOIN prefix_quiz AS quiz
	ON attempts.quiz = quiz.id

LEFT JOIN 
(
	SELECT
	c.id AS courseid,
	c.shortname AS course,
	csetc.coursesetid AS csid

	FROM prefix_course AS c

	JOIN prefix_prog_courseset_course AS csetc
	ON c.id = csetc.courseid

	GROUP BY c.id
)
	AS progpath
		ON quiz.course = progpath.courseid

JOIN prefix_prog_courseset AS cs
	ON progpath.csid = cs.id

JOIN prefix_prog AS prog
	ON cs.programid = prog.id

WHERE attempts.timefinish > 1634027059
AND attempts.attempt > 3

ORDER BY attempts.timefinish ASC