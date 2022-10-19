SELECT
attempt.id,
assessor.id


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