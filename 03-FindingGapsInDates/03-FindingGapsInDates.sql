/****** 
Given a table with records containing an id, start_date, and end_date, 
where the difference between end_date and start_date is always 1 day, 
the objective is to combine and aggregate records that have connected 
dates. 
Connected dates are those where the end_date of one record is the day 
after the start_date of the next record.

Example input Data: 
id	start_date	end_date
1	2023-05-01	2023-05-02
2	2023-05-02	2023-05-03
3	2023-05-07	2023-05-08

Desired Output:
start_date	end_date
2023-05-01	2023-05-03
2023-05-07	2023-05-08

******/
WITH	CTE_Partition
	AS	(
			SELECT	Start_Date
				,	End_Date
				,	DATEADD	(	DAY
							,	-ROW_NUMBER() OVER	(	ORDER BY	start_date 
																,	end_date
													) 
							,	End_Date
							)														AS	Partition
			FROM	[Projects]
		)

SELECT	StartDate 
	,	EndDate 

FROM	(
	SELECT	MIN	(	start_date	)									AS	StartDate
		,	MAX	(	End_Date	)									AS	EndDate 
	
	FROM	CTE_Partition
	
	GROUP BY	Partition
		)															AS	TBL
	ORDER BY	datediff(day , StartDate , EndDate)  , StartDate;
	
