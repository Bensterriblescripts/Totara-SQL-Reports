SELECT 
CONCAT('<span class="accesshide" >', CAST(p.timecompleted as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(p.timecompleted),'%d %M %Y %H:%i:%s')) AS 'Course completed',
CONCAT('<span class="accesshide" >', CAST(gg.timemodified as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(gg.timemodified),'%d %M %Y %H:%i:%s')) AS 'Graded',
concat('<a target="_new" href = "https://elearning.mito.org.nz/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://crm.mito.org.nz/MITOCRM/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(u.department, '<hr>',u.phone2) As Employer,
CONCAT(prog.fullname,'<hr><a target="_new" href = "https://elearning.mito.org.nz/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course', 
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">View attempt</a>') AS 'Attempt',
qover.attempts AS 'Overrides',
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS Grade

FROM prefix_quiz_attempts attempts
JOIN prefix_quiz quiz ON attempts.quiz=quiz.id
JOIN prefix_course_modules cm ON cm.instance=quiz.id
JOIN prefix_user u ON u.id = attempts.userid
JOIN prefix_course_modules_completion cmc ON cmc.userid = u.id AND cmc.coursemoduleid = cm.id
LEFT JOIN prefix_quiz_overrides qover ON qover.quiz = quiz.id AND qover.userid = u.id
JOIN prefix_course c ON c.id = cm.course
JOIN prefix_course_categories AS cc ON cc.id = c.category
JOIN prefix_grade_items gi ON gi.iteminstance = cm.instance AND gi.courseid = c.id
JOIN prefix_grade_grades gg ON gg.itemid = gi.id AND gg.userid = u.id
LEFT JOIN prefix_prog_user_assignment AS progua ON progua.userid = u.id 
LEFT JOIN prefix_prog AS prog ON prog.id = progua.programid
JOIN prefix_course_completions p ON p.course = c.id AND p.userid = u.id
JOIN prefix_course_completion_criteria ccc ON ccc.moduleinstance = cm.id
JOIN prefix_course_completion_crit_compl cccc ON cccc.userid = u.id AND cccc.criteriaid = ccc.id



WHERE
quiz.preferredbehaviour = 'deferredfeedback'
AND u.suspended = 0
AND cmc.completionstate = 0
AND p.timecompleted IS NOT NULL
AND prog.id IS NOT NULL
AND c.fullname != 'Vehicle Inspection eLearning COFA'
AND c.fullname != 'Vehicle Inspection eLearning COFB'
AND cccc.rpl IS NULL
AND attempts.attempt = 1
/*Admin users, Demo learenrs and test users are hidden from this queue*/
AND u.username != 'elearning.admin'  AND u.username != 'mito2' AND u.username != 'mito_nzcr' AND u.username != 'mito_nzar' AND u.username != 'mito1' AND u.username != 'mito_nzlv'
AND u.username != '773294@mymitonz.org.nz' AND u.username != '773288@mymitonz.org.nz' AND u.username != '773290@mymitonz.org.nz' AND u.username != 'demolearner'
AND u.username != 'gbalasuriya' AND u.username != 'hclark' AND u.username != 'kahmad' AND u.username != 'mito_nzlv' 
/**/

ORDER BY p.timecompleted