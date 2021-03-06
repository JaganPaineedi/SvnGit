 IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[CSP_RDLSUBREPORTHARBORSERVICENOTEHEADER]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[CSP_RDLSUBREPORTHARBORSERVICENOTEHEADER]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
 
 CREATE PROCEDURE [DBO].[CSP_RDLSUBREPORTHARBORSERVICENOTEHEADER]    
 @DocumentVersionId int    
/******************************************************************************    
**  File: csp_RDLSubreportHarborServiceNoteHeader    
**  Name: csp_RDLSubreportHarborServiceNoteHeader    
**  Desc: For Validation  on CustomDocumentMentalStatuses document(For Prototype purpose, Need modification)    
**  Return values: Resultset having validation messages    
**  Called by:    
**  Parameters:    
*******************************************************************************    
**  Change History    
*******************************************************************************    
**  Date:       Author:       Description:    
**  --------    --------        ----------------------------------------------------    
** 2012.02.08 TER    Revised based on Harbor's rules    
** 2015.01.16   RCaffrey        To Comply with Service Diagnosis Data Model 
/*22.12.2017 - Kavya.N     - Changed clientname and ClinicianName format to (Firstname Lastname)*/   
*******************************************************************************/    
as    
    
select    
 isnull(c.FirstName, '') + ' ' + isnull(c.LastName, '') as ClientName,    
 c.ClientId,    
 isnull(st.FirstName, '') + ' ' + isnull(st.LastName, '') as StaffName,    
 pc.DisplayAs as ProcedureName,    
 s.DateOfService,    
 cast(s.Unit as varchar) + ' ' + isnull(gcDuration.CodeName, '') as Duration,    
 isnull(sd1.DSMCode, '')     
  + case when sd2.DSMCode is not null then ', ' + sd2.DSMCode else '' end    
  + case when sd3.DSMCode is not null then ', ' + sd3.DSMCode else '' end    
  as ServiceDiagnosis,    
 isnull(s.ClientWasPresent, 'N') as ClientWasPresent,    
 s.OtherPersonsPresent,    
 l.LocationName    
from DocumentVersions as dv     
join Documents as d on d.DocumentId = dv.DocumentId    
join Services as s on s.ServiceId = d.ServiceId    
LEFT JOIN dbo.ServiceDiagnosis sd1 ON sd1.ServiceId = s.ServiceId AND sd1.[Order] = 1 AND ISNULL(sd1.RecordDeleted, 'N') <> 'Y'    
LEFT JOIN dbo.ServiceDiagnosis sd2 ON sd2.ServiceId = s.ServiceId AND sd2.[Order] = 2 AND ISNULL(sd2.RecordDeleted, 'N') <> 'Y'    
LEFT JOIN dbo.ServiceDiagnosis sd3 ON sd3.ServiceId = s.ServiceId AND sd3.[Order] = 3 AND ISNULL(sd3.RecordDeleted, 'N') <> 'Y'    
join Clients as c on c.ClientId = s.ClientId    
join ProcedureCodes as pc on pc.ProcedureCodeId = s.ProcedureCodeId    
join Staff as st on st.StaffId = s.ClinicianId    
left outer join GlobalCodes as gcDuration on gcDuration.GlobalCodeId = pc.EnteredAs    
left outer join Locations as l on l.LocationId = s.LocationId    
where dv.DocumentVersionId = @DocumentVersionId    
and isnull(d.RecordDeleted, 'N') <> 'Y'    
and isnull(s.RecordDeleted, 'N') <> 'Y'    
and isnull(c.RecordDeleted, 'N') <> 'Y'    
and isnull(pc.RecordDeleted, 'N') <> 'Y' 
