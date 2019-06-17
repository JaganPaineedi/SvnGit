/****** Object:  UserDefinedFunction [dbo].[ssf_GetSitePhoneTypes]    Script Date: 10/11/2015 08:01:56 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetSitePhoneTypes]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_GetSitePhoneTypes]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_GetSitePhoneTypes]    Script Date: 10/11/2015 08:01:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ssf_GetSitePhoneTypes] (@SiteId INT)
RETURNS @retPhoneInfo TABLE
    (
      Phone VARCHAR(50) ,
      ContactTypeText VARCHAR(250) 
    )
	/*********************************************************************/
	/* Function: dbo.ssf_GetSitePhoneTypes                                     */
	/* Creation Date:   12/12/2012	                                    */
	/*                                                                  */
	/* Purpose: Simple function to get a CodeName of Sitephones based on */
	/*          priority        */
	/* Input Parameters:											    */
	/*	@incoming int													*/
	/*                                                                  */
	/* Returns:															*/
	/*	varchar(500)  													*/
	/*                                                                  */
	/*                                                                  */
	/* Updates:                                                         */
	/*   Date     Author      Purpose                                   */
	/*  10/11/15   Ponnin	  created									*/
	/*********************************************************************/
AS
BEGIN
	DECLARE @ResultCodeName VARCHAR(250)
	DECLARE @PhoneNumber VARCHAR(50)

SET @ResultCodeName = '' 
SET @PhoneNumber = ''

			SELECT TOP 1 @ResultCodeName =  gc.CodeName,@PhoneNumber = SP.PhoneNumber
			FROM globalcodes gc
			INNER JOIN SitePhones SP ON SP.PhoneType = gc.GlobalCodeId
			WHERE SP.PhoneType IN (
					 31
					,33
					,30
					,32
					)
				AND SP.SiteId = @SiteId
				AND ISNULL(gc.RecordDeleted, 'N') = 'N'
				AND ISNULL(SP.RecordDeleted, 'N') = 'N'
			ORDER BY CASE 
					WHEN SP.PhoneType = 31
						THEN 1
					ELSE 2
					END
				,CASE 
					WHEN SP.PhoneType = 33
						THEN 1
					ELSE 2
					END
				,CASE 
					WHEN SP.PhoneType = 30
						THEN 1
					ELSE 2
					END
				,CASE 
					WHEN SP.PhoneType = 32
						THEN 1
					ELSE 2
					END
				,SP.PhoneType
       
	 IF (
			@ResultCodeName = ''
			OR @PhoneNumber = ''
		)
		
	BEGIN

				SELECT TOP 1 @ResultCodeName =  gc.CodeName,@PhoneNumber = SP.PhoneNumber
				FROM globalcodes gc
				INNER JOIN SitePhones SP ON SP.PhoneType = gc.GlobalCodeId
				WHERE SP.SiteId = @SiteId
					AND ISNULL(gc.RecordDeleted, 'N') = 'N'
					AND ISNULL(SP.RecordDeleted, 'N') = 'N'
 
	END

INSERT INTO @retPhoneInfo (
			Phone
			,ContactTypeText
			)
		SELECT @PhoneNumber, @ResultCodeName 
		
	RETURN
END
GO

