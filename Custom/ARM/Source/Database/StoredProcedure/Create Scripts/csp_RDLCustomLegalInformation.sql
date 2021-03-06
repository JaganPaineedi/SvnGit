/****** Object:  StoredProcedure [dbo].[csp_RDLCustomLegalInformation]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomLegalInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomLegalInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomLegalInformation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure  [dbo].[csp_RDLCustomLegalInformation]
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010   
/********************************************************************************
-- Stored Procedure: dbo.csp_RDLCustomLegalInformation  
--
-- Copyright: 2008 Streamline Healthcate Solutions
--
-- Purpose: used for viewing legal information
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 10.10.2008  SFarber     Created.      
--
*********************************************************************************/
as

declare @LegalInformationFormat table (LegalInformationFormatId int)
declare @MedicaidCustomer char(1)
declare @ShowMedicaidWarning char(1)
declare @DocumentCodeId int

insert into @LegalInformationFormat
--exec csp_RDLGetLegalInformationFormat @DocumentId = @DocumentId, @Version = @Version
exec csp_RDLGetLegalInformationFormat @DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010  

select @DocumentCodeId = DocumentCodeId
  from Documents 
-- where DocumentId = @DocumentId
 where CurrentDocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010  

if @DocumentCodeId = 100 -- Advance/Adequate Notice
  select @MedicaidCustomer = MedicaidCustomer, @ShowMedicaidWarning = ''N''
    from CustomAdvanceAdequateNotices
   --where DocumentId = @DocumentId
   --  and Version = @Version
	where DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010  
else
  select @MedicaidCustomer = ''Y'', @ShowMedicaidWarning = ''Y''

select CMHName,
       AgencyName,
       CountyName,
       AgencyPhoneNumber,
       AgencyTollFreePhoneNumber,
       AgencyTTYPhoneNumber,
       DesignatedDepartment,
       AppealAddress,
       isnull(@MedicaidCustomer, ''N'') as MedicaidCustomer,
       isnull(@ShowMedicaidWarning, ''N'') as ShowMedicaidWarning 
  from CustomLegalInformationFormats clf
       join @LegalInformationFormat lf on lf.LegalInformationFormatId = clf.LegalInformationFormatId
' 
END
GO
