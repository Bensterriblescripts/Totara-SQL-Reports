SELECT
DATE_FORMAT(FROM_UNIXTIME(attempts.timefinish),'%d %M %Y') AS Date,
COUNT(attempts.id) AS Submitted

FROM prefix_quiz_attempts AS attempts
JOIN prefix_quiz AS quiz 
    ON attempts.quiz = quiz.id
JOIN prefix_user AS u 
    ON u.id = attempts.userid
JOIN prefix_course_modules AS cm 
    ON cm.instance = quiz.id 
    AND cm.module = 18
JOIN prefix_course AS c 
    ON c.id = cm.course
JOIN prefix_course_categories AS cc 
    ON cc.id = c.category 

WHERE quiz.preferredbehaviour = 'deferredfeedback'
AND u.suspended = 0

AND u.username != 'elearning.admin'  AND u.username != 'mito1' AND u.username != 'mito2' AND u.username != 'mito_nzcr' AND u.username != 'mito_nzar' AND u.username != 'mito1' AND u.username != 'mito_nzlv' AND u.username != 'mito_suig'
AND u.username != 'demolearner'
AND u.username != 'gbalasuriya' AND u.username != 'hclark' AND u.username != 'kahmad' 
/**/
GROUP BY Date

ORDER BY attempts.timefinish DESC