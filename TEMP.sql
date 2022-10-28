SELECT

CONCAT('<span class="accesshide" >', CAST(gg.timecreated as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(gg.timecreated),'%d %M %Y %H:%i:%s')) AS 'Submitted',
CONCAT('<span class="accesshide" >', CAST(gg.timemodified as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(gg.timemodified),'%d %M %Y %H:%i:%s')) AS 'Graded',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://crm.mito.org.nz/MITOCRM/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(u.department, '<hr>',u.phone2) As Employer,
CONCAT(prog.fullname,'<hr><a target="_new" href = "https://elearning.mito.org.nz/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/view.php?id=', CAST(gi.itemmodule AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course',
qs.userattempts AS 'Attempt',
qs.useroverrides AS 'Overrides',
qs.grade AS 'Grade',
CONCAT('<a target="_new" href = "%%WWWROOT%%/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">View attempt</a>') AS 'View attempt',
CONCAT('<a target="_new" href = "%%WWWROOT%%/mod/quiz/overrides.php?cmid=', CAST(gi.itemmodule AS CHAR), '&mode=user">Add override</a>') AS 'Add override'

FROM mdl_grade_grades AS gg

JOIN mdl_grade_items AS gi
	ON gg.itemid = gi.id
JOIN mdl_block_mitoassessor_quizstatus AS qs
	ON gi.iteminstance = qs.quizid
    AND gg.userid = qs.userid
JOIN mdl_user AS u 
	ON qs.userid = u.id
JOIN mdl_course AS c
	ON gi.courseid = c.id
JOIN mdl_quiz AS quiz
	ON quiz.id = qs.quizid
JOIN mdl_block_mitoassessor_learnercompl AS lc
	ON qs.userid = lc.userid
	AND c.id = lc.courseid
JOIN mdl_prog AS prog
	ON lc.programid = prog.id
JOIN mdl_quiz_attempts AS attempts
	ON qs.userid = attempts.userid
    AND qs.quizid	= attempts.quiz
    AND qs.userattempts = attempts.attempt
JOIN mdl_prog_courseset AS pcs
	ON pcs.programid = prog.id
JOIN mdl_prog_courseset_course AS pcsc
	ON pcsc.coursesetid = pcs.id 
	AND pcsc.courseid = lc.courseid

WHERE quiz.preferredbehaviour = 'deferredfeedback'
AND gg.timemodified IS NOT NULL
AND gg.timecreated IS NOT NULL
AND gg.finalgrade < 10
AND u.suspended != 0
AND prog.fullname IS NOT NULL
AND lc.status != 0
AND qs.userattempts >= qs.useroverrides
AND attempts.sumgrades IS NOT NULL
AND attempts.timefinish !=0


/*Demo, admins and other non-learner accounts*/
AND u.username != 'elearning.admin'  AND u.username != 'mito2' AND u.username != 'mitotester2' AND u.username != 'mito_nzcr' AND u.username != 'mito_nzar' AND u.username != 'mito1' AND u.username != 'mito_nzlv' AND u.username != 'mito_suig'
AND u.username != '773294@mymitonz.org.nz' AND u.username != '773288@mymitonz.org.nz' AND u.username != '773290@mymitonz.org.nz' AND u.username != 'demolearner'
AND u.username != 'gbalasuriya' AND u.username != 'hclark' AND u.username != 'kahmad'

-- ORDER BY gg.timemodified DESC