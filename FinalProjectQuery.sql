--Finans Birimi
--Net Geliri Yüksek olan ilk 10 Ürün?
SELECT p.product_id, p.product_name, 
       SUM(ROUND((o.unit_price * (1 - o.discount) * o.quantity)::numeric, 2)) AS Net_Gelir
FROM products p
INNER JOIN order_details o ON o.product_id = p.product_id GROUP BY p.product_name, p.product_id order by Net_Gelir desc;

--Satış Birimi
--Hangi çalışan, toplam kaç sipariş almış..?
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name, COUNT(o.order_id) AS toplam_siparis
FROM employees AS e
INNER JOIN orders AS o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY toplam_siparis DESC;

--1000 Adetten fazla satılan ürünler?
select p.product_id,p.product_name, sum(od.quantity) as toplam_adet from products p inner join order_details od on od.product_id=p.product_id
group by p.product_id
having sum(od.quantity) > 1000


--Satınalma Birimi
--Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarası
SELECT p.product_id, p.product_name, s.company_name, regexp_replace(s.phone, '[^0-9]', '', 'g')  AS phone
FROM products p
INNER JOIN suppliers s ON s.supplier_id = p.supplier_id
WHERE p.units_in_stock < 1;

--Hangi tedarikçi hangi ürünü sağlıyor
select s.company_name, p.product_name, p.units_in_stock,ROUND(p.unit_price::numeric,2) as unit_price from products p 
inner join suppliers s on s.supplier_id=p.supplier_id
group by s.company_name, p.product_name,p.unit_price, p.units_in_stock order by p.unit_price desc , p.units_in_stock asc

select product_name , unit_price,units_in_stock from products 
order by unit_price desc , units_in_stock asc



--Depo Birimi
--Geciken siparişlerin listesi ve gecikme gün sayısı
SELECT o.required_date, o.shipped_date, c.contact_name AS customer_name, 
       EXTRACT(DAY FROM (o.shipped_date - o.required_date) * INTERVAL '1 day') AS gecikme_gun_sayisi
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
WHERE o.shipped_date > o.required_date;





--PowerBi dashboard sql sorguları

--En çok satan ürün ,bu ürünün kategorisi ve tedarikçisi
SELECT s.company_name, c.category_name, p.product_name
FROM categories AS c
JOIN products AS p ON c.category_id = p.category_id
JOIN suppliers AS s ON s.supplier_id = p.supplier_id
JOIN order_details AS od ON od.product_id = p.product_id
GROUP BY s.company_name, c.category_name, p.product_name
ORDER BY SUM(od.quantity) DESC LIMIT 1

--Ürün Fiyat Listesi
Select product_name , ROUND(unit_price::numeric,2) as unit_price from products order by unit_price DESC

--Ürünün Kategorileri
select  p.product_name,c.category_name from categories c 
join products p
on c.category_id = p.category_id

--En çok kazandıran 10 sipariş
select o.order_id, c.contact_name, sum(od.quantity*od.unit_price) as toplam from orders o 
inner join order_details od on od.order_id=o.order_id
INNER JOIN customers c ON c.customer_id = o.customer_id
group by o.order_id,c.contact_name order by toplam desc limit 10

--Genel Stok Adedi ve Gelen Sipariş
select product_name, units_on_order, units_in_stock from products where units_on_order > units_in_stock
