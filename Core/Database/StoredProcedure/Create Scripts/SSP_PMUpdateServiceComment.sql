/****** Object:  StoredProcedure [dbo].[SSP_PMUpdateServiceComment]    Script Date: 11/18/2011 16:25:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_PMUpdateServiceComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_PMUpdateServiceComment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[SSP_PMUpdateServiceComment]
	@ServiceId int ,
	@Comment text ,
	@CurrentUser VARCHAR(30)
AS

/********************************************************************************                                                  
-- Stored Procedure: SSP_PMUpdateServiceComment
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Query to update Comment
--
-- Author:  Msunma
-- Date:    06 Dec 2011
--
-- *****History****
-- 06.12.2011  MSuma   Query to update Comment
-- 30.11.2015  VKhare	updating Modified date form reception Page 

*********************************************************************************/

Update Services set Comment = @Comment,ModifiedBy = @CurrentUser,ModifiedDate=GETDATE()
where ServiceId = @ServiceId

GO
