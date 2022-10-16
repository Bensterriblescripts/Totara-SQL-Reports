/*SELECT
CONCAT('<strong><p ', IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) > 1, 'style="color:\ red">', ''), IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) <= 1, 'style="color:\ green">', ''),'<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y %H:%i:%s'), '</p></strong>') AS 'Submitted',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://mitocrm.mito.org.nz/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(u.department, '<hr>',u.phone2) As Employer,
CONCAT(prog.fullname,'<hr><a target="_new" href = "https://elearning.mito.org.nz/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course',
CASE
	WHEN qover.id is not null THEN
		CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/overrideedit.php?id=', CAST(qover.id AS CHAR), '&mode=user">Add override</a>') 
	ELSE
		CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/overrideedit.php?action=adduser&cmid=', CAST(cm.id AS CHAR), '&mode=user">Add override</a>') 
END AS 'Add override (new)',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">',CAST(attempts.attempt AS CHAR),'</a>') AS 'Attempt',
qover.attempts AS 'Overrides',
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS Grade,
/*
CONCAT('<a href="mailto:', attempt_join.email, '?cc=elearning@mito.org.nz', IF(ita.email IS null, '', CONCAT('%3B', ita.email)), '&Subject=MITO eLearning – ', attempt_join.fullname, ': ', attempt_join.name, ' (',attempt_join.username,')', '&body=Kia ora ',attempt_join.firstname, '%0D%0A%0D%0AYou have now used more than your allowable attempts at this assessment. %0D%0A%0D%0ABefore attempting again, you need to read the feedback from your previous answers, then review the study material and ensure that you know the answers to the questions. %0D%0A%0D%0AIf you need help with this, please call your Training Advisor and ask for guidance to find the information. %0D%0A%0D%0AWhen you are ready, start your next attempt. %0D%0A%0D%0AThe link to your last marked attempt is here: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempt_join.attemptid AS CHAR), ' (Please log in to your mymito learner portal before accessing this link)%0D%0A%0D%0AI have unlocked a new attempt for you.%0D%0A%0D%0ANgā mihi%0D%0A%0D%0A%0D%0A%0D%0A" >','Compose email', '</a>') AS 'Compose email',

CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/grade/edit/tree/grade.php?courseid=', CAST(c.id AS CHAR), '&id=',CAST(gg.id AS CHAR),'&gpr_type=report&gpr_plugin=grader&gpr_courseid=', CAST(c.id AS CHAR),'">Add grader feedback</a>') AS 'Add grader feedback',
gg.feedback AS 'Grader feedback',
CONCAT(ita.firstname, ' ', ita.lastname) as 'ita'
CONCAT(u.firstname,' ',u.lastname) AS 'learny'
*/

/* DEBUG */
SELECT
CONCAT(u.firstname,' ',u.lastname) AS 'learner',
attempts.id AS 'attemptid',
quiz.id AS 'quiz',
quiz.course AS 'course'


FROM mdl_quiz_attempts AS attempts

JOIN mdl_user AS u
	ON attempts.userid = u.id

JOIN mdl_quiz AS quiz
	ON attempts.quiz = quiz.id

JOIN mdl_course AS c
	ON quiz.course

/*JOIN mdl_grade_items AS gi
	ON quiz.course = gi.courseid
	AND attempts.quiz = gi.iteminstance

JOIN mdl_grade_grades AS gg=	
	ON gi.id = gg.itemid
	AND attempts.userid = gg.userid*/

JOIN mdl_prog_courseset_course AS pcc
	ON c.id = pcc.courseid

/*JOIN mdl_prog_courseset AS pc
	ON pcc.coursesetid = pc.id
	AND progua.programid = pc.programid

JOIN mdl_prog AS prog
	ON pc.programid = prog.id
	AND progua.programid = prog.id
	
JOIN mdl_prog_user_assignment AS progua
	ON attempts.userid = progua.userid

JOIN mdl_course_modules AS cm
	ON attempts.quiz = cm.instance

LEFT JOIN mdl_quiz_overrides AS qover
	ON attempts.quiz = qover.quiz
	AND attempts.userid = qover.userid*/

WHERE attempts.timefinish > 1634027059
AND attempts.attempt >= 4
/*AND (qover.attempts IS NULL OR attempts.attempt = qover.attempts)
AND (gg.feedback IS NULL OR gg.feedback NOT LIKE '%on hold%')*/

ORDER BY attempts.timefinish DESC