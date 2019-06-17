IF EXISTS (SELECT * 
           FROM   sysobjects 
           WHERE  type = 'P' 
                  AND name = 'ssp_SCGetServiceProviderAuthorization') 
  BEGIN 
      DROP PROCEDURE ssp_SCGetServiceProviderAuthorization 
  END 

GO 

CREATE PROCEDURE ssp_SCGetServiceProviderAuthorization 
  -- ssp_SCGetServiceProviderAuthorization 21520,-1  
  @ProviderAuthorizationId INT 
  ,@BillingCodeId          INT 
--,@AuthorizationId int   
--,@ClientCoveragePlanId int   
AS 
  BEGIN 
  /****************************************************************************************************************************/ 
      -- Stored Procedure: dbo.[ssp_CMGetAuthorizationDetails]        
      --                                                                                                               
      -- Copyright: Streamline Healthcate Solutions                                                                                                               
      --                                                                                                               
      -- Purpose:  To fecth the data for the service tab page of CM Authorization                    
      --          
      -- Author: Malathi Shiva      
      --        
      -- Date: July 01 2014      
      --                                                                                                             
      -- Updates:               
      -- Date			Author			Purpose   
	  -- 27.Jan.2015	Rohith Uppin	BillingCodeModifiers Join removed since it was returning duplicate records(All modifier combination).
	  --									Task#379 CM to SC issues tracking.
	  --1-Dec-2017      SuryaBalan      Fixed CM Auth Details-No Data to Display under Services/Claims tab for task KCMHSAS - Support #900.61
	                                    --Because we were checking only Claims and not service related Authorizations
	  --4-Dec-2017      SuryaBalan      Changed Left join to Inner Join and removed Recorddeleted check for ProcedureCodes and Programs table for Task KCMHSAS - Support #900.61
	  --7-Dec-2017      SuryaBalan      Added Columns ProcedureCodeName, IsAssociate  and changed conversion of DateOfService which is needed for binding records in Grid for Task KCMHSAS - Support #900.61                 
	  --27Dec-2017		Suneel N		Added Columns Units and Charge which is needed for binding records in grid under Services/Claims tab. Task #KCMHSAS - Support #960.52
	  --8-Jan-2018      SuryaBalan      Changed CL.BillingCodeId to PA.BillingCodeId which is making issue in displaying records in Services/Claims Tab for #KCMHSAS - Support #900.61
	  --17-Oct-2018     K.Soujanya      Added columns EndDateOfService and AuthorizationNumber which is needed for binding records in grid under Service/Claims tab. Why:KCMHSAS - Enhancements: #19 
      --9/20/2018		MD			    Corrected the logic of last union statement based on @ProviderAuthorizationId  parameter w.r.t Valley - Support Go Live #1576
/*****************************************************************************************************************************/ 
      BEGIN TRY 
          IF( @BillingCodeId = -1 ) 
            BEGIN 
                SELECT CLA.ClaimLineAuthorizationId 
                       ,CLA.ClaimLineId                          AS ServiceId 
                       ,PA.ClientId 
                       ,CL.BillingCodeId 
                       , NULL as ProcedureCodeName  
                       ,CASE 
                          WHEN ( ISNULL(CL.Modifier1, '') = '' 
                                 AND ISNULL(CL.Modifier2, '') = '' 
                                 AND ISNULL(CL.Modifier3, '') = '' 
                                 AND ISNULL(CL.Modifier4, '') = '' ) THEN 
                          BC.BillingCode 
                          ELSE BC.BillingCode + ' : ' 
                               + ISNULL(CL.Modifier1+' ', '') 
                               + ISNULL(CL.Modifier2+' ', '') 
                               + ISNULL(CL.Modifier3+' ', '') 
                               + ISNULL(CL.Modifier4+' ', '') 
                        END                                      AS DisplayAs 
                       ,CONVERT(VARCHAR, CL.FromDate, 101)       AS 
                        DateOfService 
                       ,CONVERT(VARCHAR, CL.ToDate, 101)       AS --K.Soujanya -10/17/2018
                        EndDateOfService 
                       ,CL.RenderingProviderId 
                       ,PA.ProviderAuthorizationDocumentId 
                       ,DBO.csf_GetGlobalCodeNameById(CL.Status) AS 
                        ServiceStatus 
                       ,CL.Status 
                       ,NULL                                     AS ProgramName 
                       ,CASE 
                          WHEN Pr.ProviderType = 'F' THEN 
                          Rtrim(Pr.ProviderName) + ' - ' 
                          + Ltrim(s.SiteName) 
                          ELSE Rtrim(Pr.ProviderName) + ', ' + Pr.FirstName 
                               + ' - ' + Ltrim(s.SiteName) 
                        END                                      AS 
                        ClinicianName
                        , 'N' as IsAssociate  
                        , CL.Units AS UnitsText
                        , CL.Charge
                        , PA.AuthorizationNumber --K.Soujanya -10/17/2018
                FROM   ClaimLineAuthorizations CLA 
                       INNER JOIN ClaimLines CL 
                               ON CL.ClaimLineId = CLA.ClaimLineId 
                                  AND ISNULL(CL.RecordDeleted, 'N') = 'N' 
                       LEFT JOIN ProviderAuthorizations PA 
                              ON PA.ProviderAuthorizationId = 
                                 CLA.ProviderAuthorizationId 
                       LEFT JOIN Providers Pr 
                              ON CL.RenderingProviderId = Pr.ProviderId 
                       LEFT JOIN Sites S 
                              ON PA.SiteId = S.SiteId 
                                 AND ISNULL(PA.RecordDeleted, 'N') = 'N' 
                       --LEFT JOIN BillingCodeModifiers BCM 
                       --       ON BCM.BillingCodeId = CL.BillingCodeId 
                       --          AND ISNULL(BCM.RecordDeleted, 'N') = 'N' 
                       LEFT JOIN BillingCodes BC 
                              ON BC.BillingCodeId = CL.BillingCodeId 
                                 AND ISNULL(BC.RecordDeleted, 'N') = 'N' 
                WHERE  ISNULL(CLA.RecordDeleted, 'N') <> 'Y' 
                       AND CLA.ProviderAuthorizationId = 
                           @ProviderAuthorizationId 
            END 
          ELSE 
            BEGIN 
                SELECT CLA.ClaimLineAuthorizationId 
                       ,CLA.ClaimLineId                          AS ServiceId 
                       ,PA.ClientId 
                       ,CL.BillingCodeId 
                       ,NULL as ProcedureCodeName  
                       ,CASE 
                          WHEN ( ISNULL(CL.Modifier1, '') = '' 
                                 AND ISNULL(CL.Modifier2, '') = '' 
                                 AND ISNULL(CL.Modifier3, '') = '' 
                                 AND ISNULL(CL.Modifier4, '') = '' ) THEN 
                          BC.BillingCode 
                          ELSE BC.BillingCode + ' : ' 
                               + ISNULL(CL.Modifier1+' ', '') 
                               + ISNULL(CL.Modifier2+' ', '') 
                               + ISNULL(CL.Modifier3+' ', '') 
                               + ISNULL(CL.Modifier4+' ', '') 
                        END                                      AS DisplayAs 
                       ,CONVERT(VARCHAR, CL.FromDate, 101)       AS 
                        DateOfService 
                       ,CONVERT(VARCHAR, CL.ToDate, 101)       AS --K.Soujanya -10/17/2018
                        EndDateOfService 
                       ,CL.RenderingProviderId 
                       ,PA.ProviderAuthorizationDocumentId 
                       ,DBO.csf_GetGlobalCodeNameById(CL.Status) AS 
                        ServiceStatus 
                       ,CL.Status 
                       ,NULL                                     AS ProgramName 
                       ,CASE 
                          WHEN Pr.ProviderType = 'F' THEN 
                          Rtrim(Pr.ProviderName) + ' - ' 
                          + Ltrim(s.SiteName) 
                          ELSE Rtrim(Pr.ProviderName) + ', ' + Pr.FirstName 
                               + ' - ' + Ltrim(s.SiteName) 
                        END                                      AS 
                        ClinicianName 
                        , 'Y' as IsAssociate 
                        , CL.Units AS UnitsText
                        , CL.Charge
                        ,PA.AuthorizationNumber  --K.Soujanya -10/17/2018
                FROM   ClaimLineAuthorizations CLA 
                       INNER JOIN ClaimLines CL 
                               ON CL.ClaimLineId = CLA.ClaimLineId 
                                  AND ISNULL(CL.RecordDeleted, 'N') = 'N' 
                       LEFT JOIN ProviderAuthorizations PA 
                              ON PA.ProviderAuthorizationId = 
                                 CLA.ProviderAuthorizationId 
                       LEFT JOIN Providers Pr 
                              ON CL.RenderingProviderId = Pr.ProviderId  
                       LEFT JOIN Sites S 
                              ON PA.SiteId = S.SiteId 
                                 AND ISNULL(PA.RecordDeleted, 'N') = 'N' 
                       --LEFT JOIN BillingCodeModifiers BCM 
                       --       ON BCM.BillingCodeId = CL.BillingCodeId 
                       --          AND ISNULL(BCM.RecordDeleted, 'N') = 'N' 
                       LEFT JOIN BillingCodes BC 
                              ON BC.BillingCodeId = CL.BillingCodeId 
                                 AND ISNULL(BC.RecordDeleted, 'N') = 'N' 
                WHERE  ISNULL(CLA.RecordDeleted, 'N') <> 'Y' 
                       AND CLA.ProviderAuthorizationId = 
                           @ProviderAuthorizationId 
                       AND PA.BillingCodeId = @BillingCodeId --8-Jan-2018 SuryaBalan
             
      --UNION  
      --SELECT SA.ServiceAuthorizationId  
      --       ,SA.ServiceId  
      --       ,S.ClientId  
      --       ,S.ProcedureCodeId  
      --       ,PC.ProcedureCodeName                    AS DisplayAs  
      --       ,S.DateOfService  
      --       ,S.ClinicianId  
      --       ,S.ProgramId  
      --       ,A.AuthorizationDocumentId  
      --       ,DBO.csf_GetGlobalCodeNameById(S.Status) AS ServiceStatus  
      --       ,S.Status  
      --       ,P.ProgramName  
      --       ,isnull(Staff.LastName+', ', '')  
      --        + isnull(Staff.FirstName, '')           AS ClinicianName  
      --FROM   ServiceAuthorizations SA  
      --       INNER JOIN Services S  
      --               ON S.ServiceId = SA.ServiceId  
      --                  AND ISNULL(S.RecordDeleted, 'N') <> 'Y'  
      --       LEFT JOIN Staff  
      --              ON S.ClinicianId = Staff.StaffId  
      --       LEFT JOIN ProcedureCodes PC  
      --              ON PC.ProcedureCodeId = S.ProcedureCodeId  
      --                 AND ISNULL(PC.RecordDeleted, 'N') <> 'Y'  
      --       LEFT JOIN Programs P  
      --              ON P.ProgramId = S.ProgramId  
      --                 AND ISNULL(P.RecordDeleted, 'N') <> 'Y'  
      --       LEFT JOIN ClientCoveragePlans CCP  
      --              ON CCP.ClientCoveragePlanId = @ClientCoveragePlanId  
      --                 AND ISNULL(CCP.RecordDeleted, 'N') <> 'Y'  
      --       LEFT JOIN Authorizations A  
      --              ON A.AuthorizationId = SA.AuthorizationId  
      --                 AND ISNULL(A.RecordDeleted, 'N') <> 'Y'  
      --WHERE  ISNULL(SA.RecordDeleted, 'N') <> 'Y'  
      --       AND SA.ClientCoveragePlanId = @ClientCoveragePlanId  
      --       AND SA.AuthorizationId = @AuthorizationId 
      UNION --1-Dec-2017      SuryaBalan 
      SELECT A.ProviderAuthorizationId  as ClaimLineAuthorizationId 
             ,SA.ServiceId  
             ,S.ClientId  
             ,PA.BillingCodeId as BillingCodeId
             ,PC.ProcedureCodeName 
             --,S.ProcedurecodeId  as BillingCode
             ,PC.ProcedureCodeName                    AS DisplayAs  
             ,CONVERT(VARCHAR, S.DateOfService, 101)       AS 
                        DateOfService  
             ,CONVERT(VARCHAR, S.EndDateOfService, 101)       AS  --K.Soujanya -10/17/2018
                        EndDateOfService 
             ,NULL as RenderingProviderId
             --,S.ClinicianId  
             --,S.ProgramId  
             ,PA.ProviderAuthorizationDocumentId  
             ,DBO.csf_GetGlobalCodeNameById(S.Status) AS ServiceStatus  
             --,NULL as RenderingProviderId
             ,S.Status  
             ,P.ProgramName  
             ,isnull(St.LastName+', ', '')  
              + isnull(St.FirstName, '')           AS ClinicianName  
              , 'Y' as IsAssociate   
              , CL.Units AS UnitsText
              , CL.Charge
              ,A.AuthorizationNumber  --K.Soujanya -10/17/2018
      FROM   ServiceAuthorizations SA  
             INNER JOIN Services S  
                     ON S.ServiceId = SA.ServiceId  
                        AND ISNULL(S.RecordDeleted, 'N') <> 'Y'  
             INNER JOIN Staff St
                    ON S.ClinicianId = St.StaffId  
             INNER JOIN ProcedureCodes PC  
                    ON PC.ProcedureCodeId = S.ProcedureCodeId  
                       --AND ISNULL(PC.RecordDeleted, 'N') <> 'Y'  
             INNER JOIN Programs P  
                    ON P.ProgramId = S.ProgramId  
                       --AND ISNULL(P.RecordDeleted, 'N') <> 'Y'  
             INNER JOIN Authorizations A on A.AuthorizationId = SA.AuthorizationId
						AND ISNULL(A.RecordDeleted, 'N') <> 'Y'
             INNER JOIN ProviderAuthorizations PA  
                    ON PA.ProviderAuthorizationId = A.ProviderAuthorizationId 
                       AND PA.ClientId = S.ClientId 
                       AND ISNULL(PA.RecordDeleted, 'N') <> 'Y' 
             LEFT JOIN ClaimLineAuthorizations CA
					ON CA.ProviderAuthorizationId = PA.ProviderAuthorizationId
						AND ISNULL(CA.RecordDeleted, 'N') <> 'Y' 
			 LEFT JOIN ClaimLines CL
					ON CL.ClaimLineId = CA.ClaimLineId
					AND ISNULL(CL.RecordDeleted, 'N') <> 'Y'
      WHERE  ISNULL(SA.RecordDeleted, 'N') <> 'Y'  
             AND PA.BillingcodeId = @BillingCodeId  
             AND PA.ProviderAuthorizationId = @ProviderAuthorizationId
             END 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCGetServiceProviderAuthorization') 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

           

          RAISERROR ( @Error,
                      -- Message text.                                                   
                      16, 
                      -- Severity.                                                   
                      1 
          -- State.                                                   
          ); 
      END CATCH 
  END 