/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIIIMatch]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIIIMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesIIIMatch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIIIMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[csf_DiagnosesIIIMatch] 
(@DocumentVersionId_1 int,
 @DocumentVersionId_2 int) 
 returns bit
/****************************************************************************************/
/* Function to check two diagnosis records from table DiagnosesIII to see if the    	*/
/* Diagnosis''s are a match.  Returns True(1) if the diagnosis''s are a match and    		*/
/* false(0) if they do not match or the process fails.									*/
/*																						*/
/* Author: Steve Stevens																*/
/* Date: 12/05/2012																		*/
/****************************************************************************************/
	
as
begin

-- Declare variables 
-- default @retval to false
-- @mismatch 999 forces false value in the if statement were the select clause to fail
declare @retval bit = 0;        
declare @mismatch int = 999;

-- Declare work fields
declare @Odx_Specification varchar(max) = '''';
declare @Odx_RecordDeleted char(1) = ''''; 

declare @Ndx_Specification varchar(max) = '''';
declare @Ndx_RecordDeleted char(1) = '''';     

--
--  Select applicable fields from table to test. 
Select @Odx_Specification = isnull(Specification,''''),
       @Odx_RecordDeleted = isnull(RecordDeleted,'''')
  from dbo.DiagnosesIII
 where DocumentVersionId = @DocumentVersionId_1; 
 
Select @Ndx_Specification = isnull(Specification,''''),
       @Ndx_RecordDeleted = isnull(RecordDeleted,'''')
  from dbo.DiagnosesIII
 where DocumentVersionId = @DocumentVersionId_2;  

--
-- Test returned variables for mismatch 
If @Odx_Specification <> @Ndx_Specification or 
   @Odx_RecordDeleted <> @Ndx_RecordDeleted 
   Set @mismatch = 1
   else
   Set @mismatch = 0; 

--
-- Set return value    
If @mismatch = 0
 Set @retval = 1
 else
 Set @retval = 0;

Return @retval;
 
end

' 
END
GO
