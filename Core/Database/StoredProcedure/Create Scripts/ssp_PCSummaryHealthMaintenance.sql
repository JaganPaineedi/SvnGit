IF OBJECT_ID('dbo.ssp_PCSummaryHealthMaintenance') IS NOT NULL
    DROP PROCEDURE dbo.ssp_PCSummaryHealthMaintenance
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PCSummaryHealthMaintenance]  
 /*********************************************************************************/  
 -- Copyright: Streamline Healthcate Solutions            
 --            
 -- Purpose: Customization support for Reception list page depending on the custom filter selection.            
 --            
 -- Author:  Vaibhav khare            
 -- Date:    20 May 2011            
 --            
 -- *****History****            
 /* 2012-09-21   Vaibhav khare  Created          */  
 /* 2013-03-21    New two parameters added by Deej. As per the discussion with Wasif*/  
 /* 2014-06017 Chethan N  Modified to get HealthDataTemplateId from recodes with category 'XHEALTHHISTORYVITAL' */  
 /* 2014-06-19 Vaibhav Khare Change the formating */  
 /* 2014-06-19 Shankha Change the formating as per the comment on Primary Care - Summit Pointe# 169*/  
 /* 2015-04-16 Stecyzynski Vitals date to match effective date Summit Pointe - Enhancements # 515*/  
 /* 2015-04-22 Steczynski Show current date and last three vitals records */  
 /*********************************************************************************/  
 @ClientId INT  
 ,@staffid INT  
 
AS  
BEGIN  
 BEGIN TRY  
   
  DECLARE @HTML VARCHAR(MAX),  
    @HealthRecordDate DATETIME,   
    @VitalHealthDataTemplateId INT;  
  
  SELECT @VitalHealthDataTemplateId = IntegerCodeId  
  FROM dbo.ssf_RecodeValuesCurrent('XHEALTHHISTORYVITAL');  
  
  DECLARE @HealthRecordDates TABLE(HealthRecordDate DATETIME, RowNum INT);  
  
  -- Get last 4 dates vitals were recorded  
  INSERT INTO @HealthRecordDates  
  SELECT A.HealthRecordDate, ROW_NUMBER() OVER (ORDER BY A.HealthRecordDate DESC) AS RowNum  
  FROM ( SELECT DISTINCT TOP 2  HealthRecordDate  
      FROM ClientHealthDataAttributes A   
      WHERE ClientId = @ClientId  
      AND ISNULL(RecordDeleted, 'N') = 'N'  
      --AND HealthRecordDate <= DATEADD(HOUR,24,@EffectiveDate)  
      AND A.HealthDataAttributeId IN (  
     SELECT b.HealthDataAttributeId  
     FROM dbo.HealthDataAttributes b  
     INNER JOIN dbo.HealthDataSubTemplateAttributes c ON b.HealthDataAttributeId = c.HealthDataAttributeId  
     INNER JOIN dbo.HealthDataSubTemplates d ON c.HealthDataSubTemplateId = d.HealthDataSubTemplateId  
     INNER JOIN dbo.HealthDataTemplateAttributes e ON d.HealthDataSubTemplateId = e.HealthDataSubTemplateId  
     WHERE e.HealthDataTemplateId = @VitalHealthDataTemplateId  
      )  
      ORDER BY HealthRecordDate DESC) A;  
  
  
  IF (SELECT COUNT(HealthRecordDate) FROM @HealthRecordDates) > 0  
  BEGIN  
  
   SET @HealthRecordDate = (SELECT TOP 1 HealthRecordDate FROM @HealthRecordDates);  
  
   -- Delete one record from @HealthRecordDates if the first date is not equal to the effective date  
   --IF (CAST(FLOOR(CAST(@HealthRecordDate as float)) as datetime) <> CAST(FLOOR(CAST(@EffectiveDate as float)) as datetime))  
   -- DELETE FROM @HealthRecordDates WHERE RowNum > 3;  
  
   DECLARE @VitalsResults TABLE (HealthRecordDate DATETIME, AttributeName VARCHAR(500) NULL ,AttributeValue VARCHAR(500) NULL, EntryDisplayOrder INT, OrderInFlowSheet INT );  
  
   -- Get Values for attributes    
   INSERT INTO @VitalsResults (HealthRecordDate ,AttributeName ,AttributeValue,a.EntryDisplayOrder,c.OrderInFlowSheet )  
   SELECT e.HealthRecordDate, d.NAME, CASE WHEN d.DataType = 8081 THEN f.CodeName ELSE e.Value END, a.EntryDisplayOrder,c.OrderInFlowSheet   
   FROM HealthDataTemplateAttributes a  
   INNER JOIN HealthDataSubTemplates b ON a.HealthDataSubTemplateId = b.HealthDataSubTemplateId  
   INNER JOIN HealthDataSubTemplateAttributes c ON b.HealthDataSubTemplateId = c.HealthDataSubTemplateId AND c.DisplayInFlowSheet = 'Y'  
   INNER JOIN HealthDataAttributes d ON c.HealthDataAttributeId = d.HealthDataAttributeId  
   INNER JOIN ClientHealthDataAttributes e ON d.HealthDataAttributeId = e.HealthDataAttributeId  
   LEFT JOIN GlobalCodes f ON ((CASE WHEN d.DataType = 8081 THEN e.Value ELSE - 1 END) = f.GlobalCodeId)  
   WHERE a.HealthDataTemplateId = @VitalHealthDataTemplateId  
   AND e.ClientId = @ClientId AND e.HealthRecordDate IN (select HealthRecordDate FROM @HealthRecordDates)  
   AND ISNULL(a.RecordDeleted, 'N') = 'N' AND ISNULL(b.RecordDeleted, 'N') = 'N' AND ISNULL(c.RecordDeleted, 'N') = 'N'  
   AND ISNULL(d.RecordDeleted, 'N') = 'N' AND ISNULL(e.RecordDeleted, 'N') = 'N';  
  
   DECLARE @AttributesDates TABLE(AttributeName VARCHAR(500), HealthRecordDate DATETIME, EntryDisplayOrder INT, OrderInFlowSheet INT)  
  
   INSERT INTO @AttributesDates   
   SELECT AN.AttributeName, HRD.HealthRecordDate, AN.EntryDisplayOrder, AN.OrderInFlowSheet    
   FROM (SELECT DISTINCT AttributeName, EntryDisplayOrder, OrderInFlowSheet FROM @VitalsResults ) AN  
   CROSS JOIN @HealthRecordDates HRD  
  
   DECLARE @CurrentAttributeName VARCHAR(500),   
     @CurrentHealthRecordDate DATETIME,  
     @CurrentAttributeValue VARCHAR(500),   
     @LastAttributeName VARCHAR(500);   
      
   SET @HTML = '<span style=''display:block;''><span style=''display: inline-block; width: 150px;''>Date</span>'   
  
   -- Build record dates row  
   DECLARE HealthRecordDates_Cursor CURSOR FOR   
   SELECT HealthRecordDate from @HealthRecordDates  
  
   OPEN HealthRecordDates_Cursor   
   FETCH NEXT FROM HealthRecordDates_Cursor INTO @CurrentHealthRecordDate  
  
   WHILE @@FETCH_STATUS = 0     
   BEGIN   
    SET @HTML = @HTML + '<span style=''display: inline-block; width: 170px;''>' + CONVERT(VARCHAR,@CurrentHealthRecordDate,101) + '</span>'  
  
    FETCH NEXT FROM HealthRecordDates_Cursor INTO @CurrentHealthRecordDate  
   END     
     
   SET @HTML = @HTML + '</span>';  
  
   CLOSE HealthRecordDates_Cursor     
  
   -- Build record times row  
  
   SET @HTML = @HTML + '<span style=''display:block;''><span style=''display: inline-block; width: 150px;''>&nbsp;</span>'   
  
   OPEN HealthRecordDates_Cursor   
   FETCH NEXT FROM HealthRecordDates_Cursor INTO @CurrentHealthRecordDate  
  
   WHILE @@FETCH_STATUS = 0     
   BEGIN   
    SET @HTML = @HTML + '<span style=''display: inline-block; width: 170px; text-decoration: underline;''>' + LTRIM(substring(rtrim(right(convert(varchar(26), @CurrentHealthRecordDate, 100),7)),0,6) + ' ' + right(convert(varchar(26),@CurrentHealthRecordDate,109),2)) + '</span>'  
  
    FETCH NEXT FROM HealthRecordDates_Cursor INTO @CurrentHealthRecordDate  
   END     
     
   SET @HTML = @HTML + '</span>';  
  
   CLOSE HealthRecordDates_Cursor     
   DEALLOCATE HealthRecordDates_Cursor    
  
   -- Bulid vitals data rows  
   DECLARE Vitals_Cursor CURSOR FOR   
   SELECT AD.AttributeName, CASE WHEN VR.AttributeValue IS NOT NULL THEN VR.AttributeValue ELSE '-' END AS AttributeValue   
   FROM @AttributesDates AD  
   LEFT JOIN @VitalsResults VR ON AD.AttributeName = VR.AttributeName AND AD.HealthRecordDate = VR.HealthRecordDate  
   ORDER BY AD.EntryDisplayOrder, AD.OrderInFlowSheet, AD.HealthRecordDate DESC;  
  
   OPEN Vitals_Cursor   
   FETCH NEXT FROM Vitals_Cursor INTO @CurrentAttributeName, @CurrentAttributeValue  
  
   WHILE @@FETCH_STATUS = 0     
   BEGIN   
    IF @LastAttributeName IS NULL  
     SET @HTML = @HTML + '<span style=''display:block;''><span style=''display: inline-block; width: 150px;''>' + @CurrentAttributeName + '</span>';  
    ELSE IF @LastAttributeName <> @CurrentAttributeName  
     SET @HTML = @HTML + '</span><span style=''display:block;''><span style=''display: inline-block; width: 150px;''>' + @CurrentAttributeName + '</span>';  
  
    SET @HTML = @HTML + '<span style=''display: inline-block; width: 170px;''>' + @CurrentAttributeValue + '</span>';  
  
    SET @LastAttributeName = @CurrentAttributeName;  
  
    FETCH NEXT FROM Vitals_Cursor INTO @CurrentAttributeName, @CurrentAttributeValue  
   END     
   CLOSE Vitals_Cursor     
   DEALLOCATE Vitals_Cursor   
  
   SET @HTML = @HTML + '</span>'   
  
  END  
  
  SELECT '<span style=''color:black''>' + ISNULL(@HTML, '<b>Vitals</b><br/> None') + '</span>' AS 'name'  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientHealthData.sql') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                          
    16  
    ,-- Severity.                          
    1 -- State.                          
    );  
 END CATCH  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  