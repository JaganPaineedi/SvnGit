
/****** Object:  StoredProcedure [dbo].[ssp_CMGetProvidersListForToolbar]    Script Date: 07/27/2017 12:12:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetProvidersListForToolbar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetProvidersListForToolbar]
GO


/****** Object:  StoredProcedure [dbo].[ssp_CMGetProvidersListForToolbar]    Script Date: 07/27/2017 12:12:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_CMGetProvidersListForToolbar] 
@LoggedInStaff INT,
@ProviderName Varchar(max)='',
@ClientId INT=0
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_CMGetProvidersListForToolbar			*/
	/* Copyright: 2005 Provider Claim Management System					*/
	/*                                                                  */
	/* Purpose: Fetch Provider IDs,Names								*/
	/*                                                                  */
	/* Created Info : Taken from 3.5x CM application and modified logic by Joining with Staff Providers */
	/*                                                                  */
	/* Return: returns DataSet											*/
	/*                                                                  */
	/*                                                                  */
	/* Data Modifications:												*/
	/*																	*/
	/* Updates:															*/
	/********************************************************************/
	/*	Date			Author			Purpose							*/
	/*	10 SEP 2014		Rohith Uppin	Provider > 0 condition added. task#29 CM to SC	*/
	/*  29 SEP 2014     Vichee Humane   Modified the ssp to provide if else condition on ref of  CM to SC ENV. Issues Tracking #29*/
	/*  22 DEC 2014     SURYABALAN  Modified the ssp to fix some providers were missing on Open this Providers dropdown on ref of  CM to SC ENV. Issues Tracking #267*/
	/*  22 DEC 2014     SURYABALAN  Modified the ssp to fix All providers were displaying when saved some providers in CM tab on Open this Providers dropdown on ref of  CM to SC ENV. Issues Tracking #267*/
	/*  02 JAN 2017     Basudev     Modified the ssp to handle Typeable search for task  #364 CEI SGL*/
	/*  04 April 2017   PradeepT    What:Changed the input parameter  @ProviderName from defalult null to '' as when it is null then like operator does not return any record*/
	/*                              Why: As per task Core Bugs-#2370*/
	/*  27 July 2017    PradeepT    What:Change the logic to bind the providers dropdown which are associated with the claims for clients and logged in staff either has access to all provider or specific providers*/
	/*                              Why:As per task KCMHSAS - Support-#900.82*/
	/*  3 August 2017   PradeepT    What:Changes made as per Slavik Suggestion */
	/*                              Why: As per task KCMHSAS - Support-#900.82 */
	/* 2017-11-07      esova       what: order by providername */
	/********************************************************************/
AS
BEGIN
	DECLARE @AllProvider VARCHAR(1)

	SELECT TOP 1 @AllProvider = allproviders
	FROM staff
	WHERE staffid = @LoggedInStaff

	BEGIN TRY
		SELECT  p.ProviderId,
            CASE p.ProviderType
              WHEN 'I' then isnull(p.ProviderName, '') + ', ' + isnull(p.FirstName, '')
              WHEN 'F' then isnull(p.ProviderName, '')
            END AS ProviderName
    FROM    Providers p
    WHERE   EXISTS ( SELECT *
                     FROM   Claims c
                            join Sites s on s.SiteId = c.SiteId
                     WHERE  isnull(c.RecordDeleted, 'N') = 'N'
                            and s.ProviderId = p.ProviderId
                            and (@ClientId = 0
                                 or c.ClientId = @ClientId) )
            AND (@AllProvider = 'Y'
                 OR EXISTS ( SELECT *
                             FROM   StaffProviders sp
                             WHERE  sp.StaffId = @LoggedInStaff
                                    and sp.ProviderId = p.ProviderId
                                    and isnull(sp.RecordDeleted, 'N') = 'N' ))
            AND p.Active = 'Y'
            AND (isnull(@ProviderName, '') = ''
                 or p.ProviderName like '%' + @ProviderName + '%')
            AND isnull(p.RenderingProvider, 'N') = 'N'
            AND isnull(p.RecordDeleted, 'N') = 'N'
			order by p.ProviderName        --20171107 alphabetize provider list
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMGetProvidersListForToolbar') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


