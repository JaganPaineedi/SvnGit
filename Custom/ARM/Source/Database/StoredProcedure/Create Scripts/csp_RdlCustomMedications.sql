/****** Object:  StoredProcedure [dbo].[csp_RdlCustomMedications]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomMedications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomMedications]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomMedications]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomMedications]      
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
AS             
Begin      
/*            
** Object Name:  [csp_RdlCustomMedications]            
**            
**            
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set             
**    which matches those parameters.             
**            
** Programmers Log:           
** Date  Programmer  Description            
**------------------------------------------------------------------------------------------            
** Get Data From CustomMedications 
** Oct 15 2007 Ranjeetb              
*/            
        

SELECT Drugs.DrugName as DrugName,
       [Dose]
      ,GCFrequency.CodeName as  Frequency
       ,GC.CodeName as [Route]
      ,[Comment]
      ,[Prescriber]
      ,[Strength]
      ,[ServiceId]
      
  FROM [CustomMedications] CM Inner Join GlobalCodes GC On CM.[Route]=GC.GlobalCodeId Inner Join Drugs On CM.DrugID=Drugs.DrugID Inner Join GlobalCodes GCFrequency On CM.Frequency=GCFrequency.GlobalCodeID
--  where ISNull(CM.RecordDeleted,''N'')=''N'' and DocumentId=@DocumentID and Version=@Version   
  where ISNull(CM.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010
  
    
        
  
    --Checking For Errors              
  If (@@error!=0)              
  Begin              
   RAISERROR  20006   ''csp_RdlCustomMedications : An Error Occured''               
   Return              
   End              
       
            
  
End
' 
END
GO
