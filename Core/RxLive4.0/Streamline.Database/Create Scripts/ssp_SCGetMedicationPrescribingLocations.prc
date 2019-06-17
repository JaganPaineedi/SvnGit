/****** Object:  StoredProcedure [dbo].[ssp_SCGetMedicationPrescribingLocations]    Script Date: 02/19/2009 13:17:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
Create  PROCEDURE  [dbo].[ssp_SCGetMedicationPrescribingLocations]       
(              
 @StaffID int              
)       
As        
                
Begin                
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_SCGetMedicationPrescribingLocations                */         
        
/* Copyright: 2008 Medication            */                  
        
/* Creation Date:  9/Feb/2008                                    */                  
/*                                                                   */                  
/* Purpose: Gets Data From Locations Table  */                 
/*                                                                   */                
/* Input Parameters: None */                
/*                                                                   */                   
/* Output Parameters:                                */                  
/*                                                                   */                  
/* Return:   */                  
/*                                                                   */                  
/* Called By: getLocations of particular staff */        
/*      */        
        
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/*   Updates:                                                          */                  
        
/*       Date              Author                  Purpose            */                  
/*  9 /Feb/2008    Rishu Chopra Created  */    
/*  09 Feb 2009    Chandan Srivastava      PrescribingLocation = 'Y'  */
/*	19 Feb 2009		Tom Remisoski			remove "select *" remove join to StaffLoctions.  Fix where clause. */
/*********************************************************************/                   

select LocationId, LocationCode, LocationName, Active, PrescribingLocation, Address, City, State, ZipCode, PhoneNumber,
	LocationType, PlaceOfService, Comment, HandicapAcceess, Adult, Child, MondayFrom, MondayTo, MondayClosed, TuesdayFrom, 
	TuesdayTo, TuesdayClosed, WednesdayFrom, WednesdayTo, WednesdayClosed, ThursdayFrom, ThursdayTo, ThursdayClosed, FridayFrom, 
	FridayTo, FridayClosed, SaturdayFrom, SaturdayTo, SaturdayClosed, SundayFrom, SundayTo, SundayClosed, ExternalReferenceId, 
	FaxNumber, NationalProviderId, RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy
from Locations as loc
where isnull(loc.RecordDeleted,'N') <> 'Y'
and loc.PrescribingLocation = 'Y' 
and loc.Active = 'Y'
      
If (@@error!=0)        
Begin        
   RAISERROR  20006   'ssp_SCGetMedicationPrescribingLocations: An Error Occured'         
   Return        
End                 
                
        
End     
    