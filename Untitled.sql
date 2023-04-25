create database QUANLYBANHANG;
use QUANLYBANHANG;
create table CUSTOMERS(
	customer_id varchar(4) primary key,
    name varchar(100) not null,
    email varchar(100) unique not null,
    phone varchar(25) unique not null,
    address varchar(255) not null
);
create table ORDERS(
	order_id varchar(4) primary key,
    customer_id varchar(4) not null,
    order_date date not null,
    total_amount double not null,
    foreign key (customer_id) references CUSTOMERS(customer_id)
);
create table PRODUCTS(
	product_id varchar(4) primary key,
    name varchar(255) not null,
    descriptipn text,
    price double not null,
    status bit(1) not null
);
create table ORDERS_DETAILS(
	order_id varchar(4) not null ,
    product_id varchar(4) not null,
    quantity int(11) not null,
    price double not null,
    primary key (order_id, product_id),
    foreign key (order_id) references ORDERS(order_id),
    foreign key (product_id) references PRODUCTS(product_id)
);
alter table PRODUCTS alter column `status` set default 1;
insert into CUSTOMERS values
	('C001','Nguyễn Trung Mạnh','manhnt@gmail.com','984756322','Cầu Giấy, Hà Nội'),
    ('C002','Hồ Hải Nam','namhh@gmail.com','984875926','Ba Vì, Hà Nội'),
    ('C003','Tô Ngọc Vũ','vunt@gmail.com','904725784','Mộc Châu, Sơn La'),
    ('C004','Phạm Ngọc Anh','anhpn@gmail.com','984635365','Vinh, Nghệ An'),
    ('C005','Trương Minh Cường','cuongtm@gmail.com','989735624','Hai Bà Trưng, Hà Nội');
insert into PRODUCTS(product_id,name,descriptipn,price) values
	('P001', 'Iphone 13 ProMax', 'Bản 512GB, xanh lá', 229999999),
    ('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 149999999),
    ('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 289999999),
    ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Smaill', 189999999),
    ('P005', 'Airpods2 2022', 'Spatial', 4090000);
insert into ORDERS(order_id,customer_id,order_date,total_amount) values
	('H001','C001','2023/2/22',52999997),
    ('H002','C001','2023/3/11',80999997),
    ('H003','C002','2023/1/22',54359998),
    ('H004','C003','2023/3/14',102999995),
    ('H005','C003','2022/3/12',80999997),
    ('H006','C004','2023/2/1',110449994),
    ('H007','C004','2023/3/29',79999996),
    ('H008','C005','2023/2/14',29999998),
    ('H009','C005','2023/1/10',28999999),
    ('H010','C005','2023/4/1',149999994);
insert into ORDERS_DETAILS(order_id,product_id,price,quantity) values
	('H001', 'P002', 14999999, 1),
    ('H001', 'P004', 18999999, 2),
    ('H002', 'P001', 22999999, 1),
    ('H002', 'P003', 28999999, 2),
    ('H003', 'P004', 18999999, 2),
    ('H003', 'P005', 4090000, 4),
    ('H004', 'P002', 14999999, 3),
    ('H004', 'P003', 28999999, 2),
    ('H005', 'P001', 22999999, 1),
    ('H005', 'P003', 28999999, 2),
	('H006', 'P005', 4090000, 5),
    ('H006', 'P002', 14999999, 6),
    ('H007', 'P004', 18999999, 3),
    ('H007', 'P001', 22999999, 1),
    ('H008', 'P002', 14999999, 2),
    ('H009', 'P003', 28999999, 1),
    ('H010', 'P003', 28999999, 2),
    ('H010', 'P001', 22999999, 4);
-- Bài 3: Truy vấn dữ liệu :
	-- 1.Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers 
		select name,email,phone ,address from CUSTOMERS;
	-- 2.Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).
		select CUSTOMERS.name 'Tên khách hàng',CUSTOMERS.phone'Số điện thoại',CUSTOMERS.address'Địa '
        from CUSTOMERS 
        join ORDERS on CUSTOMERS.customer_id=ORDERS.customer_id
        where year(ORDERS.order_date)=2023 and month(ORDERS.order_date)=3;
	-- 3.Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ). 
		select month(ORDERS.order_date) as Month, sum(ORDERS.total_amount)　Revenue 
        from ORDERS
        where year(ORDERS.order_date)=2023 
        group by Month;
	-- 4.Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại).
		select CUSTOMERS.name 'Tên khách hàng',CUSTOMERS.address 'Địa chỉ', CUSTOMERS.email, CUSTOMERS.phone'Số điện thoại'
        from CUSTOMERS
        left join ORDERS on CUSTOMERS.customer_id = ORDERS.customer_id
        where ORDERS.order_date is null or (year(ORDERS.order_date)=2023 and month(ORDERS.order_date)!=2);
	-- 5.Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra).
		select PRODUCTS.product_id 'Mã sản phẩm', PRODUCTS.name 'Tên sản phẩm', sum(ORDERS_DETAILS.quantity)'Số lượng bán ra'
        from PRODUCTS
        join ORDERS_DETAILS on PRODUCTS.product_id = ORDERS_DETAILS.product_id 
        join ORDERS on ORDERS_DETAILS.order_id = ORDERS.order_id
        where year(ORDERS.order_date)=2023 and month(ORDERS.order_date)=3
        group by PRODUCTS.product_id;
	-- 6.Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). 
		select CUSTOMERS.customer_id 'Mã khách hàng', CUSTOMERS.name 'Tên khách hàng', sum(total_amount)'Mức chi tiêu'
		from CUSTOMERS
		join ORDERS on CUSTOMERS.customer_id = ORDERS.customer_id
		where CUSTOMERS.customer_id  in (select ORDERS.customer_id from ORDERS where year(order_date)=2023)
		group by CUSTOMERS.customer_id ;
	-- 7.Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . 
		select CUSTOMERS.name'Tên người mua', ORDERS.total_amount 'Tổng tiền', ORDERS.order_date'Ngày tạo hoá đơn', sum(ORDERS_DETAILS.quantity)'Tổng số lượng sản phẩm'
        from CUSTOMERS
        join ORDERS on CUSTOMERS.customer_id = ORDERS.customer_id 
        join ORDERS_DETAILS on ORDERS.order_id = ORDERS_DETAILS.order_id
        group by ORDERS.order_id 
		having sum(ORDERS_DETAILS.quantity)>=5;
--  Bài 4: Tạo View, Procedure
	-- 1.Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn .
		create view INVOICE_VIEW as
        select CUSTOMERS.name'Tên khách hàng', CUSTOMERS.phone'Số điện thoại', CUSTOMERS.address'Địa chỉ', ORDERS.total_amount'Tổng tiền',ORDERS.order_date'Ngày tạo hoá đơn'
        from CUSTOMERS
        join ORDERS on CUSTOMERS.customer_id = ORDERS.customer_id ;
        SELECT * FROM INVOICE_VIEW;
	-- 2.Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt. 
		create view CUSTOMERS_VIEW as 
        select CUSTOMERS.name'Tên khách hàng', CUSTOMERS.address'Địa chỉ', CUSTOMERS.phone'Số điện thoại', count(ORDERS.order_id)'Tổng số đơn đã đặt'
        from CUSTOMERS  
		join ORDERS on ORDERS.customer_id = CUSTOMERS.customer_id
        group by CUSTOMERS.customer_id;
        SELECT * FROM CUSTOMERS_VIEW;
	-- 3.Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm. 
		create view PRODUCTS_VIEW as
        select PRODUCTS.name'Tên sản phẩm', PRODUCTS.descriptipn 'Mô tả', PRODUCTS.price 'Giá', sum(ORDERS_DETAILS.quantity) 'Tổng số lượng đã bán' 
        from PRODUCTS
		join ORDERS_DETAILS on ORDERS_DETAILS.product_id = PRODUCTS.product_id
        group by PRODUCTS.product_id;
        SELECT * FROM PRODUCTS_VIEW;
	-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer. 
		create index index_int on CUSTOMERS(phone,email);
        
        
        
