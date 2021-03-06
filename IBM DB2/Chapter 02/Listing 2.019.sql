-- Ensure you've run SalesOrdersStructure.sql and SalesOrdersData.sql 
-- in the Sample Databases folder in order to run this example. 

SET SCHEMA SalesOrdersSample;

CREATE TRIGGER updateOrdersOrderTotalsTrig AFTER INSERT OR DELETE OR UPDATE 
ON Order_Details REFERENCING OLD AS deleted NEW AS inserted
FOR EACH ROW
BEGIN
  UPDATE Orders
  SET OrderTotal = (
    SELECT SUM(OD.QuantityOrdered * OD.QuotedPrice) 
	FROM Order_Details OD
    WHERE OD.OrderNumber = Orders.OrderNumber
  )
  WHERE Orders.OrderNumber IN (
  	deleted.OrderNumber,
	inserted.OrderNumber
  );	
END;

DROP TRIGGER updateOrdersOrderTotalsTrig;

