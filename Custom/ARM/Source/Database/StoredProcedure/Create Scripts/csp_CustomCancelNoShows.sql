/****** Object:  StoredProcedure [dbo].[csp_CustomCancelNoShows]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomCancelNoShows]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomCancelNoShows]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomCancelNoShows]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE  [dbo].[csp_CustomCancelNoShows]      
      
As        
                
      

insert into CustomCancelNoShows
(ServiceId, Status, CancelReason, NoShowNoticeSent, PhysicianCancelNoticeSent, RecordCreatedDate, RecordDeleted, DeletedDate, DeletedBy)
select ServiceId, Status, CancelReason, NULL, NULL, getdate(), RecordDeleted, DeletedDate, DeletedBy
 from services s
where s.status in (72, 73)
and s.modifieddate >= ''03/07/2007''
and isnull(s.recorddeleted, ''N'') = ''N''
and not exists (Select * from CustomCancelNoShows ns
		where ns.serviceid = s.serviceid)
' 
END
GO
