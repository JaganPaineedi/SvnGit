IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateMultiClientMARStatus]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCUpdateMultiClientMARStatus] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [ssp_SCUpdateMultiClientMARStatus] 
@ClientId			INT ,
@Status				VARCHAR(250),
@Date				DATE,
@Time				VARCHAR(8),
@MedAdminRecordId	VARCHAR(MAX) =NULL    ,
@AdministeredBy INT   
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_SCUpdateMultiClientMARStatus            */ 
/* Creation Date:    07/May/2015               */ 
/* Purpose:  To  update the Status for all the Med or Sigle MedAdminRecordId              */ 
/*    Exec ssp_SCUpdateMultiClientMARStatus 2, 219 ,'2015-02-28','04:00 PM' ,'Y'                                          */
/* Input Parameters:                           */ 
/*  Date			Author			Purpose              */ 
/* 07/May/2015		Gautam			Created    task #820 ,Multi - Client MAR  Woods - Customizations       */ 
/* 31/Mar/2017		Chethan N		What: Converted Custom 'XMarStatus' to Core 'MarStatus'.
									Why:  Renaissance - Dev Items task #5.1	*/     
/* 28/Jun/2017		Chethan N		What: Updating AdministeredDose.    
									Why:  Renaissance - Dev Items task #5.1*/	
/* 08/Jan/2018		Chethan N		What: Inserting into MedAdminRecordHistory table. 
									Why : MHP-Support Go Live task #427*/				
  /*********************************************************************/ 
  BEGIN 
	DECLARE @GlobalCodeIdRefused int
	DECLARE @GlobalCodeIdStatus int
	DECLARE @MARId INT
	DECLARE @ModifiedBy VARCHAR(MAX)
	DECLARE @AdministeredDate DATE = GETDATE()
	,@AdministeredTime TIME = CAST(GETDATE() as Time(0))
	
	SELECT @ModifiedBy = UserCode FROM Staff WHERE StaffId = @AdministeredBy
	
	BEGIN TRY
	
	Select Top 1 @GlobalCodeIdRefused= GlobalcodeId From GlobalCodes Where category='MARStatus' and CodeName='Refused'
							and ISNULL(RecordDeleted, 'N') = 'N'	
	Select Top 1 @GlobalCodeIdStatus= GlobalcodeId From GlobalCodes Where category='MARStatus' and CodeName=@Status
							and ISNULL(RecordDeleted, 'N') = 'N'								
							
							
	DECLARE MARRecords CURSOR LOCAL FAST_FORWARD    
	FOR    
	SELECT MA.MedAdminRecordId 
	From MedAdminRecords MA Join ClientOrders CO on MA.ClientOrderId= CO.ClientOrderId 
					and CO.ClientId = @ClientId
					and ISNULL(CO.IsPRN,'N')='N'
				JOIN Orders O On CO.OrderId = O.OrderId
					AND ISNULL(O.RecordDeleted, 'N') = 'N'
					AND ISNULL(O.Active, 'Y') = 'Y'
				    AND ISNULL(O.DualSignRequired,'N')='N'
				JOIN [dbo].[SplitString] (@MedAdminRecordId,',') MAS ON MAS.Token = MA.MedAdminRecordId
			Where   ISNULL(MA.RecordDeleted, 'N') = 'N' and MA.AdministeredDate is null 
				--and CAST(MA.ScheduledDate AS DATE)=@Date and CAST(MA.Scheduledtime AS TIME(0))=@Time
				and not exists(Select 1 from OrderQuestions OQ where  OQ.OrderID= CO.OrderID 
								and OQ.ShowQuestionTimeOption='A' and  ISNULL(OQ.RecordDeleted, 'N') = 'N')
				and not exists(Select 1 from MedAdminRecords MA1 where MA1.MedAdminRecordId= MA.MedAdminRecordId 
											and	MA1.Status=@GlobalCodeIdRefused
											)
    
	OPEN MARRecords    
    
	FETCH NEXT    
	FROM MARRecords    
	INTO @MARId    
    
	WHILE @@FETCH_STATUS = 0    
	BEGIN    
	
		EXEC [dbo].[ssp_UpdateAdministeredDateTime] @MARId, @AdministeredDate, @AdministeredTime, @AdministeredBy, @ModifiedBy, @AdministeredDate, 0
		
		Update MA
		Set MA.Status=@GlobalCodeIdStatus, Comment='Status updated by All Med.'
		From MedAdminRecords MA
		WHERE MA.MedAdminRecordId = @MARId
		
		-- Update the ClientOrder table with Complete status if last schedule administration is given.
		EXEC ssp_UpdateClientOrderStatus @MARId, @AdministeredBy 
		
					
		--Insert into Med Admin record history table
		EXEC ssp_InsertMedAdministrationHistory	@MARId	 
			
	    
	FETCH NEXT    
	FROM MARRecords    
	INTO @MARId    
	END    
    
	-- ==============================================     
	CLOSE MARRecords    
    
	DEALLOCATE MARRecords			
   
	END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(max) 
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCUpdateMultiClientMARStatus' 
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