
Drop Table if exists #wickets
Select match_id, innings, ball,striker, non_striker,
case when row is not null then
Dense_rank() Over(partition by match_id, innings Order by row) end as wicket
Into #Wickets
from
(SELECT *, 
 Case when wicket_type is not null then
 ROW_NUMBER() Over(partition by match_id, innings Order by ball) 
 when ball = (Select max(ball) from Ball_by_ball_data b2 
              where b1.match_id=b2.match_id and b1.innings=b2.innings) 
 then ROW_NUMBER() Over(partition by match_id, innings Order by ball)  end row
 FROM Ball_by_ball_data b1) a
where row is not null
order by match_id, innings, ball



Drop table if exists #patnership
select match_id,innings, ball,season,batting_team,striker,non_striker,runs_off_bat,extras,
coalesce((select max(wicket) from #Wickets w 
          Where b.match_id=w.match_id and b.innings=w.innings and b.ball>w.ball)+1,1) wicket
Into #patnership
from Ball_by_ball_data b
order by match_id, innings, ball



-- Highest patnership
Select top 10 p.match_id, concat(striker,',',non_striker) patners,p.wicket, runs 
from 
(select match_id, innings, wicket, sum(runs_off_bat)+sum(extras) runs
from #patnership
Group by match_id, innings, wicket) p
Left join #Wickets w
On p.match_id=w.match_id and p.innings=w.innings and p.wicket=w.wicket
Order by runs desc



-- Highest patnership by wicket
Select p.match_id, concat(striker,',',non_striker) patners,p.wicket,runs
from 
(select match_id, innings, wicket, sum(runs_off_bat)+sum(extras) runs,
RANK() Over(partition by wicket order by sum(runs_off_bat)+sum(extras) desc) as rank
from #patnership
Group by match_id, innings, wicket) p
Left join #Wickets w
On p.match_id=w.match_id and p.innings=w.innings and p.wicket=w.wicket
where rank=1
Order by p.wicket 