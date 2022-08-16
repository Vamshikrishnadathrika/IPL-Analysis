-- Batsmen Analysis
-- 1.Runs against different team
Select striker, bowling_team, sum(runs_off_bat) runs,
round(cast(sum(runs_off_bat) as float)*100/count(runs_off_bat),2) strike_rate
From Ball_by_ball_data
Where striker = 'SK Raina'
Group by striker, bowling_team
Order by runs desc



-- 2.In which team he has performed best
Select striker, batting_team, sum(runs_off_bat) runs
From Ball_by_ball_data
Where striker = 'SK Raina'
Group by striker, batting_team
Order by runs desc



-- 3.Wicket Type
Select player_dismissed, wicket_type, count(wicket_type) no_of_times
From Ball_by_ball_data
Where player_dismissed = 'SK Raina'
Group by player_dismissed, wicket_type
Order by no_of_times desc



-- 4.Highest score
Select top 10 match_id, striker, bowling_team against, sum(runs_off_bat) runs,
round(cast(sum(runs_off_bat) as float)*100/count(runs_off_bat),2) strike_rate
From Ball_by_ball_data
Where striker = 'SK Raina'
Group by match_id, striker, bowling_team
Order by runs desc



-- 5.Runs in different seasons
Select striker, season, sum(runs_off_bat) runs,
round(cast(sum(runs_off_bat) as float)*100/count(runs_off_bat),2) strike_rate
From Ball_by_ball_data
Where striker = 'SK Raina'
Group by striker, season
Order by season desc



-- 6.Runs distribution
Select striker, runs_off_bat, sum(runs_off_bat) runs
From Ball_by_ball_data
Where striker = 'SK Raina' and runs_off_bat not in (0,5)
Group by striker, runs_off_bat
Order by runs_off_bat 



-- 7.Runs against indian bowling type
Select striker, i.bowl_type, count(runs_off_bat) balls, sum(runs_off_bat) runs,
round(cast(sum(runs_off_bat) as float)*100/count(runs_off_bat),2) strike_rate
From Ball_by_ball_data b
Left Join indians_bowling_type i
on b.bowler = i.player_name
Where striker = 'SK Raina' and bowl_type  in ('Pace','Spin')
Group by striker, i.bowl_type



-- 8.Wickets against indian bowling type
Select player_dismissed, i.bowl_type, count(player_dismissed) no_of_times
From Ball_by_ball_data b
Left Join indians_bowling_type i
on b.bowler = i.player_name
Where player_dismissed = 'SK Raina' and bowl_type  in ('Pace','Spin')
Group by player_dismissed, i.bowl_type



-- 9.Most times dismissed by
Select  top 10 player_dismissed, bowler, count(player_dismissed) no_of_times
From Ball_by_ball_data b
Where player_dismissed = 'SK Raina' 
Group by player_dismissed, bowler
order by no_of_times desc



-- 10.Most runs scored in
Select top 10 striker, bowler, sum(runs_off_bat) runs, count(runs_off_bat) balls,
round(cast(sum(runs_off_bat) as float)*100/count(runs_off_bat),2) strike_rate
From Ball_by_ball_data
Where striker = 'SK Raina'
Group by striker, bowler
Having count(runs_off_bat)>=20
order by strike_rate desc





-- Bowler Analysis
-- 1.Wickets against different team
Select bowler, batting_team, count(wicket_type) wickets
From Ball_by_ball_data
Where bowler = 'DJ Bravo' and wicket_type not in ('NULL','retired hurt','retired out','run out')
Group by bowler, batting_team
Order by wickets desc




-- 2.Which team he has performed best
Select bowler, bowling_team, count(wicket_type) wickets
From Ball_by_ball_data
Where bowler = 'DJ Bravo' and wicket_type not in ('NULL','retired hurt','retired out','run out')
Group by bowler, bowling_team
Order by wickets desc




-- 3.Wicket type
Select bowler, wicket_type, count(wicket_type) wickets
From Ball_by_ball_data
Where bowler = 'DJ Bravo' and wicket_type not in ('NULL','retired hurt','retired out','run out')
Group by bowler, wicket_type
Order by wickets desc




-- 4.Best figures
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
Where a.bowler = 'DJ Bravo'
Order by no_of_wickets desc ,runs



-- 5.Performance in different seasons
Select bowler, season, count(wicket_type) wickets
From Ball_by_ball_data
Where bowler = 'DJ Bravo' and wicket_type not in ('NULL','retired hurt','retired out','run out')
Group by bowler, season
Order by season desc




-- 6.Which batsmen got dissmised most
Select  top 10  bowler, player_dismissed, count(player_dismissed) no_of_times
From Ball_by_ball_data b
Where bowler = 'DJ Bravo' 
Group by player_dismissed, bowler
order by no_of_times desc



-- 7.Which batsmen scored most
Select top 10  bowler, striker, sum(runs_off_bat) runs, count(runs_off_bat) balls,
round(cast(sum(runs_off_bat) as float)*100/count(runs_off_bat),2) strike_rate
From Ball_by_ball_data
Where bowler = 'DJ Bravo'
Group by striker, bowler
Having count(runs_off_bat)>=20
order by strike_rate desc
