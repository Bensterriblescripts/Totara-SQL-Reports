SELECT
CONCAT(u.firstname, ' ',u.lastname) AS name,
CONCAT('<span class="accesshide" >', CAST(progua.timeassigned as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(progua.timeassigned),'%d %M %Y')) AS 'Program Enrolled ',
IF (u.lastaccess = 0,'<span class="accesshide" >000000000000</span>never', CONCAT('<span class="accesshide" >', CAST(u.lastaccess as CHAR), '</span>', DATE_FORMAT(FROM_UNIXTIME(u.lastaccess),'%d %M %Y'))) AS 'Last logged on',
IF (MAX(progua.timeassigned) = progua.timeassigned, CONCAT(prog.fullname), 'Wrong') AS 'Programme',
CONCAT('<a target="_new" href="%%WWWROOT%%/report/log/user.php?id=',u.id,'&course=1&mode=all">Log</a>') AS 'Activity Log',
CONCAT('<a target="_new" href="%%WWWROOT%%/report/completion/user.php?id=',u.id,'&course=1">Course progress</a>') AS 'Course progress'

FROM prefix_role_assignments AS ra
JOIN prefix_context AS context 
    ON context.id = ra.contextid
LEFT JOIN prefix_role AS role 
    ON role.id = ra.roleid
JOIN prefix_prog_user_assignment AS progua 
    ON progua.userid = context.instanceid
JOIN prefix_prog_assignment AS assign
    ON assign.id = progua.assignmentid
LEFT JOIN prefix_user_info_data AS uid 
    ON uid.userid = progua.userid
LEFT JOIN prefix_user_info_field AS uif 
    ON uid.fieldid = uif.id
LEFT JOIN prefix_prog AS prog 
    ON prog.id = assign.programid
LEFT JOIN prefix_prog_info_data AS pid 
    ON pid.programid = progua.programid
LEFT JOIN prefix_prog_info_field AS pif 
    ON pid.fieldid = pif.id
JOIN prefix_user AS u
    ON u.id = progua.userid

WHERE prog.fullname IS NOT NULL
AND ra.userid = %%USERID%%
AND context.contextlevel = 30
AND u.suspended = 0
AND (uif.shortname IS null OR (uif.shortname = 'hidefromITA' AND uid.data != 1))
AND (pif.shortname = 'showITAdashboard' AND pid.data = 1)

GROUP BY u.id

ORDER BY u.firstname, u.lastname DESC