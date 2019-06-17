/****** Object:  StoredProcedure [dbo].[ssp_MedicationInformation]    Script Date: 06/08/2015 10:32:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MedicationInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_MedicationInformation]
GO


/****** Object:  StoredProcedure [dbo].[ssp_MedicationInformation]    Script Date: 06/08/2015 10:32:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[ssp_MedicationInformation]
    @DocumentVersionId int
  , @ReconciliationTypeId int
as /******************************************************************************              
**  File:               
**  Name: ssp_MedicationInformation               
**  Desc: Retrieves Reconciliation medication based on DocumentVersionId
**         
**              
**  Return values: List of Medications              
**               
**  Called by:                 
**                            
**  Parameters:              
**  Input       Output              
**     ----------       -----------              
**              
**  Auth: Kneale Alpers              
**  Date: Dec 12, 2011              
*******************************************************************************              
**  Change History              
*******************************************************************************              
**  Date:  Author:    Description:              
**  --------  --------    -------------------------------------------              
**
*******************************************************************************/  
    begin            
            
        declare @ClientCCDId int   = 0         
        select  @ClientCCDId = ClientCCDId             
        from    dbo.ClinicalInformationReconciliation as cir            
                join dbo.ClientCCDs as ccd on cir.DocumentVersionId = ccd.DocumentVersionId            
        where   cir.DocumentVersionId = @DocumentVersionId      
              
              
        if @ClientCCDId  = 0      
        begin      
   select  @ClientCCDId= ClientCCDId             
   from    dbo.ClientCCDs as ccd where   ccd.DocumentVersionId = @DocumentVersionId           
              
        end            
                  
        if @ReconciliationTypeId = 8793 -- Med             
            exec ssp_SCParseCCDCCR @ClientCCDId, 'Medications'            
        else             
            if @ReconciliationTypeId = 8794 -- Allergy            
                exec ssp_SCParseCCDCCR @ClientCCDId, 'Allergies'            
            else             
                if @ReconciliationTypeId = 8795 -- Problem            
                    exec ssp_SCParseCCDCCR @ClientCCDId, 'Diagnosis'            
            
    end


GO


