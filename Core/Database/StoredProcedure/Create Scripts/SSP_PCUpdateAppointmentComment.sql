/****** Object:  StoredProcedure [dbo].[SSP_PCUpdateAppointmentComment]    Script Date: 11/18/2011 16:25:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_PCUpdateAppointmentComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_PCUpdateAppointmentComment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[SSP_PCUpdateAppointmentComment]
	@AppointmentId int ,
	@Comment text ,
	@CurrentUser VARCHAR(30)
AS

/********************************************************************************                                                  
-- Stored Procedure: SSP_PCUpdateAppointmentComment
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Query to update Comment
--
-- Author:  Mamta Gupta 
-- Date:    5/Nov/2012
--
-- *****History****
*********************************************************************************/

Update Appointments 
set Description = @Comment,
	ModifiedBy = @CurrentUser
where AppointmentId = @AppointmentId

GO
