/****** Object:  StoredProcedure [dbo].[csp_validateCustomDateTrackingWeb]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDateTrackingWeb]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDateTrackingWeb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDateTrackingWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomDateTrackingWeb]  

@DocumentVersionId Int  
as  
/************************************************************************/                                              
/* Stored Procedure: [csp_validateCustomDateTrackingWeb]      */                                     
/* Copyright: 2009 Streamline SmartCare         */                                              
/* Creation Date:  Nov 23 ,2009           */                                              
/*                                       */                                              
/* Purpose: or Validation on Custom Date Tracking document   */    
/*  Return values: Resultset having validation messages  */                                  
/*  Called by:                       
/* Input Parameters: DocumentVersionId        */                                            
/* Output Parameters:             */                                              
/* Purpose:           */                                    
/* Calls:                */                                              
/*                  */                                              
/* Author: Ankesh    Created according to Data Model 3.0           */   
/*********************************************************************/   */   
 
 
Return

/* 
  
Begin                                                
      
 Begin try   
--*TABLE CREATE*--    
CREATE TABLE [#CustomDateTracking] (  
DocumentVersionId int null,  
DocumentationHealthHistoryDate datetime null,  
DocumentationAnnualCustomerInformation datetime null,  
DocumentationNext3803DueOn datetime null,  
DocumentationPrivacyNoticeGivenOn datetime null,  
DocumentationPCPLetter datetime null,  
DocumentationPCPRelease datetime null,  
DocumentationBasis32 datetime null,  
CustomerSatisfactionSurvey char(1) null  
)  
--*INSERT LIST*--   
INSERT INTO [#CustomDateTracking](  
DocumentVersionId,  
DocumentationHealthHistoryDate,  
DocumentationAnnualCustomerInformation,  
DocumentationNext3803DueOn,  
DocumentationPrivacyNoticeGivenOn,  
DocumentationPCPLetter,  
DocumentationPCPRelease,  
DocumentationBasis32,  
CustomerSatisfactionSurvey  
)  
--*Select LIST*--    
select   
a.DocumentVersionId,  
a.DocumentationHealthHistoryDate,  
a.DocumentationAnnualCustomerInformation,  
a.DocumentationNext3803DueOn,  
a.DocumentationPrivacyNoticeGivenOn,  
a.DocumentationPCPLetter,  
a.DocumentationPCPRelease,  
a.DocumentationBasis32,  
a.CustomerSatisfactionSurvey  
from CustomDateTracking a   
where a.DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'')<>''Y''   
  
Insert into #validationReturnTable  
(TableName,  
ColumnName,  
ErrorMessage  
)  
--This validation returns three fields  
--Field1 = TableName  
--Field2 = ColumnName  
--Field3 = ErrorMessage  
  
  
Select ''CustomDateTracking'', ''DeletedBy'', ''Please clear all dates except Med Consent. Doc Dates are on Client Info screen.''  
From #CustomDateTracking c  
join DocumentVersions dv on dv.DocumentVersionId = c.DocumentVersionId  
join Documents d on d.DocumentId = dv.DocumentId  
where (isnull(DocumentationHealthHistoryDate, ''1/1/1900'') <> ''1/1/1900''  
or isnull(DocumentationAnnualCustomerInformation, ''1/1/1900'') <> ''1/1/1900''  
or isnull(DocumentationNext3803DueOn, ''1/1/1900'') <> ''1/1/1900''  
or isnull(DocumentationPrivacyNoticeGivenOn, ''1/1/1900'') <> ''1/1/1900''  
or isnull(DocumentationPCPLetter, ''1/1/1900'') <> ''1/1/1900''  
or isnull(DocumentationPCPRelease,''1/1/1900'') <> ''1/1/1900''  
or isnull(DocumentationBasis32,''1/1/1900'') <> ''1/1/1900'')  
and isnull(d.effectivedate, ''01/01/1900'') >= ''12/01/2007''  
end try                                                
                                                                                         
BEGIN CATCH    
  
DECLARE @Error varchar(8000)                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                               
+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateCustomDateTrackingWeb'')                                                                               
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                                              
                                                                                            
                                                                          
 RAISERROR                                                                               
 (                                                 
  @Error, -- Message text.                                                                              
  16, -- Severity.                                                                              
  1 -- State.                                                                              
 );                                                                              
                                                                              
END CATCH                                                                         
                                   
END     


*/
' 
END
GO
