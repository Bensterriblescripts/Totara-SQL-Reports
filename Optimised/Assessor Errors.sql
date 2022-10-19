SELECT 
CONCAT('<span class="accesshide" >', CAST(p.timecompleted as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(p.timecompleted),'%d %M %Y %H:%i:%s')) AS 'Course completed',
CONCAT('<span class="accesshide" >', CAST(attempts.timemodified as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timemodified),'%d %M %Y %H:%i:%s')) AS 'Graded',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://crm.mito.org.nz/MITOCRM/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(u.department, '<hr>',u.phone2) As Employer,
CONCAT(prog.fullname,'<hr><a target="_new" href = "https://elearning.mito.org.nz/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course', 
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">View attempt</a>') AS 'Attempt',
qover.attempts AS 'Overrides',
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS Grade

FROM prefix_quiz_attempts AS attempts
JOIN prefix_quiz AS quiz 
    ON attempts.quiz=quiz.id
JOIN prefix_course_modules AS cm 
    ON cm.instance = quiz.id
JOIN prefix_user AS u 
    ON u.id = attempts.userid
JOIN prefix_course_modules_completion AS cmc 
    ON cmc.userid = u.id 
    AND cmc.coursemoduleid = cm.id
LEFT JOIN prefix_quiz_overrides AS qover 
    ON qover.quiz = quiz.id AND qover.userid = u.id
JOIN prefix_course AS c 
    ON c.id = cm.course
JOIN prefix_course_categories AS cc 
    ON cc.id = c.category
LEFT JOIN prefix_prog_user_assignment AS progua 
    ON progua.userid = u.id 
LEFT JOIN prefix_prog AS prog 
    ON prog.id = progua.programid
JOIN prefix_course_completions AS p 
    ON p.course = c.id 
    AND p.userid = u.id
JOIN prefix_course_completion_criteria AS ccc 
    ON ccc.moduleinstance = cm.id
JOIN prefix_course_completion_crit_compl AS cccc 
    ON cccc.userid = u.id 
    AND cccc.criteriaid = ccc.id

WHERE quiz.preferredbehaviour = 'deferredfeedback'
AND u.suspended = 0
AND cmc.completionstate = 0
AND p.status = 50
AND prog.id IS NOT NULL
AND c.fullname != 'Vehicle Inspection eLearning COFA'
AND c.fullname != 'Vehicle Inspection eLearning COFB'
AND cccc.rpl IS NULL
/*AND ROUND(attempts.sumgrades/quiz.sumgrades*100,1) != 100*/
AND attempts.attempt < qover.attempts
AND attempts.attempt = 1

AND u.username != 'elearning.admin'  AND u.username != 'mito2' AND u.username != 'mito_nzcr' AND u.username != 'mito_nzar' AND u.username != 'mito1' AND u.username != 'mito_nzlv'
AND u.username != '773294@mymitonz.org.nz' AND u.username != '773288@mymitonz.org.nz' AND u.username != '773290@mymitonz.org.nz' AND u.username != 'demolearner'

ORDER BY p.timecompleted