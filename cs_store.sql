create table Customers (birth_day date, first_name varchar(20), last_name varchar(200), c_id int, constraint pk_customerid primary key (c_id));
create table Employees (birth_day date, first_name varchar(20), last_name varchar(200), e_id int, constraint pk_employeeid primary key (e_id));
create table Transactions (e_id int, c_id int, date date, t_id int, constraint fk_employeeid foreign key (e_id) references Employees(e_id), constraint fk_customerid foreign key (c_id) references Customers(c_id), constraint pk_transacid primary key (t_id));
create table Promotion (number_to_buy int, how_many_are_free int, type int, constraint pk_type primary key (type));
create table Items (price_for_each int, type int, amount_in_stock int, name varchar(20), constraint pk_item primary key (name));
create table ItemsInTransactions (name varchar(20), t_id int, iit_id int, constraint fk_item foreign key (name) references Items(name), constraint fk_transac foreign key (t_id) references Transactions(t_id), constraint pk_ItemsInTransac primary key (iit_id));

create view LouisTransactions as select count(t_id) as number_of_transactions from transactions where e_id = (select e_id from employees where first_name = 'Louis' and last_name = 'Davies') and date >= '2022-09-01' and date <= '2022-09-30';

create view PeopleInShop as select * from ( select distinct birth_day, first_name, last_name from customers, transactions where customers.c_id = transactions.c_id and date = '2022-09-28' union select distinct birth_day, first_name, last_name from employees, transactions where employees.e_id = transactions.e_id and date = '2022-09-28') a order by birth_day;

create view ItemsLeft1 as select items.name, type, amount_in_stock - count(iit_id) as amount_left from items, itemsintransactions where items.name = itemsintransactions.name and (type = '1' or type = '2') group by name order by type;

create view example as select items.name, items.type, amount_in_stock - count(iit_id) as amount_left from items, itemsintransactions where items.name = itemsintransactions.name and (items.type = '3' or items.type = '4') group by name;	
create view example2 as select items.name, items.type, amount_in_stock  as amount_left from items, example where items.name not in (select name from example) and (items.type = '3' or items.type = '4') group by name;
create view ItemsLeft2 as select * from example union select * from example2 order by type, name;

create view IITRanking as select iit_id, t_id, type, price_for_each as price, (select  count(*) from itemsintransactions iit2 natural join items i2 where i2.type = i.type and iit.t_id = iit2.t_id  and ((i2.price_for_each = i.price_for_each and iit.iit_id <= iit2.iit_id) or (i2.price_for_each > i.price_for_each)) group by price )  as rnk from itemsintransactions iit, items i where iit.name = i.name order by t_id desc, type desc, price desc, iit_id desc  ;




