
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


WITH    SelfJoinCTE
    AS  (
            SELECT
                    submission_date
                ,   hacker_id

            FROM    submissions

            WHERE   submission_date         =       '2016-03-01'

            UNION ALL

            SELECT
                    t1.submission_date
                ,   t1.hacker_id

            FROM    SelfJoinCTE                                                                     AS  sjc
  
            INNER   JOIN    submissions                                                             AS  t1
                ON  t1.submission_date      =       DATEADD (   DAY
                                                            ,   1
                                                            ,   sjc.submission_date
                                                            ) 
                AND t1.hacker_id            =       sjc.hacker_id
        )

    ,   number_unique_hackers_in_day 
    AS  (
            SELECT  submission_date 
                ,   COUNT   (  DISTINCT    hacker_id   )                                            AS  cnt_hacker
            
            FROM    SelfJoinCTE

            GROUP   BY  submission_date
        )

    ,   hacker_with_max_submission 
    AS (
            SELECT  *
                ,   ROW_NUMBER  ()  OVER (
                                    PARTITION   BY  submission_date 
                                    ORDER   BY      submission_date 
                                            ,       cnt                      DESC 
                                            ,       hacker_id 
                                        )                                                           AS  rn
            FROM 
                (   SELECT  submission_date
                        ,   hacker_id
                        ,   count(*)                                                                AS  cnt

                    FROM    submissions

                    GROUP   BY  submission_date
                            ,   hacker_id
                )                                                                                   AS  tbl
        )

SELECT
        hwms.submission_date
    ,   nuhid.cnt_hacker
    ,   hwms.hacker_id
    ,   h.name 

FROM    hacker_with_max_submission                                                                  AS  hwms

INNER   JOIN    number_unique_hackers_in_day                                                        AS  nuhid
            ON  hwms.submission_date        =   nuhid.submission_date
            
INNER   JOIN  
            ON  h.hacker_id                 =   hwms.hacker_id

WHERE   hwms.rn =  1
