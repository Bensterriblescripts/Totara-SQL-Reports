SELECT DISTINCT
SUBSTRING(uid.data, 20, 10) AS 'Group',
CONCAT('<strong><p ', IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) > 5, 'style="color:\ red">Submitted:<br>', ''), IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) <= 5 AND ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) > 3, 'style="color:\ orange">Submitted:<br>', ''),IF(ROUND((UNIX_TIMESTAMP() - attempts.timefinish)/86400,0) <= 3, 'style="color:\ green">Submitted:<br>', ''),'<span class="accesshide" >', CAST(attempts.timefinish as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y %H:%i:%s'), '<br><br>Expiry:<br>',DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish + 86400*7),'%d %M %Y %H:%i:%s'),'</p></strong>') AS 'Date',
CONCAT('<a target="_new" href = "%%WWWROOT%%/user/profile.php?id=', CAST(u.id AS CHAR), '">',u.firstname, ' ', u.lastname, '</a><hr><a target="_new" href = "https://mitocrm.mito.org.nz/main.aspx?etc=2&extraqs=formid%3d85b5f7f3-ac5a-4beb-95da-2fb3e6b50f38&id=%7b',u.idnumber,'%7d&pagetype=entityrecord">',u.username,'</a><hr>', u.phone1) As 'Learner',
CONCAT(u.department, '<hr>',u.phone2) As Employer,
CONCAT(prog.fullname,'<hr><a target="_new" href = "%%WWWROOT%%/course/view.php?id=', CAST(c.id AS CHAR), '">',CAST(c.fullname AS CHAR),'</a><hr><a target="_new" href = "%%WWWROOT%%/mod/quiz/view.php?id=', CAST(cm.id AS CHAR), '">',CAST(quiz.name AS CHAR),'</a>') AS 'Programme and course', 
CONCAT('Att: ', attempts.attempt,'<hr><a target="_new" href = "%%WWWROOT%%/mod/quiz/review.php?attempt=', CAST(attempts.id AS CHAR), '">Grade attempt</a>') AS 'Grade',
CONCAT('<a target="_new" href = "%%WWWROOT%%/blocks/completionstatus/details.php?course=', CAST(c.id AS CHAR), '&user=',CAST(u.id AS CHAR),'">Check course progress</a><hr><a href="mailto:', u.email, '?cc=elearning@mito.org.nz&Subject=MITO eLearning - ', c.fullname, ' – ', quiz.name, '&body=Kia ora ',u.firstname, '%0D%0A%0D%0AI have marked your written assessment for the course ',c.fullname,'.%0D%0A%0D%0ACongratulations! You have passed the written assessment.%0D%0A%0D%0AHere\'s a link to the marked attempt: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=',CAST(attempts.id AS CHAR),'%0D%0A%0D%0AYou have now completed all of the assessments for this course.%0D%0A%0D%0APlease note you still have topic assessments for this course that you need to complete.','">Send completed email (Outlook)</a>','<hr><a target="_new" href="https://mail.google.com/mail/?view=cm&fs=1&tf=1&to=',u.email, '&cc=elearning@mito.org.nz&su=MITO eLearning - ', c.fullname, ' – ', quiz.name, '&body=Kia ora ',u.firstname, '%0D%0A%0D%0AI have marked your written assessment for the course ',c.fullname,'.%0D%0A%0D%0ACongratulations! You have passed the written assessment.%0D%0A%0D%0AHere\'s a link to the marked attempt: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=',CAST(attempts.id AS CHAR),'%0D%0A%0D%0AYou have now completed all of the assessments for this course.%0D%0A%0D%0APlease note you still have topic assessments for this course that you need to complete.','">Send completed email (Gmail)</a>') AS 'Passed Actions', 
CONCAT('<a target="_new" href = "%%WWWROOT%%/mod/quiz/overrides.php?cmid=', CAST(cm.id AS CHAR), '&mode=user">Add override</a><hr><a href="mailto:', u.email, '?cc=elearning@mito.org.nz&Subject=MITO eLearning - ', c.fullname, ' – ', quiz.name, '&body=Kia ora ',u.firstname, '%0D%0A%0D%0AI have marked your written assessment for the course ',c.fullname,'.%0D%0A%0D%0AUnfortunately you have not provided sufficient answers for all of the questions.%0D%0A%0D%0AI have added comments to the assessment where you need to provide additional information.%0D%0A%0D%0AHere\'s a link to the marked attempt: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=',CAST(attempts.id AS CHAR),'%0D%0A%0D%0AYou will need to start a new attempt and re-do any questions that you did not pass on your earlier attempt (you do not need to add anything to questions that were marked correct).%0D%0A%0D%0APlease reply to this email if you have any questions.','">Send failed email (Outlook)</a>','<hr><a target="_new" href="https://mail.google.com/mail/?view=cm&fs=1&tf=1&to=',u.email, '&cc=elearning@mito.org.nz&su=MITO eLearning - ', c.fullname, ' – ', quiz.name, '&body=Kia ora ',u.firstname, '%0D%0A%0D%0AI have marked your written assessment for the course ',c.fullname,'.%0D%0A%0D%0AUnfortunately you have not provided sufficient answers for all of the questions.%0D%0A%0D%0AI have added comments to the assessment where you need to provide additional information.%0D%0A%0D%0AHere\'s a link to the marked attempt: https://elearning.mito.org.nz/mod/quiz/review.php?attempt=',CAST(attempts.id AS CHAR),'%0D%0A%0D%0AYou will need to start a new attempt and re-do any questions that you did not pass on your earlier attempt (you do not need to add anything to questions that were marked correct).%0D%0A%0D%0APlease reply to this email if you have any questions.','">Send failed email (Gmail)</a>') AS 'Failed Actions'


FROM prefix_quiz_attempts AS attempts
JOIN prefix_quiz AS quiz 
  ON attempts.quiz = quiz.id
JOIN prefix_course_modules AS cm 
  ON cm.instance = quiz.id 
  AND cm.module = 18
JOIN prefix_user AS u 
  ON u.id = attempts.userid
LEFT JOIN prefix_quiz_overrides AS qover 
    ON qover.quiz = quiz.id 
    AND qover.userid = u.id
LEFT JOIN
(
	SELECT
	id
	FROM prefix_quiz_overrides
	WHERE attempts IS NULL
) AS qovernull
		ON qover.id = qovernull.id
JOIN 
(
    SELECT
    id,
    shortname,
    fullname
    FROM prefix_course
    WHERE category = 30
) AS c
	    ON c.id = cm.course
JOIN prefix_grade_items AS gi 
	ON gi.iteminstance = cm.instance 
	AND gi.courseid = c.id
JOIN prefix_grade_grades AS gg 
  ON gg.itemid = gi.id 
  AND gg.userid = u.id
LEFT JOIN prefix_prog_user_assignment AS progua 
  ON progua.userid = u.id 
LEFT JOIN prefix_prog AS prog 
  ON prog.id = progua.programid
LEFT Join prefix_user_info_data AS uid 
  ON uid.userid = u.id
LEFT JOIN prefix_user_info_field AS uif 
  ON uid.fieldid = uif.id
JOIN prefix_course_modules_completion AS cmc
    ON cmc.userid = u.id 
    AND cmc.coursemoduleid = cm.id
JOIN prefix_prog_courseset AS pcs 
  ON pcs.programid = prog.id 
JOIN prefix_prog_courseset_course AS pcsc 
  ON pcsc.coursesetid = pcs.id 
  AND pcsc.courseid = c.id

WHERE quiz.preferredbehaviour = 'deferredfeedback'
AND (UNIX_TIMESTAMP() - attempts.timefinish)/86400 <= 7
AND cmc.timecompleted IS NULL 
AND gg.finalgrade IS NULL
AND attempts.attempt >= 1
AND u.suspended = 0

/*Demo learners and test users are hidden from this queue*/
AND u.username != 'elearning.admin' AND u.username != 'mito2' AND u.username != 'mito1' AND u.username != 'mito_nzcr' AND u.username != 'mito_nzar' AND u.username != 'mito1' AND u.username != 'mito_nzlv' AND u.username != 'mito_suig'
/**/

AND prog.fullname IS NOT NULL

AND uif.shortname = 'assessorgroup'

AND c.shortname != 'GEN-SS135-ELv1'
AND c.shortname != 'CRAR-US5744-ELv1'
AND c.shortname != 'EL-AB-3RCv1'
AND c.shortname != 'EL-CP-3RCv1'

%%FILTER_USERS:uid.data%%

GROUP BY attempts.id

ORDER BY attempts.timefinish ASC, u.firstname, c.fullname, quiz.name, uid.data DESC