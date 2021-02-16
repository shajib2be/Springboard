/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT *
FROM Facilities
Where membercost!=0


/* Q2: How many facilities do not charge a fee to members? */

SELECT count(*)
FROM Facilities
Where membercost=0

4

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT *
FROM Facilities
Where membercost<=.2*monthlymaintenance

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
Where facid =1 or facid=5

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
    -- 1. First case
    CASE WHEN monthlymaintenance >= 100 THEN 'expensive'
        -- 2. Second case
        
        -- 3. Else clause + end
        ELSE 'cheap' END
        -- 4. Alias name (popsize_group)
        AS  monthlymaintenance1
FROM Facilities



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

select surname, firstname, joindate

from Members
where joindate='2012-09-26 18:08:45'

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

//SELECT f.facid AS ID, b.memid AS memberid,concat(Members.surname,Members.firstname) as e

 FROM Bookings AS b
 INNER join Facilities AS f
 ON f.facid = b.facid
 
 INNER JOIN Members
 ON b.memid = Members.memid
 where f.facid=1//


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


SELECT  f.facid AS ID, b.memid AS memberid,concat(Members.surname,Members.firstname) as e, f.membercost as mcost, f.guestcost as gcost, b.slots as slot1,
  case 
		when b.memid = 0 then
			b.slots*f.guestcost
		else
			b.slots*f.membercost
	end as cost
FROM Bookings AS b
 INNER join Facilities AS f
 ON f.facid = b.facid
   INNER JOIN Members
 ON b.memid = Members.memid
 Where DATE(b.starttime) = '2012-09-14' and b.memid = 0 or DATE(b.starttime) = '2012-09-14' and b.memid != 0
order by cost desc



/* Q9: This time, produce the same result as in Q8, but using a subquery. */


/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT Facility,
 Revenue
FROM (
SELECT Facilities.name AS Facility,
 SUM(CASE WHEN (Members.memid = 0) THEN (Bookings.slots*Facilities.guestcost)
ELSE (Bookings.slots*Facilities.membercost) END) AS Revenue
FROM Bookings  
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER JOIN Members  ON Bookings.memid = Members.memid
GROUP BY Facility
) as dataset
WHERE Revenue < 1000
/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT M.surname, M.firstname,
TP.surname AS Recomedsur,
TP.firstname as Recomfirst

FROM Members as M
LEFT JOIN Members as TP 
on M.recommendedby =TP.memid  
order by M.surname

/* Q12: Find the facilities with their usage by member, but not guests */
Select f.facid AS ID, f.name as Facility, b.memid AS memberid,concat(Members.surname,Members.firstname) as Name
  

FROM Bookings AS b
 INNER join Facilities AS f
 ON f.facid = b.facid
   INNER JOIN Members
 ON b.memid = Members.memid
 Where Members.memid!=0



/* Q13: Find the facilities usage by month, but not guests */
FROM Bookings AS b
 INNER join Facilities AS f
 ON f.facid = b.facid
   INNER JOIN Members
 ON b.memid = Members.memid
 Where Members.memid!=0

