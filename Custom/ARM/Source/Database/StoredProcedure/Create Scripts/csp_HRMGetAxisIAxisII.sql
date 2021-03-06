/****** Object:  StoredProcedure [dbo].[csp_HRMGetAxisIAxisII]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HRMGetAxisIAxisII]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_HRMGetAxisIAxisII]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HRMGetAxisIAxisII]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_HRMGetAxisIAxisII]              
 @ClientId int,             
 @AxisIAxisIIOut nvarchar(1100) OUTPUT                      
AS                      
BEGIN                      
/*********************************************************************/                        
/* Stored Procedure: dbo.[csp_PAGetAxisIAxisII]                */                        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                        
/* Creation Date:    04/26/2010                                         */                        
/*                                                                   */                        
/* Purpose: It will return the current diagnosis for CustomHRMAssessments   */                        
/*                                                                   */                      
/* Input Parameters: @ClientId             */                      
/*                                                                   */                        
/* Output Parameters:   @AxisIAxisIIOut                   */                        
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
/*     Sandeep Singh    Created                                    */                        
/*********************************************************************/                       
                      
                      
declare  @varDocumentVersionId int                             
declare @varAxisI as nvarchar(500)            
declare @varAxisII as nvarchar(500)            
set @varAxisI = ''''             
set @varAxisII = ''''                  
                        
select top 1 @varDocumentVersionId = D.CurrentDocumentVersionId                   
		from Documents D                    
		where D.ClientId = @ClientId                       
		and D.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))            
		and D.DocumentCodeId = 5             
		and D.Status = 22                
		and isNull(D.RecordDeleted,''N'')<>''Y''                    
		order by D.EffectiveDate desc, D.ModifiedDate desc                   
            
select @varAxisI = @varAxisI + CHAR(13) + CHAR(10) + ISNULL(a.DSMCode,'''') + '' '' + ''-'' + '' '' + ISNULL(DSM.DSMDescription,'''')            
		From DiagnosesIAndII a, DiagnosisDSMDescriptions DSM               
		Where a.DSMCode = DSM.DSMCode and a.DSMNumber = DSM.DSMNumber            
		and DiagnosisId in (select DiagnosisId from dbo.DiagnosesIAndII             
		where DocumentVersionId = @varDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y'')                                           
		and isNull(a.RecordDeleted,''N'')<>''Y''  and a.billable =''Y'' and a.Axis=1             
            
            
select @varAxisII = @varAxisII + CHAR(13) + CHAR(10) + ISNULL(a.DSMCode,'''') + '' '' + ''-'' + '' '' + ISNULL(DSM.DSMDescription,'''')            
		From DiagnosesIAndII a, DiagnosisDSMDescriptions DSM               
		Where a.DSMCode = DSM.DSMCode and a.DSMNumber = DSM.DSMNumber            
		and DiagnosisId in (select DiagnosisId from dbo.DiagnosesIAndII             
		where DocumentVersionId = @varDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y'')                                           
		and isNull(a.RecordDeleted,''N'')<>''Y''  and a.billable =''Y'' and a.Axis=2        
            
select @AxisIAxisIIOut = ''AxisI'' + @varAxisI + CHAR(13) + CHAR(10) + ''AxisII'' + @varAxisII            
         
--Check for documentid , is 0 then select Axis5 from notes otheriwse from DiagnosisV                    
--select AxisV from EventDiagnosesV where EventId = @varEventId  and isNull(RecordDeleted,''N'')<>''Y''                        
                      
    IF (@@error!=0)                      
    BEGIN              
RAISERROR  20002 ''[csp_HRMGetAxisIAxisII]: An Error Occured''                      
                           
        RETURN(1)                      
                          
    END                      
                      
       RETURN(0)                      
END
' 
END
GO
