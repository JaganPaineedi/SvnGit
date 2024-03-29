/****** Object:  StoredProcedure [dbo].[csp_DisclosureCoverLetterInfo]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DisclosureCoverLetterInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DisclosureCoverLetterInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DisclosureCoverLetterInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE Procedure [dbo].[csp_DisclosureCoverLetterInfo]
@clientdisclosureid int
as
/*********************************************************************/                      
/* Stored Procedure: csp_DisclosureCoverLetterInfo             */                      
/* Creation Date:  2/07/2011                                            */                      
/*                                                                       */                      
/* Purpose: to get all Disclosure Cover Letter RDL   */                     
/*                                                                   */                    
/* Input Parameters: 						*/                    
/*                                                                   */                      
/* Output Parameters:                                */                      
/*                                                                   */                      
/*  Date                  Author                 Purpose                                    */                      
/* 2/07/2011            Rahul Aneja             Created                                    */                      
/*********************************************************************/ 
--declare	@ClientDisclosureId int
--select top 1 @ClientDisclosureId = ClientDisclosureId
--from dbo.ClientDisclosures
--where ClientId = @ClientId
--and ISNULL(RecordDeleted, ''N'') <> ''Y''
--order by ModifiedDate desc
BEGIN
BEGIN TRY
select a.DisclosureDate, a.NameAddress, a.CoverLetterComment, c.LastName + '', '' + c.FirstName + '' ('' + CAST(c.ClientId as varchar) + '')'' as ClientName,a.ClientDisclosureId
from dbo.ClientDisclosures as a
join dbo.Clients as c on c.ClientId = a.ClientId
where ClientDisclosureId = @clientdisclosureid AND ISNULL(a.RecordDeleted,''N'')<>''Y''
END TRY
 BEGIN CATCH            
   RAISERROR  20006  ''csp_DisclosureCoverLetterInfo An Error Occured''                   
   Return                
 END CATCH 
END
' 
END
GO
