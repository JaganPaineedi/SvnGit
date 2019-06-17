IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCCancelASPScheduledAppointment]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCCancelASPScheduledAppointment] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go
CREATE PROCEDURE [dbo].[ssp_SCCancelASPScheduledAppointment] (  
@ClientId               INT,
@ProgramId              INT,
@DatetOfCancel	       DATE,
@DeletedBy				varchar(100) )
AS  
-- =============================================  
-- Author:  Gautam  
-- Create date: 13th-Dec-2013 
-- Description: cancel  scheduled appointments for the client 
/*
Date               Author				Purpose
23-Apr-2014		  Revathi				Created
*/
-- =============================================  
BEGIN  
	Begin Try
	
		Begin Tran	
		
		update ProgramAppointments 
		set RecordDeleted='Y',DeletedBy=@DeletedBy,DeletedDate=getdate() 
		where ClientId=@ClientId and ProgramId=@ProgramId
			and cast(AppointmentDate as DATE) = @DatetOfCancel                                                                 
			And Isnull(RecordDeleted,'N')='N'
		
		Commit Tran
	 END try 

     BEGIN catch 
        DECLARE @Error VARCHAR(max) 
			
		if @@TRANCOUNT > 0 rollback tran 
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCCancelASPScheduledAppointment' 
                      ) 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                 
                      16, 
                      -- Severity.                                                                                 
                      1 
          -- State.                                                                                 
          ); 
      END catch 
  END 

go  