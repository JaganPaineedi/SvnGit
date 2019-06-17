-- =============================================  
-- Author:    Anto Jenkins 
-- Create date: Oct 05, 2017 
-- Description: Setting the SystemConfiguration Key value as 'N' if the value is NULL or empty.  
-- Purpose : Core bugs #2426  
-- =============================================    

DECLARE @KeyValue Char(10)
IF EXISTS (SELECT * FROM Systemconfigurationkeys WHERE [Key] = 'PaymentAdjustmentPostingRequireLocation')
BEGIN
  SELECT @KeyValue = value FROM Systemconfigurationkeys WHERE [Key] = 'PaymentAdjustmentPostingRequireLocation'
  IF @KeyValue = '' OR @KeyValue IS NULL
  BEGIN
  UPDATE Systemconfigurationkeys SET value = 'N' WHERE [Key] = 'PaymentAdjustmentPostingRequireLocation' 
  END
END


