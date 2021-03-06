/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportServiceNoteHeaderNew]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportServiceNoteHeaderNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportServiceNoteHeaderNew]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportServiceNoteHeaderNew]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_RdlSubReportServiceNoteHeaderNew]  
@DocumentVersionId int          
 AS           
/*          
** Object Name:  [csp_RdlSubReportServiceNoteHeader]          
**          
**          
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set           
**    which matches those parameters.           
**          
** Programmers Log:          
** Date  Programmer  Description          
**------------------------------------------------------------------------------------------          
**        
** Oct 08 2007 Ranjeetb     
** 10-21-2009 avoss		modified to correctly calculate duration based on procedurecode    
** 08.27.2010 avoss		new for documentVersionId variable   
*/          
      
SELECT  DocumentCodes.DocumentName,Documents.DocumentId,
		dv.DocumentVersionId,
		(select OrganizationName from SystemConfigurations ) as OrganizationName,
		pc.DisplayAs, 
		ISNULL(Clients.FirstName, '''') + '' '' + ISNULL(Clients.LastName, '''') AS ClientName, 
		Clients.ClientId,
        GlobalCodes.CodeName AS Status, 
		ISNULL(Staff.FirstName, '''') + '' '' + ISNULL(Staff.LastName, '''') AS StaffName, 
		Services.EndDateOfService as EndTime,       
        Convert(varchar(8),Services.DateOfService,1) as DateOfService, 
		Services.DateOfService as StartTime, 
		case gc2.GlobalCodeId 
		when 112--''Days'' 
			then case when convert(varchar(7),DATEDIFF(dd, Services.DateOfService, Services.EndDateOfService) ) = 1 
					then convert(varchar(7),DATEDIFF(dd, Services.DateOfService, Services.EndDateOfService) ) + '' ''
					+ case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))=''s'' 
						then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'''') 
						else gc2.CodeName end
			else convert(varchar(7),DATEDIFF(dd, Services.DateOfService, Services.EndDateOfService) ) +  '' '' + gc2.Codename end
		when 111--''Hours''
			then case when convert(varchar(7),DATEDIFF(hh, Services.DateOfService, Services.EndDateOfService) ) = 1 
					then convert(varchar(7),DATEDIFF(hh, Services.DateOfService, Services.EndDateOfService) ) + '' ''
					+ case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))=''s'' 
						then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'''') 
						else gc2.CodeName end
			else convert(varchar(7),DATEDIFF(hh, Services.DateOfService, Services.EndDateOfService) ) + '' '' +  gc2.Codename end
		when 113 --''Items''
			then case when services.Unit = 1 
				then convert(varchar(7),services.Unit) + '' ''
					+ case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))=''s'' 
						then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'''') 
						else gc2.CodeName end
			else convert(varchar(7),services.Unit) +  '' '' + gc2.Codename end
		when 114 --''mg''
			then convert(varchar(7),services.Unit) +  '' '' + gc2.Codename
		when 110 --''Minutes'' 
			then case when convert(varchar(7),DATEDIFF(mi, Services.DateOfService, Services.EndDateOfService) ) = 1 
					then convert(varchar(7),DATEDIFF(mi, Services.DateOfService, Services.EndDateOfService) ) + '' ''
					+ case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))=''s'' 
						then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'''') 
						else gc2.CodeName end
			else convert(varchar(7),DATEDIFF(mi, Services.DateOfService, Services.EndDateOfService) ) + '' '' + gc2.Codename end
		when 116 --''Units''
			then case when services.Unit = 1 
				then convert(varchar(7),services.Unit) + '' ''
					+ case when substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName))=''s'' 
						then replace(gc2.CodeName,substring(gc2.CodeName,len(gc2.CodeName),len(gc2.CodeName)),'''') 
						else gc2.CodeName end
			else convert(varchar(7),services.Unit) +  '' '' + gc2.Codename end
		end AS Duration      
FROM documentVersions dv  
join Documents on documents.DocumentId = dv.DocumentId and isnull(documents.RecordDeleted,''N'')<>''Y''
INNER JOIN Clients ON Documents.ClientId = Clients.ClientId   and isnull(clients.RecordDeleted,''N'')<>''Y''
INNER JOIN Services ON Documents.ServiceId = Services.ServiceId AND Clients.ClientId = Services.ClientId  and isnull(Services.RecordDeleted,''N'')<>''Y''
Inner join ProcedureCodes pc on pc.ProcedureCodeid=Services.ProcedureCodeid and isnull(pc.RecordDeleted,''N'')<>''Y''
Inner join DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId  and isnull(DocumentCodes.RecordDeleted,''N'')<>''Y''
INNER JOIN Staff ON Documents.AuthorId = Staff.StaffId and isnull(Services.RecordDeleted,''N'')<>''Y''
INNER JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = Services.Status 
left join globalcodes gc2 on gc2.GlobalCodeId = pc.EnteredAs
where dv.DocumentVersionId = @DocumentVersionId
--Documents.DocumentId =@DocumentId 
--and DocumentVersions.Version=@Version
' 
END
GO
