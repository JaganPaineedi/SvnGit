
/****** Object:  StoredProcedure [dbo].[ssp_PMGetCareManagementClaims]    Script Date: 05/03/2017 03:01:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetCareManagementClaims]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetCareManagementClaims]
GO


/****** Object:  StoredProcedure [dbo].[ssp_PMGetCareManagementClaims]    Script Date: 05/03/2017 03:01:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_PMGetCareManagementClaims] @ClientId INT    
 ,@Status INT    
 ,@FromDate DATETIME    
 ,@ToDate DATETIME    
 ,@InsurerId INT    
 ,@Type CHAR(1) = NULL    
 ,@ClinicianId INT = - 1    
 ,@ProgramId INT = - 1    
 ,@OtherFilter INT    
 ,@AddOnCodes char(1)='N'    --03.May.2017     Msood
AS    
/******************************************************************************      
** File: ssp_PMGetCareManagementClaims.sql      
** Name: ssp_PMGetCareManagementClaims      
** Desc:      
**      
**      
** This template can be customized:      
**      
** Return values: Filter Values - Client Services List Page      
**      
** Called by:      
**      
** Parameters:      
** Input Output      
** ---------- -----------      
**      
** Auth: Mary Suma      
** Date: 09/07/2011      
*******************************************************************************      
** Change History      
*******************************************************************************      
** Date:  Author:   Description:      
** 09/07/2011 Mary Suma  Client Services List Page      
** 09/28/2011 Mary Suma  Included Additional Paramenter      
** 2/28/2013 Vishant Garg    We are showing claim lines and services on services list page .so onclick of      
        list page we need to open the respective detail screens.      
        Added a column screenid to set in openpage on the basis of type.      
        with ref to task # 505 i 3.x issues      
** 10/22/2013 Vichee Humane Made Program column blank. As it is not required in Care management. Core-Bugs #1239      
** 04/17/2015   PRaorane  Pulled changes to calculate charges and payments from an earlier version that were not brought forward in 4.x      
** 08/01/2016   Gautam   what :Removed logic related to ContractRules,ProviderAuthorizations tables since the final result set     
        does not used the Auth.Also used ClaimLines PaidAmount for Payment.    
        why: Showing duplicates ,Ref .Riverwood-Support > Tasks#1119 > SC: Services: Double Encounters From Contract Billing Rules  
** 01/27/2016 What- We added new column Units for showing the units  
     Why - For task #849 Allegan - Support  
** 05/03/2017	 Msood	What: Added a new filter 'Add On Codes' and a new column to the List page
					Why: Allegan - Support Task # 961   
** 06/28/2017	 Msood	What: Increased the length of column Status from 50 to 250
					Why: Allegan - Support Task # 849 	
** 02.APRIL.2018 Akwinass	 What: Added "Attachments" column
					         Why: Added "Attachments" column #550 
** 07/18/2018    MD          Added the three missing columns for Group Name which is included in "ssp_PMClientClaimsAndServices" w.r.t 	SWMBH - Enhancements #684 				         				        
*******************************************************************************/    
BEGIN    
 BEGIN TRY    
  IF EXISTS (    
    SELECT *    
    FROM sysobjects    
    WHERE type = 'U'    
     AND NAME = '#TEMPCLIENTCLAIMS'    
    )    
  BEGIN    
   DROP TABLE #TEMPCLIENTCLAIMS    
  END    
    
  CREATE TABLE #TEMPCLIENTCLAIMS (    
   DOS DATETIME    
   ,Document VARCHAR(50)    
   ,[Procedure] VARCHAR(100)    
   ,Clinician VARCHAR(200)    
   ,Program VARCHAR(100)    
   ,STATUS VARCHAR(250)    
   ,Comment VARCHAR(100)    
   ,StaffId INT    
   ,DisplayAs VARCHAR(100)    
   ,ClientId INT    
   ,DocumentId INT    
   ,serviceId INT    
   ,ProgramId INT    
   ,DOSMAIN DATETIME    
   ,CodeName VARCHAR(100)    
   ,ProcedureCodeMain VARCHAR(100)    
   ,GlobalCodeId INT    
   ,StatusCode INT    
   ,Type CHAR    
   ,DocumentCodeId INT    
   ,DocumentType INT    
   ,LocationId INT    
   ,Location VARCHAR(100)    
   ,Charge MONEY    
   ,Payment MONEY    
   ,[ClientBal] MONEY    
   ,[3rdPartyBal] MONEY    
   ,ClinicianId INT    
   ,StatusId INT    
   ,ClaimLineId INT    
   ,DisDateOfService VARCHAR(50)    
   ,    
   --Added By Vishant Garg      
   ScreenId INT  
   
   ,Units DECIMAL(18,2)  
   ,AddOnCodes VARCHAR(Max)   --03.May.2017     Msood   
   )    
    
  INSERT INTO #TEMPCLIENTCLAIMS (    
   DOS    
   ,Document    
   ,[Procedure]    
   ,Clinician    
   ,Program    
   ,STATUS    
   ,Comment    
   ,StaffId    
   ,DisplayAs    
   ,ClientId    
   ,DocumentId    
   ,ServiceId    
   ,ProgramId    
   ,DOSMAIN    
   ,CodeName    
   ,ProcedureCodeMain    
   ,GlobalCodeId    
   ,StatusCode    
   ,Type    
   ,DocumentCodeId    
   ,DocumentType    
   ,Location    
   ,Charge    
   ,Payment    
   ,ClientBal    
   ,[3rdPartyBal]    
   ,ClinicianId    
   ,StatusId    
   ,ClaimLineId    
   ,DisDateOfService    
   ,    
   --Added By Vishant Garg      
   ScreenId    
   ,Units  
   ,AddOnCodes  --03.May.2017     Msood    
   )    
  SELECT Cl.FromDate AS DOS    
   ,'' AS Document    
   ,CASE     
    WHEN bc.BillingCode IS NULL    
     THEN cl.ProcedureCode    
    ELSE bc.BillingCode    
    END + ' ' + ISNULL(CONVERT(VARCHAR, cl.Units), '') + ' Units ' AS [Procedure]    
   ,P.ProviderName AS Clinician    
   ,'' AS Program    
   ,-- Added by Vichee      
   g.CodeName AS STATUS    
   ,'' AS Comment    
   ,P.ProviderId AS StaffId    
   ,'' AS DisplayAs    
   ,'' AS ClientId    
   ,'' AS DocumentId    
   ,Cl.ClaimLineId AS ServiceId    
   ,'' AS ProgramId    
   ,'' AS DOSMAIN    
   ,'' AS CodeName    
   ,'' AS ProcedureCodeMain    
   ,cl.STATUS AS GlobalCodeId    
   ,'' AS StatusCode    
   ,'C' AS Type    
   ,'' AS DocumentCodeId    
   ,'' AS DocumentType    
   ,NULL AS Location    
   ,cl.ClaimedAmount AS Charge    
   ,cl.PaidAmount AS Payment    
   ,NULL AS ClientBal    
   ,NULL AS [3rdPartyBal]    
   ,NULL AS ClinicianId    
   ,NULL AS StatusId    
   ,Cl.ClaimLineId AS ClaimLineId    
   ,NULL AS DisDateOfService    
   ,116    
   ,cl.Units As Units 
   ,NULL AS AddOnCodes  --03.May.2017     Msood    
  FROM ClaimLines AS cl    
  INNER JOIN GlobalCodes AS g ON g.GlobalCodeId = cl.STATUS    
  INNER JOIN Claims AS c ON cl.ClaimId = c.ClaimId    
  INNER JOIN Clients AS ce ON ce.ClientId = c.Clientid    
  INNER JOIN Insurers AS i ON i.InsurerId = c.InsurerId    
  INNER JOIN Sites AS s ON s.SiteId = c.SiteId    
  INNER JOIN Providers AS p ON p.ProviderId = s.ProviderId    
  LEFT OUTER JOIN BillingCodes bc ON (cl.BillingCodeId = bc.BillingCodeId)    
  WHERE Ce.ClientId = @ClientId    
   AND ISNULL(cl.RecordDeleted, 'N') <> 'Y'    
   AND c.InsurerId = @InsurerId    
   AND ISNULL(c.RecordDeleted, 'N') <> 'Y'    
   AND ISNULL(ce.RecordDeleted, 'N') <> 'Y'    
   AND ISNULL(i.RecordDeleted, 'N') <> 'Y'    
   AND ISNULL(s.RecordDeleted, 'N') <> 'Y'    
   AND ISNULL(p.RecordDeleted, 'N') <> 'Y'    
   AND ISNULL(g.RecordDeleted, 'N') <> 'Y'    
   AND (    
    @Status = - 1    
    OR -- All Statuses      
    (    
     @Status = 752    
     AND cl.STATUS = 2021    
     )    
    OR -- Entry Incomplete      
    (    
     @Status = 753    
     AND cl.STATUS = 2022    
     )    
    OR -- Entry Complete Claims      
    (    
     @Status = 754    
     AND cl.STATUS = 2023    
     )    
    OR -- Approved      
    (    
     @Status = 755    
     AND cl.STATUS = 2025    
     )    
    OR -- Partially Approved Claims      
    (    
     @Status = 756    
     AND cl.STATUS = 2026    
     )    
    OR -- Paid Claims      
    (    
     @Status = 757    
     AND cl.STATUS = 2024    
     )    
    OR -- Denied Claims      
    (    
     @Status = 758    
     AND cl.STATUS = 2027    
     ) -- Pended Claims      
    )    
   AND (    
    cl.FromDate >= @FromDate    
    OR @FromDate IS NULL    
    )    
   AND (    
    cl.FromDate <= @ToDate    
    OR @ToDate IS NULL    
    )    
  ORDER BY Cl.FromDate    
   ,cl.claimlineid DESC    
    
  SELECT Type AS Type    
   ,DOS AS DateOfService    
   ,[Procedure] AS ProcedureCode    
   ,StatusId    
   ,[Status] AS STATUS    
   ,Clinician AS Clinician    
   ,serviceId AS ServiceId    
   ,ClinicianId    
   ,ProgramId AS ProgramId    
   ,Program AS Program    
   ,LocationId AS LocationId    
   ,Location AS Location    
   ,Charge AS Charge    
   ,Payment AS Payment    
   ,[ClientBal] AS ClientBal    
   ,[3rdPartyBal] AS [3rdPartyBal]    
   ,ClaimLineId    
   ,DisDateOfService    
   ,    
   --Added By Vishant Garg      
   ScreenId    
   ,Units 
   ,AddOnCodes  --03.May.2017     Msood   
   ,NULL AS Attachments --02.APRIL.2018 Akwinass
   ---Added by MD on 07/18/2018
   ,NULL AS GroupName
   ,NULL AS GroupId
   ,NULL AS GroupServiceId
  FROM #TEMPCLIENTCLAIMS    
    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMGetCareManagementClaims') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.      
    16    
    ,-- Severity.      
    1 -- State.      
    );    
 END CATCH    
END    
GO


