/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportCustomMedicationAdministration]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomMedicationAdministration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportCustomMedicationAdministration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomMedicationAdministration]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlSubReportCustomMedicationAdministration]        
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
 AS               
Begin        
/*              
** Object Name:  [csp_RdlSubReportCustomMedicationAdministration]              
**              
**              
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set               
**    which matches those parameters.               
**              
** Programmers Log:              
** Date  Programmer  Description              
**------------------------------------------------------------------------------------------              
** Get Data From CustomMedications   
** Oct 26 2007 Rishu                
*/              
          
  
SELECT Drugs.DrugName  as  Medicationname,CM.Medicationid,CM.Dose,CM.Strength,CM.Comment        
  FROM [CustomMedications] CM 
left join   Drugs On CM.DrugID=Drugs.DrugID
 -- where ISNull(CM.RecordDeleted,''N'')=''N'' and DocumentId=@DocumentId and Version=@Version   
where ISNull(CM.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId     --Modified by Anuj Dated 03-May-2010   

  
      
          
    
    --Checking For Errors                
  If (@@error!=0)                
  Begin                
   RAISERROR  20006   ''csp_RdlSubReportCustomMedicationAdministration : An Error Occured''                 
   Return                
   End                
         
              
    
End
' 
END
GO
