/****** Object:  StoredProcedure [dbo].[ssp_PMGetMiscSharedTables]    Script Date: 11/18/2011 16:25:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetMiscSharedTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetMiscSharedTables]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetMiscSharedTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PMGetMiscSharedTables]
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_PMGetMiscSharedTables             */
/* Creation Date:  29 June, 2007                                    */
/*                                                                   */
/* Purpose: retuns data for shared tables filling.             */
/*                                                                   */
/* Input Parameters:                                    */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications: Due to addition of new tables    */
/*  Modifications By Kamaljitsingh  */
/*    Modifications Date-3-7-2007                                  */
/* Author: Jaspreet Singh.                                         */
/* 19 Oct 2015  Revathi    what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.      
							why:task #609, Network180 Customization */
/*********************************************************************/
--Primary Clinician                                      
SELECT NULL AS StaffId
	,'''' AS StaffName
	,''Y'' AS Active
	,''Y'' AS Clinician

UNION

SELECT S.StaffId
	,CASE 
		WHEN S.degree IS NULL
			THEN (S.LastName + '', '' + S.FirstName)
		ELSE (S.LastName + '', '' + S.FirstName + '' '' + CONVERT(VARCHAR, GC.CodeName))
		END AS StaffName
	,S.Active
	,S.Clinician
FROM Staff S
LEFT JOIN globalcodes GC ON S.degree = GC.GlobalCodeId
WHERE
	-- Clinician = ''Y''                                      
	--AND                                       
	(
		S.RecordDeleted = ''N''
		OR S.RecordDeleted IS NULL
		)
ORDER BY StaffName

--Prefix                            
SELECT PrefixName
FROM (
	SELECT '''' AS PrefixName
	
	UNION
	
	SELECT ''Mr.'' AS PrefixName
	
	UNION
	
	SELECT ''Mrs.'' AS PrefixName
	) Prefix

--Suffix                                      
SELECT SuffixName
FROM (
	SELECT '''' AS SuffixName
	
	UNION
	
	SELECT ''Sr'' AS SuffixName
	
	UNION
	
	SELECT ''Jr'' AS SuffixName
	
	UNION
	
	SELECT ''II'' AS SuffixName
	) Suffix

--Hospital                                      
DECLARE @Hospital INT
	,@AddressTypeOffice INT

SELECT @Hospital = 2244
	,@AddressTypeOffice = 2282

SELECT 0 AS SiteId
	,'''' AS SiteName
	,''Y'' AS Active

UNION

SELECT b.SiteId
	,a.ProviderName + CASE 
		WHEN ISNULL(c.Address, '''') = ''''
			THEN ''''
		ELSE '' - '' + c.Address
		END AS SiteName
	,b.Active
FROM Providers a
INNER JOIN Sites b ON (
		a.ProviderId = b.ProviderId
		AND ISNULL(b.RecordDeleted, ''N'') = ''N''
		)
LEFT JOIN SiteAddressess c ON (
		b.SiteId = c.SiteId
		AND c.AddressType = @AddressTypeOffice
		AND ISNULL(c.RecordDeleted, ''N'') = ''N''
		)
WHERE b.SiteType = @Hospital
	AND isnull(a.RecordDeleted, ''N'') = ''N''
ORDER BY SiteName

--CountyofTreatment                                      
SELECT NULL AS CountyFIPS
	,'''' AS CountyName
	,0 AS StateFIPS

UNION

SELECT C.CountyFIPS
	,C.CountyName
	,C.StateFIPS
FROM Counties AS C
INNER JOIN SystemConfigurations SC ON C.StateFIPS = SC.StateFIPS
ORDER BY CountyName

-- Kamaljitsingh 4-7-2007                        
--Information                            
SELECT InfoCompleteId
	,InfoCompleteName
FROM (
	SELECT 1 AS InfoCompleteId
		,''Complete and Incomplete Information'' AS InfoCompleteName
	
	UNION
	
	SELECT 2 AS InfoCompleteId
		,''Complete Information'' AS InfoCompleteName
	
	UNION
	
	SELECT 3 AS InfoCompleteId
		,''Incomplete Information'' AS InfoCompleteName
	) InformationComp

-- CoveragePlans                        
SELECT 0 AS CoveragePlanId
	,'''' AS DisplayAs
	,'''' AS BillingCodeTemplate --(S - Standard, O - Other Plan, T - Template)                            
	,0 AS UseBillingCodesFrom
	,'''' AS ContactPhone

UNION

SELECT DISTINCT CP.CoveragePlanId
	,CP.DisplayAs
	,BillingCodeTemplate --(S - Standard, O - Other Plan, T - Template)                            
	,UseBillingCodesFrom
	,ContactPhone AS CoveragePlan
FROM CoveragePlans CP
WHERE (
		CP.RecordDeleted = ''N''
		OR CP.RecordDeleted IS NULL
		)
	AND Active = ''Y''
ORDER BY DisplayAs

--  GlobalCode with case statement                
SELECT GlobalCodeId
	,CodeName
	,Category
	,CASE 
		WHEN SortOrder IS NULL
			THEN 9999
		ELSE SortOrder
		END AS SortOrder
FROM GlobalCodes
WHERE Active = ''Y''
	AND (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)
ORDER BY SortOrder
	,CodeName

--  GlobalCodeCategeories                    
SELECT DISTINCT RTRIM(LTRIM(CategoryName)) AS Category
FROM GlobalCodeCategories GC
WHERE (
		RecordDeleted = ''N''
		OR RecordDeleted IS NULL
		)

--Added by Jaspreet Singh on 5 July,2007                  
--Agency                  
SELECT *
FROM Agency

/*Program*/
SELECT 0 AS CheckBox -- For check box                 
	,ProgramId
	,ProgramCode AS ProgramName
	,''1'' AS RecordDeleted
	,''N'' AS RadioButton --For Primary Program ID Radio Button              
	,''0'' AS StaffProgramId
FROM Programs
WHERE Active = ''Y''
	AND (ISNULL(RecordDeleted, ''N'') = ''N'')
ORDER BY ProgramCode

/*Client from procedurerates*/
SELECT 0 AS CheckBox
	,ClientId
	--Added by Revathi	19 Oct 2015       
	,CASE 
		WHEN ISNULL(ClientType, ''I'') = ''I''
			THEN ISNULL(LastName, '''') + '', '' + ISNULL(FirstName, '''')
		ELSE ISNULL(OrganizationName, '''')
		END AS ClientName
FROM Clients
WHERE (ISNULL(RecordDeleted, ''N'') = ''N'')
	AND (ISNULL(Active, ''Y'') = ''Y'')

IF (@@error != 0)
BEGIN
	RAISERROR 20002 ''ssp_PMGetMiscSharedTables : An error  occured''

	RETURN
END
' 
END
GO
