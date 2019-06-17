/****** Object:  StoredProcedure [dbo].[ssp_SCGetRecordTypeFromAssociationWith]    Script Date: 16-10-2018 12:37:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetRecordTypeFromAssociationWith]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetRecordTypeFromAssociationWith]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetRecordTypeFromAssociationWith]    Script Date: 16-10-2018 12:37:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetRecordTypeFromAssociationWith]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_SCGetRecordTypeFromAssociationWith] AS'
END
GO

ALTER PROCEDURE [dbo].[ssp_SCGetRecordTypeFromAssociationWith] @AssociatedWith INT
	,@LoggedInStaffId INT = NULL
AS
/*********************************************************************/
/* Stored Procedure: [[ssp_SCGetRecordTypeFromAssociationWith]]             */
/* Creation Date:  12 july 2010                                    */
/*                                                                   */
/* Purpose: Gets RecordTypes to bind in the ImageRecords list page                                               
             w.r.t  AssociationWith         */
/*                                                                   */
/* Input Parameters: @@AssociatedWith int                                   */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Return: retuns list of RecordTypes                                                  
             w.r.t AssociationWith            */
/*                                                                         */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:       */
/*                             */
/*                                                                   */
/* Updates:                                                          */
/*  Date               Author                    Purpose             */
/*  10 July 2010       Ashwani Kumar Angrish     created              
/*  06 May 2011        Karan Garg                Updated (added else if for "5820" */          
/*  01 March 2012	   Saurav Pande				 Added DocumentType 11 for AssociatedWith = 5811*/
/*  18 June 2012	   Saurav Pande				 reverted change made for DocumentType 11 for AssociatedWith = 5811*/
/*  23 Dec 2013        Md Hussain Khusro         Added GlobalCodes Category = "APPEALSCANTYPE" for AssociatedWith = 5817 wrt task#203 Venture Region 3.5 Imp.*/*/
/*  05 Apr 2018		   Rajeshwari				 Added Associated ID with for Client order(5828) use globalcodeid in table globalsubcodes #98 Renaissance - Environment Issues Tracking   */
/*  16 Oct 2018		   Shankha					 Implemented changes to filter Record Types for Patient Portal users.*/


/*********************************************************************/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from                          
	-- interfering with SELECT statements.                          
	SET NOCOUNT ON;

	-- Insert statements for procedure here                          
	IF (@AssociatedWith = 5811)
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM Staff
				WHERE StaffId = Isnull(@LoggedInStaffId, 0)
					AND TempClientId IS NOT NULL
				)
		BEGIN
			SELECT dc.DocumentCodeId AS Id
				,dc.DocumentName AS Name
			FROM DocumentCodes dc
			WHERE dc.Active = 'Y'
				AND dc.DocumentType = 17
				AND isnull(DC.AllowClientPortalUserAsAuthor, 'N') = 'Y'
				AND ISNULL(dc.RecordDeleted, 'N') = 'N'
		END
		ELSE
		BEGIN
			SELECT DocumentCodeId AS Id
				,DocumentName AS Name
			FROM DocumentCodes
			WHERE Active = 'Y'
				AND DocumentType = 17
				AND isnull(RecordDeleted, 'N') = 'N'
		END
	END
	ELSE IF (@AssociatedWith = 5812)
	BEGIN
		SELECT et.EventTypeId AS Id
			,et.EventName AS Name
		FROM EventTypes AS et
		INNER JOIN DocumentCodes AS dc ON et.AssociatedDocumentCodeId = dc.DocumentCodeId
		WHERE dc.DocumentType = 17
			AND isnull(dc.RecordDeleted, 'N') = 'N'
			AND isnull(et.RecordDeleted, 'N') = 'N'
	END
	ELSE IF (@AssociatedWith = 5813)
	BEGIN
		SELECT GlobalCodeId AS Id
			,CodeName AS Name
		FROM GlobalCodes
		WHERE Category = 'CLIENTSCANTYPE'
			AND isnull(RecordDeleted, 'N') = 'N'
	END
			---------        
	ELSE IF (@AssociatedWith = 5814)
	BEGIN
		SELECT GlobalCodeId AS Id
			,CodeName AS Name
		FROM GlobalCodes
		WHERE Category = 'STAFFSCANTYPE'
			AND isnull(RecordDeleted, 'N') = 'N'
	END
			--ELSE IF (@AssociatedWith=271)                          
			--BEGIN                          
			--select GlobalCodeId as Id,CodeName as Name from GlobalCodes where Category='STAFFSCANTYPE'       and isnull(RecordDeleted,'N')='N'                             
			--END                          
	ELSE IF (@AssociatedWith = 5815)
	BEGIN
		SELECT GlobalCodeId AS Id
			,CodeName AS Name
		FROM GlobalCodes
		WHERE Category = 'PROVIDERSCANTYPE'
			AND isnull(RecordDeleted, 'N') = 'N'
	END
	ELSE IF (@AssociatedWith = 5816)
	BEGIN
		SELECT GlobalCodeId AS Id
			,CodeName AS Name
		FROM GlobalCodes
		WHERE Category = '-1'
	END
	ELSE IF (@AssociatedWith = 5817)
	BEGIN
		SELECT GlobalCodeId AS Id
			,CodeName AS Name
		FROM GlobalCodes
		WHERE Category = 'APPEALSCANTYPE'
			AND isnull(RecordDeleted, 'N') = 'N'
	END
	ELSE IF (@AssociatedWith = 5820)
	BEGIN
		SELECT GlobalCodeId AS Id
			,CodeName AS Name
		FROM GlobalCodes
		WHERE Category = 'COVERAGEPLANIMAGETYP'
			AND isnull(RecordDeleted, 'N') = 'N'
	END
	ELSE IF (@AssociatedWith = 5828) --05.04.2018  Rajeshwari                             
	BEGIN
		SELECT GlobalSubCodeId AS Id
			,SubCodeName AS Name
		FROM globalsubcodes
		WHERE GlobalCodeId = 5828
			AND isnull(RecordDeleted, 'N') = 'N'
	END

	IF (@@error != 0)
	BEGIN
		RAISERROR (
				'[ssp_SCGetRecordTypeFromAssociationWith]'
				,16
				,1
				)
	END
END
GO


