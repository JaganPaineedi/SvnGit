/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateTimeline]    Script Date: 11/18/2011 16:26:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateTimeline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateTimeline]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateTimeline]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  procedure [dbo].[ssp_SCUpdateTimeline]
--@DocumentId int
@DocumentVersionId int
AS

/*********************************************************************/
/* Stored Procedure: dbo.ssp_UpdateTimeline                              */
/* Copyright:	2005 Streamline Healthcare Solutions,  LLC	     */
/* Creation Date:    4/24/05                                         */
/*                                                                   */
/* Purpose:  Updates Timeline tables when a Service/Note or a Diagnosis is created	        */
/*                                                                   */
/* Input Parameters:	@DocumentId					*/
/*			  	     */
/*                                                                   */
/* Return: 	0=success, otherwise an error number                 */
/*                                                                   */
/* Called By:       						     */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  7/28/05   JHUSAIN	  Created   
/*  9/25/2009 Mohit Madaan Replace documentId to DocumentVersionId   */                                 */
/*  16 May 2017 Manjunath K Taking @ClientId from Documents table instead of Service. */
/*********************************************************************/

declare @ClientId int
declare @AxisV int
declare @DiagnosisDate datetime
declare @DateOfService  datetime

-- Get the Date of Service and Axis V for ServiceNote
select @DateOfService = isnull(b.DateOfService,a.effectiveDate), 
@ClientId = a.ClientId, /*16 May 2017 Manjunath K*/
@DiagnosisDate = isnull(b.DateOfService, a.effectiveDate), @AxisV = isnull(c.AxisV,d.AxisV)
from  Documents a
left join Services b ON (a.ServiceId = b.ServiceId)
--left JOIN Notes c ON (a.DocumentId = c.DocumentId
left JOIN Notes c ON (a.CurrentDocumentVersionId = c.DocumentVersionId)
--and a.CurrentVersion = c.[Version])
--left join DiagnosesV d on d.documentId = a.documentId
left join DiagnosesV d on d.DocumentVersionId= a.CurrentDocumentVersionId
--where a.DocumentId = @DocumentId
where a.CurrentDocumentVersionId= @DocumentVersionId
 and ISNULL(a.RecordDeleted,''N'')=''N''
 and ISNULL(b.RecordDeleted,''N'')=''N''
 and ISNULL(c.RecordDeleted,''N'')=''N''
 and ISNULL(d.RecordDeleted,''N'')=''N''

if @@error <> 0 goto error

-- Get the AxisV value for diagnosis document

if @ClientId is null
begin

select @AxisV = a.AxisV, @DiagnosisDate = b.EffectiveDate, @ClientId = b.ClientId
from DiagnosesV a
--JOIN Documents b ON (a.DocumentId = b.DocumentId)
JOIN Documents b ON (a.DocumentVersionId = b.CurrentDocumentVersionId)
--and a.Version = b.CurrentVersion)
--where a.DocumentId = @DocumentId
where a.DocumentVersionId = @DocumentVersionId
 and ISNULL(a.RecordDeleted,''N'')=''N''
 and ISNULL(b.RecordDeleted,''N'')=''N''

if @@error <> 0 goto error

end
-- Update TimelineAxisV
if @ClientId is not null and  @DiagnosisDate is not null and isnull(@AxisV,0) <> 0
and not exists (select * from TimelineAxisV where ClientId = @ClientId and
DiagnosisDate = convert(datetime, convert(varchar,@DateOfService,101)))
begin
insert into TimelineAxisV
(ClientId, DiagnosisDate, Score)
select @ClientId, convert(datetime, convert(varchar, @DiagnosisDate, 101)), @AxisV
if @@error <> 0 goto error

end


-- Update TimelineServices
if @ClientId is not null and  @DateOfService is not null 
and not exists (select * from TimelineServices where ClientId = @ClientId and ServiceDate = 
convert(datetime, convert(varchar,@DateOfService,101)))
begin
insert into TimelineServices
(ClientId, ServiceDate)
select @ClientId, convert(datetime, convert(varchar,@DateOfService,101))
if @@error <> 0 goto error

end

return

rollback_tran:

ROLLBACK TRANSACTION

error:









' 
END
GO
