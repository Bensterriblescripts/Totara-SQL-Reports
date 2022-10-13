SELECT DISTINCT
CONCAT(assessor.firstname, ' ', assessor.lastname) 'Assessor',
c.shortname,
CONCAT('<a href = "%%WWWROOT%%/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">',CAST(attempts.attempt AS CHAR),'</a>') AS 'Attempt',
CONCAT('<span class="accesshide" >', CAST(l.timecreated as CHAR), '  </span>', DATE_FORMAT(FROM_UNIXTIME(l.timecreated),'%d %M %Y %H:%i:%s')) AS 'Date assessed',
CONCAT('<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y %H:%i:%s')) AS 'Date submitted',
(SELECT concat('<a target="_new" href="%%WWWROOT%%/user/profile.php?id=',id,'">',CONCAT(firstname,' ', lastname),'</a>') FROM prefix_user WHERE id = l.relateduserid) AS learner,
concat('<a target="_new" href = "%%WWWROOT%%/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://crm.mito.org.nz/MITOCRM/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(prog.fullname,'<hr><a target="_new" href = "%%WWWROOT%%/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "%%WWWROOT%%/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course',
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS Grade,
prog.fullname AS program


FROM 
prefix_quiz_attempts attempts
JOIN prefix_quiz quiz ON attempts.quiz=quiz.id
JOIN prefix_course_modules cm ON cm.instance=quiz.id
JOIN prefix_user u ON u.id = attempts.userid
JOIN prefix_course c ON c.id = cm.course
JOIN prefix_grade_items gi ON gi.iteminstance = cm.instance AND gi.courseid = c.id
JOIN prefix_grade_grades gg ON gg.itemid = gi.id AND gg.userid = u.id
JOIN prefix_logstore_standard_log AS l ON l.relateduserid = u.id AND gg.id=l.objectid
JOIN prefix_user assessor ON assessor.id = l.userid
LEFT JOIN prefix_prog_user_assignment AS progua ON progua.userid = u.id 
LEFT JOIN prefix_prog AS prog ON prog.id = progua.programid


WHERE 
(assessor.username in 
(
/* Queue 1 */'rlunn@mymitonz.org.nz',
/* Queue 2 */'savageg@mymitonz.org.nz',
/* Queue 3 */'vhowden@mymitonz.org.nz',
/* Queue 4 */'georgehewison@mymitonz.org.nz',
/* Queue 5 */'johnm_george@mymitonz.org.nz',
/* Queue 6 */'520660@mymitonz.org.nz',
/* Queue 7 */'pdoherty@mymitonz.org.nz',
/* Queue 8 */'511225@mymitonz.org.nz',
/* Queue 9 */'wedwards@mymitonz.org.nz',
/* Queue 10 */'503973@mymitonz.org.nz',
/* Queue 11 */'alexjansen@mymitonz.org.nz',
/* Queue 12 */'simon@mymitonz.org.nz',
/* Queue 13 */'fred_jenkins@mymitonz.org.nz',
/* Queue 14 */'dotnwayne@mymitonz.org.nz',
/* Queue 15 */'ghildred@mymitonz.org.nz',
/* Queue 16 */'harryvvliet@mymitonz.org.nz',
/* Queue 17 */'gregcorbett@mymitonz.org.nz',
/* Other */'656985@mymitonz.org.nz'
))
AND l.action = 'graded'
AND l.target = 'user'
AND gi.itemmodule = 'quiz'
AND quiz.name = 'Written assessment'
AND attempts.sumgrades IS NOT NULL
AND ROUND((UNIX_TIMESTAMP() - l.timecreated)/86400,0) < 365
%%FILTER_SEARCHTEXT:(Concat(assessor.firstname,assessor.lastname)):~%%

%%FILTER_STARTTIME:l.timecreated:>%% %%FILTER_ENDTIME:l.timecreated:<%%
ORDER BY l.timecreated DESC