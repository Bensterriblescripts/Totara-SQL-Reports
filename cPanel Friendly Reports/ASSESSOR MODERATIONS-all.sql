SELECT
attempts.id,
quiz.id


FROM mdl_quiz_attempts AS attempts

JOIN mdl_quiz AS quiz
	ON attempts.quiz = quiz.id
JOIN mdl_course_modules AS cm
	ON quiz.id = cm.instance
JOIN mdl_user AS u
	ON attempts.userid
LEFT JOIN mdl_quiz_overrides AS qover
	ON qover.quiz = quiz.id
	AND qover.userid = u.id
JOIN mdl_course AS c
	ON cm.course = c.id
JOIN mdl_course_categories AS cc
	ON c.category = cc.id
JOIN mdl_grade_items AS gi
	ON cm.instance = gi.iteminstance
	AND c.id = gi.courseid
JOIN mdl_grade_grades AS gg
	ON gi.id = gg.itemid
	AND gg.userid = u.id
LEFT JOIN mdl_prog_user_assignment AS progua
	ON u.id = progua.userid
LEFT JOIN mdl_prog AS prog
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