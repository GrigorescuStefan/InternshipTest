# Create a MySQL Database

# Create a MySql container. Create a database named “company”.
```
C:\Users\Stefan>docker pull mysql
Using default tag: latest
latest: Pulling from library/mysql
9a5c778f631f: Pull complete
9e77c3a95bf2: Pull complete
8b279a2086e0: Pull complete
c8bfbcde7882: Pull complete
d35b074b68ec: Pull complete
beea5014e6af: Pull complete
dc3791a61558: Pull complete
52f9323b9f0e: Pull complete
7f7391eab49b: Pull complete
8d2f04b287ee: Pull complete
Digest: sha256:9d1c923e5f66a89607285ee2641f8a53430a1ccd5e4a62b35eb8a48b74b9ff48
Status: Downloaded newer image for mysql:latest
docker.io/library/mysql:latest

What's Next?
  1. Sign in to your Docker account → docker login
  2. View a summary of image vulnerabilities and recommendations → docker scout quickview mysql

C:\Users\Stefan>docker run --name -intern-sqldb -e MYSQL_ROOT_PASSWORD=grigo1 -d mysql:latest
docker: Error response from daemon: Invalid container name (-intern-sqldb), only [a-zA-Z0-9][a-zA-Z0-9_.-] are allowed.
See 'docker run --help'.

C:\Users\Stefan>docker run --name intern-sqldb -e MYSQL_ROOT_PASSWORD=grigo1 -d mysql:latest
397334e6b059937b9748cc6eab5b2ad1bd0d405bd88c7fe236fa9c6fee6eff62
```
## Unexpected error
```

C:\Users\Stefan\Desktop\InternshipTasks\thirdExercise>docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                 NAMES
397334e6b059   mysql:latest   "docker-entrypoint.s…"   12 minutes ago   Up 51 seconds   3306/tcp, 33060/tcp   intern-sqldb

C:\Users\Stefan\Desktop\InternshipTasks\thirdExercise>docker cp ./company.sql CONTAINER_ID:397334e6b059
Successfully copied 4.61kB to CONTAINER_ID:397334e6b059
Error response from daemon: No such container: CONTAINER_ID

C:\Users\Stefan\Desktop\InternshipTasks\thirdExercise>docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS         PORTS                 NAMES
397334e6b059   mysql:latest   "docker-entrypoint.s…"   13 minutes ago   Up 2 minutes   3306/tcp, 33060/tcp   intern-sqldb
```

## Realization that i still don't understand docker and its commands that well
```
C:\Users\Stefan\Desktop\InternshipTasks\thirdExercise>docker cp ./company.sql 397334e6b059
must specify at least one container source

C:\Users\Stefan\Desktop\InternshipTasks\thirdExercise>docker cp ./company.sql 397334e6b059:/company.sql
Successfully copied 4.61kB to 397334e6b059:/company.sql

C:\Users\Stefan\Desktop\InternshipTasks\thirdExercise>docker exec -it 397334e6b059 bash
bash-4.4# ls
bin   company.sql  docker-entrypoint-initdb.d  home  lib64  mnt  proc  run   srv  tmp  var
boot  dev          etc                         lib   media  opt  root  sbin  sys  usr
bash-4.4#
```

# Import the company.sql file in your company database.
```
mysql> create database if not exists company;
Query OK, 1 row affected, 1 warning (0.02 sec)
mysql> use company;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A
mysql> source /company.sql;
Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected, 1 warning (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

ERROR 1366 (HY000): Incorrect integer value: 'Consulting' for column 'department' at row 41
Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected, 1 warning (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 8 rows affected (0.01 sec)
Records: 8  Duplicates: 0  Warnings: 0

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected, 1 warning (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 11 rows affected (0.01 sec)
Records: 11  Duplicates: 0  Warnings: 0
```
## After checking the company.sql file in more detail i see the problem.
Where it should've been presumably `7` i have the string `Consulting`. I decided to modify it outside of the container and just follow the same steps as before to copy the file inside the Docker container.
# Database created
```
C:\Users\Stefan\Desktop\InternshipTasks\thirdExercise>docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                 NAMES
397334e6b059   mysql:latest   "docker-entrypoint.s…"   38 minutes ago   Up 26 minutes   3306/tcp, 33060/tcp   intern-sqldb

C:\Users\Stefan\Desktop\InternshipTasks\thirdExercise>docker cp ./company.sql 397334e6b059:/company.sql
Successfully copied 4.61kB to 397334e6b059:/company.sql

C:\Users\Stefan\Desktop\InternshipTasks\thirdExercise>docker exec -it 397334e6b059 bash
bash-4.4# ls
bin  boot  company.sql  dev  docker-entrypoint-initdb.d  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
bash-4.4# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 8.3.0 MySQL Community Server - GPL

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database if not exists company;
Query OK, 1 row affected, 1 warning (0.00 sec)

mysql> use company;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> source /company.sql;
Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected, 1 warning (0.02 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 47 rows affected (0.01 sec)
Records: 47  Duplicates: 0  Warnings: 0

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected, 1 warning (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 8 rows affected (0.01 sec)
Records: 8  Duplicates: 0  Warnings: 0

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected, 1 warning (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 11 rows affected (0.00 sec)
Records: 11  Duplicates: 0  Warnings: 0
mysql> select * from employees;
+-------------+------------+-----------+----------+------------+----------+
| employee_id | first_name | last_name | position | department | salary   |
+-------------+------------+-----------+----------+------------+----------+
|          95 | John       | Doe       |        1 |          1 | 60000.00 |
|          96 | Jane       | Smith     |        2 |          2 | 70000.00 |
|          97 | Michael    | Johnson   |        3 |          3 | 55000.00 |
|          98 | Emily      | Williams  |        4 |          4 | 65000.00 |
|          99 | William    | Jones     |        5 |          2 | 75000.00 |
|         100 | Sarah      | Brown     |        6 |          5 | 50000.00 |
|         101 | James      | Taylor    |        1 |          6 | 62000.00 |
|         102 | Olivia     | Martinez  |        7 |          7 | 80000.00 |
|         103 | David      | Anderson  |        8 |          6 | 58000.00 |
|         104 | Sophia     | Garcia    |        9 |          3 | 48000.00 |
|         105 | Benjamin   | Lopez     |       10 |          8 | 57000.00 |
|         106 | Emma       | Hernandez |       11 |          6 | 63000.00 |
|         107 | Alexander  | Scott     |        2 |          2 | 72000.00 |
|         108 | Ava        | Clark     |        3 |          3 | 56000.00 |
|         109 | Mia        | Lewis     |        4 |          4 | 67000.00 |
|         110 | Ethan      | Adams     |        5 |          2 | 78000.00 |
|         111 | Charlotte  | Green     |        6 |          5 | 51000.00 |
|         112 | Ryan       | Baker     |        1 |          6 | 64000.00 |
|         113 | Daniel     | Gonzalez  |        7 |          7 | 82000.00 |
|         114 | Chloe      | Nelson    |        8 |          6 | 59000.00 |
|         115 | Jacob      | Carter    |        9 |          3 | 49000.00 |
|         116 | Liam       | Hill      |       10 |          8 | 58000.00 |
|         117 | Madison    | Mitchell  |       11 |          6 | 65000.00 |
|         118 | Avery      | Perez     |        2 |          2 | 73000.00 |
|         119 | Harper     | Roberts   |        3 |          3 | 57000.00 |
|         120 | Evelyn     | Turner    |        4 |          4 | 68000.00 |
|         121 | Jackson    | Phillips  |        5 |          2 | 79000.00 |
|         122 | Sofia      | King      |        6 |          5 | 52000.00 |
|         123 | Henry      | Adams     |        1 |          6 | 66000.00 |
|         124 | Amelia     | Campbell  |        7 |          7 | 84000.00 |
|         125 | Landon     | Parker    |        8 |          6 | 60000.00 |
|         126 | Scarlett   | Evans     |        9 |          3 | 50000.00 |
|         127 | Lucas      | Edwards   |       10 |          8 | 59000.00 |
|         128 | Mason      | Stewart   |       11 |          6 | 67000.00 |
|         129 | Eleanor    | Flores    |        2 |          2 | 74000.00 |
|         130 | Grace      | Morris    |        3 |          3 | 58000.00 |
|         131 | Nolan      | Nguyen    |        4 |          4 | 69000.00 |
|         132 | Carter     | Rogers    |        5 |          2 | 80000.00 |
|         133 | Aubrey     | Gray      |        6 |          5 | 53000.00 |
|         134 | Joshua     | Cook      |        1 |          6 | 68000.00 |
|         135 | Hannah     | Murphy    |        7 |          7 | 86000.00 |
|         136 | Hunter     | James     |        8 |          6 | 61000.00 |
|         137 | Anna       | Reed      |        9 |          3 | 51000.00 |
|         138 | Isaac      | Bailey    |       10 |          8 | 60000.00 |
|         139 | Levi       | Ward      |       11 |          6 | 69000.00 |
|         140 | Natalie    | Bell      |        2 |          2 | 75000.00 |
|         141 | Ella       | Harrison  |        3 |          3 | 59000.00 |
+-------------+------------+-----------+----------+------------+----------+
47 rows in set (0.01 sec)
```

# Create a user and assign all the permissions required for the database “company”
Flushing the privileges just means reloading them so the changes can actually take place.
```
mysql> create user 'Stefan'@'%' identified by '[REDACTED]';  
Query OK, 0 rows affected (0.03 sec)

mysql> grant all privileges on company.* to 'Stefan'@'%';  
Query OK, 0 rows affected (0.02 sec)

mysql> flush privileges;  
Query OK, 0 rows affected (0.02 sec)
```
# Find the average salary for each department
```
mysql> select department, avg(salary) as average_salary from employees group by department;
+------------+----------------+
| department | average_salary |
+------------+----------------+
|          1 |   60000.000000 |
|          2 |   75111.111111 |
|          3 |   53666.666667 |
|          4 |   67250.000000 |
|          5 |   51500.000000 |
|          6 |   63500.000000 |
|          7 |   83000.000000 |
|          8 |   58500.000000 |
+------------+----------------+
8 rows in set (0.00 sec)
```