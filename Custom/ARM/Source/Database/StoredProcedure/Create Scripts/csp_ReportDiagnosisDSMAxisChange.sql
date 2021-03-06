/****** Object:  StoredProcedure [dbo].[csp_ReportDiagnosisDSMAxisChange]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDiagnosisDSMAxisChange]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDiagnosisDSMAxisChange]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDiagnosisDSMAxisChange]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ReportDiagnosisDSMAxisChange]

	@Action as varchar(1),	-- Input Parameter, ''V'' to View, ''U'' to Update records
	@DSMCode as varchar(6),	-- Input Parameter, Requested DSM to change
	@NewAxis as int			-- Input Parameter, Desired Axis result
AS
/***************************************************************************/           
/* Stored Procedure: [csp_ReportDiagnosisDSMAxisChange]                    */                                                           
/* Copyright: 2012 Streamline Healthcare Solutions                         */                                                                    
/* Creation Date:  December 4,2012                                         */                                                                    
/* Purpose:  Allow user change of the Axis value related to a DSM Code     */                                                                   
/* Input Parameters: @Action, @DSMCode, @NewAxis                           */                                                                  
/* Output Parameters: None                                                 */                                                                    
/* Return:  0=success, otherwise an error number                           */     
/* Calls:                                                                  */                          
/* Data Modifications:                                                     */                          
/* Updates:                                                                */                          
/* Date        Author               Purpose                                */                          
/* 12/04/2012  Matt Lightner        Created                                */                          
/***************************************************************************/              

IF NOT EXISTS (SELECT * FROM dbo.DiagnosisDSMDescriptions WHERE DSMCode = @DSMCode) -- Invalid DSM Code Entered
BEGIN  
 	 SELECT NULL as "DSM Code"
		  , NULL as "DSM Number"
		  , NULL as "DSM Description"
		  , NULL as "Axis"
		  , ''DSM Code Entered Does Not Exist'' Comment
END

ELSE IF (@Action = ''U'' AND @NewAxis IS NULL)	-- Updating without selecting an Axis
BEGIN  
 	 SELECT NULL as "DSM Code"
		  , NULL as "DSM Number"
		  , NULL as "DSM Description"
		  , NULL as "Axis"
		  , ''Please Select a Valid Axis Value'' Comment
END

ELSE IF (@Action = ''V'')	-- View Existing Record(s)
BEGIN
	 SELECT DSMCode as "DSM Code"
		  , DSMNumber as "DSM Number"
		  , DSMDescription as "DSM Description"
		  , case Axis when 1 then ''Axis I'' else ''Axis II'' end as "Axis"
		  , ''Current Setting Listed'' Comment
	   FROM dbo.DiagnosisDSMDescriptions
	  WHERE DSMCode = @DSMCode
	  ORDER BY DSMCode, DSMNumber
END
 
ELSE IF (@Action = ''U'')	-- Update Selected DSM Record(s)
BEGIN
	 UPDATE dbo.DiagnosisDSMDescriptions
	    SET Axis = @NewAxis
	  WHERE DSMCode = @DSMCode
	 
	 SELECT DSMCode as "DSM Code"
		  , DSMNumber as "DSM Number"
		  , DSMDescription as "DSM Description"
		  , case Axis when 1 then ''Axis I'' else ''Axis II'' end as "Axis"
		  , ''Record(s) Updated Successfully'' as Comment
	   FROM dbo.DiagnosisDSMDescriptions
	  WHERE DSMCode = @DSMCode
	  ORDER BY DSMCode, DSMNumber
END
 
' 
END
GO
