IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentRegistrationDeleteFromTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentRegistrationDeleteFromTables]
GO

CREATE PROCEDURE [dbo].[csp_CustomDocumentRegistrationDeleteFromTables]  
	@DocumentVersionId INT    
AS
/*********************************************************************/                                                                                        
 /* Stored Procedure: [csp_CustomDocumentRegistrationDeleteFromTables]               */                                                                               
 /* Data Modifications:												*/                                                                                        
 /*   Updates:														*/                                                                                        
 /*	  Date				Author			Purpose    */    
 /*  -------------------------------------------------------------- */    
 /*   17 october 2014		Aravind		Delete from validattion return table based on program id */  
 /*********************************************************************/       

-- Set ClientId  
DECLARE @ClientId INT
  

--SELECT @ClientId = d.ClientId  
--FROM Documents d  
--WHERE d.CurrentDocumentVersionId = @DocumentVersionId 
--Declare @Program Varchar(25) 
--set @Program = (
--SELECT DISTINCT Lower(P.ProgramName)  
--FROM Programs P  
--INNER JOIN ClientPrograms CP ON P.ProgramId=CP.ProgramId  
--INNER JOIN Clients C ON C.ClientId=CP.ClientId 
--WHERE C.ClientId= 44 and P.ProgramName like '%flex care%')


--SELECT  ProgramName from  Programs where ProgramName like '%flexcare%'
--set @Program = (select ProgramName from  Programs where ProgramName like '%flexcare%')
DECLARE @ProgramId INT;
SET @ProgramId = (Select PrimaryProgramId FROM CustomDocumentRegistrations WHERE DocumentVersionId = @DocumentVersionId )


DECLARE @ClientPrograms TABLE
(
	programId INT
);

INSERT INTO @ClientPrograms
SELECT DISTINCT P.ProgramId
FROM ClientPrograms CP  
INNER JOIN Programs P ON CP.ProgramId=P.ProgramId  
INNER JOIN Clients C ON C.ClientId=CP.ClientId  
WHERE C.ClientId= @ClientID  
	AND CP.Status IN(4) 
	AND ISNULL(CP.RecordDeleted,'N')='N'  
	AND ISNULL(P.RecordDeleted,'N')='N'  
	AND ISNULL(C.RecordDeleted,'N')='N'

DECLARE @Recodes TABLE
(
	IntegerCodeId INT
	,ProgramCode VARCHAR(100)
	--,Enrolled VARCHAR(5)
);
INSERT INTO @Recodes
SELECT 
	r.IntegerCodeId
	,rc.CategoryCode
	--,(CASE WHEN ISNULL(cp.programId,0) >0 THEN 'Yes' ELSE 'No' END ) AS Enrolled  
FROM Recodes r 
JOIN RecodeCategories rc  ON r.RecodeCategoryId = rc.RecodeCategoryId 
LEFT JOIN @ClientPrograms cp  ON cp.programId = r.IntegerCodeId  
WHERE rc.CategoryCode IN ('XVALLEYFLEXCARE')
DECLARE @ProgramIDFlexCare INT

SET @ProgramIDFlexCare=(

			
										SELECT IntegerCodeId 
										FROM Recodes 
										WHERE RecodeCategoryId IN(
																	SELECT RecodeCategoryId 
																	FROM RecodeCategories 
																	WHERE  CategoryCode IN('XVALLEYFLEXCARE')
																	)
				)														
		
																	
IF(@ProgramId=@ProgramIDFlexCare)


BEGIN
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('NumberInHousehold')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('DependentsInHousehold')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('HouseholdAnnualIncome')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('EducationStatus')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('EmploymentStatus')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('MilitaryStatus')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('SmokingStatus')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('AdvanceDirective')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('LivingArrangments')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('HispanicOrigin')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('Race')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('PreviousMentalHealthServices')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomDocumentRegistrations' and ColumnName in('ClientAnnualIncome')
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomRegistrationFormsAndAgreements' and ColumnName = 'Form' and errormessage like '%Please specify Advanced Healthcare Directive Brochure%'
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomRegistrationFormsAndAgreements' and ColumnName = 'Form' and errormessage like '%Please specify Client Rights and Responsibilities%'
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomRegistrationFormsAndAgreements' and ColumnName = 'Form' and errormessage like '%Please specify Medicaid Handbook%'
	DELETE FROM #validationReturnTable WHERE TableName = 'CustomRegistrationFormsAndAgreements' and ColumnName = 'Form' and errormessage like '%Please specify Privacy Notice%'

END  


	
  
	
	
	
	
	
	

		




-------------------------------------------------------------------------------------------------------------	

IF @@error <> 0 GOTO error
RETURN
ERROR:    
RAISERROR 50000 'csp_CustomDocumentMHADeleteFromTables failed.  Please contact your system administrator. We apologize for the inconvenience.'  
GO