# Maji Ndogo Water Project – Part 2
### Data Integrity, Pattern Discovery, and Analysis.
This project focuses on cleaning and analyzing employee and water source data for Maji Ndogo. 
The goal is to understand water access, identify patterns, and prioritize interventions
## Project Activities
### 1. Cleaning and Standardizing Employee Data
Formatted employee emails by replacing spaces with dots (First Last → first.last@ndogowater.gov).
Converted all emails to lowercase to avoid case issues.
Updated phone numbers to include country code (+) for numbers with 11 characters
### 2. Employee Performance Analysis
Counted the number of location visits per employee.
Identified the top 3 field surveyors by visit count for recognition
### 3. Water Source Distribution Analysis
Counted water source records by town and province.
Calculated the percentage of water sources in rural areas.
Summed the total number of people served by all water sources.
Counted number of wells, taps, and rivers.
### 4. Water Source Usage Analysis
Calculated the average number of people per source type.
Calculated the total number of people using each source type.
Calculated the percentage of the population using each source type.
### 5. Prioritizing Water Source Repairs
Ranked water sources by the number of people served to prioritize repairs.
Used RANK() to assign priority levels within each type of source (shared taps, wells, rivers).
### 6. Survey Duration
Identified the first and last visit dates to determine how long the field survey took.
### 7. Queue Time Analysis
Calculated average queue time across all locations with waiting lines.
Analyzed average queue time by day of the week.
Analyzed average queue time by hour and day of the week to identify peak demand times.

## Findings
### Employee Visits
Top 3 surveyors handled the most visits:
Employee 1 – 3,708 visits
Employee 30 – 3,676 visits
Employee 34 – 3,539 visits
### Water Source Records
Most water sources by town: Rural (23,740), Harare (1,650), Amina (1,090).
Most water sources by province: Kilimani (9,510), Akatsi (8,940), Sokoto (8,220).
About 60% of water sources are in rural areas.
### People Served
Total population served by all water sources: 27,628,140 people
### Water Source Types
Wells: 17,383 sources
Taps in homes: 7,265
Broken taps in homes: 5,856
Shared taps: 5,767
Rivers: 3,379
### Average People per Source
Shared taps: 2,071 people
Rivers: 699 people
Broken taps in homes: 649 people
Taps in homes: 644 people
Wells: 279 people
### Total People per Source Type
Shared taps: 11.9 million
Wells: 4.8 million
Taps in homes: 4.7 million
Broken taps: 3.8 million
Rivers: 2.4 million
### Population Percentage by Source Type
Shared taps: 43.24%
Wells: 17.52%
Taps in homes: 16.94%
Broken taps: 13.75%
Rivers: 8.55%
### Survey Duration
Field survey lasted from January 1, 2021, 09:10 to July 14, 2023, 13:53 (~2.5 years)
### Queue Times
Average queue time: 123 minutes.
By day: Saturdays are busiest (246 minutes), Sundays are least busy (82 minutes).
By hour and day:
Saturdays peak at 282 minutes around 19:00.
Weekdays have lower queues in early morning, with spikes around 6–8 and 17–19 hours.
Sundays have the shortest queues early in the day.




















