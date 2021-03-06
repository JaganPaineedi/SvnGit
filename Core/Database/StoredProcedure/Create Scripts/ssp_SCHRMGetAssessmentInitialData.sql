/****** Object:  StoredProcedure [dbo].[ssp_SCHRMGetAssessmentInitialData]    Script Date: 11/18/2011 16:25:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCHRMGetAssessmentInitialData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCHRMGetAssessmentInitialData]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCHRMGetAssessmentInitialData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = 
		N'CREATE PROCEDURE [dbo].[ssp_SCHRMGetAssessmentInitialData]    
   
(    
 @ClientId int   
)    
  
AS  
/******************************************************************************    
**  File:     
**  Name: ssp_SCHRMGetAssessmentInitialData    
**  Desc:  AssessmentWizardIintial.cs  
**    
   
**                  
**  Return values:    
**     
**  Called by: GetClientInfoInitial()       
**                  
**  Parameters:    
**  Input			Output 
**	--------      -----------   
**	ClientId
 
   
**  Auth:  Udai Pratap Verma  
**  Date:  01 May 08
  
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		08 May 08	udai				Modify parameter 
**    
**  21 Oct 2015    Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  /   
**										why:task #609, Network180 Customization  /
*******************************************************************************/



BEGIN  
 Begin Try  

  
 Select DOB,
 --Added by Revathi 21 Oct 2015
 CASE 
    WHEN ISNULL(ClientType, ''I'') = ''I'' THEN ISNULL(LastName,'''')+'' ''+ISNULL(FirstName,'''')+'' ''+ISNULL(MiddleName,'''') ELSE ISNULL(OrganizationName, '''') END as ClientFullName,
   datediff (year, convert (datetime, DOB), 
   getdate())AS ClientAge   
 from  Clients  
 where ClientId=@ClientId
  
  
 
End Try  
  
Begin Catch  
declare @Error varchar(8000)  
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCHRMGetAssessmentInitialData'')   
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())    
    + ''*****'' + Convert(varchar,ERROR_STATE())  
    
 RAISERROR   
 (  
  @Error, -- Message text.  
  16, -- Severity.  
  1 -- State.  
 );  
  
End Catch  
END
'
END
GO

