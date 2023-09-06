-- Question:
--  pivore the occupation column in occupations table so that each Name 
--  is stored alphabetically and displayed underneath its corresponding 
--  Occupation. The output column headers should be Doctor, Professor, Singer
--  and Actor, respectively.
-- Table structure: 
--  column --> Name , Occupation
-- There are only 4 types of occupation as mentioned above

WITH    [doc_cte] 
    AS  (
        SELECT
                name 
            ,   ROW_NUMBER  () 
                    OVER    (   ORDER   BY  name    )           AS  'id'

        FROM    [occupations]

        WHERE   occupation      =       'Doctor'
        )

    ,   [prof_cte]  
    AS  (
        SELECT 
                name 
            ,   ROW_NUMBER  () 
                    OVER    (   ORDER   BY  name    )           AS  [id]

        FROM    [occupations]

        WHERE   occupation      =       'Professor'
        )

    ,   [sing_cte]
    AS  (
        SELECT
                name 
            ,   ROW_NUMBER  () 
                    OVER    (   ORDER   BY  name    )           AS  [id]

        FROM    [occupations]

        WHERE   occupation      =       'Singer'
        ) 

    ,   [act_cte]
    AS  (
        SELECT
                name
            ,   ROW_NUMBER  () 
                    OVER    (   ORDER   BY  name    )           AS  [id]

        FROM    [occupations]

        WHERE   occupation      =       'Actor'
    )

    SELECT
            [d].    [name]
        ,   [f].    [name] 
        ,   [s].    [name]
        ,   [a].    [name]

    FROM    [doc_cte]                                           AS  [d] 
    
    FULL    JOIN   [prof_cte]                                   AS  [f] 
        ON  [d].    [id]        =       [f].    [id]

    FULL    JOIN    [sing_cte]                                  AS  [s] 
        ON  [s].    [id]        =       [f].    [id]

    FULL    JOIN    [act_cte]                                   AS  [a]
        ON  [a].    [id]        =       [s].    [id]