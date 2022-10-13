SELECT

CONCAT('<strong><p ', IF(ROUND((UNIX_TIMESTAMP() - attempt_join.timefinish)/86400,0) > 1, 'style="color:\ red">', ''), IF(ROUND((UNIX_TIMESTAMP() - attempt_join.timefinish)/86400,0) <= 1, 'style="color:\ green">', ''),'<span class="accesshide" >', CAST(attempt_join.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempt_join.timefinish),'%d %M %Y %H:%i:%s'), '</p></strong>') AS 'Submitted',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/user/profile.php?id=', CAST(attempt_join.userid AS CHAR), '">',attempt_join.firstname, ' ', attempt_join.lastname, '</a><hr><a target="_new" href = "https://mitocrm.mito.org.nz/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',attempt_join.idnumber,'%7d&pagetype=entityrecord">',attempt_join.username,'</a><hr>', attempt_join.phone1) As 'Learner',
CONCAT(attempt_join.department, '<hr>',attempt_join.phone2) As Employer,
CONCAT(prog.fullname,'<hr><a target="_new" href = "https://elearning.mito.org.nz/course/view.php?id=', CAST(attempt_join.courseid AS CHAR), '">',CAST(attempt_join.fullname AS CHAR),'</a><hr><a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/view.php?id=', CAST(attempt_join.coursemoduleid AS CHAR), '">',CAST(attempt_join.name AS CHAR),'</a>') AS 'Programme and course',
CASE
	WHEN attempt_join.overrideid is not null THEN
		CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/overrideedit.php?id=', CAST(attempt_join.overrideid AS CHAR), '&mode=user">Add override</a>') 
	ELSE
		CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/overrideedit.php?action=adduser&cmid=', CAST(attempt_join.coursemoduleid AS CHAR), '&mode=user">Add override</a>') 
END AS 'Add override (new)',
/*CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/overrides.php?cmid=', CAST(attempt_join.coursemoduleid AS CHAR), '&mode=user">Add override</a>') AS 'Add override',*/
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempt_join.attemptid AS CHAR), '">',CAST(attempt_join.attempt AS CHAR),'</a>') AS 'Attempt',
attempt_join.attempts AS 'Overrides',
ROUND(attempt_join.sumgrades/attempt_join.quizgrades*100,1) AS Grade,
CONCAT('<a href="mailto:', attempt_join.email, '?cc=elearning@mito.org.nz', IF(ita.email IS null, '', CONCAT('%3B', ita.email)), '&Subject=MITO eLearning – ', attempt_join.fullname, ': ', attempt_join.name, ' (',attempt_join.username,')', '&body=Kia ora ',attempt_join.firstname, '%0D%0A%0D%0AYou have now used more than your allowable attempts at this assessment. %0D%0A%0D%0ABefore attempting again, you need to read the feedback from your previous answers, then review the study material and ensure that you know the answers to the questions. %0D%0A%0D%0AIf you need help with this, please call your Training Advisor and ask for guidance to find the information. %0D%0A%0D%0AWhen you are ready, start your next attempt. %0D%0A%0D%0AThe link to your last marked attempt is here: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempt_join.attemptid AS CHAR), ' (Please log in to your mymito learner portal before accessing this link)%0D%0A%0D%0AI have unlocked a new attempt for you.%0D%0A%0D%0ANgā mihi%0D%0A%0D%0A%0D%0A%0D%0A" >','Compose email', '</a>') AS 'Compose email',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/grade/edit/tree/grade.php?courseid=', CAST(attempt_join.courseid AS CHAR), '&id=',CAST(gg.id AS CHAR),'&gpr_type=report&gpr_plugin=grader&gpr_courseid=', CAST(attempt_join.courseid AS CHAR),'">Add grader feedback</a>') AS 'Add grader feedback',
gg.feedback AS 'Grader feedback',
CONCAT(ita.firstname, ' ', ita.lastname) as 'ita'

SELECT
attempts.id AS 'attempt id',
CONCAT(u.firstname,' ',u.lastname) AS 'learner',
attempts.attempt AS 'attempt number',
qover.attempts AS 'overrides',
attempts.timefinish AS 'completed on',
quiz.id AS 'quiz',
c.shortname AS 'course'

FROM prefix_quiz_attempts AS attempts

JOIN prefix_user AS u
	ON attempts.userid = u.id
	
LEFT JOIN prefix_quiz_overrides AS qover
	ON attempts.quiz = qover.quiz
	AND attempts.userid = qover.userid
	AND (qover.attempts IS NULL OR attempts.attempt = qover.attempts)

JOIN prefix_quiz AS quiz
	ON attempts.quiz = quiz.id

JOIN prefix_course AS c
	ON quiz.course = c.id

LEFT JOIN prefix_prog_courseset_course AS cc
	ON c.id = cc.courseid

JOIN prefix_prog_courseset AS pc
	ON cc.coursesetid = pc.id


WHERE attempts.timefinish > 1634027059
AND attempts.attempt > 3

ORDER BY attempts.timefinish ASC