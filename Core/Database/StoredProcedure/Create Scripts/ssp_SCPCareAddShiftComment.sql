IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCPCareAddShiftComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCPCareAddShiftComment]
GO

CREATE PROCEDURE  [dbo].[ssp_SCPCareAddShiftComment]  
(
@CreatedBy varchar(30),
@CreatedDate datetime,
@PersonalCareServicesAndCLSId int,
@PersonalCareAndCLSActivityId int,
@ShiftNumber int,
@ShiftDate datetime,
@Comment text
)            
                                      
As                                                                                                                                                      
/************************************************************************/                                                              
/* Stored Procedure: ssp_SCPCareAddShiftComment        */                                                     
/*        */                                                              
/* Creation Date:  13 September 2012           */                                                              
/*                  */                                                              
/* Purpose:It is used for insert comments corressponding to particular shift.  */                                                       
/* Input Parameters:        */                                                            
/* Output Parameters:             */                                                              
/* Purpose:        */                                                    
/* Calls:                */                                                              
/*                  */                                                              
/* Author: Rachna Singh             */ 
/* Updates:                   */            
/*  Date           Author             Purpose            */            
/* 09-sept-2012    Rachna Singh            */  
/*********************************************************************/    
BEGIN  
	DECLARE @Error varchar(8000)  
	DECLARE @GlobalCodeIdMonth int;
	BEGIN TRY                                     
		BEGIN	   
			IF NOT EXISTS(SELECT 'x' FROM PersonalCareServicesAndCLSs 
							INNER JOIN GlobalCodes ON [MONTH] = GlobalCodeId						 
						WHERE MONTH(@ShiftDate) = CODE AND PersonalCareServicesAndCLSId = @PersonalCareServicesAndCLSId
				)
			BEGIN		
				SET @Error = 'Date month not matched'
				GOTO ERROR
			END
		      
			  SELECT @GlobalCodeIdMonth=GlobalCodeId FROM GlobalCodes WHERE Category='PCARECLSMONTH' AND Code= MONTH(getdate())
		      
		      
			INSERT INTO PersonalCareAndCLSShiftComments(	
				CreatedBy,
				CreatedDate,
				ModifiedBy,
				ModifiedDate,	
				PersonalCareServicesAndCLSId,
				PersonalCareAndCLSActivityId,
				ShiftNumber,
				ShiftDate,
				Comment
					  )
			VALUES(
				@CreatedBy,
				@CreatedDate,
				@CreatedBy,
				@CreatedDate,
				@PersonalCareServicesAndCLSId,
				@PersonalCareAndCLSActivityId,
				@ShiftNumber,
				@ShiftDate,
				@Comment
			  )								  		
		 END                                                                                        
	END TRY                                                                                                 
	BEGIN CATCH                                                                                                                            
		   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
		   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCPCareAddShiftComment')                     
		   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
		   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                       
	END CATCH

		ERROR:
			if(ISNULL(LTRIM(RTRIM(@Error)),'') <> '')
			BEGIN
				RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )
			END   
END
  
