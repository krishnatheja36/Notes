Terminal Access: /usr/local/mysql/bin/mysql -u root -p
create database LEARN;
CREATE USER 'LEARN_ADMIN'@'localhost' IDENTIFIED BY 'KR@ishna@123';
GRANT ALL PRIVILEGES ON LEARN.* TO 'LEARN_ADMIN'@'localhost';
SHOW GRANTS FOR 'LEARN_ADMIN'@'localhost';
/usr/local/mysql/bin/mysql -u LEARN_ADMIN -p



import pandas as pd
import mysql.connector as msql
from mysql.connector import Error

empdata = pd.read_csv('/Users/krishnathejaupadhyaya/Downloads/1000_Sales_Records.csv', index_col=False, delimiter = ',')

try:
    conn = msql.connect(host='localhost', database='LEARN', user='LEARN_ADMIN', password='KR@ishna@123')
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute("select database();")
        record = cursor.fetchone()
        print("You're connected to database: ", record)
        cursor.execute('DROP TABLE IF EXISTS employee_data;')
        print('Creating table....')
# in the below line please pass the create table statement which you want #to create
        cursor.execute("CREATE TABLE employee_data(Region varchar(255),Country varchar(255),Item_Type varchar(255),Sales_Channel varchar(255),Order_Priority varchar(255),Order_Date varchar(255),Order_ID varchar(255),Ship_Date varchar(255),Units_Sold varchar(255),Unit_Price varchar(255),Unit_Cost varchar(255),Total_Revenue varchar(255),Total_Cost varchar(255),Total_Profit varchar(255))")
        print("Table is created....")
        #loop through the data frame
        for i,row in empdata.iterrows():
            #here %S means string values 
            sql = "INSERT INTO LEARN.employee_data VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            cursor.execute(sql, tuple(row))
            print("Record inserted")
            # the connection is not auto committed by default, so we must commit to save our changes
            conn.commit()
except Error as e:
            print("Error while connecting to MySQL", e)
            
            
