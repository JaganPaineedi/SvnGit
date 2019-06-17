/****** Object:  StoredProcedure [dbo].[ssp_PAGetInsuranceName]    Script Date: 08/14/2014 19:58:54 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PAGetInsuranceName]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_PAGetInsuranceName]
GO


/****** Object:  StoredProcedure [dbo].[ssp_PAGetInsuranceName]    Script Date: 08/14/2014 19:58:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_PAGetInsuranceName]

/****************************************************************************************************/
/* Stored Procedure: dbo.ssp_PAGetInsuranceName              */
/* Copyright: 2005 Provider Claim Management System             */
/* Creation Date:  13 May 2014                  */
/* SP taken form SC\3.5xMerge\Database\SQLSourceControl\Venture\Summit\Stored Procedures   */

/* Purpose: it will get all the user details corsponding to providerID        */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:          
Modified
14th Aug 2014  Vichee  Removed InsurerPlans and instead of that added  InsurerServiceAreas  for joins
					   as InsurerPlans table is no longer used. (CM to SC #70) 		
01/05/2016     MD Hussain Added Alias as PlanId for 'p.CoveragePlanId' as it is using in code w.r.t Newaygo – Support #413    
05/08/2017     Gautam   What: Change code to solve performance issue,SWMBH - Support #1179                                        */
/*********************************************************************/ 
(@providerid int = 1)
AS
BEGIN
  BEGIN TRY
  
  declare @Localproviderid int  
    
  Select  @Localproviderid=@providerid  
  
  Create Table #TempCoveragePlanId  
    (CoveragePlanId int)  
      
    insert into #TempCoveragePlanId(CoveragePlanId)  
    Select P.CoveragePlanId
    FROM CoveragePlans p 
    JOIN ClientCoveragePlans CCP ON p.CoveragePlanId=ccp.CoveragePlanId and ISNULL(CCP.RecordDeleted, 'N') <> 'Y'
    JOIN ClientCoverageHistory CCH ON CCP.ClientCoveragePlanId=CCH.ClientCoveragePlanId  and ISNULL(CCH.RecordDeleted, 'N') <> 'Y'
    JOIN InsurerServiceAreas i ON i.ServiceAreaId = CCH.ServiceAreaId
    JOIN dbo.ProviderInsurers p2 ON p2.InsurerId = i.InsurerId
    WHERE p2.ProviderId = @Localproviderid
    AND ISNULL(i.RecordDeleted, 'N') <> 'Y'
    AND ISNULL(p2.RecordDeleted, 'N') <> 'Y'
      
     
    --Fetch data for Name of insurance dropdown                      
    SELECT
      NULL AS PlanId,
      NULL AS NameofInsurance
    UNION
    SELECT
      p.CoveragePlanId AS PlanId,
      RTRIM(ISNULL(p.CoveragePlanName, '')) + ', ' + RTRIM(ISNULL(p.AddressDisplay, '')) + ', ' + ISNULL(p.city, '')
      + ', ' + ISNULL(p.state, '') + ', ' + ISNULL(p.ZipCode, '') AS NameofInsurance
    FROM #TempCoveragePlanId T join CoveragePlans p on T.CoveragePlanId= p.CoveragePlanId
    WHERE ISNULL(p.RecordDeleted, 'N') <> 'Y'
  END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_PAGetInsuranceName')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR
    (
    @Error, -- Message text.        
    16, -- Severity.        
    1 -- State.        
    )
  END CATCH
END

GO