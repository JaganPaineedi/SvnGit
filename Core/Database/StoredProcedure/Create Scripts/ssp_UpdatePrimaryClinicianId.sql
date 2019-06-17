IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_UpdatePrimaryClinicianId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_UpdatePrimaryClinicianId]
GO
 
CREATE Procedure [dbo].[ssp_UpdatePrimaryClinicianId]     
@ClientId int,                     
@PrimaryClinicianId int,   
@ClientInpatientVisitId int = NULL       /* modified by Seema,18/Jan/2016 */
                                 
AS     
/*********************************************************************/                                                                                          
 /* Stored Procedure: [ssp_UpdatePrimaryClinicianId]              */                                                                                 
 /* Creation Date:  24/June/2013                                     */                                                                                          
 /* Purpose: Updates the PrimaryClinicianId in Clients For White Board/Therapist PopUp   */                                                                                        
 /* Input Parameters:@PrimaryClinicianId and ClientId */                    
  /* Output Parameters:   */              
  /*Updates the PrimaryClinicianId in Clients */                                                                                          
 /* Called By:                                                       */                                                                                
 /* Data Modifications:                                              */                                                                                          
 /*   Updates:                                                       */                                                                                          
 /*   Date   Author  Purpose                       */                                                                                          
 /*  24/June/2013  Vithobha  Created                       */          
 /*  18/JAN/2016   Seema     What : Updating ClientInpatientVisits.ClinicianId Instead of Clients.PrimaryClinicianId
							 Why :  Philheaven Development #369   */    
 /********************************************************************/      
BEGIN TRY      
--UPDATE Clients   
/* modified by Seema,18/Jan/2016 */
UPDATE ClientInpatientVisits 
SET    ClinicianId = @PrimaryClinicianId   
WHERE  ClientInpatientVisitId = @ClientInpatientVisitId   
       AND Isnull(recorddeleted, 'N') = 'N' 
END try                                                                                                             
BEGIN CATCH                              
                            
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                        
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_UpdatePrimaryClinicianId')                                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                                       
 RAISERROR                                                                                                         
 (                                                              
  @Error, -- Message text.                                                                                                        
  16, -- Severity.                                     
  1 -- State.                                                                                                        
 );                                                                                                      
END CATCH      
     