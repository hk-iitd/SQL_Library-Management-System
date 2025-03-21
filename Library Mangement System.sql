-- Library Management sysytem Project

Use library_db;

drop table if exists branch;

Create table branch(
	branch_id varchar(10) Primary key,
    manager_id	varchar(10),
    branch_address	varchar(50),
    contact_no varchar(30)
);
drop table if exists employee;

ALTER TABLE Branch,
ALTER COLUMN branch_id Type varchar(30);

Create table empolyee (
	emp_id	varchar(25) Primary key,
    emp_name varchar(30),
    position varchar(30),
    salary	int,
    branch_id varchar(25), -- FK
    FOREIGN KEY (branch_id) references branch(branch_id)
);

create table books(
	isbn varchar(50) Primary Key, 
    book_title varchar(50),
    category varchar(50),
    rental_price float,
    status	varchar(50),
    author	varchar(50),
    publisher varchar(60)
);


Create table members(
 member_id	varchar(10) primary key,
 member_name varchar(50),
 member_address	varchar(50),
 reg_date date
);

CREATE TABLE issue_status(
issued_id varchar(50) primary key,
issued_member_id varchar(50), -- FK
issued_book_name varchar(75),
issued_date	date,
issued_book_isbn varchar(50), -- FK
issued_emp_id varchar(50), -- FK
FOREIGN KEY (issued_member_id) references members(member_id),
FOREIGN KEY (issued_book_isbn) references books(isbn),
FOREIGN KEY (issued_emp_id) references empolyee(emp_id)
);


Create table return_status(
	return_id	varchar(50) primary key,
    issued_id	varchar(50), -- FK
    return_book_name	varchar(80),
    return_date	date,
    return_book_isbn varchar(50), -- FK
    FOREIGN KEY (issued_id) references issue_status(issued_id),
    FOREIGN KEY (return_book_isbn) references books(isbn)
);

-- Project Task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO BOOKS(isbn, book_title, category, rental_price, status, author, publisher) 
VALUE('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

select count(*) from books;

-- Task 2: Update an Existing Member's Address

select * from members;

update members
set member_address = '133 Pine St'
where member_id = 'C104';

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM ISSUE_STATUS WHERE issued_id = 'IS121';

Delete from issue_status
where issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT ISSUED_BOOK_NAME FROM ISSUE_STATUS WHERE ISSUED_EMP_ID = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

Select issued_emp_id, count(*) from issue_status
group by 1
having count(*) > 1;

-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

Create table book_cnt as
select b.isbn, b.book_title, count(issued_id)
from books as b
join issue_status as iss
on b.isbn  = iss.issued_book_isbn
group by 1,2;

select * from book_cnt;

-- Task 7. Retrieve All Books in a Specific Category:

select * from books
where category = 'classic';

-- Task 8: Find Total Rental Income by Category:

select b.category, sum(b.rental_price), count(*)
from issue_status ist
join books b
on ist.issued_book_isbn = b.isbn
group by 1;

-- Task 9: List Members Who Registered in the Last 180 Days:

select * from members
where reg_date >= current_date() - interval '380 days';

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

Select e1.*,e2.emp_name as manager_name
from empolyee e1
join branch b1
on e1.branch_id=b1.branch_id
join empolyee e2
on b1.manager_id = e2.emp_id;

-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

Create table book_rental_price_above_7USD
as
select * from books where rental_price > 7;

select * from book_rental_price_above_7USD;

-- Task 12: Retrieve the List of Books Not Yet Returned


SELECT * 
FROM issue_status ist
left join return_status rs
on rs.issued_id = ist.issued_id
where return_id is null;

