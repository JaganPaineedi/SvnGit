
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAllDocumentsByGroupServiceId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAllDocumentsByGroupServiceId]
GO

CREATE PROCEDURE [dbo].[ssp_GetAllDocumentsByGroupServiceId]   --3309,3310    
(      
  @GroupServiceIdOld  int,      
  @GroupServiceIdNew  int      
)      
AS      
/*********************************************************************/                                                                            
 /* Stored Procedure: [ssp_GetAllDocumentsByGroupServiceId]      */                                                                   
 /* Creation Date:  09/April/2012         */                                                                            
 /* Purpose: get the group detail  */                                                                          
 /* Input Parameters: @GroupServiceId                  */                                                                          
 /* Output Parameters:     get All document  list by group service id */                                                                            
 /* Called By: Document.cs            */                                                                  
 /* Data Modifications:              */                                                                            
 /*   Updates:                */                                                                            
 /*   Date     Author           */                                                                            
 /*  09/April/2012        Rakesh-II          */ 
 /*  29/april/2013        jaswinderjeet add s.groupServiceid=d.groupServiceid instead of d.groupServiceid and remove s.groupServiceid=d.groupServiceid      */                                                                      
						/* for task thresholds bug and features 3060*/	
 /*  13/oct/2015		Revathi			what:If ClientType =''I'' then Client FirstName and LastName and If ClientType=''O'' then OrganizationName  */ 
 /*		why:task #609 Network180 Customization  		*/ 	
 /*********************************************************************/       
 BEGIN      
  BEGIN TRY      
      
--old        
   Select   c.clientid,case when  ISNULL(C.ClientType,'I')='I' then  isnull((c.LastName +', ' +firstName),'') else C.OrganizationName end as name         
  ,'' as NewService,0 as NewServiceStatusID, 0 as NewServiceID        
  --,isnull(dbo.GetGlobalCodeName(d.currentversionStatus),'') as NewDoc         
  ,'' as NewDoc ,0 as NewDocID        
  ,isnull(dbo.GetGlobalCodeName(s.Status),'') as OldService , s.Status as OldServiceStatusID        
  ,d.ServiceId  as  OldServiceID         
  ,isnull(dbo.GetGlobalCodeName(d.Status),'') as OldDoc ,d.Status as OldDocID         
  ,isnull(s.comment,'') as comment ,   d.DocumentId as OldDocumentId, 0 as NewDocumentId,d.AuthorId as OldAuthorId,0 as NewAuthorId,gs.GroupId as OldGroupId,0 as NewGroupId, gs.GroupServiceId as OldGroupServiceId, 0 as NewGroupServiceId     
  FROM  Documents d        
  INNER  JOIN clients c on c.clientId=d.clientId         
  INNER JOIN  services s on  s.clientid=c.clientid and s.ServiceId=d.ServiceId --s.groupServiceid=d.groupServiceid and  
  INNER join GroupServices gs on  gs.groupServiceid= s.groupServiceid      
  --where d.groupServiceid = @GroupServiceIdOld    ORDER BY c.clientid        
   where  d.Serviceid IS NOT null and s.groupServiceid=@GroupServiceIdOld and  isnull(d.recordDeleted,'N')<>'Y'  --d.groupServiceid=@GroupServiceIdOld       
  and  isnull(s.recordDeleted,'N')<>'Y'      
  ORDER BY c.clientid       
--new        
 Select   c.clientid, case when  ISNULL(C.ClientType,'I')='I' then  isnull((c.LastName +', ' +firstName),'') else C.OrganizationName end as name          
  ,isnull(dbo.GetGlobalCodeName(s.Status),'') as NewService,        
  s.Status as NewServiceStatusID, d.ServiceId  as NewServiceID        
  --,isnull(dbo.GetGlobalCodeName(d.currentversionStatus),'') as NewDoc         
  ,isnull(dbo.GetGlobalCodeName(d.Status),'') as NewDoc ,d.Status as NewDocID        
  ,'' as OldService , 0 as OldServiceStatusID,     
  0 as  OldServiceID         
  ,'' as OldDoc ,0 as OldDocID         
  ,isnull(s.comment,'') as comment,  0 as OldDocumentId, d.DocumentId as NewDocumentId,0 as OldAuthorId,d.AuthorId as NewAuthorId ,0 as OldGroupId,gs.GroupId as NewGroupId, 0 as OldGroupServiceId, gs.GroupServiceId as NewGroupServiceId          
  FROM  Documents d        
  INNER  JOIN clients c on c.clientId=d.clientId         
  inner JOIN  services s on  s.clientid=c.clientid and s.ServiceId=d.ServiceId  --s.groupServiceid=d.groupServiceid and     
  inner join GroupServices gs on  gs.groupServiceid= s.groupServiceid  
  --where d.groupServiceid =@GroupServiceIdNew   ORDER BY c.clientid           
   where  d.Serviceid IS NOT null and s.groupServiceid=@GroupServiceIdNew and  isnull(d.recordDeleted,'N')<>'Y'         
  and  isnull(s.recordDeleted,'N')<>'Y'      
  ORDER BY c.clientid       
        
  END TRY        
 BEGIN CATCH        
 DECLARE @Error varchar(8000)                                                                                                                                        
 SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                                                         
 + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetAllDocumentsByGroupServiceId')                                                                 
 + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                                                         
 + '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                                                                                       
 RAISERROR                                                                                
 (                                                                                  
 @Error, -- Message text.                                                                                                      
 16, -- Severity.                           
 1 -- State.                                                                  
 );         
 END CATCH        
END
GO


