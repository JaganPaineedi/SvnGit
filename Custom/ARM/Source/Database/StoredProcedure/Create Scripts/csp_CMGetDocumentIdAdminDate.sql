/****** Object:  StoredProcedure [dbo].[csp_CMGetDocumentIdAdminDate]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CMGetDocumentIdAdminDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CMGetDocumentIdAdminDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CMGetDocumentIdAdminDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_CMGetDocumentIdAdminDate]          
 @ClientId int,         
 @varDocumentIdOut int OUTPUT,   
 @varAdmissionDateOut datetime OUTPUT,  
 @varNumberOfDaysInSettingOut int OUTPUT             
AS                  
BEGIN                  
/*********************************************************************/                    
/* Stored Procedure: dbo.[csp_CMGetDocumentIdAdminDate]                */                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                    
/* Creation Date:    04/20/2010                                         */                    
/*                                                                   */                    
/* Purpose: It will return the current DocumentId,AdmissionDate,NumberOfDaysInSetting for DischargeEvent   */                    
/*                                                                   */                  
/* Input Parameters: @ClientId             */                  
/*                                                                   */                    
/* Output Parameters:   @varDocumentIdOut,@varAdmissionDateOut,@varNumberOfDaysInSettingOut                   */                    
/*                                                                   */                    
/* Return:  0=success, otherwise an error number                     */                    
/*                                                                   */                    
/* Called By:                                                        */                    
/*                                                                   */                    
/* Calls:                                                            */                    
/*                                                                   */                    
/* Data Modifications:                                               */                    
/*                                                                   */                    
/* Updates:                                                          */                    
/*   Date     Author       Purpose                                    */                    
/*     Jitender    Created                                    */                    
/*********************************************************************/                   
                  
  
select top 1 @varDocumentIdOut = D.DocumentId                 
from Documents D,CustomPreScreens C                  
where D.ClientId = @ClientID    
and D.CurrentDocumentVersionId = C.DocumentVersionId                     
and D.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))          
and D.DocumentCodeId = 1048           
--and D.Status = 22              
and isNull(D.RecordDeleted,''N'')<>''Y''                  
order by D.EffectiveDate desc, D.ModifiedDate desc   
              
select top 1 @varAdmissionDateOut = C.AdmissionDateTime,@varNumberOfDaysInSettingOut=C.NumberOfDaysInSetting               
from Documents D,CustomConcurrentReviews C                  
where D.ClientId = @ClientID    
and D.CurrentDocumentVersionId = C.DocumentVersionId                     
and D.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))          
and D.DocumentCodeId = 1053                     
and isNull(D.RecordDeleted,''N'')<>''Y''                  
order by D.EffectiveDate desc, D.ModifiedDate desc        
        
   
     
        
select @varDocumentIdOut,@varAdmissionDateOut,@varNumberOfDaysInSettingOut        
                        
                  
    IF (@@error!=0)                  
    BEGIN          
RAISERROR  20002 ''[csp_CMGetDocumentIdAdminDate]: An Error Occured''                  
                       
        RETURN(1)                  
                      
    END                  
                  
       RETURN(0)                  
END
' 
END
GO
