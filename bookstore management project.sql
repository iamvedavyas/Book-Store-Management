create database project;
use project;

CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
);
 
INSERT INTO author (name_author)
VALUES ('Ruskin Bond'),
       ('Arundhati Roy'),
       ('R.K.Narayan'),
       ('Chetan Bhagat'),
       ('Premchand');
 
CREATE TABLE genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR(30)
);
 
INSERT INTO genre(name_genre)
VALUES ('Novel'),
       ('Poetry'),
       ('Adventures');
 
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8, 2),
    amount INT,
    FOREIGN KEY (author_id)
        REFERENCES author (author_id)
        ON DELETE CASCADE,
    FOREIGN KEY (genre_id)
        REFERENCES genre (genre_id)
        ON DELETE SET NULL
);
 
INSERT INTO book (title, author_id, genre_id, price, amount)
VALUES  ('Angry River', 1, 1, 699.99, 3),
        ('The Blue Umbrella ', 1, 1, 549.50, 5),
        ('The God of small things', 2, 1, 460.00, 10),
        ('The cost of living', 2, 1, 799.01, 2),
        ('The Dark Room', 2, 1, 499.50, 10),
        ('The English Teacher', 3, 2, 650.00, 15),
        ('Half Girlfriend', 3, 2, 570.20, 6),
        ('One Indian Girl', 4, 2, 518.99, 2);
 
CREATE TABLE city (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    name_city VARCHAR(30),
    days_delivery INT
);
 
INSERT INTO city(name_city, days_delivery)
VALUES ('Delhi', 5),
       ('Hyderabad', 3),
       ('Chennai', 12);
 
CREATE TABLE client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name_client VARCHAR(50),
    city_id INT,
    email VARCHAR(30),
    FOREIGN KEY (city_id) REFERENCES city (city_id)
);
 
INSERT INTO client(name_client, city_id, email)
VALUES ('Tarak', 3, 'tarakram@test'),
       ('kalyan', 1, 'kalayanram@test'),
       ('karan', 2, 'karna@test'),
       ('Ayaan', 1, 'bunny@test');
 
CREATE TABLE buy(
    buy_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_description VARCHAR(100),
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES client (client_id)
);
 
INSERT INTO buy (buy_description, client_id)
VALUES ('The door is just right', 1),
       (NULL, 3),
       ('Read every page on the list', 2),
       (NULL, 1);
 
CREATE TABLE buy_book (
    buy_book_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id INT,
    book_id INT,
    amount INT,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id),
    FOREIGN KEY (book_id) REFERENCES book (book_id)
);
 
INSERT INTO buy_book(buy_id, book_id, amount)
VALUES (1, 1, 1),
       (1, 7, 2),
       (1, 3, 1),
       (2, 8, 2),
       (3, 3, 2),
       (3, 2, 1),
       (3, 1, 1),
       (4, 5, 1);
 
CREATE TABLE step (
    step_id INT PRIMARY KEY AUTO_INCREMENT,
    name_step VARCHAR(30)
);
 
INSERT INTO step(name_step)
VALUES ('Payment'),
       ('Package'),
       ('Transportation'),
       ('Delivery');
 
CREATE TABLE buy_step (
    buy_step_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id INT,
    step_id INT,
    date_step_beg DATE,
    date_step_end DATE,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id),
    FOREIGN KEY (step_id) REFERENCES step (step_id)
);
 
INSERT INTO buy_step(buy_id, step_id, date_step_beg, date_step_end)
VALUES (1, 1, '2020-02-20', '2020-02-20'),
       (1, 2, '2020-02-20', '2020-02-21'),
       (1, 3, '2020-02-22', '2020-03-07'),
       (1, 4, '2020-03-08', '2020-03-08'),
       (2, 1, '2020-02-28', '2020-02-28'),
       (2, 2, '2020-02-29', '2020-03-01'),
       (2, 3, '2020-03-02', NULL),
       (2, 4, NULL, NULL),
       (3, 1, '2020-03-05', '2020-03-05'),
       (3, 2, '2020-03-05', '2020-03-06'),
       (3, 3, '2020-03-06', '2020-03-10'),
       (3, 4, '2020-03-11', NULL),
       (4, 1, '2020-03-20', NULL),
       (4, 2, NULL, NULL),
       (4, 3, NULL, NULL),
       (4, 4, NULL, NULL);
-- Display all orders of Tarak 
-- (order id, what books, at what price and in what quantity he ordered)
--  in a view sorted by order number and book titles.
select buy.buy_id, book.title, book.price, buy_book.amount
from client
join buy on client.client_id=buy.client_id
join buy_book on buy.buy_id=buy_book.buy_id
join book on buy_book.book_id=book.book_id
where client.client_id=1
order by buy.buy_id, book.title
-- Display the names of all customers who ordered Ruskin Boond's book The Angry River
SELECT DISTINCT name_client
FROM client
    INNER JOIN buy ON client.client_id = buy.client_id
    INNER JOIN buy_book ON buy_book.buy_id = buy.buy_id
    INNER JOIN book ON buy_book.book_id=book.book_id
WHERE title ='Angry River' and author_id = 1
-- Count how many times each book was ordered, and for a book, display its author
-- (you need to count how many orders each book appears in).
-- Print the last name and initials of the author, the title of the book, and call the last column Quantity. 
--  Sort the results first by the names of the authors, and then by the titles of the books.
select name_author,title, if (sum(buy_book.amount) is null, 0, count(buy_book.buy_book_id)) as Quantity
from author 
join book on author.author_id=book.author_id
left join buy_book on book.book_id=buy_book.book_id
group by book.book_id
order by name_author, title
-- Display the cities in which customers who placed orders in the online store live. 
-- Indicate the number of orders to each city, call this column Quantity. 
-- Display the information in descending order of the number of orders, and then in alphabetical order by city name.
SELECT name_city, if(count(buy.buy_id) is null, 0, count(buy.buy_id) ) as Quantity
from city 
left join client on city.city_id=client.city_id
join buy on client.client_id=buy.client_id
group by name_city
order by Quantity desc, name_city
-- Display the numbers of all paid orders and the dates when they were paid.
select buy_id, date_step_end
from buy_step
where buy_step.step_id=1 and date_step_end is not null
-- Display information about each order: its number, who created it (user's last name)
-- and its cost (the sum of the products of the number of books ordered and their prices), sorted by order number. 
-- The last column is called Cost.
select buy.buy_id, name_client, sum(buy_book.amount*price) as Price
from buy
join client on buy.client_id=client.client_id
join buy_book on buy_book.buy_id=buy.buy_id
join book on buy_book.book_id=book.book_id
group by buy_id
order by buy_id
-- Display order numbers (buy_id) and the names of the stages at which they are currently located. 
-- If the order is delivered, do not display information about it. Sort information in ascending order buy_id.
select buy_id, name_step
from buy_step
join step on buy_step.step_id=step.step_id
where date_step_end is null and date_step_beg is not null
order by buy_id
-- The city table for each city indicates the number of days in which the order can be delivered to this city 
-- (only the “Transportation” stage is considered). 
-- For those orders that have passed the transportation stage, display the number of days for which the order was actually delivered to the city. 
-- And also, if the order was delivered late, indicate the number of days of delay, otherwise output 0. 
-- The result includes the order number (buy_id), as well as the calculated columns Number_of_days and Lateness.
--  Display information sorted by order number.
select buy.buy_id, datediff(date_step_end,date_step_beg) as Amount of days, if(datediff(date_step_end,date_step_beg)>days_delivery,datediff(date_step_end,date_step_beg)-days_delivery, 0) as Late
from city
join client on city.city_id=client.city_id
join buy on client.client_id=buy.client_id
join buy_step on buy_step.buy_id=buy.buy_id
where step_id=3 and date_step_beg is not null and date_step_end is not null
-- Select all clients who ordered Arundatiroy's books and display the information sorted alphabetically.
-- In your solution, use the author's last name, not his id.
select distinct name_client
from author 
join book on author.author_id=book.author_id
join buy_book on book.book_id=buy_book.book_id
join buy on buy.buy_id=buy_book.buy_id
join client on client.client_id=buy.client_id
where name_author like '%Arundhati Roy%'
order by name_client