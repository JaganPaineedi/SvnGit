/****** Object:  StoredProcedure [dbo].[ssp_CMGetClaimlineInformationForPay]    Script Date: 06/26/2014 10:02:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClaimlineInformationForPay]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetClaimlineInformationForPay]
GO

CREATE  Procedure [dbo].[ssp_CMGetClaimlineInformationForPay]

(
	@ClaimlineIds varchar(max),
	@PageNumber				INT,
	@PageSize				INT
)
AS
/*************************************************************************/                
/* Stored Procedure: dbo.ssp_CMGetClaimlineInformationForPay             */                
/* Copyright: 2005 Provider Claim Management System						 */                
/* Creation Date:  6/26/2014											 */                
/*                                                                       */                
/* Purpose: retuns the details of claimlines fro PayClaims               */               
/*                                                                       */              
/* Input Parameters: @ClaimlineIds                                       */              
/*																		 */                
/* Output Parameters:													 */                
/*                                                                       */                
/* Return:                                                               */                
/*                                                                       */                
/* Called By:                                                            */                
/*                                                                       */                
/* Calls:                                                                */                
/*                                                                       */                
/* Data Modifications:                                                   */                
/*                                                                       */                
/* Updates:                                                              */                
/*  Date            Author				Purpose                  */  
-- 16.Feb.2015		Rohith Uppin		Method modified from fnSplit to fnSplitCM. Task#518 CM to SC issues tracking.
-- 22.Apr.2015		Rohith Uppin		fnSplitCM Reverted back to fnSplit as Input parameter in fnSplit is modified to Max size. #571 CM to SC issues.
-- 9.Mar.2017		Ponnin				Pagination done for the Claimline Pay popup. For task #409 of CEI - Support Go Live. 
-- 23 Mar 2017		Ponnin				SET @PageSize = 1 if the input parameter is -1. For task #409 of CEI - Support Go Live. 
-- 21 March 2017    PradeepT            what: Modified to show  billing code + modifier as Billing Code.Earlier it was showing BillingCode+Units.
--                                      Why: As per task Allegan Support-#687.46 and Allegan Support-#687.59(For 687.59 only did modification for 687.46 in  Latest version from svn where paging functionality has been implemented, earlier it was old.)
-- 20.Nov.2018       K.Soujanya         Added condtion to select only the claim lines which are not under review to exclude the Adjudication process if the claim line is under Review.Why: SWMBH - Enhancements#591
/*************************************************************************/        
    BEGIN TRY   
    
    IF @PageSize = -1 SET @PageSize = 1
    
	CREATE TABLE #ClaimLines
	(ClaimLineId int) 

	INSERT INTO #ClaimLines(ClaimLineId) select * from dbo.fnSplit(@ClaimLineIds,',')
	
	  
	Create table #ClaimDisplayForPayment 
	(ClaimLineId int, Plan1 varchar(100), 
	Plan1Amt money, Plan2 varchar(100), Plan2Amt money, 
	OtherAmt money)

	INSERT INTO #ClaimDisplayForPayment 
	Exec ssp_CMCreateClaimDisplayForPay	@ClaimlineIds


;WITH RankResultSet 
	AS
	( 
SELECT '' as BlankColumn,claimlines.ClaimLineId,claimlines.ClaimId,
       Clients.LastName+ ','+ Clients.FirstName as ClientName,
       Providers.ProviderName,
       claimlines.FromDate,
       claimlines.ProcedureCode + ' '
        + CASE WHEN claimlines.Modifier1 IS NOT NULL THEN claimlines.Modifier1+' ' ELSE '' END
        + CASE WHEN claimlines.Modifier2 IS NOT NULL THEN   claimlines.Modifier2+' ' ELSE '' END
        + CASE WHEN claimlines.Modifier3 IS NOT NULL  THEN   claimlines.Modifier3+' ' ELSE '' END
        + CASE WHEN claimlines.Modifier4 IS NOT NULL THEN   claimlines.Modifier4+' ' ELSE '' END AS ProcedureCode,
               
       claimlines.RevenueCode, claimlines.Units, claimlines.Status, GlobalCodes.CodeName, Claims.InsurerId,
       Insurers.InsurerName, Claimlines.ClaimedAmount, Claimlines.PayableAmount, Claimlines.BillingCodeId, Sites.ProviderId,
       Claims.ClientId, Sites.TaxId, Sites.PayableName, Sites.SiteId, Sites.TaxIdType, Plan1 ,Plan1Amt , Plan2 , Plan2Amt , OtherAmt		
FROM claimlines inner join claims on claimlines.claimid=claims.claimid
INNER JOIN Sites on Sites.SiteId=Claims.SiteId  
INNER JOIN GlobalCodes on GlobalCodes.GlobalCodeId=claimlines.Status   
INNER JOIN Clients on Claims.ClientId=Clients.ClientId   	
INNER JOIN Providers on Providers.ProviderId=Sites.ProviderId
INNER JOIN Insurers on Insurers.Insurerid=Claims.InsurerId
LEFT OUTER JOIN #ClaimDisplayForPayment on ClaimLines.ClaimLineId = #ClaimDisplayForPayment.ClaimLineId
WHERE 
--ClaimLines.Claimlineid = @ClaimlineId 
ISNULL(claimlines.ClaimLineUnderReview,'N') <>'Y' AND
EXISTS(SELECT ClaimLineId FROM #ClaimLines CLS WHERE CLS.ClaimLineId = ClaimLines.Claimlineid  )
AND IsNull(claimlines.RecordDeleted,'N') <>'Y'  AND IsNull(claims.RecordDeleted,'N') <>'Y' AND IsNull(Sites.RecordDeleted,'N') <>'Y'		
AND IsNull(GlobalCodes.RecordDeleted,'N') <>'Y' AND IsNull(Clients.RecordDeleted,'N') <>'Y' AND IsNull(Providers.RecordDeleted,'N') <>'Y'	
AND IsNull(Insurers.RecordDeleted,'N') <>'Y' 		
),
   counts as ( 
    select count(*) as totalrows from RankResultSet
    ),


		FinalResultSet
		as
		(				SELECT 
							 BlankColumn
							,ClaimLineId
							,ClaimId
							,ClientName
							,ProviderName
							,FromDate
							,ProcedureCode
							,RevenueCode
							,Units
							,STATUS
							,CodeName
							,InsurerId
							,InsurerName
							,ClaimedAmount
							,PayableAmount
							,BillingCodeId
							,ProviderId
							,ClientId
							,TaxId
							,PayableName
							,SiteId
							,TaxIdType
							,Plan1
							,Plan1Amt
							,Plan2
							,Plan2Amt
							,OtherAmt
							,COUNT(*) OVER ( ) AS TotalCount 
							,RANK() OVER (ORDER BY  ClaimLineId) AS RowNumber
					FROM    RankResultSet
					)
					
					
					 SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
							 BlankColumn
							,ClaimLineId
							,ClaimId
							,ClientName
							,ProviderName
							,FromDate
							,ProcedureCode
							,RevenueCode
							,Units
							,STATUS
							,CodeName
							,InsurerId
							,InsurerName
							,ClaimedAmount
							,PayableAmount
							,BillingCodeId
							,ProviderId
							,ClientId
							,TaxId
							,PayableName
							,SiteId
							,TaxIdType
							,Plan1
							,Plan1Amt
							,Plan2
							,Plan2Amt
							,OtherAmt
							,TotalCount 
							,RowNumber
					INTO    #FinalResultSet
					FROM    FinalResultSet
					WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )


					 SELECT
							 BlankColumn
							,ClaimLineId
							,ClaimId
							,ClientName
							,ProviderName
							,FromDate
							,ProcedureCode
							,RevenueCode
							,Units
							,STATUS
							,CodeName
							,InsurerId
							,InsurerName
							,ClaimedAmount
							,PayableAmount
							,BillingCodeId
							,ProviderId
							,ClientId
							,TaxId
							,PayableName
							,SiteId
							,TaxIdType
							,Plan1
							,Plan1Amt
							,Plan2
							,Plan2Amt
							,OtherAmt	
            FROM    #FinalResultSet
            ORDER BY RowNumber

					
		 IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1
             BEGIN
                    SELECT 0 AS PageNumber ,
                    0 AS NumberOfPages ,
                    0 NumberOfRows
                  END
             ELSE
		BEGIN                              
			 SELECT TOP 1
						@PageNumber AS PageNumber ,
						CASE (TotalCount % @PageSize) WHEN 0 THEN 
						ISNULL(( TotalCount / @PageSize ), 0)
						ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,
						ISNULL(TotalCount, 0) AS NumberOfRows
				FROM    #FinalResultSet  
		 END     
		 
		 


END TRY        
                
    
    BEGIN CATCH                                 
        DECLARE @Error VARCHAR(8000)                                  
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     '[ssp_CMGetClaimlineInformationForPay]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())                                  
                      
--set @result=0                                                    
                              
        RAISERROR                                   
 (                                  
  @Error, -- Message text.                                  
  16, -- Severity.                                  
  1 -- State.                                  
 ) ;                                  
                                  
    END CATCH      
    
              
GO


