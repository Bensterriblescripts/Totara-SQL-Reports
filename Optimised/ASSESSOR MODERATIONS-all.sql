SELECT
c.shortname,
CONCAT('<a href = "%%WWWROOT%%/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">',CAST(attempts.attempt AS CHAR),'</a>') AS 'Attempt',
CONCAT('<span class="accesshide" >', CAST(gg.timemodified as CHAR), '  </span>', DATE_FORMAT(FROM_UNIXTIME(gg.timemodified),'%d %M %Y %H:%i:%s')) AS 'Date assessed',
CONCAT('<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y %H:%i:%s')) AS 'Date submitted',
CONCAT('<a target="_new" href = "%%WWWROOT%%/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://crm.mito.org.nz/MITOCRM/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(prog.fullname,'<hr><a target="_new" href = "%%WWWROOT%%/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "%%WWWROOT%%/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course',
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS Grade,
prog.fullname AS 'program'


FROM prefix_quiz_attempts AS attempts

JOIN prefix_quiz AS quiz
	ON attempts.quiz = quiz.id
JOIN prefix_course_modules AS cm
	ON quiz.id = cm.instance
JOIN prefix_user AS u
	ON attempts.userid
LEFT JOIN prefix_quiz_overrides AS qover
	ON qover.quiz = quiz.id
	AND qover.userid = u.id
JOIN prefix_course AS c
	ON cm.course = c.id
JOIN prefix_course_categories AS cc
	ON c.category = cc.id
JOIN prefix_grade_items AS gi
	ON cm.instance = gi.iteminstance
	AND c.id = gi.courseid
JOIN prefix_grade_grades AS gg
	ON gi.id = gg.itemid
	AND gg.userid = u.id
LEFT JOIN prefix_prog_user_assignment AS progua
	ON u.id = progua.userid
LEFT JOIN prefix_prog AS prog
	ON progua.programid = prog.id



/*
FROM 
prefix_quiz_attempts AS attempts
JOIN prefix_quiz AS quiz 
	ON attempts.quiz = quiz.id
JOIN prefix_course_modules AS cm 
	ON cm.instance = quiz.id
JOIN prefix_user AS u 
	ON u.id = attempts.userid
JOIN prefix_course AS c 
	ON c.id = cm.course
JOIN prefix_grade_items AS gi 
	ON gi.iteminstance = cm.instance 
	AND gi.courseid = c.id
JOIN prefix_grade_grades AS gg 
	ON gg.itemid = gi.id 
	AND gg.userid = u.id
JOIN prefix_prog_user_assignment AS progua 
	ON progua.userid = u.id 
JOIN prefix_prog AS prog 
	ON prog.id = progua.programid
JOIN prefix_logstore_standard_log AS l 
	ON gg.id = l.objectid
JOIN prefix_user AS assessor 
	ON assessor.id = l.userid
	*/