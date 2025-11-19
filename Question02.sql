CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	credit_limit NUMERIC(10,2)
);
CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(id),
	order_amount INT
);
INSERT INTO customers (name, credit_limit)
VALUES
('Nguyen Van A', 50000000.00),
('Tran Thi B', 75000000.50),   
('Le Van C', 30000000.00);    

INSERT INTO orders (customer_id, order_amount)
VALUES
(1, 1500000),  
(1, 2200000),
(1, 800000),
(1, 3500000),
(2, 5000000),  
(2, 1200000),
(2, 4500000),
(3, 10000000), 
(3, 7500000),
(3, 900000);

CREATE OR REPLACE FUNCTION check_credit_limit()
RETURNS TRIGGER 
LANGUAGE plpgsql AS
$$
	DECLARE 
		v_credit_limit NUMERIC(10,2); 
	BEGIN
		SELECT credit_limit INTO v_credit_limit 
		FROM customers WHERE id = NEW.customer_id; 
		IF(NEW.order_amount < v_credit_limit) THEN
			RAISE NOTICE 'Thanh toán thành công';
			RETURN NEW;
		ELSE 
			RAISE NOTICE 'Số tiền vượt quá hạn mức cho phép';
			RETURN NULL;
		END IF; 
	END;
$$;

CREATE OR REPLACE TRIGGER trg_check_credit
BEFORE INSERT ON orders 
FOR EACH ROW 
EXECUTE FUNCTION check_credit_limit();


