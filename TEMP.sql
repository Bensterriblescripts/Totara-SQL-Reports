SELECT
CONCAT(u.firstname,' ',u.lastname) AS 'Learner',
CONCAT(assessor.firstname,' ',assessor.lastname) AS 'Assessor'

FROM prefix_grade_grades AS gg
JOIN prefix_user AS u
    ON gg.userid = u.id
JOIN prefix_user AS assessor
    ON gg.usermodified = u.id


%%FILTER_USERS:CONCAT(u.firstname,' ',u.lastname):~%%



ORDER BY attempts.timeassigned DESC