
--Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 
--and the end date was March 15, 2016.
--Write a query to print total number of unique hackers who made at least  submission each day 
--(starting on the first day of the contest), and find the hacker_id and name of the hacker who made
--maximum number of submissions each day. If more than one such hacker has a maximum number of submissions, 
--print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.
--The following tables hold contest data:
--Hackers: The hacker_id(integer) is the id of the hacker, and name (string) is the name of the hacker.
--Submissions: The submission_date (date) is the date of the submission, submission_id(int) is the id of 
--the submission, hacker_id (int) is the id of the hacker who made the submission, and score (integer) 
--is the score of the submission. 



WITH SelfJoinCTE AS (
  SELECT
    submission_date, 
    hacker_id
  FROM
    submissions
  WHERE
    submission_date = '2016-03-01'
  UNION ALL
  SELECT
    t1.submission_date ,
    t1.hacker_id
    
  FROM
    SelfJoinCTE cte
  INNER JOIN
    submissions t1 ON t1.submission_date = 
    DATEADD(day, 1, cte.submission_date) and t1.hacker_id = cte.hacker_id
)
, number_unique_hackers_in_day 
AS (
       SELECT submission_date , count(distinct hacker_id) cnt_hacker
      FROM SelfJoinCTE
      group by submission_date
    )
 , hacker_with_max_submission 
AS (
        select  *
            ,   row_number () over (
                                partition by submission_date 
                                order by submission_date , cnt desc,  hacker_id 
                                    )                                                       as rn
        from 
                (   select  submission_date
                        ,   hacker_id
                        ,   count(*)                                                        as cnt
                    from submissions
                    group by submission_date,   hacker_id
                )                                                                           as tbl
    )

select 
        hwms.submission_date
    ,   nuhid.cnt_hacker
    ,   hwms.hacker_id
    ,   h.name 
from    hacker_with_max_submission                                                          as hwms
inner   join    number_unique_hackers_in_day                                                as nuhid
            on  hwms.submission_date        =   nuhid.submission_date
            
inner   join    hackers                                                                     as h 
            on  h.hacker_id                 =   hwms.hacker_id
where   hwms.rn =  1
