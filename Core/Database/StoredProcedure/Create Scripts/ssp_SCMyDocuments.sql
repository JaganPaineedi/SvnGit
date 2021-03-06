/****** Object:  StoredProcedure [dbo].[ssp_SCMyDocuments]    Script Date: 11/18/2011 16:25:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCMyDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCMyDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[ssp_SCMyDocuments]   
@StaffRowIdentifier varchar(150)                                          
AS                    
                  
/*********************************************************************/                                        
/* Stored Procedure: dbo.ssp_MyDocuments                              */                                        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC      */                                        
/* Creation Date:    4/24/05                                         */                                        
/*                                                                   */                                        
/* Purpose:   Populate the My Documents Page in the application        */                                        
/*                                                                   */ /* Input Parameters: @StaffId - StaffId for current user       */                                        
/*                                                                   */                                        
/* Output Parameters:   None                                         */                                        
/*                                                                   */                                        
/* Return:  0=success, otherwise an error number                 */                                        
/*                                                                   */                                        
/* Called By:                  */                                        
/*                                                                   */                                        
/* Calls:                                                            */                                        
/*                                                                   */                                        
/* Data Modifications:                                               */                                        
/*                                                                   */                                        
/* Updates:                                                          */                                        
/*   Date     Author       Purpose                                  */                                        
/*  7/18/05   JHUSAIN    Created          */                                       
/*            Modified by saurabh                                       
 TO FETCH GLOBALCODEID FROM GLOBALCODES    */                                  
/* 08/01/05  Kulwinder  Modified                                 */                                  
/*17 july 2006 Tarunjit Singh Modified      */                        
/* 4-Feb-2008 TREMISOSKI removed requirement for Active Clients */      
/*13th-Aug-2008 Vikas Vyas As per task #198 */
/*19th -Aug-2008 Vikas Vyas as per task #2562*/    
/*								removed dead code      */   
/* 1-March-2017  vsinha			What:  Length of "Display As" to handle procedure code display as increasing to 75     
								Why :  Keystone Customizations 69  	   */             
/*********************************************************************/                                        
BEGIN   
BEGIN TRY     
Declare @varClinicianId as int                                  
Declare @StaffPrimaryProgramId as int                            
SELECT @varClinicianId=StaffId,@StaffPrimaryProgramId=PrimaryProgramId FROM  Staff where RowIdentifier=@StaffRowIdentifier                            
                                       
create table #Document(DocumentID int,ClientID int,DocumentCodeID int,DocumentShared char(1), EffectiveDate DateTime,DueDate DateTime,                                      
Status int,AuthorID int,SignedByAuthor varchar(1),CoSign varchar(50),ToSign char(1),DisplayDocumentAsProcedureCode char(1),DisplayAs varchar(75))  --1-March-2017  vsinha                                    
                                      
-- Insert Documents where Current Clinician is author   
INSERT INTO #Document                                      
select a.DocumentID,a.ClientID,a.DocumentCodeID,a.DocumentShared,a.EffectiveDate,a.DueDate,a.Status,a.AuthorID,a.SignedByAuthor,'',case when a.AuthorId = @varClinicianId then a.ToSign else null end     
,PC.DisplayDocumentAsProcedureCode as DisplayDocumentAsProcedureCode ,PC.DisplayAs as  DisplayAs    
from Documents a    
left join Services S on a.ServiceID  =  S.ServiceId  --        due to task 1720 by sandeep trivedi   
--Following Condition Added by Vikas Vyas In ref to task #2562 On Dated Aug 19,2008                
left join DocumentCodes DC on a.DocumentCodeID = Dc.DocumentCodeID and DC.ServiceNote = 'Y'                                                  
left join ProcedureCodes PC on S.ProcedureCodeID = PC.ProcedureCodeID                                         
--End  
                  
where Isnull(a.RecordDeleted,'N') ='N'             and isNull(S.RecordDeleted,'N')='N'                                
and (a.AuthorId = @varClinicianId or a.ProxyId= @varClinicianId)                                    
and a.Status in (20, 21)  -- and status must be To DO or In Progress                                      
UNION                                      
-- Insert Documents where Current Clinician is Co-Signer                                      
select a.DocumentID,a.ClientID,a.DocumentCodeID,a.DocumentShared,a.EffectiveDate,a.DueDate,a.Status,a.AuthorID,a.SignedByAuthor,'',null                                      
,'' as  DisplayDocumentAsProcedureCode,'' as DisplayAs  from Documents a JOIN  DocumentSignatures i  ON (a.DocumentId = i.DocumentId                                        
and i.StaffId = @varClinicianId                                     
-- Changed logic for Co-sign                                     
and a.AuthorId <> @varClinicianId                                  
and a.SignedbyAuthor = 'Y'                                  
and a.DocumentShared = 'Y'                                        
and IsNull(a.RecordDeleted,'N')='N'                                
and Isnull(i.RecordDeleted,'N') ='N'       )                   
                  
--left join Services S on a.ServiceID = S.ServiceId  and isNull(S.RecordDeleted,'N')='N'  --due to task 1720 by sandeep trivedi                                     
                                
UNION                                
                           
select a.DocumentID,a.ClientID,a.DocumentCodeID,a.DocumentShared,a.EffectiveDate,a.DueDate,a.Status,a.AuthorID,a.SignedByAuthor,'',null                                      
,'' as  DisplayDocumentAsProcedureCode,'' as DisplayAs  from Documents a                  
                  
--left join Services S on a.ServiceID = S.ServiceId  and isNull(S.RecordDeleted,'N')='N'  --due to task 1720 by sandeep trivedi                  
                  
 where Isnull(a.RecordDeleted,'N') ='N'                                             
and (a.AuthorId = @varClinicianId or a.ProxyId=  @varClinicianId)                                                      
and a.Status =22 and isnull(signedbyauthor,'N')='N'  -- and status must be To DO or In Progress                        
                  
                         
                                      
UNION                              
                              
select a.DocumentID,a.ClientID,a.DocumentCodeID,a.DocumentShared,a.EffectiveDate,a.DueDate,a.Status,a.AuthorID,a.SignedByAuthor,'',null                                    
,'' as  DisplayDocumentAsProcedureCode,'' as DisplayAs  from Documents a JOIN  DocumentSignatures i  ON (a.DocumentId = i.DocumentId                                        
and i.StaffId = @varClinicianId                                     
-- Changed logic for Co-sign                                     
and (a.AuthorId = @varClinicianId or a.ProxyId=  @varClinicianId)                                              
and a.SignedbyAuthor = 'Y'                                  
and a.DocumentShared = 'Y'                         
and IsNull(a.RecordDeleted,'N')='N'                                     
and Isnull(i.RecordDeleted,'N') ='N')                          
                  
--left join Services S on a.ServiceID = S.ServiceId  and isNull(S.RecordDeleted,'N')='N'  --due to task 1720 by sandeep trivedi                   
                  
                      
                              
IF (@@error!=0)                                      
    BEGIN 
    
    RAISERROR                                                                                                           
		(                                                                             
		'ssp_MyDocuments: An error  occured'  , -- Message text.         
		16, -- Severity.         
		1 -- State.                                                           
		)          
        RETURN(1)                                      
    END                                      
                      
--select * into DocumentDummy from #Document where DocumentCodeID not in(2,3,6)                
                      
-- Modified by Dinesh and Replaced ExternalClientID with ClientID                                       
--Commented by Vikas Vyas On Dated Aug 13,2008 in ref to task #198    
--select Distinct  C.ClientID as ExternalClientId, c.ClientID,rtrim(c.LastName) as LastName ,        
--rtrim(c.FirstName) as FirstName,                 
--End        
--Added by Vikas Vyas On Dated Aug 13,2008 in ref to task #198                     
select Distinct  C.ClientID as ExternalClientId,c.ClientID,rtrim(c.LastName) +', '+  rtrim(c.FirstName) as [Name] ,                     
f.DocumentName   as Document ,                                    
Convert(datetime,convert(varchar(20),a.EffectiveDate,101)) as EffectiveDate, case when isnull(a.SignedByAuthor,'N')='N' and h.CodeName='Completed' then 'Completed' when a.SignedByAuthor='Y' and h.CodeName='Completed' then 'Signed' else h.CodeName end as 
   
    
--End    
--Commented by Vikas Vyas On Dated Aug 13,2008 in ref to task #198                     
--case when a.documentcodeid=2 then           
--case when isnull(TP.PlanOrAddendum,'P')='A' then 'TxPlan Addendum' else f.DocumentName  end          
--else f.DocumentName  end  as Document ,                                    
--Convert(datetime,convert(varchar(20),a.EffectiveDate,101)) as EffectiveDate, case when isnull(a.SignedByAuthor,'N')='N' and h.CodeName='Completed' then 'Completed' when a.SignedByAuthor='Y' and h.CodeName='Completed' then 'Signed' else h.CodeName end as
  
      
              
Status,h.GlobalCodeId,                                         
a.DueDate,  a.SignedByAuthor    ,                                
case when z.DocumentID is not null then                                         
 case when isnull(z.DeclinedSignature,'N') = 'Y' then 'Declined'                                        
  when z.SignatureDate is not null then 'Co-Signed'                              
  else 'To Co-Sign'                                        
 end                                        
else null end as CoSign, -- status for 'To Co-Sign'                                      
case when y.DocumentID is not null then                               
 case when isnull(y.DeclinedSignature,'N') = 'Y' then 'Declined'                                        
  when y.SignatureDate is not null then 'Client Signed'                                        
  when y.ClientSignedPaper = 'Y' then 'Signed Paper'                                        
 else 'Client Sign'  -- status for 'Client Sign'                                      
 end                                        
else null end as ClientSign,                                     
case  when a.DocumentShared ='Y' then 'Yes'  else 'No' end as Shared,                                        
Case when e.ClientID is null then 'No' else 'Yes' end as PrimaryClient,                                      
 rtrim(g.LastName) AuthorLastName , rtrim(g.FirstName) AuthorFirstName,                                      
a.DocumentID,F.DocumentCodeId,a.ToSign   
  
--Added by Vikas Vyas in ref to task #2562 On Dated Aug 19, 2008  
, case when isnull(a.DisplayDocumentAsProcedureCode,'N')<>'Y' then f.DocumentName  
      else Isnull(a.DisplayAs,'')  end as DisplayAs   
--End                                    
 from #Document a                                      
LEFT JOIN DocumentSignatures z  -- join with DocumentSignatures for fecthing 'To Co-Sign' status                                      
ON a.DocumentID = z.DocumentID  and                                       
z.StaffId = @varClinicianId       and                                
 z.StaffId <> a.AuthorID                                        
and z.SignatureDate is null                                        
and Isnull(z.RecordDeleted,'N') ='N'                        
and isnull(z.DeclinedSignature,'N') = 'N'                                      
and a.Status=22                                  
LEFT JOIN DocumentSignatures y  -- join with DocumentSignatures for fecthing 'Client Sign' status                                      
ON a.DocumentID = y.DocumentID and                                       
y.IsClient = 'Y'                                        
and y.SignatureDate is null                                        
and Isnull(y.RecordDeleted,'N') ='N'                        
and isnull(y.DeclinedSignature,'N') = 'N'                                        
and isnull(y.ClientSignedPaper,'N') = 'N'           
-- tremisoski 2/4/2008                                  
JOIN Clients c  ON (a.ClientID = c.ClientID /*and (c.Active='Y' or (c.Active='N' and a.Status=21)) */ )        
--and c.PrimaryClinicianId = @varClinicianId)        -- Added Condition For PrimaryClinicianID from Clients table in place of ClinicianID from ClientsProgram Table                           
                    
                   
left JOIN ClientEpisodes  d ON (c.ClientID = d.ClientID                                        
and c.CurrentEpisodeNumber = d.EpisodeNumber)                                        
-- To find out if the staff id is the primary clinician for the client                                        
LEFT JOIN ClientPrograms e ON (d.ClientId = e.ClientId                                        
-- Commented Two Lines from Gursharn Singh                                
--and d.EpisodeNumber = e.EpisodeNumber                                        
--and e.ClinicianId = @varClinicianId             
and Isnull(e.RecordDeleted,'N') ='N'                                            
and (e.PrimaryAssignment = 'Y'))-- or e.ProgramId=@StaffPrimaryProgramId))                 
                                                           
JOIN DocumentCodes f ON (a.DocumentCodeID = f.DocumentCodeID)                              
JOIN Staff g ON (a.AuthorID  = g.StaffId)                   
JOIN GlobalCodes h ON (a.Status  = h.GlobalCodeId)               
--Commented by Vikas Vyas in ref to task #198 On dated Aug 13,2008    
--left outer Join TpGeneral Tp on (Tp.DocumentId=a.Documentid)               
      
IF (@@error!=0)                                      
    BEGIN   
		RAISERROR                                                                                                           
		(                                                                             
		'ssp_MyDocuments: An error  occured' , -- Message text.         
		16, -- Severity.         
		1 -- State.                                                           
		)                                                                      
		RETURN(1)                                      
    END                                      
                                      
drop table #Document                                      
                                      
RETURN(0)

END TRY 
BEGIN CATCH 
DECLARE @Error varchar(8000)                                                                          
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCMyDocuments')                                                                                                           
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
+ '*****' + Convert(varchar,ERROR_STATE())                                                        
RAISERROR                                                                                                           
(                                                                             
@Error, -- Message text.         
16, -- Severity.         
1 -- State.                                                           
); 
END CATCH
END
GO

