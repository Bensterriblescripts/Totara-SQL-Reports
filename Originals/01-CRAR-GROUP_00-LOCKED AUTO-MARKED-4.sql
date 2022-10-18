SELECT DISTINCT
CONCAT('<strong><p ', IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) > 1, 'style="color:\ red">', ''), IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) <= 1, 'style="color:\ green">', ''),'<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y %H:%i:%s'), '</p></strong>') AS 'Submitted',
concat('<a target="_new" href = "https://elearning.mito.org.nz/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://mitocrm.mito.org.nz/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(u.department, '<hr>',u.phone2) As Employer,
CONCAT(prog.fullname,'<hr><a target="_new" href = "https://elearning.mito.org.nz/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/overrides.php?cmid=', CAST(cm.id AS CHAR), '&mode=user">Add override</a>') AS 'Add override',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">',CAST(attempts.attempt AS CHAR),'</a>') AS 'Attempt',
qover.attempts AS 'Overrides',
ROUND(attempts.sumgrades/quiz.sumgrades*100,1) AS Grade,
CONCAT('<a href="mailto:', u.email, '?cc=elearning@mito.org.nz', IF(ita.email IS null, '', CONCAT('%3B', ita.email)), '&Subject=MITO eLearning – ', c.fullname, ': ', quiz.name, ' (',u.username,')', '&body=Kia ora ',u.firstname, '%0D%0A%0D%0AYou have now used more than your allowable attempts at this assessment. %0D%0A%0D%0ABefore attempting again, you need to read the feedback from your previous answers, then review the study material and ensure that you know the answers to the questions. %0D%0A%0D%0AIf you need help with this, please call your Training Advisor and ask for guidance to find the information. %0D%0A%0D%0AWhen you are ready, start your next attempt. %0D%0A%0D%0AThe link to your last marked attempt is here: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), ' (Please log in to your mymito learner portal before accessing this link)%0D%0A%0D%0AI have unlocked a new attempt for you.%0D%0A%0D%0ANgā mihi%0D%0A%0D%0A%0D%0A%0D%0A" >','Compose email', '</a>') AS 'Compose email',

/* 
CONCAT('<a href="mailto:', u.email, '?cc=elearning@mito.org.nz', IF(ita.email IS null, '', CONCAT(',', ita.email)), '&Subject=MITO eLearning – ', c.fullname, ': ', quiz.name, '&body=Kia ora ',u.firstname, '%0D%0A%0D%0A I have reviewed your attempts for the automarked assessment ',c.fullname, ': ',quiz.name,'.%0D%0A%0D%0AI have added some comments to the questions you didn’t pass in this attempt. Please make sure that you read these.%0D%0A%0D%0AThe link to your last marked attempt is here: https://elearning.mito.org.nz/login/index.php?auth=oauth2%26wantsurl=mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '%0D%0A%0D%0APlease ensure that you have revised and know the answers to the questions before you commence your next attempt.%0D%0A%0D%0AI have unlocked a new attempt for you.%0D%0A%0D%0ANgā mihi%0D%0A%0D%0A%0D%0A%0D%0A" >','Compose email', '</a>') AS 'Compose email',
*/

CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/grade/edit/tree/grade.php?courseid=', CAST(c.id AS CHAR), '&id=',CAST(gg.id AS CHAR),'&gpr_type=report&gpr_plugin=grader&gpr_courseid=', CAST(c.id AS CHAR),'">Add grader feedback</a>') AS 'Add grader feedback',
gg.feedback AS 'Grader feedback'
,CONCAT(ita.firstname, ' ', ita.lastname) as 'ita'
FROM prefix_quiz_attempts attempts
JOIN prefix_quiz quiz ON attempts.quiz=quiz.id
JOIN prefix_course_modules cm ON cm.instance=quiz.id
JOIN prefix_user u ON u.id = attempts.userid
LEFT OUTER JOIN prefix_context AS context ON context.instanceid = u.id
LEFT OUTER JOIN prefix_role_assignments AS ra ON ra.contextid = context.id
LEFT OUTER JOIN prefix_role AS r ON r.id = ra.roleid
LEFT OUTER JOIN prefix_user ita ON ita.id = ra.userid AND ita.email like '%@mito.org.nz' AND r.name = 'Supervisor'
LEFT JOIN prefix_quiz_overrides qover ON qover.quiz = quiz.id AND qover.userid = u.id
JOIN prefix_course c ON c.id = cm.course 
JOIN prefix_grade_items gi ON gi.iteminstance = cm.instance AND gi.courseid = c.id
JOIN prefix_course_categories AS cc ON cc.id = c.category 
JOIN prefix_grade_grades gg ON gg.itemid = gi.id AND gg.userid = u.id
LEFT JOIN prefix_prog_user_assignment AS progua ON progua.userid = u.id 
LEFT JOIN prefix_prog AS prog ON prog.id = progua.programid
JOIN prefix_enrol enrol ON enrol.courseid = c.id
JOIN prefix_user_enrolments ue ON ue.userid = u.id AND ue.enrolid = enrol.id

WHERE
u.suspended = 0
AND ue.status = 0
AND gg.finalgrade < 10
AND attempts.sumgrades/quiz.sumgrades < 1
AND quiz.preferredbehaviour != 'deferredfeedback'
AND (qover.attempts IS NULL OR qover.attempts = attempts.attempt)
AND attempts.attempt > 3
AND (cc.name = 'NZ Cert CR and AR 2017' or cc.name = 'NZ Cert CR and AR 2021')
AND u.suspended = 0
AND prog.fullname IS NOT NULL
AND (gg.feedback IS NULL OR gg.feedback NOT LIKE '%ON HOLD%')

ORDER BY attempts.timefinish ASC, u.firstname, c.fullname, quiz.name, attempts.attempt 