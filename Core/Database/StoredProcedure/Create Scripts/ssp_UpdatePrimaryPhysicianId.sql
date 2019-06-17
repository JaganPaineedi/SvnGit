IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_UpdatePrimaryPhysicianId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_UpdatePrimaryPhysicianId]
GO
  
Create Procedure [dbo].[ssp_UpdatePrimaryPhysicianId]   
@ClientId int,                   
@PrimaryPhysicianId int,
@ClientInpatientVisitId int = NULL  /* Modified by Seema, 18/Jan/2016 */  
                               
AS   
/*********************************************************************/                                                                                        
 /* Stored Procedure: [ssp_UpdatePrimaryClinicianId]              */                                                                               
 /* Creation Date:  24/June/2013                                     */                                                                                        
 /* Purpose: Updates the PrimaryClinicianId in Clients For White Board/Attending Physician PopUp   */                                                                                      
 /* Input Parameters:@PrimaryClinicianId and ClientId */                  
  /* Output Parameters:   */            
  /*Updates the PrimaryPhysicianId in Clients */                                                                                        
 /* Called By:                                                       */                                                                              
 /* Data Modifications:                                              */                                                                                        
 /*   Updates:                                                       */                                                                                        
 /*   Date			Author		Purpose                       */                                                                                        
 /*  24/June/2013  Vithobha		Created                       */        
 /*	 18/JAN/2016   Seema		What: Updating ClientInpatientVisits.PhysicianId Instead of Clients.PrimaryPhysicianId
							    Why :  Philheaven Development #369 */
 /********************************************************************/    
  BEGIN TRY  
--UPDATE Clients 
/* Modified by Seema, 18/Jan/2016 */
UPDATE ClientInpatientVisits   
SET    PhysicianId = @PrimaryPhysicianId 
WHERE   ClientInpatientVisitId = @ClientInpatientVisitId 
       AND Isnull(recorddeleted, 'N') = 'N'   
       
       END try                                                                                                             
BEGIN CATCH                              
                            
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                        
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_UpdatePrimaryPhysicianId')                                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                                       
 RAISERROR                                                                                                         
 (                                                              
  @Error, -- Message text.                                                                                                        
  16, -- Severity.                                     
  1 -- State.                                                                                                        
 );                                                                                                      
END CATCH     
  