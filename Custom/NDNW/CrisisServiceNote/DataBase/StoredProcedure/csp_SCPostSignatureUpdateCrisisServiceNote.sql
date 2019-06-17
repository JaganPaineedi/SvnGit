/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateCrisisServiceNote]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCPostSignatureUpdateCrisisServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCPostSignatureUpdateCrisisServiceNote]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateCrisisServiceNote]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
    
    
       
CREATE Procedure [dbo].[csp_SCPostSignatureUpdateCrisisServiceNote]    
(    
@ScreenKeyId int,                          
@StaffId int,                          
@CurrentUser varchar(30),                          
@CustomParameters xml    
 )    
AS        
/************************************************************************************/            
/* Stored Procedure: dbo.[csp_SCPostSignatureUpdateCrisisServiceNote]        */            
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */            
/* Creation Date:  18-jan-2013              */                 
/* Purpose:It is used to update table CustomDocumentRevokeReleaseOfInformations .   */           
/*                     */          
/* Input Parameters:                */          
/*                     */            
/* Output Parameters:   None              */            
/*                     */            
/* Return:  0=success, otherwise an error number         */            
/*                     */            
/* Called By:                  */            
/*                     */            
/* Calls:                   */            
/*                     */            
/* Data Modifications:                */            
/*                     */            
/* Updates:                   */            
/*  Date           Author             Purpose            */            
/* 18-Jan-2013    Vichee      Created to update Hositalization of ClientHospitalizations table          */      
         
/************************************************************************************/       
Begin    
Begin Try    
    
declare @currentDocumentVersionId  int     
DECLARE @EffectiveDate DATETIME     
DECLARE @Hospitalizations char    
Declare @ClientId int  
Declare @Hospital int  
    
    
    
 SELECT TOP 1 @currentDocumentVersionId = CurrentDocumentVersionId, @EffectiveDate = EffectiveDate,  
 @Hospitalizations = RiskActionTakenPsychiatricPlacement,@ClientId=Doc.ClientId,
 @Hospital= ActionTakenPsychiatricPlacementHospital 
   
 FROM CustomAcuteServicesPrescreens CASP  
 INNER JOIN Documents Doc ON CASP.DocumentVersionId = Doc.CurrentDocumentVersionId  
 WHERE --Doc.ClientId = @ClientID  
 -- AND 
  Doc.[Status] = 22  
  AND ISNULL(CASP.RecordDeleted, 'N') = 'N'  
  AND ISNULL(Doc.RecordDeleted, 'N') = 'N'  
 ORDER BY Doc.EffectiveDate DESC  
  ,Doc.ModifiedDate DESC   
 --Inserting Client Information (Admin) Hospitalization (YES)

IF  (ISNULL(@Hospitalizations,'N') = 'Y' and NOT EXISTS (SELECT * FROM ClientHospitalizations where ClientID=@ClientID and ISNULL(RecordDeleted,'N')='N'))      
Begin  

 insert into  ClientHospitalizations (Hospitalized,ClientId,Hospital) values ('Y',@ClientId,@Hospital)   
  
  End  
    
 End Try                                
  Begin Catch                                  
  declare @Error varchar(8000)                                                
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                 
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCPostSignatureUpdateCrisisServiceNote')                                                 
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                  
  + '*****' + Convert(varchar,ERROR_STATE())                                                                
  End Catch                                  
    
 End                
          
GO


