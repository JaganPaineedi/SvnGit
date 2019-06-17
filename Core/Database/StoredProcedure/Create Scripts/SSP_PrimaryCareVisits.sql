IF OBJECT_ID('dbo.SSP_PrimaryCareVisits') IS NOT NULL
    DROP PROCEDURE dbo.SSP_PrimaryCareVisits
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[SSP_PrimaryCareVisits]     
 @clientId int,  
 @staffid int  
AS    
/************************************************************************************/                            
/* Stored Procedure: dbo.[SSP_PrimaryCareVisits]12,93      */                            
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */                            
/* Creation Date:   08/08/2012                 */                                                         
/*                        */                          
/* Input Parameters: @clientId,@staffid           */                          
/*                     */                            
/* Output Parameters:   None              */                            
/*                     */                            
/* Return:  0=success, otherwise an error number         */                            
/*                     */                            
/* Called By:                  */                            
/*                     */                            
/* Calls:                   */                            
/*                     */                            
/* Data Modifications:                */                            
/*                     */                            
/* Updates:                   */                            
/*  Date   Author      Purpose            */                            
/* 08-08-2012  Anil Kumar chaturvedi  Created          */   
/* 17/Sep/2012  Mamta Gupta     Ref Task No. 32/ Primary Care - Summit Pointe - To get AppointmentId, ServiceId, StaffId  
            To open My Calendar page on Date link   
 21/Sep/2012  Mamta Gupta     Ref Task No. 32/ Primary Care - Summit Pointe - RecordDeleted check added and   
            EndTime column included to get value   
*/                      
/************************************************************************************/   
BEGIN   
 BEGIN TRY   
/*                          Visits      */  
 /*       Start         */  
 
 CREATE TABLE #StaffProxies(StaffId INT,
		ProxyForStaffId INT
		)

		INSERT INTO #StaffProxies
		SELECT StaffId, ProxyForStaffId FROM StaffProxies
		WHERE StaffId = @StaffId AND ISNULL(RecordDeleted, 'N') = 'N'

		UNION

		SELECT @StaffId, @StaffId
 
  select   
   --Added By Mamta Gupta - Ref Task No. 32 - Primary Care - Summit Pointe  
   
   CASE   
    WHEN DOC.CurrentVersionStatus = 21  
    AND (DOC.AuthorId = @StaffId OR (SP.ProxyForStaffId = DOC.AuthorId AND SP.StaffId = @StaffId)) 
     --AND CAST(DOC.EffectiveDate AS DATE) = CAST(GETDATE() AS DATE)  
     THEN 'NonEditable.png'  
    WHEN DOC.CurrentVersionStatus = 21  
     AND DOC.AuthorId = @StaffId  
     --AND CAST(DOC.EffectiveDate AS DATE) = CAST(GETDATE() AS DATE)  
     THEN 'InProgress.png'  
    WHEN DOC.CurrentVersionStatus = 22  
     --AND CAST(DOC.EffectiveDate AS DATE) = CAST(GETDATE() AS DATE)  
     THEN 'signed.png'  
    WHEN DOC.DocumentCodeId IS NULL  AND (AP.StaffId = @StaffId OR (SP.ProxyForStaffId = AP.StaffId AND SP.StaffId = @StaffId))
     THEN 'New.png'  
    ELSE 'NonEditable.png'  
    END AS [Image]
    , @clientId AS 'ClientId'
    ,CASE   
    WHEN DOC.CurrentVersionStatus = 21  
     AND DOC.AuthorId != 1  
     THEN 'Auto'  
    ELSE 'hand'  
    END AS [Cursor]
   ,ISNULL(DOC.DocumentId, - 1) AS DocumentId  
   ,ISNULL(DOC.CurrentDocumentVersionId, - 1) AS CurrentDocumentVersionId 
   ,ISNULL(DP.TemplateID, - 1) AS TemplateID 
   
   ,ap.AppointmentId,  
   ap.ServiceId,  
   ap.StaffId,   
   ap.EndTime, 
    --Changes End   
   ap.StartTime,  
   gc.CodeName as Type,  
   s.LastName +', '+s.FirstName as Provider
   ,dbo.GetGlobalCodeName(ap.status) AS [Status]   
  from Appointments as ap inner join GlobalCodes gc on gc.GlobalCodeId=ap.AppointmentType and ap.status NOT IN(8043,8042,8044,8045) 
  inner join Staff s on ap.StaffId =s.StaffId
  LEFT JOIN Documents DOC ON DOC.AppointmentId = AP.AppointmentId 
  AND ISNULL(DOC.RecordDeleted, 'N') = 'N'  
  LEFT JOIN DocumentProgressNotes DP ON DP.DocumentVersionId = DOC.CurrentDocumentVersionId   
LEFT JOIN #StaffProxies SP ON SP.StaffId = @StaffId AND SP.ProxyForStaffId = AP.StaffId 
  where isnull(ap.RecordDeleted,'N')='N' and ap.ClientId=@clientId  
  
  order by ap.StartTime asc  
 /* END */  
   
   
   
 END TRY  
   
 BEGIN CATCH                                                                      
  DECLARE @Error varchar(8000)            
  SET @Error = convert(VARCHAR, ERROR_NUMBER()) + '*****' + convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_PrimaryCareVisits') + '*****' + convert(VARCHAR, ERROR_LINE()) + '*****' +         
  convert(VARCHAR, ERROR_SEVERITY()) + '*****' + convert(VARCHAR, ERROR_STATE())                                                                                        
            
   RAISERROR          
   (          
   @Error, -- Message text.          
   16, -- Severity.          
   1 -- State.          
   )          
 End CATCH    
END 