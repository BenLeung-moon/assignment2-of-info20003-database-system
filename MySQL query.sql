-- __/\\\\\\\\\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\\\____/\\\\\_________/\\\\\\\\\_________/\\\\\\\________/\\\\\\\________/\\\\\\\________/\\\\\\\\\\________________/\\\\\\\\\_______/\\\\\\\\\_____        
--  _\/////\\\///__\/\\\\\\___\/\\\_\/\\\///////////___/\\\///\\\_____/\\\///////\\\_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\____/\\\///////\\\_____________/\\\\\\\\\\\\\___/\\\///////\\\___       
--   _____\/\\\_____\/\\\/\\\__\/\\\_\/\\\____________/\\\/__\///\\\__\///______\//\\\___/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\__\///______/\\\_____________/\\\/////////\\\_\///______\//\\\__      
--    _____\/\\\_____\/\\\//\\\_\/\\\_\/\\\\\\\\\\\___/\\\______\//\\\___________/\\\/___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_________/\\\//_____________\/\\\_______\/\\\___________/\\\/___     
--     _____\/\\\_____\/\\\\//\\\\/\\\_\/\\\///////___\/\\\_______\/\\\________/\\\//_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\________\////\\\____________\/\\\\\\\\\\\\\\\________/\\\//_____    
--      _____\/\\\_____\/\\\_\//\\\/\\\_\/\\\__________\//\\\______/\\\______/\\\//________\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\___________\//\\\___________\/\\\/////////\\\_____/\\\//________   
--       _____\/\\\_____\/\\\__\//\\\\\\_\/\\\___________\///\\\__/\\\______/\\\/___________\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\___/\\\______/\\\____________\/\\\_______\/\\\___/\\\/___________  
--        __/\\\\\\\\\\\_\/\\\___\//\\\\\_\/\\\_____________\///\\\\\/______/\\\\\\\\\\\\\\\__\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___\///\\\\\\\\\/_____________\/\\\_______\/\\\__/\\\\\\\\\\\\\\\_ 
--         _\///////////__\///_____\/////__\///________________\/////_______\///////////////_____\///////________\///////________\///////_______\/////////_______________\///________\///__\///////////////__

-- Your Name: HAOHONG LIANG
-- Your Student Number: 1247421
-- By submitting, you declare that this work was completed entirely by yourself.

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1
select firstName, lastName
from player natural join clubplayer inner join club 
on clubplayer.ClubID = club.ClubID
where ClubName = 'Melbourne Tigers' and ToDate is null;

-- END Q1
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2
select TeamName
from team inner join game on (team.TeamID = game.Team1 and T1Score is null)
or (team.TeamID = game.Team2 and T2Score is null)
where (T1Score = 28 and T2Score is null) or (T2Score = 28 and T1Score is null)
group by TeamName
order by count(TeamID) DESC
limit 1;


-- END Q2
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3
select FirstName, lastName
from player inner join clubplayer on player.PlayerID = clubplayer.PlayerID
group by clubplayer.playerID
order by count(distinct ClubID) DESC
limit 1;

-- END Q3
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4
select firstName, lastName, 
count(case when SeasonYear = '2020' then 1 else NUll end)as numGames2020
, count(case when SeasonYear = '2021' then 1 else NUll end) as numGame2021
from player inner join playerteam inner join game inner join season
on player.PlayerID = playerteam.PlayerID and playerteam.GameID = game.GameID
and season.SeasonID = game.SeasonID
group by firstName, lastName
having count(case when SeasonYear = '2020' then 1 else NUll end) 
> count(case when SeasonYear = '2021' then 1 else NUll end);


-- END Q4
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5
select teamName,  
(sum(case when TeamID = game.Team1 then game.T1Score else 0 end) + sum(case when TeamID = game.Team2 then game.T2Score else 0 end)) as sumOfPoints
from team inner join game on (team.TeamID = game.Team1 or team.TeamID = game.Team2) 
inner join season on game.SeasonID =  season.SeasonID inner join competition on competition.CompetitionID = season.CompetitionID
where CompetitionName = 'Williams Plate' and SeasonYear = 2021
group by team.TeamID
having sumOfPoints
= (select (sum(case when TeamID = game.Team1 then game.T1Score else 0 end) + sum(case when TeamID = game.Team2 then game.T2Score else 0 end)) as maxScore
	from team inner join game on (team.TeamID = game.Team1 or team.TeamID = game.Team2) inner join season on game.SeasonID =  season.SeasonID inner join competition on competition.CompetitionID = season.CompetitionID
	where CompetitionName = 'Williams Plate' and SeasonYear = 2021
	group by team.TeamID
    order by maxScore desc
    limit 1)
    ;


-- END Q5
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6
select distinct firstName, lastName
from player inner join playerteam inner join game inner join season inner join competition 
on player.PlayerID = playerteam.PlayerID 
	and (playerteam.TeamID = game.Team1 or playerteam.TeamID = game.Team2)
	and playerteam.GameID = game.GameID
	and game.SeasonID = season.SeasonID
	and season.CompetitionID = competition.CompetitionID
where Sex = 'F' and CompetitionName = 'Bingham Trophy' and player.playerID not in (
	select distinct player.playerID
	from player inner join playerteam inner join game inner join season inner join competition 
	on player.PlayerID = playerteam.PlayerID 
		and (playerteam.TeamID = game.Team1 or playerteam.TeamID = game.Team2)
		and playerteam.GameID = game.GameID
		and game.SeasonID = season.SeasonID
		and season.CompetitionID = competition.CompetitionID
	where competition.CompetitionName ='Williams Plate'
)
;

-- END Q6
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7
select player.FirstName, player.LastName, club1.ClubName as firstClubName, club2.ClubName as mostRecentClubName
from (select playerID, min(clubplayer.FromDate) as firstTime, max(clubplayer.FromDate) as recentTime
		from clubplayer
        group by clubplayer.PlayerID
    ) as playerDate inner join player inner join clubplayer as clubplayer1 inner join club as club1 
	inner join playerteam inner join game inner join club as club2 inner join clubplayer as clubplayer2
	on player.PlayerID = clubplayer1.playerID and player.PlayerID = clubplayer2.playerID 
	and clubplayer1.ClubID = club1.ClubID and clubplayer2.ClubID = club2.ClubID 
	and player.PlayerID = playerteam.PlayerID and playerteam.GameID = game.GameID
    and player.PlayerID = playerDate.PlayerID
where clubplayer1.Fromdate = (playerDate.firstTime) and clubplayer2.Fromdate = (playerDate.recentTime)
group by player.PlayerID
;

-- END Q7
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8
select distinct playerHavePlayed.firstName, playerHavePlayed.lastName
from 
(select distinct player.playerID, club.ClubName, player.FirstName, player.lastName
	from player inner join club inner join clubplayer
    on player.playerID = clubplayer.PlayerID and club.clubID = clubplayer.ClubID
) as playerHavePlayed
where playerHavePlayed.playerID not in (select player.playerID
										from player inner join club inner join clubplayer 
                                        on player.playerID = clubplayer.PlayerID
                                        and club.ClubID = clubplayer.ClubID
                                        where club.ClubName like '%Melbourne%'
                                        group by player.PlayerID
                                        having count(*) > 1)
and playerHavePlayed.playerID not in (select distinct player.playerID
										from player inner join clubplayer inner join club 
                                        on player.playerID = clubplayer.playerID and club.ClubID = clubplayer.ClubID
                                        where club.ClubName not like '%Melbourne%'
                                        group by player.playerID
                                        having count(*) >= 1
										)
;
-- END Q8
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9
select firstName, lastName, competition.CompetitionName, season.SeasonYear as competitionYear
from player inner join playerteam inner join team inner join game inner join season inner join competition
inner join
(select distinct TeamID
from team inner join game inner join season inner join competition
on (team.TeamID = game.Team1 or team.TeamID = game.Team2) and game.SeasonID = season.SeasonID 
and competition.CompetitionID = season.CompetitionID 
where (team.TeamID = game.Team1 and game.T1Score < game.T2Score) or (team.TeamID = game.Team2 and game.T1Score > game.T2Score)
)as haveLostTeam
on player.PlayerID = playerteam.PlayerID and playerteam.TeamID = team.TeamID and playerteam.GameID = game.GameID
and game.SeasonID = season.SeasonID and competition.CompetitionID = season.CompetitionID
and (team.TeamID = game.Team1 or team.TeamID = game.Team2) and team.TeamID = haveLostTeam.TeamID
where (team.TeamID = game.Team1 and game.T1Score > game.T2Score) or (team.TeamID = game.Team2 and game.T1Score < game.T2Score)
group by player.playerID
;
-- END Q9
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10
select ratioTable.clubName
from
    (select club.ClubName, TeamID, TeamName, team.ClubID,
    (sum(CASE WHEN team.TeamID = game.Team1 AND (game.T1score > game.T2Score OR game.T2Score IS NULL) THEN 1 ELSE 0 END) 
    + sum(CASE WHEN team.TeamID = game.Team2 AND (game.T1score < game.T2Score OR game.T1Score IS NULL) THEN 1 ELSE 0 END)) 
    /
      (sum(CASE WHEN team.TeamID = game.Team1 AND (game.T1score < game.T2Score OR game.T1Score IS NULL) THEN 1 ELSE 0 END) 
      + sum(CASE WHEN team.TeamID = game.Team2 AND (game.T1score > game.T2Score OR game.T2Score IS NULL) THEN 1 ELSE 0 END))  AS wlRatio
    from club inner join team inner join game inner join season
    on club.ClubID = team.ClubID and (team.TeamID = game.Team1 or team.TeamID = game.Team2) and season.SeasonID = game.SeasonID
    where season.SeasonYear = 2021
    group by team.teamID
    ) as ratioTable
group by ratioTable. ClubID
ORDER BY (max(ratioTable.wlRatio) - min(ratioTable.wlRatio)) DESC
limit 1;
-- END Q10
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- END OF ASSIGNMENT Do not write below this line