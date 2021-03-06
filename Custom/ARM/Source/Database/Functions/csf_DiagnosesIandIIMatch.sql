/****** Object:  UserDefinedFunction [dbo].[csf_DiagnosesIandIIMatch]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIandIIMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_DiagnosesIandIIMatch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_DiagnosesIandIIMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [dbo].[csf_DiagnosesIandIIMatch] 
(@DocumentVersionId_1 int,
 @DocumentVersionId_2 int) 
 returns bit
/****************************************************************************************/
/* Function to check two diagnosis records from table DiagnosesIandII to see if the 	*/
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

--  Use common tables to get each set of rows from the diagnosis tables
--  Then join using a full outer join to ensure null values on one side 
--  of the join in the event of a row mismatch.  The row mismatch is 
--  detected by check for isnull(0) value in the documentversionid which
--  should never contain a zero value. 
With OrgDx as (
  select isnull(DocumentVersionId,0) as DocumentVersionId,
         isnull(axis,0) as axis,
         isnull(DSMCode,'''') as DSMCode,
         isnull(DSMNumber,0) as DSMNumber,
         isnull(DiagnosisType,0) as DiagnosisType,
         isnull(RuleOut,'''') as RuleOut,
         isnull(Billable,'''') as Billable, 
         isnull(Severity,0) as Severity,
         isnull(DSMVersion,'''') as DSMVersion,
         isnull(DiagnosisOrder,0) as DiagnosisOrder,
         isnull(Remission,0) as Remission,
         isnull(RecordDeleted,'''') as RecordDeleted
         from dbo.DiagnosesIAndII 
         where DocumentVersionId = @DocumentVersionId_1
         ),
     NewDx as (
  select isnull(DocumentVersionId,0) as DocumentVersionId,     
         isnull(axis,0) as axis,
         isnull(DSMCode,'''') as DSMCode,
         isnull(DSMNumber,0) as DSMNumber,
         isnull(DiagnosisType,0) as DiagnosisType,
         isnull(RuleOut,'''') as RuleOut,
         isnull(Billable,'''') as Billable, 
         isnull(Severity,0) as Severity,
         isnull(DSMVersion,'''') as DSMVersion,
         isnull(DiagnosisOrder,0) as DiagnosisOrder,
         isnull(Remission,0) as Remission,
         isnull(RecordDeleted,'''') as RecordDeleted    
         from dbo.DiagnosesIAndII 
         where DocumentVersionId = @DocumentVersionId_2
         )
select @mismatch = COUNT(*) from orgdx odx full outer join NewDx ndx 
  on odx.diagnosistype = ndx.diagnosistype 
 and odx.diagnosisorder = ndx.diagnosisorder
 where odx.axis <> ndx.axis
    or odx.DSMCode <> ndx.DSMCode
    or odx.DSMNumber <> ndx.DSMNumber
    or odx.DiagnosisType <> ndx.DiagnosisType
    or odx.RuleOut <> ndx.RuleOut
    or odx.Billable <> ndx.Billable
    or odx.Severity <> ndx.Severity 
    or odx.DSMVersion <> ndx.DSMVersion 
    or odx.DiagnosisOrder <> ndx.DiagnosisOrder 
    or odx.Remission <> ndx.Remission  
    or odx.RecordDeleted <> ndx.RecordDeleted 
    or isnull(odx.DocumentVersionId, 0) = 0     -- row mismatch on 1
    or isnull(ndx.DocumentVersionId, 0) = 0;    -- row mismatch on 2
    
If @mismatch = 0
 Set @retval = 1
 else
 Set @retval = 0;

Return @retval;
 
end

' 
END
GO
