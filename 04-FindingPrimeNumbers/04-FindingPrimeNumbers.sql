with numbers    
    as  (
        select 2 as level 
            union all
        select level + 1 as level 
            from numbers
            where level < = 1000
        )             
 , prime_not_prime as (               
            select  n1. level  , case when n1.level % n2.level <> 0 then 'prime'
             else  'not prime' end prime 
             from numbers n1 cross join numbers  n2 
            where n1.level > n2.level
     )
  , not_prime as (
    select distinct level as np_level from prime_not_prime
    where prime = 'not prime' 
   )
select string_agg(num.level, '&') from numbers num left join not_prime np
on num.level = np.np_level
where np.np_level is null 

    
  OPTION (MAXRECURSION 1000);