
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_SureScriptsMedicationPreviewDateFormat]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT')) 
DROP FUNCTION [dbo].[ssf_SureScriptsMedicationPreviewDateFormat]
GO
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create function [dbo].[ssf_SureScriptsMedicationPreviewDateFormat] (
	@inDateTime datetime
)
/*=======================================================
-- Function: ssf_SureScriptsMedicationPreviewDateFormat
--
-- Copyright: Streamline Healthcare Solutions
-- 
-- Purpose: Format data on the Medication Preview Page
--
-- Updates:                 
--  Date         Author    Purpose                
--  1/6/2017    Pranay   Created for EPCS Task#37    

========================================================*/

returns varchar(10)
as
begin
RETURN CONVERT(VARCHAR(10), @inDateTime, 110) 

end

GO

