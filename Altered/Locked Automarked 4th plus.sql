SELECT
CONCAT('<strong><p ', IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) > 1, 'style="color:\ red">', ''), IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) <= 1, 'style="color:\ green">', ''),'<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y %H:%i:%s'), '</p></strong>') AS 'Submitted',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/user/profile.php?id=', CAST(attempts.userid AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://mitocrm.mito.org.nz/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.id,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(u.department, '<hr>',u.phone2) As Employer,
CONCAT(prog.fullname,'<hr><a target="_new" href = "https://elearning.mito.org.nz/course/view.php?id=', CAST(quiz.course AS CHAR), '">',CAST(progpath.fullname AS CHAR),'</a><hr><a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course',
CASE
	WHEN qover.id is not null THEN
		CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/overrideedit.php?id=', CAST(qover.id AS CHAR), '&mode=user">Add override</a>') 
	ELSE
		CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/overrideedit.php?action=adduser&cmid=', CAST(cm.id AS CHAR), '&mode=user">Add override</a>') 
END AS 'Add override (new)',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">',CAST(attempts.attempt AS CHAR),'</a>') AS 'Attempt',
qover.attempts AS 'Overrides',
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS Grade,
/*CONCAT('<a href="mailto:', attempt_join.email, '?cc=elearning@mito.org.nz', IF(ita.email IS null, '', CONCAT('%3B', ita.email)), '&Subject=MITO eLearning – ', attempt_join.fullname, ': ', attempt_join.name, ' (',attempt_join.username,')', '&body=Kia ora ',attempt_join.firstname, '%0D%0A%0D%0AYou have now used more than your allowable attempts at this assessment. %0D%0A%0D%0ABefore attempting again, you need to read the feedback from your previous answers, then review the study material and ensure that you know the answers to the questions. %0D%0A%0D%0AIf you need help with this, please call your Training Advisor and ask for guidance to find the information. %0D%0A%0D%0AWhen you are ready, start your next attempt. %0D%0A%0D%0AThe link to your last marked attempt is here: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempt_join.attemptid AS CHAR), ' (Please log in to your mymito learner portal before accessing this link)%0D%0A%0D%0AI have unlocked a new attempt for you.%0D%0A%0D%0ANgā mihi%0D%0A%0D%0A%0D%0A%0D%0A" >','Compose email', '</a>') AS 'Compose email',*/
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/grade/edit/tree/grade.php?courseid=', CAST(cm.course AS CHAR), '&id=',CAST(gg.id AS CHAR),'&gpr_type=report&gpr_plugin=grader&gpr_courseid=', CAST(cm.course AS CHAR),'">Add grader feedback</a>') AS 'Add grader feedback',
gg.feedback AS 'Grader feedback'
/*CONCAT(ita.firstname, ' ', ita.lastname) as 'ita'*/

/*Debug*/
/*attempts.id AS 'attempt id',
CONCAT(u.firstname,' ',u.lastname) AS 'learner',
attempts.attempt AS 'attempt number',
qover.attempts AS 'overrides',
attempts.timefinish AS 'completed on',
quiz.id AS 'quiz',
progpath.course AS 'course',
prog.fullname AS 'program'*/


FROM prefix_quiz_attempts AS attempts

JOIN prefix_quiz AS quiz
	ON attempts.quiz = quiz.id

JOIN 
(
	SELECT
	c.id AS courseid,
	c.shortname AS course,
	csetc.coursesetid AS csid,
	c.fullname AS fullname

	FROM prefix_course AS c

	JOIN prefix_prog_courseset_course AS csetc
	ON c.id = csetc.courseid

	GROUP BY c.id
)
	AS progpath
		ON quiz.course = progpath.courseid

JOIN prefix_course_modules AS cm
	ON quiz.id = cm.instance
	AND progpath.courseid = cm.course
	AND quiz.course = cm.course
	AND gi.iteminstance = cm.instance

JOIN prefix_prog_courseset AS cs
	ON progpath.csid = cs.id

JOIN prefix_prog AS prog
	ON cs.programid = prog.id

JOIN prefix_grade_items AS gi
	ON quiz.course = gi.courseid

JOIN prefix_grade_grades AS gg
	ON gi.id = gg.itemid
	AND attempts.userid = gg.userid

LEFT JOIN prefix_quiz_overrides AS qover
ON attempts.quiz = qover.quiz
AND attempts.userid = qover.userid

JOIN prefix_user AS u
	ON attempts.userid = u.id

WHERE attempts.timefinish > 1634027059
AND attempts.attempt >= 4
AND (qover.attempts IS NULL OR attempts.attempt = qover.attempts)


ORDER BY attempts.timefinish ASC