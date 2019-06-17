IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMGetGlobalCodeCategories]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_PMGetGlobalCodeCategories]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[ssp_PMGetGlobalCodeCategories] 
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMGetGlobalCodeCategories
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Procedure to return global code categories.
--
-- Author:  Girish Sanaba
-- Date:    June 29 2011
--
-- *****History****
-- 10/01/2018 Lakshmi  Added Ltrim and Ltrim function for Coloumn 'Category', as per the task 	Core Bugs #2520
*********************************************************************************/

AS
BEGIN


	--Global Code Categories
	SELECT GlobalCodeCategoryId,
		   LTRIM(RTRIM(Category)) AS Category,
		   CategoryName,
           Active,
           AllowAddDelete,
           AllowCodeNameEdit,
           AllowSortOrderEdit,
           [Description],
           UserDefinedCategory,
           HasSubcodes,
           UsedInPracticeManagement,
		   UsedInCareManagement,
           ExternalReferenceId,
           RowIdentifier,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate,
           RecordDeleted,
           DeletedDate,
           DeletedBy
	FROM GlobalCodeCategories
	WHERE ISNULL(RecordDeleted,'N')='N' 
	ORDER BY CategoryName	
	RETURN
END

GO

