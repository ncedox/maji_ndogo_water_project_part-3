/* Maji Ndogo Water Project – Part 2: Data Integrity, Pattern Discovery, and Analysis

Cleaning and Standardizing Employee Data
Format Employee Emails
Employee names are stored as First Last. Email addresses require a dot between the first and last names.
*/
SELECT REPLACE(employee_name, ' ', '.') AS formatted_name
 FROM 
 employee
 LIMIT 5
 ;
/* Convert to Lowercase
Ensure emails are all lowercase to avoid case-sensitivity issues.*/

SELECT 
	LOWER(REPLACE(employee_name, ' ', '.'))
 FROM 
	employee
 LIMIT 5;
 
/* Update Employee Table
Write the formatted emails into the email column.*/

SET SQL_SAFE_UPDATES = 0;
UPDATE employee
    SET email = CONCAT(LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov');
    SET SQL_SAFE_UPDATES = 1;

/* Standardizing Phone Numbers
   Check Phone Number Length
   Identify extra or missing characters in phone numbers.*/
   
   SELECT phone_number, LENGTH(phone_number) AS length_of_number
          FROM employee
         
          LIMIT 10;
          
/* Prepend Country Code
Fix phone numbers that are 11 characters long by adding a leading +.*/


SET SQL_SAFE_UPDATES = 0;
UPDATE employee
SET phone_number = '+' || phone_number
WHERE LENGTH(phone_number) = 11;
 SET SQL_SAFE_UPDATES = 1;
 
 /* Top 3 Field Surveyors
Identify employees with the most location visits for recognition.*/

SELECT assigned_employee_id,
       COUNT(visit_count) AS number_of_visits
FROM 
	visits
GROUP BY 
	assigned_employee_id
ORDER BY 	
	number_of_visits DESC
LIMIT 3;
			/* Employee Visit Summary
            We analyzed the number of visits handled by each employee. The top three employees based on visit count are:
            Employee ID 1 – 3,708 visits,
            Employee ID 30 – 3,676 visits
			Employee ID 34 – 3,539 visits
            */

/* Water Source Records by Town and Province
Analyze distribution of water sources to prioritize maintenance or surveys. */

SELECT 
	town_name, COUNT(*) AS number_of_records
FROM 
	location
GROUP BY town_name
ORDER BY number_of_records DESC;/* Location Record Summary
									We analyzed the number of records per town from the location table. The top towns by record count are:
									Rural – 23,740 records,
									Harare – 1,650 records,
									Amina – 1,090 records,
									Lusaka – 1,070 records,
									Mrembo – 990 records,
									Asmara – 930 records*/
			

SELECT -- Province distribution
	province_name, 
	COUNT(*) AS number_of_records 
FROM 
	location
GROUP BY province_name
ORDER BY number_of_records DESC;/*Province Record Summary:
								We analyzed the number of location records per province. The top provinces by record count are:
								Kilimani – 9,510 records,
								Akatsi – 8,940 records,
								Sokoto – 8,220 records,
								Amanzi – 6,950 records,
								Hawassa – 6,030 records */
				

/* Percentage of Rural Water Souces
We want to understand the distribution of water sources in Maji Ndogo, specifically how many are located in rural areas. 
Calculating the percentage of rural sources gives a more relatable measure than raw counts, making it easier to communicate the situation and support decision-making
*/

SELECT 
    COUNT(*) AS total_sources,
    SUM(CASE WHEN town_name = 'Rural' THEN 1 ELSE 0 END) AS rural_sources,
    ROUND(
        (SUM(CASE WHEN town_name = 'Rural' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
    ) AS rural_percentage
FROM 
    location;  /*In Maji Ndogo, there are 39,650 water sources in total. Of these, 23,740 are located in rural areas, which is about 59.87% of all sources. 
				This highlights that a majority of water sources are in rural regions, giving a clear view of distribution and helping guide planning and decision-making.*/

/* Total Number of People Surveyed
We calculate the total number of people served by all water sources in Maji Ndogo. 
This provides a clear sense of the population affected and the scale of water access needs.
*/

SELECT 
	SUM(number_of_people_served) AS total_people_surveyed
FROM
	water_source; /*he total population served by all water sources is 27,628,140. This highlights the scale of water access in the region and gives a clear sense of the population affected.*/

/* Number of Wells, Taps, and Rivers
We want to understand the distribution of water source types in Maji Ndogo. 
Counting wells, taps, rivers, and other types helps assess infrastructure coverage and plan resource allocation
*/

SELECT 
type_of_water_source, 
COUNT(*) AS number_of_sources
	FROM 
    water_source
GROUP BY type_of_water_source
ORDER BY number_of_sources DESC;  /* wells are the most common water source, with 17,383 in total.
									 Other sources include taps in homes (7,265), broken taps in homes (5,856), shared taps (5,767), and rivers (3,379). 
									 This breakdown helps show both the availability and reliability of water sources across the region.*/

/* Average Number of People per Source Type
We calculate the average number of people served per water source type. 
This helps understand which sources are overcrowded and which are under less pressure. */

SELECT type_of_water_source,
       ROUND(AVG(number_of_people_served), 2) AS avg_people_per_source
FROM 
	water_source
GROUP BY type_of_water_source
ORDER BY ROUND(AVG(number_of_people_served), 2) DESC;  /*On average, shared taps serve the largest number of people in Maji Ndogo, with about 2,071 individuals relying on each one. 
														 Rivers serve around 699 people per source, while broken taps in homes serve 649, working taps in homes serve 644, and wells serve about 279. 
                                                         This highlights how shared taps carry the heaviest demand compared to other water sources*/

/* Total Number of People Using Each Source Type
We calculate the total number of people served by each type of water source. 
This shows which sources support the largest share of the population. */
SELECT type_of_water_source,
       SUM(number_of_people_served) AS total_people_per_type
FROM water_source
GROUP BY type_of_water_source
ORDER BY SUM(number_of_people_served) DESC; /*shared taps support the largest share of the population, serving about 11.9 million people.
											Wells serve 4.8 million, taps in homes serve 4.7 million, broken taps serve 3.8 million, and rivers serve 2.4 million. 
                                            This breakdown highlights how heavily communities depend on shared taps compared to other sources.*/

/* Percentage of People Using Each Source Type
 We calculate what percentage of the total surveyed population depends on each water source type. This helps identify which sources matter most for interventions.
 */
SELECT type_of_water_source,
       ROUND((SUM(number_of_people_served) / 27628140.0) * 100, 2) AS percentage_people_per_source
FROM 
	water_source
GROUP BY type_of_water_source
ORDER BY ROUND((SUM(number_of_people_served) / 27628140.0) * 100, 2) DESC; /* 43.24% of the population relies on shared taps for water. 
																				Wells serve 17.52%, taps in homes serve 16.94%, broken taps serve 13.75%, and rivers account for 8.55%. 
                                                                                This shows that shared taps are by far the most important water source for the majority of people*/

/* Prioritizing Water Source Repairs
 Not all water sources serve the same number of people. To maximize impact, repairs should be prioritized for sources with the largest populations depending on them. 
 Why Ranking Matters
Some water sources serve thousands, while others only a few dozen.
Ranking helps allocate limited repair resources to where they’ll make the biggest difference.
Different ranking functions (ROW_NUMBER, RANK, DENSE_RANK) provide flexibility depending on how ties are treated.*/

SELECT
    source_id,
    type_of_water_source,
    number_of_people_served,
    RANK() OVER (
        PARTITION BY type_of_water_source
        ORDER BY number_of_people_served DESC
    ) AS priority_rank
FROM water_source
WHERE type_of_water_source IN ('shared_tap','well','river')  
ORDER BY priority_rank, number_of_people_served DESC;

SELECT -- summarizing the above in a nut shell 
    type_of_water_source,
    MAX(number_of_people_served) AS max_people_served
FROM water_source
WHERE type_of_water_source IN ('shared_tap','well','river')
GROUP BY type_of_water_source
ORDER BY max_people_served DESC;   /*Shared taps serve the most people per source, with the top taps reaching up to 3,998 individuals. 
									 Rivers are next, with the largest river sources serving 998 people each.
									Wells serve fewer people per source, with the maximum around 398..*/

/* Survey Duration
To understand how long the field survey lasted, we calculate the difference between the first and last recorded visits in the visits table.*/
SELECT
    MIN(time_of_record) AS first_record,
    MAX(time_of_record) AS last_record
FROM visits; /*The visit records span from January 1, 2021, at 09:10, to July 14, 2023, at 13:53. 
				This period covers over two and a half years, providing a comprehensive view of visit activity over time*/

/* Average Water Queue Time in Maji Ndogo
 Many water sources, like taps in homes, have no queues (recorded as 0). 
 To understand actual waiting times, we ignore zeros and focus only on sources where people queue.*/
 
SELECT
    AVG(time_in_queue) AS avg_queue_time_minutes
FROM
    visits
WHERE
    time_in_queue != 0; /*On average, people spent about 123 minutes waiting in the queue, giving insight into service delays and workload at the water sources.*/
    
/* Average Queue Time by Day of the Week
We analyze which days of the week experience the longest water queues. This helps identify peak demand days and plan interventions accordingly */
SELECT
    CASE dow
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS day_of_week,
    ROUND(AVG(time_in_queue)) AS avg_queue_time
FROM (
    SELECT
        DAYOFWEEK(time_of_record) AS dow,
        time_in_queue
    FROM visits
    WHERE time_in_queue != 0
) AS sub
GROUP BY dow
ORDER BY dow; /* Average queue times vary across the week in Maji Ndogo. Saturdays are the busiest, with people waiting an average of 246 minutes, while Sundays are the least busy, with an average wait of 82 minutes.
				Weekdays generally fall between these extremes, showing how demand fluctuates over the week. */

-- Average Queue Time by Hour and Day of the Week 
-- We analyze how queue times vary across hours of the day and days of the week. This helps identify peak times and plan water distribution or repairs efficiently. 

SELECT
    HOUR(time_of_record) AS hour_of_day,
    ROUND(AVG(CASE WHEN DAYOFWEEK(time_of_record) = 1 THEN time_in_queue END), 0) AS Sunday,
    ROUND(AVG(CASE WHEN DAYOFWEEK(time_of_record) = 2 THEN time_in_queue END), 0) AS Monday,
    ROUND(AVG(CASE WHEN DAYOFWEEK(time_of_record) = 3 THEN time_in_queue END), 0) AS Tuesday,
    ROUND(AVG(CASE WHEN DAYOFWEEK(time_of_record) = 4 THEN time_in_queue END), 0) AS Wednesday,
    ROUND(AVG(CASE WHEN DAYOFWEEK(time_of_record) = 5 THEN time_in_queue END), 0) AS Thursday,
    ROUND(AVG(CASE WHEN DAYOFWEEK(time_of_record) = 6 THEN time_in_queue END), 0) AS Friday,
    ROUND(AVG(CASE WHEN DAYOFWEEK(time_of_record) = 7 THEN time_in_queue END), 0) AS Saturday
FROM
    visits
WHERE
    time_in_queue != 0
GROUP BY
    hour_of_day
ORDER BY
    hour_of_day;

				/* Findings:
				Saturdays consistently have the highest average queue times, peaking at 282 minutes around 19:00.
				Weekdays generally have lower queues in the early morning, with some spikes around 6–8 and 17–19 hours.
				Sundays have the shortest queues early in the day, averaging 78–86 minutes, except for a late spike at 19:00.*/


























          
	


