-- 1.Top 10 Indian batsmen by runs
SELECT top 10 striker, sum(runs_off_bat) total_runs
FROM Ball_by_ball_data b
LEFT JOIN player_country p
ON b.striker = p.player_name
WHERE country = 'India'
GROUP BY striker
ORDER BY total_runs desc

-- 2.Top 10 Foreign batsmen by runs
SELECT top 10 striker, sum(runs_off_bat) total_runs
FROM Ball_by_ball_data b
LEFT JOIN player_country p
ON b.striker = p.player_name
WHERE country <> 'India'
GROUP BY striker
ORDER BY total_runs desc



-- 3.Top Run scorer's in powerplay
SELECT top 10 striker, sum(runs_off_bat) total_runs_in_pp
FROM Ball_by_ball_data
WHERE ball <= 6
GROUP BY striker
ORDER BY total_runs_in_pp desc


-- 4.Top Run scorer's in death overs
SELECT top 10 striker, sum(runs_off_bat) total_runs_in_death
FROM Ball_by_ball_data
WHERE ball > 15
GROUP BY striker
ORDER BY total_runs_in_death desc



-- 5.Top Run scorer's in middle overs
SELECT top 10 striker, sum(runs_off_bat) total_runs_in_middle
FROM Ball_by_ball_data
WHERE ball  between 6 and 15
GROUP BY striker
ORDER BY total_runs_in_middle desc



-- 6.Batsmen with most boundary percentage (total runs > 1000)
SELECT TOP 10 striker, Round(cast(runs_by_boundaries as float)*100/total_runs,2) per_runs_by_boundaries
FROM
(SELECT striker, sum(runs_off_bat) total_runs, 
   sum(case when runs_off_bat in (4,6) then runs_off_bat else 0 end) runs_by_boundaries
 FROM Ball_by_ball_data
 GROUP BY striker) a
WHERE total_runs > 1000 
ORDER BY per_runs_by_boundaries desc



-- 7.Top ten strikers of the ball
SELECT top 10 striker, Round(sum(runs_off_bat)*100/count(runs_off_bat),2) strike_rate
FROM Ball_by_ball_data
GROUP BY striker
HAVING sum(runs_off_bat) > 1000
ORDER BY strike_rate desc


-- 8.Number of runs per match
SELECT top 10 striker, Round(sum(runs_off_bat)/count(distinct match_id),2) runs_per_match
FROM Ball_by_ball_data
GROUP BY striker
HAVING sum(runs_off_bat) > 1000
ORDER BY runs_per_match desc



-- 9.Number of runs per innings
SELECT top 10 striker, Round(sum(runs_off_bat)/
(select count(distinct match_id)
 from Ball_by_ball_data
 Where player_dismissed = b.striker),2) runs_per_innings
FROM Ball_by_ball_data b
GROUP BY striker
HAVING sum(runs_off_bat) > 1000
ORDER BY runs_per_innings desc



-- 10.Balls played per match
SELECT top 10 striker, Round(count(runs_off_bat)/count(distinct match_id),2) balls_per_match
FROM Ball_by_ball_data
GROUP BY striker
HAVING count(runs_off_bat) > 1000
ORDER BY balls_per_match desc

-- 11. Highest score by a batsmen
SELECT top 10 match_id, striker, sum(runs_off_bat) highest_score
FROM Ball_by_ball_data
GROUP BY striker, match_id
ORDER BY highest_score desc


-- 12.Most no.of centuries by a batsmen
SELECT TOP 10 striker, count(*) no_of_centuries
FROM
(SELECT  match_id, striker
 FROM Ball_by_ball_data
 GROUP BY striker, match_id
 HAVING sum(runs_off_bat) >= 100) a
GROUP BY striker
ORDER BY no_of_centuries DESC



-- 13. No.of centuries in a season
SELECT season, count(*) no_of_centuries
FROM
(SELECT  season, match_id, striker
 FROM Ball_by_ball_data
 GROUP BY season, striker, match_id
 HAVING sum(runs_off_bat) >= 100) a
GROUP BY season
ORDER BY season



-- 14.Most no.of halfcenturies by a batsmen
SELECT TOP 10 striker, count(*) no_of_half_centuries
FROM
(SELECT  match_id, striker
 FROM Ball_by_ball_data
 GROUP BY striker, match_id
 HAVING sum(runs_off_bat) between 50 and 99) a
GROUP BY striker
ORDER BY no_of_half_centuries DESC



-- 15. No.of halfcenturies in a season
SELECT season, count(*) no_of_half_centuries
FROM
(SELECT season, match_id, striker
 FROM Ball_by_ball_data
 GROUP BY season, striker, match_id
 HAVING sum(runs_off_bat) between 50 and 99) a
GROUP BY season
ORDER BY season



-- 16.Most no.of ducks by a batsmen
SELECT TOP 10 striker, count(*) no_of_ducks
FROM
(SELECT  match_id, striker
 FROM Ball_by_ball_data
 GROUP BY striker, match_id
 HAVING sum(runs_off_bat) = 0) a
GROUP BY striker
ORDER BY no_of_ducks DESC


-- 17. Most four's by a batsmen
SELECT TOP 10 striker, count(*) no_of_4s
FROM Ball_by_ball_data
WHERE runs_off_bat = 4
GROUP BY striker
ORDER BY no_of_4s desc



-- 18. Most four's by a batsmen in an innings
SELECT TOP 10 match_id, striker, count(*) no_of_4s
FROM Ball_by_ball_data
WHERE runs_off_bat = 4
GROUP BY striker, match_id
ORDER BY no_of_4s desc



-- 19. Most six's by a batsmen
SELECT TOP 10 striker, count(*) no_of_6s
FROM Ball_by_ball_data
WHERE runs_off_bat = 6
GROUP BY striker
ORDER BY no_of_6s desc



-- 20. Most six's by a batsmen in an innings
SELECT TOP 10 match_id, striker, count(*) no_of_6s
FROM Ball_by_ball_data
WHERE runs_off_bat = 6
GROUP BY striker, match_id
ORDER BY no_of_6s desc