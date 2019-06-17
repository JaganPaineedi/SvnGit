
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCMGetClaimLinesForActions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageCMGetClaimLinesForActions]
GO

CREATE Procedure [dbo].[ssp_ListPageCMGetClaimLinesForActions]    
(                   
                 
 @ClaimLineIds varchar(MAX)
  
)          
AS      
             
/*********************************************************************                                  
-- Stored Procedure: dbo.ssp_GetFilteredClaimLines      
-- Copyright: 2005 Provider Claim Management System      
-- Creation Date:  13/June/20014                            
--                                                       
-- Purpose: retuns list of claim lines based on parameter values      
--                               
-- Updates:                      
--  Date         Author			Purpose      
	12.Feb.2015	 Rohith Uppin	Split Function name modified. Task#502 CM to SC issue tracking.
-- 22.Apr.2015	 Rohith Uppin	fnSplitCM Reverted back to fnSplit as Input parameter in fnSplit is modified to Max size. #571 CM to SC issues.
-- 01.Jul.2016	 Basudev Shau	Modified For Task #684 Network180 Network 180 Environment Issues Tracking to Get Organisation  As ClientName    
--20.Nov.2018    K.Soujanya     Added condtion to select only the claim lines which are not under review to exclude the Adjudication process if the claim line is under Review.Why: SWMBH - Enhancements#591
*********************************************************************/                                
Begin   
  BEGIN TRY
  
 
	CREATE TABLE #ClaimLines
	(ClaimLineId int) 

	INSERT INTO #ClaimLines(ClaimLineId) select * from dbo.fnSplit(@ClaimLineIds,',')
	
	SELECT ClaimLineId as ClaimLineId, -- 01.Jul.2016	 Basudev Shau
		   CASE             
      WHEN ISNULL(CE.ClientType, 'I') = 'I'        
       THEN ISNULL(CE.LastName, '') + ', ' + ISNULL(CE.FirstName, '')        
      ELSE ISNULL(CE.OrganizationName, '')        
      END as Member, 
		CASE WHEN isnull(P.FirstName, '') <> '' THEN P.ProviderName + ', ' + P.FirstName ELSE P.ProviderName END AS Provider,
		Convert(varchar(10),CL.FromDate, 101 ) as DOS, 
		rtrim((case when CL.ProcedureCode is null Then CL.RevenueCode else CL.ProcedureCode End) + ' ' + IsNull(CL.Modifier1,' ') + ' ' + IsNull(CL.Modifier2,' ') + ' ' + IsNull(CL.Modifier3,' ') + ' ' + IsNull(CL.Modifier4,' ')) as HCPCSCodeModes,
		CL.RevenueCode as RevCode,
		cast(substring(convert(varchar,convert(decimal(18,0),cl.Units)),1,6) as int) as Units, 
		G.CodeName as Status,
		I.InsurerName as Insurer, 
		CL.ClaimedAmount as ClaimedAmt,
		CL.PayableAmount as Payable,
		P.ProviderId as ProviderId,
		I.InsurerId as InsurerId,
		cl.Status as ClaimlineStatus
	FROM ClaimLines CL 
	INNER JOIN Claims as C on CL.ClaimId=C.ClaimId  AND ISNULL(CL.ClaimLineUnderReview,'N') <>'Y' -- Added by K.Soujanya on 20/Nov/2018
	INNER JOIN Clients as CE on CE.ClientId=C.Clientid and ISNULL(CE.RecordDeleted,'N') <>'Y'
	INNER JOIN Sites as S on S.SiteId=C.SiteId and ISNULL(S.RecordDeleted,'N') <>'Y'  
	INNER JOIN Providers as P on P.ProviderId=S.ProviderId and ISNULL(P.RecordDeleted,'N') <>'Y' 
	INNER JOIN GlobalCodes as G on G.GlobalCodeId=CL.Status and ISNULL(G.RecordDeleted,'N') <>'Y'    
	INNER JOIN Insurers as I on I.InsurerId=C.InsurerId and ISNULL(I.RecordDeleted,'N') <>'Y'
	WHERE EXISTS(SELECT ClaimLineId FROM #ClaimLines CLS WHERE CLS.ClaimLineId = CL.ClaimLineId AND ISNULL(CL.RecordDeleted,'N') = 'N' )
	
  END TRY
  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_ListPageCMGetClaimLinesForActions')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.  
    16,  -- Severity.  
    1  -- State.  
    );
  END CATCH                 
End                  
      