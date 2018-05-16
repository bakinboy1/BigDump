SELECT semesters.semesterName,CRN.section,CRN.day,CRN.time,
CRN.location,courses.subjectName,courses.courseName,courses.credits,courses.courseDescription,
instructors.fName,instructors.lName,semesters.semesterName,CRN.crnCode,CRN.section,CRN.day,
CRN.time,CRN.location,courses.subjectName,courses.courseName,courses.credits,
courses.courseDescription,instructors.fName,instructors.lName FROM semesters , CRN ,
 courses , instructors