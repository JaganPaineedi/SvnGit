/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicalNoteBPGraph]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNoteBPGraph]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMedicalNoteBPGraph]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNoteBPGraph]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLCustomMedicalNoteBPGraph]              
              
(              
 --@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010              
)              
              
As              
                      
Begin                      
/*********************************************************************/                        
/* Stored Procedure: dbo.csp_RDLCustomMedicalNoteBPGraph                */               
              
/* Copyright: 2005 SHS             */                        
              
/* Creation Date:  24/10/2007                                    */                        
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
select @clientid=Clientid from documents where CurrentDocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010
                 
--select  top 5  m.DocumentId,convert(varchar,d.EffectiveDate,101) as Date, m.BloodPressureDiastolic,m.BloodPressureSystolic from  CustomMedicalNote  m          
select  top 5  m.DocumentVersionId,convert(varchar,d.EffectiveDate,101) as Date, m.BloodPressureDiastolic,m.BloodPressureSystolic from  CustomMedicalNote  m  --Modified by Anuj Dated 03-May-2010

--inner join documents d on d.documentid=m.documentid where d.clientid=@clientid order by d.effectivedate   desc       
inner join documents d on d.CurrentDocumentVersionId=m.DocumentVersionId where d.clientid=@clientid order by d.effectivedate   desc   --Modified by Anuj Dated 03-May-2010     
            
              
  --Checking For Errors              
  If (@@error!=0)              
  Begin              
   RAISERROR  20006   ''csp_RDLCustomMedicalNoteBPGraph: An Error Occured''               
   Return              
   End                       
                      
              
End
' 
END
GO
