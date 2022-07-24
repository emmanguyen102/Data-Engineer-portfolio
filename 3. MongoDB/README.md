# Query with MongoDB 
The aim is to get used to a popular NoSQL database.

## Step by step procedure:
1. Data analysis and define all collections of this database
2. Create ERD of database
3. Create mongo database based on ERD design
4. Test validity of database by answering some business questions
5. Create index for better query performance

### Data set analysis
Based on the given data set, 5 collections with its own purpose were created as follows:
- Collection user: contains personal information of each user such as age, gender, native
country, and race.
- Collection education: contains information about user’s education such as education
level and number of years of education.
- Collection occupation: contains information of user’s work class, occupation, and
hours of working per week.
- Collection relationship: contains information of user’s marital status and relationship
with owner.
- Collection finance: contains information of user’s financial situation such as total
income, income level, capital gain and capital loss.

### ERD design
ERD design as follows.
<br>
![erd](./img/Database%20ERD.png)
<br>
Relationship among between collections:
- Users-Relationship: 1-M, meaning that many users have one same kind of relationship. One user
has only 1 kind of relationship.
- Users-Finance: 1-M, meaning that many users have one same kind of financial situation. One user
has only 1 financial state.
- Users-Occupation: 1-M, meaning that many users have one same kind of relationship. One user has
only one kind of occupation.
- Users-Education: 1-M, meaning that many users have one same kind of education. One user has
only 1 kind of education

### Create physical database

1. Import file in mongoDB compass into database named “DEPx302_Asm2” under collection named
“whole”. The idea is load data into the database without separating it into different collections up
to this point.  

![erd2](./img/import%20data.png)  

2. While loading data, some variables’ data types have been changed into int32 including age, total,
capital_gain, capital_loss, hours_per_week, and education-num.  

![erd3](./img/change%20data%20type.png)

3. Sequentially import data into these 5 predefined collections. Source code can be found in file [Import data to collections.js](https://github.com/emmanguyen102/Data-Engineer-portfolio/blob/main/3.%20MongoDB/Import%20data%20to%20collections.js).

### Collections
Education collection: 16 documents
<br>
![erd4](./img/education%20collection.png)
<br>
-	_id: unique classifier
-	education: type of highest education
-	education_num: years of education

Finance collection: 25757 documents
<br>
![erd5](./img/finance%20collection.png)
 <br>
-	_id: unique classifier
-	income_bracket: either > 50k or <= 50k
-	total: total amount in balance
-	capital_gain: plus changes in account
-	capital_loss: minus changes in account

Occupation collection: 1858 documents
<br>
![erd6](./img/occupation%20collection.png)
<br>
-	_id: unique classifier
-	occupation: occupation name
-	workclass: work class name
-	hours_per_weeks: number of working hours per week

Relationship collection: 29 documents
<br>
![erd](./img/relationship%20collection.png)
<br>
-	_id: unique classifier
-	marital_status: marital status
-	relationship: relationship with owner

User collection: 32429 documents
<br>
![erd](./img/user%20collection.png)
<br>
-	_id: unique classifier
-	age: age
-	gender: gender
-	native_country: native country
-	race: race
-	education_id: references _id in education collection
-	finance_id: references _id in finance collection
-	relationship_id: references _id in relationship collection
-	occupation_id: references _id in occupation collection

### Create index

1. Create index in collection “finance” collection:
Type: compound index
	db.finance.createIndex({income_bracket:1, total: 1})
Reason: Faster to retrieve data, meaning that the mongodb did not have to scan all of the documents, and only those matching documents had to be pulled into memory. This results in a very efficient query.
2. The same applies to other collections, where shows potential for creating index other than _id.
- “finance” collection: single field index for only income_bracket field, so that later if we want to retrieve data only for this field in this collection or in join with other connections to get result related to this field.
- “occupation” collection: single field index for only “work_class” field, since it has only 6 values.
- “relationship” collection: compound index for all fields in this collection.
- “education” collection: single field index for only “education” field, since it has only small amount of values and it would faster to retrieve data when using group() aggregation or simply find().
- “user” collection: compound index for field “gender” and “native_country” since these 2 field are very common personal information.


## Prerequisites
1. MongoDB newest version
2. LucidChart
3. MongoDB Compass

# More information
More about this project can be found on my Medium [blogpost](https://medium.com/@hangmortimer/mongodb-part-5-build-a-mongodb-database-from-csv-file-b2d3cee9456f).
