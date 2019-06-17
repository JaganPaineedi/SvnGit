IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_UpdateMoveDocument]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[ssp_UpdateMoveDocument]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON	
GO
    
CREATE  procedure [dbo].[ssp_UpdateMoveDocument] --exec ssp_UpdateMoveDocument @ServiceIdTo=1207,@ServiceIdFrom=1206,@StaffId=550                                     
(                                          
 @ServiceIdTo int,                               
 @ServiceIdFrom int,                              
 @StaffId int    
)                                  
                              
/*********************************************************************                                          
-- Stored Procedure: dbo.ssp_PMServiceMoveDocument                                          
--                                          
-- Copyright: 2010 Streamline Healthcare Solutions                                          
--                                          
-- Purpose: Moves ServiceId from one DocumentId to another.                                          
--                                          
--                                          
-- Updates:                                           
-- Date---------Author--------Purpose-----------------------------------          
-- 13/06/2017   Veena                    Created SP to implement move document functionality Core Bugs #857.1          
-- 16/05/2018   Dasari Sunil			 New Directions - Support Go Live#807. 								 
										 What : Added logic  for add on codes services to be error when the service is error on move documents.
										 Why : when a service is error out on move documents, then add on codes do not error out, they have to be individually error out.                        
**********************************************************************/                                                           
as     
BEGIN                                   
                              
BEGIN TRY         
declare @UserCode varchar(30)                              
declare @DocumentIdTo int                              
declare @DocumentCodeIdTo int                              
declare @ClientIdTo int                              
declare @AuthorIdTo int                              
declare @DocumentIdFrom int                              
declare @DocumentCodeIdFrom int                              
declare @ClientIdFrom int                              
                              
--Find Staff's UserCode                              
Set @UserCode = (Select UserCode From Staff Where StaffId = @StaffId)                              
                            
--Find DocumentId and Client information                              
Select @DocumentIdFrom = d.DocumentId,                              
 @DocumentCodeIdFrom = d.DocumentCodeId,                              
 @ClientIdFrom = d.ClientId,                              
 @ClientIdTo = s.ClientId,                              
 @AuthorIdTo = d.AuthorId                              
From Documents as d                              
Cross Join Services as s                              
where d.ServiceId = @ServiceIdFrom                              
and s.ServiceId = @ServiceIdTo                              
--and isnull(d.RecordDeleted, 'N')= 'N'                              
and isnull(s.RecordDeleted, 'N')= 'N'                              
                              
                              
--Find To Document Id and Author                              
Select @DocumentIdTo = d.DocumentId,                              
 @AuthorIdTo = d.AuthorId,                              
 @DocumentCodeIdTo = d.DocumentCodeId                              
From Documents as d                              
where d.ServiceId = @ServiceIdTo                              
and isnull(d.RecordDeleted, 'N')= 'N'                              
     
                       
Insert into DocumentMoves                              
(DocumentId,ClientIdFrom,ClientidTo,ServiceIdFrom,ServiceIdTo,DateOfMove,MoverId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)                              
Values                              
(@DocumentIdTo,@ClientIdFrom,@ClientIdTo,@ServiceIdFrom,@ServiceIdTo,getdate(),@StaffId,@UserCode,getdate(),@UserCode,getdate()) 
 -- 16/05/2018   Dasari Sunil  
	if(@ServiceIdFrom >0)
			begin
					update  S  
						 set S.[Status]=76 
								From services S
									 where exists(Select  serviceid From  ServiceAddOnCodes SA where SA.AddOnServiceId= S.serviceid
										 and SA.serviceid=@ServiceIdFrom  
										  AND ISNULL(SA.RecordDeleted, 'N') ='N') 
									 AND ISNULL(S.RecordDeleted, 'N') = 'N'
               end
  -- 16/05/2018   Dasari Sunil               
     END TRY                                                                                                                                                                                                                                    
        BEGIN CATCH                                                      
            DECLARE @Error VARCHAR(8000)                                                                                                 
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_UpdateMoveDocument') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                   
            RAISERROR                                                                                                     
  (                                                                                                   
   @Error, -- Message text.                                                                                                                     
   16, -- Severity.                                                                                                                                
   1 -- State.                                                         
  );                                                                                                                              
        END CATCH                                
                                
    END    
  
GO