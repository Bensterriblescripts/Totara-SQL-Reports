SELECT DISTINCT 
SUBSTRING(uidata.data, 20, 10) AS 'Group',
CONCAT('<strong><p ', IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) > 5, 'style="color:\ red">Submitted:<br>', ''), IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) <= 5 AND ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) > 3, 'style="color:\ orange">Submitted:<br>', ''),IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) <= 3, 'style="color:\ green">Submitted:<br>', ''),'<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y %H:%i:%s'), '<br><br>Expiry:<br>',DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish + 86400*7),'%d %M %Y %H:%i:%s'),'</p></strong>') AS 'Date',
concat('<a target="_new" href = "https://elearning.mito.org.nz/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://mitocrm.mito.org.nz/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(u.department, '<hr>',u.phone2) As Employer,
CONCAT(prog.fullname,'<hr><a target="_new" href = "https://elearning.mito.org.nz/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course', 
CONCAT('Att: ', attempts.attempt,'<hr><a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">Grade attempt</a>') AS 'Grade',
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/blocks/completionstatus/details.php?course=', CAST(c.id AS CHAR), '&user=',CAST(u.id AS CHAR),'">Check course progress</a><hr><a href="mailto:', u.email, '?cc=elearning@mito.org.nz&Subject=MITO eLearning - ', c.fullname, ' – ', quiz.name, '&body=Kia ora ',u.firstname, '%0D%0A%0D%0AI have marked your written assessment for the course ',c.fullname,'.%0D%0A%0D%0ACongratulations! You have passed the written assessment.%0D%0A%0D%0AHere\'s a link to the marked attempt: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=',CAST(attempts.id AS CHAR),'%0D%0A%0D%0AYou have now completed all of the assessments for this course.%0D%0A%0D%0APlease note you still have topic assessments for this course that you need to complete.','">Send completed email (Outlook)</a>','<hr><a target="_new" href="https://mail.google.com/mail/?view=cm&fs=1&tf=1&to=',u.email, '&cc=elearning@mito.org.nz&su=MITO eLearning - ', c.fullname, ' – ', quiz.name, '&body=Kia ora ',u.firstname, '%0D%0A%0D%0AI have marked your written assessment for the course ',c.fullname,'.%0D%0A%0D%0ACongratulations! You have passed the written assessment.%0D%0A%0D%0AHere\'s a link to the marked attempt: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=',CAST(attempts.id AS CHAR),'%0D%0A%0D%0AYou have now completed all of the assessments for this course.%0D%0A%0D%0APlease note you still have topic assessments for this course that you need to complete.','">Send completed email (Gmail)</a>') AS 'Passed Actions', 
CONCAT('<a target="_new" href = "https://elearning.mito.org.nz/mod/quiz/overrides.php?cmid=', CAST(cm.id AS CHAR), '&mode=user">Add override</a><hr><a href="mailto:', u.email, '?cc=elearning@mito.org.nz&Subject=MITO eLearning - ', c.fullname, ' – ', quiz.name, '&body=Kia ora ',u.firstname, '%0D%0A%0D%0AI have marked your written assessment for the course ',c.fullname,'.%0D%0A%0D%0AUnfortunately you have not provided sufficient answers for all of the questions.%0D%0A%0D%0AI have added comments to the assessment where you need to provide additional information.%0D%0A%0D%0AHere\'s a link to the marked attempt: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=',CAST(attempts.id AS CHAR),'%0D%0A%0D%0AYou will need to start a new attempt and re-do any questions that you did not pass on your earlier attempt (you do not need to add anything to questions that were marked correct).%0D%0A%0D%0APlease reply to this email if you have any questions.','">Send failed email (Outlook)</a>','<hr><a target="_new" href="https://mail.google.com/mail/?view=cm&fs=1&tf=1&to=',u.email, '&cc=elearning@mito.org.nz&su=MITO eLearning - ', c.fullname, ' – ', quiz.name, '&body=Kia ora ',u.firstname, '%0D%0A%0D%0AI have marked your written assessment for the course ',c.fullname,'.%0D%0A%0D%0AUnfortunately you have not provided sufficient answers for all of the questions.%0D%0A%0D%0AI have added comments to the assessment where you need to provide additional information.%0D%0A%0D%0AHere\'s a link to the marked attempt: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=',CAST(attempts.id AS CHAR),'%0D%0A%0D%0AYou will need to start a new attempt and re-do any questions that you did not pass on your earlier attempt (you do not need to add anything to questions that were marked correct).%0D%0A%0D%0APlease reply to this email if you have any questions.','">Send failed email (Gmail)</a>') AS 'Failed Actions'


FROM mdl_quiz_attempts AS attempts
JOIN mdl_quiz AS quiz 
    ON attempts.quiz = quiz.id
JOIN mdl_course_modules AS cm 
    ON cm.instance = quiz.id 
    AND cm.module = 18
JOIN mdl_user AS u 
    ON u.id = attempts.userid
    AND u.suspended = 0
LEFT JOIN mdl_quiz_overrides AS qover 
	ON qover.quiz = quiz.id 
    AND qover.userid = u.id
JOIN mdl_course AS c 
	ON c.id = cm.course
JOIN mdl_course_categories AS cc 
	ON cc.id = c.category 
JOIN mdl_grade_items AS gi 
	ON gi.iteminstance = cm.instance 
	AND gi.courseid = c.id
JOIN mdl_grade_grades AS gg    
    ON gg.itemid = gi.id 
    AND gg.userid = u.id
LEFT JOIN mdl_prog_user_assignment AS progua 
    ON progua.userid = u.id 
LEFT JOIN mdl_prog AS prog 
    ON prog.id = progua.programid
    AND prog.fullname != 'Collision Repair (Structural Repair) (Level 5)'
    AND prog.fullname != 'Commercial Road Transport – Heavy Combination Vehicle Loading Fundamentals Micro-credential 2021%'
    AND prog.fullname != 'Automotive Refinishing (Level 4) (direct entry) 2021-01'
    AND prog.fullname IS NOT NULL
LEFT Join mdl_user_info_data AS uidata 
    ON uidata.userid = u.id
LEFT JOIN mdl_user_info_field AS uif 
    ON uidata.fieldid = uif.id
LEFT JOIN mdl_course_modules_completion AS cmc 
    ON cmc.userid = u.id 
    AND cmc.coursemoduleid = cm.id 
INNER JOIN mdl_prog_courseset AS pcs 
    ON pcs.programid = prog.id 
INNER JOIN mdl_prog_courseset_course AS pcsc 
    ON pcsc.coursesetid = pcs.id 
    AND pcsc.courseid = c.id

WHERE (UNIX_TIMESTAMP() - attempts.timefinish)/86400 <= 7
AND attempts.timefinish != 0
AND quiz.preferredbehaviour = 'deferredfeedback'
AND (attempts.attempt >= 1 AND qover.attempts IS NULL)
AND (cmc.completionstate IS NULL OR (cmc.completionstate!= 1 AND cmc.completionstate != 2))
AND (gg.finalgrade < 10 or gg.finalgrade IS NULL)
AND uif.shortname = 'assessorgroup'
AND cc.name != 'COF'
AND c.shortname != 'GEN-SS135-ELv1'
AND c.shortname NOT LIKE 'FLM%'
AND 1=1

%%FILTER_USERS:uid.data%% 

ORDER BY attempts.timefinish ASC, u.firstname, c.fullname, quiz.name