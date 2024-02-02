/*
objectives
Come up with a flu shot dashoard for 2022 that does the folling :

	1) Total % ofpatience getting flu shots stratified by 
		a. Age
		b.Race
		c. County (on a map)
		d. Overall
		
	2)Running total of flu shots over the course of 2022 
	3)Total number of flu shots given in 2022
	4)A list of patience that show whether or not they received the flu shots
	
Reqirements :
Patients must be "active" at the hospital and with in the eligible age for flu shots which is 6months or older

*/

with active_patients as (

	select distinct patient from encounters as e 
	join patients as pat on e.patient = pat.id
	where start between '2020-01-01 00:00' and '2022-12-31 23:59'
	and pat.deathdate is null
	and extract (month from age('2022-12-31', pat.birthdate))>=6

),

flu_shot_2022 as
(
select patient, min(date) as earliest_flu_shot_2022 
from immunizations 
where code = '5302' 
and date between '2022-01-01 00:00' and '2022-12-31 23:59'
group by patient 
)

select  
	  pat.birthdate
	 ,pat.race
	 ,pat.county
	 ,pat.id
	 ,pat.first
	 ,pat.last
	 ,flu.earliest_flu_shot_2022
	 ,flu.patient
	 ,case when flu.patient is not null then 1 
	 else 0
	 end as flu_shot_2022
from patients as pat 
left join flu_shot_2022 as flu 
on pat.id = flu.patient 
where 1=1
and pat.id in (select patient from active_patients);





