--Написати запити SELECT для отримання даних (включаючи фільтрацію за допомогою WHERE та вибір певних стовпців).
Select first_name
from public.customer
where first_name = 'Alice'

--Практикувати використання оператори INSERT для додавання нових рядків до таблиць.
insert into customer
(customer_id, first_name, last_name, email, phone)
values
(gen_random_uuid(), 'David', 'Brown', 'david.brown@example.com', '+11223344556');

select * from customer;

--Практикувати використання оператора UPDATE для зміни існуючих рядків (використовуючи SET та WHERE)
UPDATE customer
set email = 'meneZminyly@example.com'
where customer_id = 'Odaa667f-ab7f-4484-be69-7d44fb1a7909';

select * from customer;

--Практикувати використання оператори DELETE для безпечного видалення рядків (за допомогою WHERE)
delete from customer
where customer_id = 'Odaa667f-ab7f-4484-be69-7d44fb1a7909';

select * from customer;