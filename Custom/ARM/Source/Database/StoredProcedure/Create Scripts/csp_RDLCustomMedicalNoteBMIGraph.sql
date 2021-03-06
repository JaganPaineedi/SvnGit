/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicalNoteBMIGraph]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNoteBMIGraph]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMedicalNoteBMIGraph]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNoteBMIGraph]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLCustomMedicalNoteBMIGraph]                
                
(                
 --@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010    
)                
                
As                
                        
Begin                        
/*********************************************************************/                          
/* Stored Procedure: dbo.csp_RDLCustomMedicalNoteBMIGraph                */                 
                
/* Copyright: 2005 SHS             */                          
                
/* Creation Date:  13/10/2006                                    */                          
/*                                                                   */                          
/* Purpose: Gets Previous Vital Information          */                         
/*                                                                   */                        
/* Input Parameters: @clientid*/                        
/*                                                                   */                           
/* Output Parameters:                                */                          
/*                                                                   */                          
/* Return:   */                          
/*                                                                   */                          
/* Called By:     */                          
/*                                                                   */                          
/* Calls:                                                            */                          
/*                                                                   */                          
/* Data Modifications:                                               */                          
/*                                                                   */                          
/*   Updates:                                                          */                          
                
/*       Date              Author                  Purpose                                    */                          
/* 24-Oct-2007    Rishu Chopra          Created                                    */                          
/*********************************************************************/                           
                      
   Declare @clientid as int      
      
 --select @clientid=Clientid from documents where documentid=@documentid        
 select @clientid=Clientid from documents where CurrentDocumentVersionId=@DocumentVersionId     --Modified by Anuj Dated 03-May-2010    
--select   top 5 m.DocumentId,
select   top 5 m.DocumentVersionId,   --Modified by Anuj Dated 03-May-2010
convert(varchar,d.EffectiveDate,101) as Date,   
case when  height=0 or height is null then null  
else  isnull((m.weight/(m.height*m.height)) * 703,0) end as BMI   
from  CustomMedicalNote  m            
--inner join documents d on d.documentid=m.documentid where d.clientid=@clientid order by d.effectivedate desc       
inner join documents d on d.CurrentDocumentVersionId=m.DocumentVersionId where d.clientid=@clientid order by d.effectivedate desc    --Modified by Anuj Dated 03-May-2010    
         
  --Checking For Errors                
  If (@@error!=0)                
  Begin                
   RAISERROR  20006   ''csp_RDLCustomMedicalNoteBMIGraph: An Error Occured''                 
   Return                
   End                         
                        
                
End
' 
END
GO
