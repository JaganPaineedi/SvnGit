/****** Object:  StoredProcedure [dbo].[csp_ReportDiagnosisICDAddDelete]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDiagnosisICDAddDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDiagnosisICDAddDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDiagnosisICDAddDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE procedure [dbo].[csp_ReportDiagnosisICDAddDelete]

	@Action as varchar(1),		-- Input Parameter, ''V'' to View, ''A'' to Add records
	@ICDCode as varchar(6),		-- Input Parameter, Requested ICD Code
	@ICDDesc as varchar(1000)	-- Input Parameter, Desired ICD Code Description
AS
/***************************************************************************/           
/* Stored Procedure: [csp_ReportDiagnosisICDAddDelete]                     */                                                           
/* Copyright: 2013 Streamline Healthcare Solutions                         */                                                                    
/* Creation Date:  January 3, 2013                                         */                                                                    
/* Purpose:  Allow user to maintain ICD Codes						       */                                                                   
/* Input Parameters: @Action, @ICDCode, @ICDDesc                           */                                                                  
/* Output Parameters: None                                                 */                                                                    
/* Return:  0=success, otherwise an error number                           */     
/* Calls:                                                                  */                          
/* Data Modifications:                                                     */                          
/* Updates:                                                                */                          
/* Date        Author               Purpose                                */                          
/* 01/03/2013  Steven P. Stevens    Created                                */                          
/***************************************************************************/              

--  In view mode and code entered does not exist
IF @Action <> ''A'' and (NOT EXISTS (SELECT * FROM dbo.DiagnosisICDCodes WHERE ICDCode = @ICDCode)) 
  BEGIN  
 	 SELECT NULL as "ICD Code"
		  , NULL as "ICD Description"
		  , ''The ICD Code entered does not exist.'' as Comment
  END

--  In Add mode and did not enter a description
ELSE IF (@Action = ''A'' AND @ICDDesc IS NULL) or	
		(@Action = ''A'' AND @ICDDesc = '''') 	
  BEGIN  
 	 SELECT @ICDCode as "ICD Code"
		  , NULL as "ICD Description"
		  , ''Please enter an ICD Code description.'' as Comment
  END

--  View an existing record
ELSE IF (@Action = ''V'')	
  BEGIN
    Begin Try
	 SELECT ICDCode as "ICD Code"
		  , ICDDescription as "ICD Description"
		  , ''Displaying current ICD Code values.'' as Comment
	   FROM dbo.DiagnosisICDCodes
	  WHERE ICDCode = @ICDCode
	  ORDER BY ICDCode
    End Try
    Begin Catch
   	 SELECT @ICDCode as "ICD Code"
		  , NULL as "ICD Description"
		  , ''Unable to display ICD Code values.'' as Comment
    End Catch
  END
  
--  Add a new ICD Code 
ELSE IF (@Action = ''A'')	
  BEGIN
    Begin try
	 Insert into DiagnosisICDCodes (ICDCode, ICDDescription)
		Values(@ICDCode, @ICDDesc)
	 
	 SELECT ICDCode as "ICD Code"
		  , ICDDescription as "ICD Description"
		  , ''The ICD Code was added successfully!!'' as Comment
	   FROM dbo.DiagnosisICDCodes
	  WHERE ICDCode = @ICDCode
	  ORDER BY ICDCode
    End try
    --  Error Handling if ICD Code not added
    Begin Catch
      IF EXISTS (SELECT * FROM dbo.DiagnosisICDCodes WHERE ICDCode = @ICDCode)   -- Does it already exist?  
       SELECT NULL as "ICD Code"
		  , NULL as "ICD Description"
		  , ''The ICD Code already exists.'' as Comment
      ELSE	                                                                     -- Other errors
   	   SELECT NULL as "ICD Code"
		  , NULL as "ICD Description"
		  , ''The ICD Code could not be added.'' as Comment
    End Catch	  
  END

' 
END
GO
