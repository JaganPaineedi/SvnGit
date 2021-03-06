/****** Object:  StoredProcedure [dbo].[csp_RDWExtractError]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractError]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractError]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractError]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractError]
@AffiliateId int,
@ErrorText varchar(4000)
as

update CustomRDWExtractSummary
   set ErrorMessage = case when ErrorMessage is null
                           then @ErrorText
                           else ErrorMessage + char(13) + char(10) + @ErrorText
                      end
 where AffiliateId = @AffiliateId

if @@error <> 0 
  raiserror 50010 ''Failed to update Extract Summary table''


raiserror 50020 @ErrorText

return
' 
END
GO
