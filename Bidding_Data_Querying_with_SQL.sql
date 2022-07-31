# 1. Show the percentage of wins of each bidder in the order of highest to lowest percentage.
# Winning percentage can be calculated in two ways:
# Use a case statement and find the percentage of wins / total from the same table, 
# ipl_bidding_details 
# OR 
# find the number of wins from ipl_bidding_details and cross-reference it with 
# ipl_bidder_points
use ipl;   
SELECT 
    bd.bidder_id,
    bd.user_id,
    bd.bidder_name,
    ibp.NO_OF_BIDS,
    COUNT(ibd.bid_status) AS total,
    (COUNT(ibd.bid_status) / ibp.no_of_bids) * 100 AS percentage_win
FROM
    ipl_bidder_details bd
        INNER JOIN
    ipl_bidding_details ibd ON bd.BIDDER_ID = ibd.BIDDER_ID
        INNER JOIN
    ipl_bidder_points ibp ON ibd.BIDDER_ID = ibp.BIDDER_ID
WHERE
    BID_STATUS = 'Won'
GROUP BY bd.bidder_id , bd.bidder_name
ORDER BY percentage_win DESC;

# This approach has 3 less records because we are joining 
# it with another table
# OR

SELECT 
	bd1.bidder_id, 
    bd2.user_id, 
    bd2.bidder_name, 
    count(*) AS total,
    sum(case when bd1.bid_status = 'Won' then 1 else 0 end) AS won_count,
    sum(case when bd1.bid_status = "Lost" then 1 else 0 end) AS lost_count, 
    100 * sum(case when bd1.bid_status = 'Won' then 1 else 0 end) / count(*) as winning_percentage
FROM 
	ipl_bidding_details bd1
join 
	ipl_bidder_details bd2 
on 
	bd1.bidder_id = bd2.bidder_id
GROUP BY 
	bd1.bidder_id
order by 
	winning_percentage desc;
    
# 2. Display the number of matches conducted at each stadium with stadium name, city from the database.

select 
	s.stadium_id, 
    s.stadium_name, 
    s.city, 
    ms.match_id, 
    count(*)
from 
	ipl_stadium s
join 
	ipl_match_schedule ms
on
	s.stadium_id = ms.stadium_id
group by
	s.stadium_id, 
    s.stadium_name
order by 
	count(*) desc;
    
# 3. In each stadium, what is the percentage of wins by a team which has won the toss?

select 
	s.stadium_id, 
    s.stadium_name, 
    ms.match_id, 
    m.team_id1, 
    m.team_id2, 
    m.toss_winner, 
    m.match_winner, 
    count(*) as total_number_of_matches, 
    sum(case when m.toss_winner = m.match_winner then 1 else 0 end) as wins,
    sum(case when m.toss_winner <> m.match_winner then 1 else 0 end) as losses, 
    100 * sum(case when m.toss_winner = m.match_winner then 1 else 0 end) / count(*) as percentage
    
from 
	ipl_stadium s
join 
	ipl_match_schedule ms
on
	s.stadium_id = ms.stadium_id
join 
	ipl_match m
on 
	ms.match_id = m.match_id
group by 
	s.stadium_id
order by 
	percentage desc;
    
# 4. Show the total bids along with bid team and team name.

select 	
	bp.bidder_id,
    bp.no_of_bids,
    bd.bid_team, 
    sum(no_of_bids)
from 
	ipl_bidder_points as bp
join 
	ipl_bidding_details as bd
on
	bp.bidder_id = bd.bidder_id
group by 
    bd.bid_team;
    
select 
	bp.bidder_id, 
    bp.no_of_bids, 
    bd.bid_team,
   sum(NO_OF_BIDS) total_no_of_bids, 
   t.team_name team
from 
	ipl_bidder_points bp
join 
	ipl_bidding_details bd
on
	bp.BIDDER_ID = bd.BIDDER_ID
join 
	ipl_team t
on
	bd.BID_TEAM = t.TEAM_ID
group by 
	bd.BID_team
order by 
	bd.bid_team;

# 5.	Show the team id who won the match as per the win details.

select
	TEAM_ID1, 
    TEAM_ID2, 
    MATCH_WINNER, 
    count(*) as total_no_of_matches, 
    sum(case when match_winner = 1 then 1 else 0 end) as no_of_wins, 
    sum(case when match_winner = 2 then 1 else 0 end) as no_of_losses
from 
	ipl_match m
group by 
	m.TEAM_ID1
order by 
	no_of_wins desc;

# 6.	Display total matches played, total matches won, and total matches lost by team along with its team name.

select
	TEAM_ID1 team_id, 
    t.team_name, 
    MATCH_WINNER, 
    count(*) as total_no_of_matches, 
    sum(case when match_winner = 1 then 1 else 0 end) as no_of_wins, 
    sum(case when match_winner = 2 then 1 else 0 end) as no_of_losses
from 
	ipl_match m
join 
	ipl_team t
on
	m.TEAM_ID1 = t.TEAM_ID
group by 
	m.TEAM_ID1
order by 
	no_of_wins desc;
    
# some entries are unclean data
# because the MATCH_WINNER can only be 1 or 2 
# but sometimes other numbers like 6 are there 
# that's why total_no_of_matches != no_of_wins + no_of_losses

# 7.	Display the bowlers for Mumbai Indians team.

SELECT 
	* 
FROM 
	ipl.ipl_team_players
WHERE 
	remarks like "%MI%" 
    and
    PLAYER_ROLE = 'Bowler';

# 8.	How many all-rounders are there in each team, Display the teams with more than 4 
# all-rounder in descending order.

SELECT 
    substr(remarks, 8, 4) team_initials, 
    PLAYER_ROLE, 
    count(*) no_of_all_rounders
FROM 
	ipl.ipl_team_players
WHERE
	PLAYER_ROLE = "All-Rounder"
GROUP BY 
	team_initials
HAVING
	no_of_all_rounders > 4
ORDER BY
	no_of_all_rounders DESC;

    
