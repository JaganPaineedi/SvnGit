IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SaveChangeMedicationRequested]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_SaveChangeMedicationRequested;
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE PROCEDURE ssp_SaveChangeMedicationRequested

   @REQUESTEDDRUGDESCRIPTION VARCHAR(105) ,
    @REQUESTEDDRUGSTRENGTH VARCHAR(35) ,
    @REQUESTEDDRUGSTRENGTHUNIT VARCHAR(35) ,
    @REQUESTEDQUANTITYQUALIFIER VARCHAR(35) ,
    @REQUESTEDQUANTITYVALUE VARCHAR(35) ,
    @REQUESTEDDAYSSUPPLY VARCHAR(35) ,
    @REQUESTEDPOTENCYUNITCODE VARCHAR(35) ,
    @REQUESTEDDIRECTIONS VARCHAR(140) ,
    @REQUESTEDNOTE VARCHAR(210) ,
    @REQUESTEDSUBSTITUTIONS VARCHAR(35) ,
    @REQUESTEDREFILLQUALIFIER VARCHAR(35) ,
    @REQUESTEDREFILLQUANTITY VARCHAR(35) ,
    @REQUESTEDWRITTENDATE DATETIME ,
    @REQUESTEDDIAGNOSIS1 VARCHAR(100) ,
    @REQUESTEDDIAGNOSIS2 VARCHAR(100) ,
    @REQUESTEDPRIORAUTHQUALIFIER VARCHAR(2) ,
    @REQUESTEDPRIORAUTHVALUE VARCHAR(35) ,
    @REQUESTEDPRIORAUTHSTATUS VARCHAR(1) ,
      @REQUESTEDPRODUCTCODE VARCHAR(100),
	@REQUESTEDPRODUCTCODEQUALIFIER VARCHAR(100),
	@SureScriptChangeRequestedId INT
    
	AS 
	  BEGIN TRY

/*********************************************************************/        
---Copyright: 2011 Streamline Healthcare Solutions, LLC

---Creation Date: 09/22/2017

--Author : Pranay

---Purpose:To get the change request


---Return:Inserts change Medications

---Called by:Windows Service
---Log:
--	Date                     Author                             Purpose
/*********************************************************************/  

	      INSERT  INTO SureScriptsChangeMedicationRequests
                (RequestedDrugDescription ,
                  RequestedNumberOfDaysSupply ,
                  RequestedRefillType ,
                  RequestedNumberOfRefills ,
                  RequestedQuantityQualifier ,
                  RequestedQuantityValue ,
                  RequestedPotencyUnitCode ,
                  RequestedSubstitutions ,
                  RequestedDirections ,
                  RequestedNote ,
                  RequestedWrittenDate ,
                  RequestedDiagnosis1 ,
                  RequestedDiagnosis2 ,
                  RequestedPriorAuthQualifier ,
                  RequestedPriorAuthValue ,
                  RequestedPriorAuthStatus,
				  RequestedProductCode,
				  RequestedProductCodeQualifier
				  ,SureScriptChangeRequestedId

                )
        VALUES  ( 
                  @REQUESTEDDRUGDESCRIPTION ,
                  case when ISNULL(@REQUESTEDDAYSSUPPLY,'')='' then null else cast(@REQUESTEDDAYSSUPPLY AS INT) end ,
                  CASE WHEN LEN(LTRIM(RTRIM(@REQUESTEDREFILLQUALIFIER))) = 0
                       THEN 'R'
                       ELSE @REQUESTEDREFILLQUALIFIER
                  END ,
                  CASE WHEN LEN(LTRIM(RTRIM(@REQUESTEDREFILLQUANTITY))) = 0
                     THEN 0
                       ELSE CAST(@REQUESTEDREFILLQUANTITY AS INT)
                  END ,
                  @REQUESTEDQUANTITYQUALIFIER ,
                  CAST(@REQUESTEDQUANTITYVALUE AS DECIMAL(29, 14)) ,
                  @REQUESTEDPOTENCYUNITCODE , --ISNULL(@DISPENSEDPOTENCYUNITCODE_Desc,
                     --    @DISPENSEDPOTENCYUNITCODE) ,
                  @REQUESTEDSUBSTITUTIONS ,
                  @REQUESTEDDIRECTIONS ,
                  @REQUESTEDNOTE ,
                  @REQUESTEDWRITTENDATE ,
                  @REQUESTEDDIAGNOSIS1 ,
                  @REQUESTEDDIAGNOSIS2 ,
                  @REQUESTEDPRIORAUTHQUALIFIER ,
                  @REQUESTEDPRIORAUTHVALUE ,
                  @REQUESTEDPRIORAUTHSTATUS,
				  @REQUESTEDPRODUCTCODE,
				  @REQUESTEDPRODUCTCODEQUALIFIER
				  ,@SureScriptChangeRequestedId
                )

END TRY 
 BEGIN CATCH

        IF @@trancount > 0 
            ROLLBACK TRAN

        DECLARE @ErrorMessage NVARCHAR(4000)
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT  INTO ErrorLog
                ( ErrorMessage, ErrorType )
        VALUES  ( @ErrorMessage, 'SureScripts-ssp_SaveChangeMedicationRequested' )

        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH


GO