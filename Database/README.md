# Database
I have explored the world of MySQL Server with T-SQL with the help of one course on Udemy (a list of courses can be found in README.md file in the main repo).
<br>I have solved all SQL challenges on HackerRank for basic SQL syntax, which took me around 3 days.
However, understanding advanced T-SQL is quite different experience as I have never touched advanced SQL that much before. Thanksfully, I have done a project on 
e-news website database desgin from scratch with 10 querries to understand these advanced T-SQL concept in practice. It is actually very logical and fun at the same
time to see my codes get errors all the time. Each time I encountered something wrong, I immediately searched StackOverFlows and gained much better acknowledge of
SQL Server in general. 
<br>
<br>

## ERD
I created this by using this tool called [LucidChart](https://www.google.com/aclk?sa=l&ai=DChcSEwilsdOL6Ib4AhVOFXsKHbFCDXkYABAAGgJsZQ&ae=2&sig=AOD64_3ffR6msjyq6BlPuqzE0c3pSjPm2Q&q&adurl&ved=2ahUKEwjbr8iL6Ib4AhWhCRAIHW1rB20Q0Qx6BAgDEAE)
<br>Here is the ERD design for this project. I no mean say this is an actual version of any e-news website, this is just my own design:
<br>
![image](https://user-images.githubusercontent.com/57014399/170951231-cb601c27-8be1-4910-b7ed-44de4ee7fa87.png)

## Database design
Based on ERD, I created the database named “Assignmen2” with 8 tables representing 8 entities in figure 1. I have created queries 
to ingest dummy data into these 8 tables, each with 10 rows. All the tasks have been conducted as follows:
1. Create database named “Assignmen2” and all its 8 tables with all variables, data types and 
constraints based the initial table design above. [file 1](https://github.com/emmanguyen102/Data-Engineer-portfolio/blob/main/Database/define_table.sql)
2. Insert records into these tables. (Dummy data for the assignment purpose) (file 1)
3. Write 10 queries with at least 1 function, 1 trigger, 1 stored procedure, 
1 indexing and 2 transactions are implemented. The comments are given within the source code 
files to illustrate further each function of each query. [file 2](https://github.com/emmanguyen102/Data-Engineer-portfolio/blob/main/Database/10queries_including_advancedTSQL.sql).

## Blogging
You can also check my blogs on advanced SQL on my [Medium blog](https://hangmortimer.medium.com/) for indexing, trigger, stored procedure, function and transaction.

## Requirement
* Windows 10
* MySQL Sever 2019
* Microsoft SQL Server Management Studio 18
* LucidChart
