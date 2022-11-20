SELECT
CONCAT('<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y %H:%i:%s')) AS 'Submitted',
CONCAT('<span class="accesshide" >', CAST(gg.timemodified as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(gg.timemodified),'%d %M %Y %H:%i:%s')) AS 'Graded',
CONCAT('<a target="_new" href = "%%WWWROOT%%/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://crm.mito.org.nz/MITOCRM/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(prog.fullname,'<hr><a target="_new" href = "%%WWWROOT%%/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "%%WWWROOT%%/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course',
attempts.attempt AS 'Attempt',
qover.attempts AS 'Overrides',
ROUND(attempts.sumgrades / quiz.sumgrades * 100, 1) AS 'Grade',
CONCAT('<a target="_new" href = "%%WWWROOT%%/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">View attempt</a>') AS 'View attempt',
CONCAT('<a target="_new" href = "%%WWWROOT%%/mod/quiz/overrides.php?cmid=', CAST(cm.id AS CHAR), '&mode=user">Add override</a>') AS 'Add override'

FROM prefix_quiz_attempts AS attempts
LEFT JOIN prefix_quiz AS quiz 
	ON attempts.quiz = quiz.id
LEFT JOIN prefix_course_modules AS cm 
	ON cm.instance = quiz.id
JOIN prefix_user AS u 
	ON u.id = attempts.userid
LEFT JOIN prefix_quiz_overrides AS qover 
	ON qover.userid = attempts.userid
	AND qover.quiz = quiz.id
LEFT JOIN prefix_course AS c 
	ON c.id = cm.course
LEFT JOIN prefix_grade_items AS gi 
	ON gi.iteminstance = cm.instance
    AND gi.courseid = c.id
JOIN prefix_grade_grades AS gg 
	ON gg.itemid = gi.id 
    AND gg.userid = u.id
LEFT JOIN prefix_prog_user_assignment AS progua 
	ON progua.userid = u.id 
LEFT JOIN prefix_prog AS prog 
	ON prog.id = progua.programid
LEFT JOIN prefix_course_modules_completion AS cmc 
	ON cmc.userid = u.id 
    AND cmc.coursemoduleid = cm.id
JOIN prefix_prog_courseset AS pcs 
	ON pcs.programid = prog.id
JOIN prefix_prog_courseset_course AS pcsc 
	ON pcsc.coursesetid = pcs.id 
    AND pcsc.courseid = c.id

WHERE quiz.preferredbehaviour = 'deferredfeedback'
AND attempts.attempt >= 
CASE 
	WHEN qover.attempts IS NULL THEN 0
	ELSE qover.attempts
END
AND c.category != 10
AND attempts.sumgrades IS NOT NULL
AND cmc.completionstate IS NULL
AND gg.finalgrade < 10
AND u.suspended = 0

ORDER BY gg.timemodified ASC, u.firstname ASC