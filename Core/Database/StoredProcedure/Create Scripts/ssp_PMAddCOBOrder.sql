/****** Object:  StoredProcedure [dbo].[ssp_PMAddCOBOrder]    Script Date: 08/04/2016 10:07:55 ******/
Drop PROCEDURE ssp_PMAddCOBOrder

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[ssp_PMAddCOBOrder]
    @ClientId INT ,
    @ClientCoveragePlanId INT ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @COBOrder INT ,
    @UserCode VARCHAR(30) ,
    @ServiceAreaId INT
AS /******************************************************************************   
**  File: dbo.ssp_PMAddCOBOrder.prc    
**  Name: Add COB   
**  Desc:    
**   
**  This template can be customized:   
**                 
**  Return values:   
**    
**  Called by:      
**                 
**  Parameters:   
**  Input       Output   
**       --------      -----------   
**   
**  Auth:    
**  Date:    
*******************************************************************************   
**  Change History   
*******************************************************************************   
**  Date:    Author:      Description:   
**  --------  --------    -------------------------------------------   
**  07/07/2010  dharvey      Added RecordDeleted checking to avoid validation on  
								logically deleted records. 
	10/14/2011  Girish		Added service area logic 
	10/28/2011  MSuma		Moved the filer critetia to resolve when ServiceAreaId is NULL 
	11/8/2011	Kneale		Updated code to handle -1 ServiceAreaID for all Service Areas 
	11/14/2011  MSuma		Fixed all open issues on AddCOB for eachService(remove all Service) 
    19/02/2015	Akwinass    Included Code for CoveragePlanChangeLog
    03/06/2015  Shruthi.S   Added COBOrder auto updation based on COBPriority.Ref #2 - CEI - Customizations.
    24/06/2015  Shruthi.S   Added condition to automate and use the existing cob generation process as per discussion with Javed.Ref:#2 CEI - Customizations.
    08/04/2016	NJain		Updated to set @EndDate to NULL if @EndDate is entered as 12/31/9999
*******************************************************************************/ 
  
  
	
    DECLARE @ErrorMessage VARCHAR(MAX)
  
    IF @EndDate = '12/31/9999'
        BEGIN
            SELECT  @EndDate = NULL
        END
        

  
    IF ( @COBOrder = 0 )
        BEGIN
            EXEC ssp_SCAddCOBOrderAutomate @ClientId, @ClientCoveragePlanId, @StartDate, @EndDate, @COBOrder, @UserCode, @ServiceAreaId
        END
    ELSE
        BEGIN
            EXEC ssp_SCAddCOBOrderManual @ClientId, @ClientCoveragePlanId, @StartDate, @EndDate, @COBOrder, @UserCode, @ServiceAreaId

        END



GO
