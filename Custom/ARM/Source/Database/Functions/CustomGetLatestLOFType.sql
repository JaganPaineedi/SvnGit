/****** Object:  UserDefinedFunction [dbo].[CustomGetLatestLOFType]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestLOFType]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CustomGetLatestLOFType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestLOFType]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create function [dbo].[CustomGetLatestLOFType]    
(@ClientId       int)  
Returns char(1)  
AS  
-- Description: Procedure to determine and return LOFType to any calling procedure.  As some required elements are commonly needed in  
-- many documents for various reasons, this procedure accepts those elements as parameters, or can calculate them if they have not already  
-- been calculated.  
--  
-- Created by: Ryan Noble  
-- Created on: Apr 18 2011  
Begin  
Declare @AdmissionDate      datetime,  
  @Age        int,  
  @LatestAssessmentDocumentVersionId int,  
  @LOFType       char(1)  
  
-- Get the client''s age.  
  Select @Age = dbo.GetAge(c.DOB, getdate())    
 From Clients c    
 Where c.ClientId = @ClientID    
 and isnull(c.RecordDeleted, ''N'')= ''N''    
    
-- Get the latest signed Assessment DocumentVersionId  
If (@LatestAssessmentDocumentVersionID is null)    
 Begin    
 select @LatestAssessmentDocumentVersionId = dbo.CustomGetLatestDocumentVersionIdByDocumentCodeGroup (@ClientId, null, ''349, 1469'', ''22'')  
  End    
  
-- Only pull @LOFType is the assessment was not a ''DD'' assessment.  If no assessment existed, decided ''Adult'' or ''Child'' based on Age.  Adult = DLA, Child = CAFAS  
select @LOFType =   
  case when isnull(c.ClientInDDPopulation,''N'') = ''N'' then  
   case when isnull(c.AdultOrChild,'''') = '''' then  
    case when @Age >= 18 then ''A'' else ''C''  
    end else c.AdultOrChild  
   end  
  else null  
  end  
 from  
 Clients a  
 left join Documents b on a.ClientId = b.ClientId and b.CurrentDocumentVersionId = @LatestAssessmentDocumentVersionId  
 left join CustomHRMAssessments c on b.CurrentDocumentVersionId = c.DocumentVersionId  
  where   
   a.ClientId = @ClientId  
   and IsNull(a.RecordDeleted,''N'') <> ''Y''  
   and IsNull(b.RecordDeleted,''N'') <> ''Y''  
   and isnull(c.RecordDeleted,''N'') <> ''Y''  
  
return @LOFType  
  
End' 
END
GO
