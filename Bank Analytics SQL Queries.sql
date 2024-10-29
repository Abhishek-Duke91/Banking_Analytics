USE projectdb;
show tables;
show variables like "secure_file_priv";

create table finance_1 
( id int,	member_id int,	loan_amnt int,	funded_amnt int,	funded_amnt_inv double,	term char(30),	int_rate double,	
installment double,	grade varchar(50),	sub_grade varchar(50),	emp_title varchar(100),	emp_length varchar(50),	home_ownership varchar(50),
annual_inc int,	verification_status varchar(30), issue_d char(30),	loan_status varchar(30),	pymnt_plan varchar(20),	descrip varchar(5000),
purpose varchar(200), title varchar(200),	zip_code varchar(50),	addr_state varchar(50),	dti double );


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\finance_1.csv'
INTO TABLE finance_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from finance_1;



create table finance_2
(id int,	delinq_2yrs int, earliest_cr_live date,	inq_last_6mths int,	mths_since_last_delinq char(30),
s_since_last_record char(30), open_acc int, pub_rec int,	revol_bal int, revol_until double, total_acc int, initial_list_status char(30),	
out_prncp int,	out_prncp_inv int,	total_pymnt double,	total_pymnt_inv double,	total_rec_prncp double,	total_rec_int double,	
total_rec_late_fee int,	recoveries double, 	collection_recovery_fee double,	last_pymnt_d char(50),	last_pymnt_amnt double,	
next_pymnt_d char(50),	last_credit_pull_d char(50)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\finance_2.csv'
INTO TABLE finance_2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from finance_2;

# KPI 1 Year wise loan amount Stats
select year (issue_d), sum(loan_amnt) from finance_1 group by year(issue_d) order by year(issue_d);


#KPI 2 Grade and sub grade wise revol_bal
Select grade, sub_grade, sum(revol_bal)
from finance_1 inner join finance_2 on finance_1.id = finance_2.id
group by grade, sub_grade order by grade, sub_grade;


#KPI 3 Total Payment for Verified Status Vs Total Payment for Non Verified Status
select verification_status, round(sum(total_pymnt),2) from
finance_1 inner join finance_2 on finance_1.id = finance_2.id
group by verification_status;


# KPI 4 State wise and month wise loan status
select addr_state as state , month(issue_d) as month_,loan_status
from finance_1 inner join finance_2 on finance_1.id = finance_2.id
order by state , month_;


# KPI 5 Home ownership Vs last payment date stats
select home_ownership , count(last_pymnt_d)
from finance_1 inner join finance_2 on finance_1.id = finance_2.id
group by home_ownership;