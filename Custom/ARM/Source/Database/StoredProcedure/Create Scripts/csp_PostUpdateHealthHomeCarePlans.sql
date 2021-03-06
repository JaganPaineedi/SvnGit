/****** Object:  StoredProcedure [dbo].[csp_PostUpdateHealthHomeCarePlans]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateHealthHomeCarePlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostUpdateHealthHomeCarePlans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateHealthHomeCarePlans]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_PostUpdateHealthHomeCarePlans]
    @ScreenKeyId int,
    @StaffId int,
    @CurrentUser varchar(30),
    @CustomParameters xml
as 
declare @PRIMARYCARERELATIONSHIPCODEID int = 1009494

declare @DocumentVersionId int,
    @AuthorId int,
    @ClientId int
select  @DocumentVersionId = CurrentDocumentVersionId,
        @AuthorId = AuthorId,
        @ClientId = ClientId
from    Documents
where   DocumentId = @ScreenKeyId

if not exists ( select  *
                from    dbo.ClientContacts as cc
                where   cc.ClientId = @ClientId
                        and cc.Relationship = @PRIMARYCARERELATIONSHIPCODEID
                        and ISNULL(cc.RecordDeleted, ''N'') <> ''Y'' )
    and exists ( select *
                 from   dbo.CustomDocumentHealthHomeCarePlans as cp
                 where  cp.DocumentVersionId = @DocumentVersionId
                        and LEN(ISNULL(LTRIM(RTRIM(cp.PrimaryCareProviderFirstName)),
                                       '''')) > 0
                        and LEN(ISNULL(LTRIM(RTRIM(cp.PrimaryCareProviderLastName)),
                                       '''')) > 0 ) 
    insert  into dbo.ClientContacts
            (
             ListAs,
             ClientId,
             Relationship,
             FirstName,
             LastName,
             Organization
	        )
            select  cp.PrimaryCareProviderLastName + '', ''
                    + PrimaryCareProviderFirstName,
                    @ClientId,
                    @PRIMARYCARERELATIONSHIPCODEID,
                    cp.PrimaryCareProviderFirstName,
                    cp.PrimaryCareProviderLastName,
                    cp.PrimaryCareProviderOrganization
            from    dbo.CustomDocumentHealthHomeCarePlans as cp
            where   cp.DocumentVersionId = @DocumentVersionId

' 
END
GO
