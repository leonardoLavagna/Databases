# Toy-Employee
The idea of this project is to use MySQL and MongoDB to compare performances on some queries carried out on a toy database. 

### What's in here?
- The toy database `database_employee.sql` imported from a freely available dataset (see below)
- The SQL queries we carried out in MySQL `queries.sql`
- The NoSQL queries we carried in MongoDB `mongodb_queries.txt`

*Remark .*  MongoDB Compass in conjunction with Cloud MongoDB (MongoDB Atlas) can be used to carry out the tasks in the NoSQL case. To populate the NoSQL database we have exported all the relevant tables using MySQL Workbench into .json files. Those files can be then imported into MongoDB Compass. Another approach can be to use MongoDB Atlas in order to work with single database in the cloud (by creating a cluster) and connect with it by adding your IP addresses in the network access manager in MongoDB Atlas and via a URI connection string. 

### Dataset
We used the dataset cited in this article: https://towardsdatascience.com/learning-sql-learn-how-to-practice-sql-with-a-complex-database-4b2ce933b1ef. All the relevant data can be obtained here: https://www.dropbox.com/s/znmjrtlae6vt4zi/employees.sql?dl=0.

### Disclamair 
This project was part of a course of Data Menagement at Sapienza University of Rome held by Prof. D. Lembo and Prof. R. Rosati. This project was done in collaboration with Alessia Sgrigna. 
