/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportPSMedications]    Script Date: 11/27/2013 16:33:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportPSMedications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportPSMedications]
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportPSMedications]    Script Date: 11/27/2013 16:33:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_RdlSubReportPSMedications]       
            
@DocumentVersionId  int 
AS                 
Begin          
/*                
** Object Name:  [csp_RdlSubReportPSMedications]                
**                
**                
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set                 
**    which matches those parameters.                 
**                
** Programmers Log:                
** Date  Programmer  Description                
**------------------------------------------------------------------------------------------                
** Get Data From     DiagnosesIAndII,DiagnosisDSMDescriptions      
** Oct 16 2007 Ranjeetb               
avoss corrected joins and added additonal columns
   
exec dbo.csp_RdlSubReportPSMedications 1200006
*/                


Select 
HRMAssessmentMedicationId,

DocumentVersionId,
Name,
Dosage,
Purpose,
PrescribingPhysician
From 
CustomHRMAssessmentMedications where DocumentVersionId=@DocumentVersionId
    

    
--Checking For Errors                  
  If (@@error!=0)                  
  Begin                  
   RAISERROR  20006   'csp_RdlSubReportPSMedications : An Error Occured'                   
   Return                  
   End                  
           
                
      
End

--select Top 1 * from DiagnosesIAndII order by createddate desc


GO


