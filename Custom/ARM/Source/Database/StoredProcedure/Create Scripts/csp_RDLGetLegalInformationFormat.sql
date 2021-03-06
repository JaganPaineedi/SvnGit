/****** Object:  StoredProcedure [dbo].[csp_RDLGetLegalInformationFormat]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetLegalInformationFormat]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetLegalInformationFormat]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetLegalInformationFormat]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure  [dbo].[csp_RDLGetLegalInformationFormat]  
--@DocumentId int,               
--@Version int    
@DocumentVersionId int     --Modified by Anuj Dated 04-May-2010       
/********************************************************************************  
-- Stored Procedure: dbo.csp_RDLGetLegalInformationFormat   
--  
-- Copyright: 2008 Streamline Healthcate Solutions  
--  
-- Purpose: used for getting legal information format ID  
--  
-- Updates:                                                         
-- Date        Author      Purpose  
-- 10.10.2008  SFarber     Created.        
--  
*********************************************************************************/  
as  
  
declare @SignatureDate datetime  
declare @DocumentCodeId int  
  
  
--select @DocumentCodeId = DocumentCodeId from Documents where DocumentId = @DocumentId  
select @DocumentCodeId = DocumentCodeId 
 from Documents d
 Join DocumentVersions dv on dv.DocumentId=d.DocumentId
 where dv.DocumentVersionId = @DocumentVersionId   --Modified by Anuj Dated 04-May-2010   
  
  
select @SignatureDate = min(ds.SignatureDate)  
  from DocumentSignatures ds  
 --where ds.DocumentId = @DocumentId  
 --  and ds.Version <= @Version  
 where ds.SignedDocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 04-May-2010   
   and isnull(ds.RecordDeleted, ''N'') = ''N''  
   and not exists(select 1   
                    from DocumentSignatures ds2  
--                   where ds2.DocumentId = @DocumentId  
--                     and ds2.Version <= @Version  
--                     and ds2.Version > ds.Version  
					 where ds2.SignedDocumentVersionId = @DocumentVersionId   --Modified by Anuj Dated 04-May-2010   
                     and isnull(ds2.RecordDeleted, ''N'') = ''N'') 

                                
  
select top 1 LegalInformationFormatId  
  from CustomLegalInformationFormats  
 where case when @DocumentCodeId = 100 and EffectiveDate > ''4/13/2009'' then ''4/13/2009'' else EffectiveDate end <= isnull(@SignatureDate, getdate())  
   --and isnull(RecordDeleted, ''N'') = ''N''  
 order by EffectiveDate desc
' 
END
GO
