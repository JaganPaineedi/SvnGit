/****** Object:  StoredProcedure [dbo].[ssp_PMGetClientInformationOrganization]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMGetClientInformationOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGetClientInformationOrganization]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMGetClientInformationOrganization]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE  [dbo].[ssp_PMGetClientInformationOrganization]  
(  
    @ClientID AS BIGINT ,  
    @OrganizationName AS varchar(100) ,
    @EIN AS varchar(25) , 
    @ClientType AS char(1), 
    @Active AS type_Active = NULL ,  
    @FinanciallyResponsible AS type_YOrN = NULL ,  
    @DoesNotSpeakEnglish AS type_YOrN = NULL,  
    @CreatedBy As type_CurrentUser = NULL,  
    @StaffId AS INT = NULL  
     )  

As               
/********************************************************************/                          
/* Stored Procedure: dbo.ssp_PMGetClientInformationOrganization							*/                          
/* Creation Date:  Oct 08 2015                                    */                          
/*  Author: Vichee Humane											*/                          
/* Purpose: To Create Client Organization*/                         
/*                                                                  */ 
/*                                                                  */                          
/*	Updates:                                                        */                          
/*  Date		Author			Purpose								*/           
/*  19 Oct 2015 Vichee           Network 180-Customization#609 */	
/********************************************************************/

BEGIN 
	BEGIN TRY
	DECLARE @MasterRecord CHAR  
	SET @MasterRecord = 'Y'  

	DECLARE @ExistClientId INT
	DECLARE @ExistClientIdCount INT
	DECLARE @PoviderCount INT
	SET @ExistClientId=0
	SET @PoviderCount=0
	SET @ExistClientId = (SELECT top 1 ClientId from Clients where OrganizationName=@OrganizationName  and EIN=@EIN and MasterRecord='Y' and ISNULL(RecordDeleted,'N') <> 'Y')
	SET @ExistClientIdCount = (SELECT COUNT(*) from Clients where OrganizationName=@OrganizationName  and EIN=@EIN and MasterRecord='Y' and MasterRecord='Y' and ISNULL(RecordDeleted,'N') <> 'Y')
	IF @ExistClientIdCount >0
	BEGIN
		SET @MasterRecord='N'
		--SET @PoviderCount = (SELECT COUNT(*) FROM ProviderClients PC
		--						INNER JOIN Clients C on PC.ClientId=C.ClientId
		--						WHERE PC.ProviderId=@ProviderId and C.FirstName=@FirstName and C.LastName=@LastName and C.DOB=@DOB and C.SSN=@SSN and ISNULL(PC.RecordDeleted,'N') <> 'Y' and ISNULL(C.RecordDeleted,'N') <> 'Y')
	END
	ELSE
	BEGIN
		SET @MasterRecord='Y'
		INSERT  INTO Clients  
                    ( OrganizationName ,                        
                      EIN , 
                      ClientType, 
                      Active ,  
                      FinanciallyResponsible ,  
                      DoesNotSpeakEnglish,  
                      MasterRecord,  
                      CreatedBy,  
                      ModifiedBy   
                    )  
            VALUES  ( ISNULL(@OrganizationName,'') ,   
                      ISNULL(@EIN,'') ,  
                      ISNULL(@ClientType,'') ,                   
                      ISNULL(@Active,'Y') ,  
                      ISNULL(@FinanciallyResponsible,'N') ,  
                      ISNULL(@DoesNotSpeakEnglish,'N'),  
                      @MasterRecord,  
                      ISNULL(@CreatedBy,''),  
                      ISNULL(@CreatedBy,'')  
                    )   
               SET  @ExistClientId = @@Identity     

	END
	
	
--IF @PoviderCount = 0
--BEGIN	
-- IF @ProviderId > 0  
--  BEGIN     
--   DECLARE @IsSubstanceUseProvider CHAR  
       
--   SELECT @IsSubstanceUseProvider = ISNULL(SubstanceUseProvider,'N')  
--   FROM Providers   
--   WHERE ProviderId = @ProviderId and ISNULL(RecordDeleted,'N') <> 'Y'  
      
--   IF @IsSubstanceUseProvider = 'Y'  
--    SET @MasterRecord = 'N'  
--  END  
            
       
    IF @ClientID = -1   
        BEGIN           
   --INSERT  INTO Clients  
   --                 ( OrganizationName ,                      
   --                   EIN , 
   --                   ClientType, 
   --                   Active ,  
   --                   FinanciallyResponsible ,  
   --                   DoesNotSpeakEnglish,  
   --                   MasterRecord,  
   --                   CreatedBy,  
   --                   ModifiedBy   
   --                 )  
   --         VALUES  ( ISNULL(@OrganizationName,'') ,                       
   --                   ISNULL(@EIN,'') ,  
   --                   ISNULL(@ClientType,'') ,  
   --                   ISNULL(@Active,'Y') ,  
   --                   ISNULL(@FinanciallyResponsible,'N') ,  
   --                   ISNULL(@DoesNotSpeakEnglish,'N'),  
   --                   @MasterRecord,  
   --                   ISNULL(@CreatedBy,''),  
   --                   ISNULL(@CreatedBy,'')  
   --                 )   
                      
                     
    
            SELECT  @ClientID = @@Identity        
            insert into CustomStateReporting (ClientId ) values (@ClientID)  
      --     	INSERT INTO ProviderClients(ClientId,ProviderId,MasterClientId,Active,RowIdentifier,CreatedBy,CreatedDate)
						--VALUES(@ClientID,@ProviderId,@ExistClientId,'Y',NewId(),@CreatedBy,Getdate())                      
            
            exec ssp_RefreshStaffClients  @StaffId,null,'N'   
            
			select @ClientID as ClientId;    
        END   
--END 
ELSE
BEGIN
	select 0 as ClientId
END
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_PMGetClientInformationOrganization' ) 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error,-- Message text.              
                      16,-- Severity.              
                      1 -- State.              
          ); 
	END CATCH
END
GO


