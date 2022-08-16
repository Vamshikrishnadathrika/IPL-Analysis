-- 1. most balls bowled 
select top 10 bowler ,count(*) balls
from Ball_by_ball_data
where noballs is null and wides is null
group by bowler
order by balls desc


--2. Most Wickets
select top 10 bowler, count(wicket_type) no_of_wickets
from Ball_by_ball_data
Where wicket_type not in ('NULL','retired hurt','retired out','run out')
group by bowler
order by no_of_wickets desc



-- 3.most wickets in powerplay
select top 10 bowler, count(wicket_type) no_of_wickets
from Ball_by_ball_data
Where wicket_type not in ('NULL','retired hurt','retired out','run out') and ball<6
group by bowler
order by no_of_wickets desc




-- 4. Best Figures
Select top 10 a.bowler, no_of_wickets, runs
from
(select match_id, bowler, count(wicket_type) no_of_wickets
from Ball_by_ball_data
Where wicket_type not in ('NULL','retired hurt','retired out','run out')
group by bowler, match_id) a -- calculates no.of wickets
Left Join
(select match_id, bowler,
sum(runs_off_bat) + sum(case when wides is not null then wides else 0 end) +
sum(case when noballs is not null then noballs else 0 end) runs
from Ball_by_ball_data
group by match_id, bowler) b  -- calculates no.of runs given
On a.match_id=b.match_id and a.bowler=b.bowler
Order by no_of_wickets desc ,runs



-- 5. Most 3+ wickets
select top(10) bowler, COUNT(no_of_wickets) no_of_3_wickets
from 
(select match_id, bowler, count(wicket_type) no_of_wickets
from Ball_by_ball_data
Where wicket_type not in ('NULL','retired hurt','retired out','run out')
group by bowler, match_id) a
Where no_of_wickets >= 3
Group by bowler
Order by no_of_3_wickets desc



-- 6. hatick
Select bowler, count(*) number_of_times
from
(select match_id, season, bowler, ball, wicket_type, 
 Lag(wicket_type) Over(Partition By match_id,season, bowler Order by ball) pre_ball,
 Lag(wicket_type,2) Over(Partition By match_id,season, bowler Order by ball) prepre_ball
 from Ball_by_ball_data ) a
Where wicket_type is not null and pre_ball is not null and prepre_ball is not null
and wicket_type not in ('NULL','retired hurt','retired out','run out')
and pre_ball not in ('NULL','retired hurt','retired out','run out')
and prepre_ball not in ('NULL','retired hurt','retired out','run out')
group by bowler
order by number_of_times desc


-- 7. most maidens
select top 10 bowler, count(*) maidens
from
(select match_id, season, bowler, cast(ball as int) over_num, sum(runs_off_bat) runs, count(*) balls
from Ball_by_ball_data
Group by match_id, season, bowler, cast(ball as int)
Having sum(runs_off_bat) = 0 and count(*) = 6) a
group by bowler
order by maidens desc



-- 8. most maidens in an innings
select top 10 match_id, bowler, count(*) maidens
from
(select match_id, season, bowler, cast(ball as int) over_num, sum(runs_off_bat) runs, count(*) balls
from Ball_by_ball_data
Group by match_id, season, bowler, cast(ball as int)
Having sum(runs_off_bat) = 0 and count(*) = 6) a
group by bowler, match_id
order by maidens desc



-- 9.Most dot balls
select top 10 bowler, count(ball) dot_balls
from
(select match_id, season, bowler,cast(ball as int) ove, ball, runs_off_bat, wides,
 Lag(wides) Over(Partition by match_id, season, bowler order by ball) pre_wide, noballs,
 Lag(noballs) Over(Partition by match_id, season, bowler order by ball) pre_noball
 from Ball_by_ball_data ) a
where runs_off_bat = 0 and wides is null and pre_wide is null and
noballs is null and pre_noball is null
group by bowler
order by dot_balls desc



-- 10.Most dot balls in an innings
select top 10 bowler, count(ball) dot_balls
from
(select match_id, season, bowler, ball, runs_off_bat, wides,noballs
 from Ball_by_ball_data ) a
where runs_off_bat = 0 and wides is null  and
noballs is null 
group by bowler, match_id
order by dot_balls desc



-- 11. Best bowling average
select top 10 bowler, Round(cast(runs as float)/wickets,2) average
from
(select bowler, sum(runs_off_bat) + 
 sum(Case when wides is not null then wides else 0 end ) +
 sum(Case when noballs is not null then noballs else 0 end ) runs,
 (select count(wicket_type) no_of_wickets from Ball_by_ball_data b
  Where wicket_type not in ('NULL','retired hurt','retired out','run out') and a.bowler=b.bowler) wickets
 from Ball_by_ball_data a
 group by bowler ) c
where wickets <> 0 and runs > 150
order by average



-- 12.Best bowling economy
select top 10 bowler, Round(cast(runs as float)*6/balls,2) economy
from
(select bowler, sum(runs_off_bat) + 
 sum(Case when wides is not null then wides else 0 end ) +
 sum(Case when noballs is not null then noballs else 0 end ) runs,
 (select count(*) balls from Ball_by_ball_data b
  where noballs is null and wides is null and a.bowler=b.bowler) balls
 from Ball_by_ball_data a
 group by bowler ) c
where balls > 120
order by economy




-- 13.Best bowling economy in death overs
select top 10 bowler, Round(cast(runs as float)*6/balls,2) economy
from
(select bowler, sum(runs_off_bat) + 
 sum(Case when wides is not null then wides else 0 end ) +
 sum(Case when noballs is not null then noballs else 0 end ) runs,
 (select count(*) balls from Ball_by_ball_data b
  where noballs is null and wides is null and a.bowler=b.bowler and ball>15) balls
 from Ball_by_ball_data a
 where ball>15
 group by bowler ) c
where balls > 120
order by economy




-- 14. Best bowling strikerate
select top 10 bowler, Round(cast(balls as float)/wickets,2) strike_rate
from
(select bowler,
 (select count(wicket_type) no_of_wickets from Ball_by_ball_data b
  Where wicket_type not in ('NULL','retired hurt','retired out','run out') and a.bowler=b.bowler) wickets,
 (select count(*) balls from Ball_by_ball_data b
  where noballs is null and wides is null and a.bowler=b.bowler) balls
 from Ball_by_ball_data a
 group by bowler ) c
where balls > 120
order by strike_rate




-- 15. wicket per innings
select top 10 bowler, Round(cast(wickets as float)/innings,2) wickets_per_innings
from
(select bowler,
 (select count(wicket_type) no_of_wickets from Ball_by_ball_data b
  Where wicket_type not in ('NULL','retired hurt','retired out','run out') and a.bowler=b.bowler) wickets,
 (select count(distinct match_id) balls from Ball_by_ball_data b
  where a.bowler=b.bowler) innings
 from Ball_by_ball_data a
 group by bowler ) c
where innings >= 10
order by wickets_per_innings desc



-- 16. Most 0 wickets
select top 10 b.bowler,count(distinct b.match_id) as no_of_0_wickets
from 
(select match_id, bowler, count(wicket_type) no_of_wickets
from Ball_by_ball_data
Where wicket_type not in ('NULL','retired hurt','retired out','run out')
group by bowler, match_id) a
Right join (select distinct match_id, bowler from Ball_by_ball_data) b
On a.match_id=b.match_id and a.bowler=b.bowler
where no_of_wickets is null
group by b.bowler
Order by no_of_0_wickets desc




-- 17. Most 5+ wickets
select top(10) bowler, COUNT(no_of_wickets) no_of_5_wickets
from 
(select match_id, bowler, count(wicket_type) no_of_wickets
from Ball_by_ball_data
Where wicket_type not in ('NULL','retired hurt','retired out','run out')
group by bowler, match_id) a
Where no_of_wickets >= 5
Group by bowler
Order by no_of_5_wickets desc


-- 18.most wickets per 4 overs
select top 10 bowler, Round(cast(wickets as float)*24/balls,2) wic_per_4overs
from
(select bowler,
 (select count(wicket_type) no_of_wickets from Ball_by_ball_data b
  Where wicket_type not in ('NULL','retired hurt','retired out','run out') and a.bowler=b.bowler) wickets,
 (select count(*) balls from Ball_by_ball_data b
  where noballs is null and wides is null and a.bowler=b.bowler) balls
 from Ball_by_ball_data a
 group by bowler ) c
where balls > 120
order by wic_per_4overs desc



-- 19. best bowling economy in an innings
select top 10 match_id,bowler, Round(cast(runs as float)*6/balls,2) economy
from
(select match_id,bowler, sum(runs_off_bat) + 
 sum(Case when wides is not null then wides else 0 end ) +
 sum(Case when noballs is not null then noballs else 0 end ) runs,
 (select count(*) balls from Ball_by_ball_data b
  where noballs is null and wides is null and a.bowler=b.bowler and a.match_id=b.match_id) balls
 from Ball_by_ball_data a
 group by match_id,bowler ) c
where balls = 24
order by economy



-- 20.most runs consided in an innings
select top 10 match_id,bowler, sum(runs_off_bat) + 
 sum(Case when wides is not null then wides else 0 end ) +
 sum(Case when noballs is not null then noballs else 0 end ) runs
 from Ball_by_ball_data a
 group by match_id,bowler 
 Order by runs desc



 -- 21. most noballs bowled
select top 10 bowler, sum(case  when noballs is not null then 1 else 0 end) as number_of_noballs
from Ball_by_ball_data
group by bowler
order by number_of_noballs desc



 -- 22. most wides bowled
select top 10 bowler, sum(case  when wides is not null then 1 else 0 end) as number_of_wides
from Ball_by_ball_data
group by bowler
order by number_of_wides desc



-- 23. most boundaries consided
SELECT bowler, sum(case when runs_off_bat in (4,6) then 1 else 0 end) boundaries_consided
FROM Ball_by_ball_data
GROUP BY bowler
order by boundaries_consided desc
