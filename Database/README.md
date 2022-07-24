# Database: Data modelling of an e-news website and turn ERD design into a physical database in MySQL Server

An e-news website was investagted with the aim of creating the ERD. This was later turned into a database in MySQL Server using T-SQL along with 10 querries from database to practice advanced T-SQL syntax.  
<br>
<br>

## ERD
The ERD was created by using the tool called [LucidChart](https://www.google.com/aclk?sa=l&ai=DChcSEwilsdOL6Ib4AhVOFXsKHbFCDXkYABAAGgJsZQ&ae=2&sig=AOD64_3ffR6msjyq6BlPuqzE0c3pSjPm2Q&q&adurl&ved=2ahUKEwjbr8iL6Ib4AhWhCRAIHW1rB20Q0Qx6BAgDEAE)
<br>Here is the ERD design for this project. 
<br>
![image](https://user-images.githubusercontent.com/57014399/170951231-cb601c27-8be1-4910-b7ed-44de4ee7fa87.png)
<br>
### Enitites description:

-	Writer: aka reporter, person that writes one or several articles.
  - writerID: unique sequence for each writer
  - writerName: name of the writer
-	Editor: person who is in charge of reviewing article written by one or several writers.
  - editorID: unique sequence for each editor
  - editorName: name of each editor
-	Review: Since the relationship between writer and editor is M-N, a new entity named “Review” should be created to connect between these 2 entities. 
  - reviewID: unique sequence for each review
  - reviewDate: the day that the review session is conducted
-	Article: an article
  - articleID: unique sequence of each article
  - fullContent: whole content of each article
  - publishedDate: the day that the article is published
  - headerName: summary of the article
  - articleNam: name of the article
-	ArticleWriter: Since the relationship between writer and article is M-N, a new entity named “ArticleWriter” should be created to connect between these 2 entities. 
-	InCategory: Since the relationship between article and category is M-N, a new entity named “InCategory” should be created to connect between these 2 entities.
-	Picture: pictures used in all articles
  - picID: unique sequence of each picture
  - picName: name of each picture
-	Category:
  - categoryID: unique sequence of each category
  - categoryName: name of each category


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
