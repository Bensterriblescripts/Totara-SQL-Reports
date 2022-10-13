SELECT

CONCAT(u.firstname,' ',u.lastname) AS 'Learner',
CONCAT(assessort.firstname, ' ',assessort.lastname) AS 'Assessor',
ROUND(grade.finalgrade) AS 'Result',
FROM_UNIXTIME(grade.timemodified, '%e/%m/%Y %H:%i:%s') AS 'Date Assessed',
c.shortname AS 'course',
prog.fullname AS 'program'

FROM prefix_user AS u

JOIN prefix_grade_grades_history AS grade
	ON grade.userid = u.id
JOIN prefix_grade_grades AS gg
	ON grade.oldid = gg.id
	AND gg.userid = u.id
	AND grade.itemid = gg.itemid
JOIN prefix_grade_items AS gi
	ON gg.itemid = gi.id
	AND grade.itemid = gi.id
	AND gg.rawgrademin = gi.grademin
	AND gg.rawgrademax = gi.grademax
	AND grade.rawgrademax = gi.grademax
	AND grade.rawgrademin = gi.grademin
JOIN prefix_prog_user_assignment AS progua
	ON u.id = progua.userid
JOIN prefix_prog AS prog
	ON progua.programid = prog.id
JOIN prefix_prog_courseset AS cs
	ON prog.id = cs.programid
JOIN prefix_prog_courseset_course AS csc
	ON cs.id = csc.coursesetid
JOIN prefix_course AS c
	ON csc.courseid = c.id
	AND gi.courseid = c.id
	
/*Assessor name table query*/
JOIN
	(SELECT
	u.firstname,u.lastname,graded.id
	FROM prefix_user AS u
	JOIN prefix_grade_grades_history AS graded
		ON graded.loggeduser = u.id
		AND graded.finalgrade IS NOT NULL
	WHERE 
	graded.timemodified > 1649203200 /*1601942400*/)
/*Query end*/
	AS assessort
	ON grade.id = assessort.id

WHERE grade.timemodified > 1649203200
AND grade.source = 'aggregation'
/*AND (assessort.firstname,assessort.lastname) != (u.firstname,u.lastname)*/

%%FILTER_SEARCHTEXT:(CONCAT(assessort.firstname,' ',assessort.lastname)):~%%

GROUP BY grade.id