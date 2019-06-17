IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomInquiry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomInquiry]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomInquiry] 
 (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
-- =============================================    
-- Author      : Venkatesh MR 
-- Date        : 27/March/2015  
-- Purpose     : Initializing SP Created.	
-- Modified By     Modified Date    Purpose
-- Venkatesh MR    23/04/2015       To initialize the tables CustomDispositions, CustomServiceDispositions, CustomProviderServices for task 23 - in VCAT
-- =============================================   
BEGIN
	BEGIN TRY
Declare @Legal VARCHAR(100)
DECLARE @MaritalStatus VARCHAR(100)
DECLARE @Language INT
DECLARE @EducationLevel VARCHAR(100)

SELECT @Legal=Legal,@EducationLevel=EducationLevel FROM CustomClients WHERE ClientId=@ClientID
SELECT @MaritalStatus=MaritalStatus,@Language=PrimaryLanguage FROM Clients WHERE ClientId=@ClientID

 DECLARE @CompletedGlobalCodeId INT  
  
SELECT @CompletedGlobalCodeId = GlobalCodeId  
FROM  
 GlobalCodes  
WHERE  
 Category = 'XINQUIRYSTATUS'  
 AND Code = 'COMPLETE'  


SELECT 'CustomInquiries' AS TableName
		,- 1 AS InquiryId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		@StaffID as RecordedBy,
		@StaffID as GatheredBy,
		@Legal as OtherDemographicsLegal,
		@MaritalStatus as OtherDemographicsMaritalStatus,
		@Language as PrimarySpokenLanguage,
		@EducationLevel as Education,
		@CompletedGlobalCodeId as InquiryStatus	
		FROM systemconfigurations s
	LEFT OUTER JOIN CustomInquiries  ON InquiryId = -1	
	
SELECT 'CustomDispositions' AS TableName
		,- 1 AS CustomDispositionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate		
		FROM systemconfigurations s
	LEFT OUTER JOIN CustomDispositions  ON InquiryId = -1	
	
SELECT 'CustomServiceDispositions' AS TableName
		,- 1 AS CustomServiceDispositionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate		
		FROM systemconfigurations s
	LEFT OUTER JOIN CustomServiceDispositions  ON CustomDispositionId = -1	
	
SELECT 'CustomProviderServices' AS TableName
		,- 1 AS CustomProviderServiceId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate		
		FROM systemconfigurations s
	LEFT OUTER JOIN CustomProviderServices  ON CustomServiceDispositionId = -1	

DECLARE @InquiryId INT
SET @InquiryId= (SELECT  Top 1 InquiryId  from CustomInquiries  WHERE ClientId =  @ClientId order by  InquiryId desc)
Select	  
		'CustomInquiriesCoverageInformations' AS TableName
		,CRCP.CreatedBy         
		,CRCP.CreatedDate         
		,CRCP.ModifiedBy         
		,CRCP.ModifiedDate        
		,CRCP.RecordDeleted      
		,CRCP.DeletedBy         
		,CRCP.DeletedDate
		,-1 as InquiryId         
		,CRCP.CoveragePlanId          
		,CRCP.InsuredId         
		,CRCP.GroupNumber AS GroupId
		,CRCP.Comment  						
     FROM ClientCoveragePlans CRCP
      left join CoveragePlans CP on CP.CoveragePlanId = CRCP.CoveragePlanId
			where ISNULL(CRCP.RecordDeleted, 'N') = 'N' and ISNULL(CP.RecordDeleted, 'N') = 'N' and ClientId = @ClientID

		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomInquiry') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END

