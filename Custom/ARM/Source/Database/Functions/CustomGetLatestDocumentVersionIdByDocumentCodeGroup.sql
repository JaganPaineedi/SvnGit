/****** Object:  UserDefinedFunction [dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[CustomGetLatestDocumentVersionIdByDocumentCodeGroup]  
(@ClientId    int,  
@StartDate    datetime, -- Only look for documents after this date.  Can be passed as null and will default to 1/1/1900.  
@DocumentCodeGroup  varchar(max), -- Comma separated list of documentCodeId''s.  
@DocumentStatusGrouping varchar(max)  -- Comma separated list of document statuses.  
)  
Returns int  
-- Description: This function accepts a clientId, start date, a comma delimited list of document codes, and a comma delimited list of document statuses.  The function then determines and returns  
-- the latest (after the start date provided) DocumentVersionId for any document with a status provied and in the grouping of document codes provided.  
--  
-- Created by: Ryan Noble  
-- Created on: Apr 18 2011  
Begin  
 -- Variable declaration  
 declare @SQL    varchar(max),  
   @DocumentVersionId int,  
   @AdmissionDate  datetime  
   
 declare @DocumentCodes  table  
    (DocumentCodeId int)  
   
 declare @DocumentStatuses table  
    (Status   int)  
  
 -- Use the fnsplit function to create a table of document code filters  
 insert into @DocumentCodes  
 (DocumentCodeId)  
 select * from dbo.fnsplit(@DocumentCodeGroup,'','')  
   
 -- Use the fnsplit function to create a table of document status filters  
 insert into @DocumentStatuses  
 (Status)  
 select * from dbo.fnsplit(@DocumentStatusGrouping,'','')  
  
 -- Using the DocumentCodes and Admission Date, determine the latest document in the group.  
 Select @DocumentVersionId = (select top 1 CurrentDocumentVersionId  
        from Documents a  
        join @DocumentCodes b on a.documentCodeId = b.DocumentCodeId  
        join @DocumentStatuses c on a.status = c.status  
         where a.ClientId = @ClientId  
          and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))  
          and a.EffectiveDate >= isnull(@StartDate, ''1/1/1900'')  
          and isNull(a.RecordDeleted,''N'') <> ''Y''  
          order by a.EffectiveDate desc,a.status,a.ModifiedDate desc) -- To prevent ''random'' sorting, currently status will sort by integer.  This could be given a hierarchy.  
            
 Return @DocumentVersionId  
End  
  ' 
END
GO
