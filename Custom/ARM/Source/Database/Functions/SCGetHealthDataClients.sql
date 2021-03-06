/****** Object:  UserDefinedFunction [dbo].[SCGetHealthDataClients]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetHealthDataClients]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SCGetHealthDataClients]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetHealthDataClients]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date, ,>  
-- Description: <Description, ,>  
-- =============================================  
CREATE FUNCTION [dbo].[SCGetHealthDataClients]  
(  
 @HealthDataCategoryId INT,  
 @HealthDataItemNumber INT,  
 @HealthDataItemMinVal INT,  
 @HealthDataItemMaxVal INT  
)  
RETURNS @HealthDataClients TABLE (ClientId INT)  
AS  
BEGIN  
   
 DECLARE @HealthDataItemValue INT    
 --IF @HealthDataItemNumber = 1  
 --BEGIN  
 Insert into @HealthDataClients(clientId)  
  SELECT ClientID from HealthData where   
  HealthDataCategoryId = @HealthDataCategoryId   
  AND   
  CASE  
   WHEN @HealthDataItemNumber = 1 THEN ItemValue1  
   WHEN @HealthDataItemNumber = 2 THEN ItemValue2  
   WHEN @HealthDataItemNumber = 3 THEN ItemValue3  
   WHEN @HealthDataItemNumber = 4 THEN ItemValue4  
   WHEN @HealthDataItemNumber = 5 THEN ItemValue5  
   WHEN @HealthDataItemNumber = 6 THEN ItemValue6  
   WHEN @HealthDataItemNumber = 7 THEN ItemValue7  
   WHEN @HealthDataItemNumber = 8 THEN ItemValue8  
   WHEN @HealthDataItemNumber = 9 THEN ItemValue9  
   WHEN @HealthDataItemNumber = 10 THEN ItemValue10  
   WHEN @HealthDataItemNumber = 11 THEN ItemValue11  
   WHEN @HealthDataItemNumber = 12 THEN ItemValue12  
   --WHEN @HealthDataItemNumber = 13 THEN ItemValue13  
   --WHEN @HealthDataItemNumber = 14 THEN ItemValue14  
   --WHEN @HealthDataItemNumber = 15 THEN ItemValue15  
   --WHEN @HealthDataItemNumber = 16 THEN ItemValue16  
   --WHEN @HealthDataItemNumber = 17 THEN ItemValue17  
   --WHEN @HealthDataItemNumber = 18 THEN ItemValue18  
  END  
  BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 2  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue2 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 3  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue3 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 4  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue4 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 5  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue5 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 6  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue6 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 7  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue7 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 8  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue8 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 9  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue9 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 10  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue10 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 11  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue11 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 12  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue12 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 13  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue13 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 14  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue14 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 15  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue15 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 16  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue16 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 17  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue17 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 --IF @HealthDataItemNumber = 18  
 --BEGIN  
 -- Insert into @HealthDataClients(clientId)  
 -- SELECT ClientID from HealthData where   
 -- HealthDataCategoryId = @HealthDataCategoryId   
 -- AND ItemValue18 BETWEEN @HealthDataItemMinVal AND @HealthDataItemMaxVal  
 --END  
 RETURN  
END  ' 
END
GO
