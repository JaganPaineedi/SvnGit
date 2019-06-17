/****** Object:  StoredProcedure [dbo].[ssp_RDLReportRegistraions]    Script Date: 08/20/2018 16:23:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLReportRegistraions]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLReportRegistraions]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLReportRegistraions]    Script Date: 08/20/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_RDLReportRegistraions (@DocumentVersionId INT)
AS
/******************************************************************************                                  
**  File: ssp_RDLReportRegistraions.sql                
**  Name: ssp_RDLReportRegistraions           
**  Desc:  Get data for General tab Sub report                           
**  Return values: <Return Values>                                                                   
**  Called by: <Code file that calls>                                                                                 
**  Parameters:    @DocumentVersionId                              
**  Input   Output                                  
**  ----    -----------                                                                  
**  Created By: Ravi                
**  Date:  Aug 06 2018                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:			Author:    Description: 
	-----			-------		-----------
	Aug 06 2018		Ravi		Get data for General tab Sub report
								Engineering Improvement Initiatives- NBL(I) > Tasks #618> Registration Document                                     
*******************************************************************************/
BEGIN
	BEGIN TRY
	
	DECLARE @ClientID INT 
	SET @ClientID = (SELECT Top 1 ClientId 
                   FROM   Documents 
                   WHERE  InProgressDocumentVersionId = @DocumentVersionId)
                   
			--ClientCoveragePlans 
		DECLARE @InsuredId varchar(25)
		SET @InsuredId = ( Select top (1) a.InsuredId  
							from    ClientCoveragePlans as a    
							inner join CoveragePlans as b on b.CoveragePlanId = a.CoveragePlanId    
							inner join ClientCoverageHistory as c on a.ClientCoveragePlanId = c.ClientCoveragePlanId    
							where   a.ClientId = @ClientID    
									and b.MedicaidPlan = 'Y'    
									and ISNULL(a.RecordDeleted, 'N') <> 'Y'    
									and ISNULL(b.RecordDeleted, 'N') <> 'Y'    
									and ISNULL(c.RecordDeleted, 'N') <> 'Y'    
									and DATEDIFF(DAY, c.StartDate, GETDATE()) >= 0    
									and (    
										 (c.EndDate is null)    
									or (DATEDIFF(DAY, c.EndDate, GETDATE()) <= 0)    
										)    
							order by c.COBOrder     )
							
							
		SELECT C.ClientId
			,(
				SELECT TOP 1 OrganizationName
				FROM SystemConfigurations
				) AS OrganizationName
			,CONVERT(VARCHAR(10), D.EffectiveDate, 101) AS EffectiveDate
			,DC.DocumentName
			,CONVERT(VARCHAR(10), C.DOB, 101) AS DOB
			,ISNULL(C.ClientType,'') AS ClientType
			,CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END AS ClientName
			,CASE   
			   WHEN rtrim(ltrim(S.DisplayAs)) IS NULL  
			   THEN ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '')  
			  ELSE ISNULL(S.DisplayAs,'')
			  END AS PrimaryClinician
			,CASE   
			   WHEN rtrim(ltrim(SS.DisplayAs)) IS NULL  
			   THEN ISNULL(SS.LastName, '') + ', ' + ISNULL(SS.FirstName, '')  
			  ELSE ISNULL(SS.DisplayAs,'')
			  END AS PrimaryPhysician
			--Commented to fix 618 Registration Document Reported issue
			--,ISNULL(S.LastName, '') + ', ' + ISNULL(S.FirstName, '') AS PrimaryClinician
			--,ISNULL(SS.LastName, '') + ', ' + ISNULL(SS.FirstName, '') AS PrimaryPhysician
			,CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
				ELSE ISNULL(C.OrganizationName, '')
				END AS ClientTypeText
			,DR.SSN
			,DR.Prefix
			,DR.FirstName
			,DR.MiddleName
			,DR.LastName
			,DR.Suffix
			,DR.Email
			,DR.Active
			,DR.ProfessionalSuffix
			,DR.EIN
			,DR.CoverageInformation
			,DR.Comment
			,@InsuredId AS InsuredId
			,LTRIM((select ISNULL(STUFF((SELECT CHAR(13)+CHAR(10) + dbo.ssf_GetGlobalCodeNameById (CP.PhoneType)+': '+ISNULL(CP.PhoneNumber, '')
			  FROM DocumentRegistrationClientPhones CP  
			  where DR.DocumentVersionId=CP.DocumentVersionId   
			  AND ISNULL(CP.RecordDeleted, 'N') = 'N'          
			  FOR XML PATH('')
			  ,type ).value('.', 'nvarchar(max)'), 1, 2, ' '), '') )) AS PhoneNumber
			 
			 ,LTRIM((select ISNULL(STUFF((SELECT CHAR(13)+CHAR(10) + dbo.ssf_GetGlobalCodeNameById (CA.AddressType)+': '+ISNULL(CA.Display, '')
			  FROM DocumentRegistrationClientAddresses CA  
			  where DR.DocumentVersionId=CA.DocumentVersionId   
			  AND ISNULL(CA.RecordDeleted, 'N') = 'N'          
			  FOR XML PATH('')
			  ,type ).value('.', 'nvarchar(max)'), 1, 2, ' '), '') )) AS ClientAddress
			  
		FROM DocumentRegistrations DR
		JOIN DocumentVersions DV ON DV.DocumentVersionId = DR.DocumentVersionId
		JOIN Documents D ON D.DocumentId = DV.DocumentId
		JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
		JOIN Clients C ON C.ClientId = DR.ClientId
		LEFT JOIN Staff S ON S.StaffId = DR.PrimaryClinicianId
		LEFT JOIN Staff SS ON SS.StaffId = DR.PrimaryPhysicianId
		WHERE DR.DocumentVersionId = @DocumentVersionId
			AND ISNULL(DR.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(DC.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLReportRegistraions') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
