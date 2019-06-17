/****** Object:  StoredProcedure [dbo].[ssp_PMUpdateClientAccountDetail]    Script Date: 06/21/2016 12:49:45 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_PMUpdateClientAccountDetail]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_PMUpdateClientAccountDetail] 

GO 

/****** Object:  StoredProcedure [dbo].[ssp_PMUpdateClientAccountDetail]    Script Date: 06/21/2016 12:49:45 ******/ 
SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

CREATE PROCEDURE [dbo].[Ssp_pmupdateclientaccountdetail] (@DoNotSendStatement 
CHAR(1), 
                                                          @Reason 
INT, 
                                                          @FinancialIncomplete 
CHAR(1), 
                                                          @AccountingNotes 
type_Comment, 
                                                          @ClientID 
INT,
@InternalCollections CHAR(1),
@ExternalCollections CHAR(1)
) 
AS 
  /******************************************************************************    
  ** File: ssp_PMUpdateClientAccountDetail.sql   
  ** Name: ssp_PMUpdateClientAccountDetail   
  ** Desc:     
  **    
  **    
  ** This template can be customized:    
  **    
  ** Return values: Filter Values - Client Accounts Tab   
  **    
  ** Called by:    
  **    
  ** Parameters:    
  ** Input Output    
  ** ---------- -----------    
  ** N/A   Dropdown values   
  ** Auth: Mary Suma   
  ** Date: 27/06/2011   
  *******************************************************************************    
  ** Change History    
  *******************************************************************************    
  ** Date:    Author:    Description:    
  ** 27/06/2011  Mary Suma   Query to Update Client Accounts   
  ** 21/06/2016 Bibhudatta   Exec SCSP_PostUpdateClientAccount(AspenPointe-Implementation#143) 
  -- 10 Feb 2017	Vithobha		Update InternalCollections,ExternalCollections columns in Clients table, Renaissance - Dev Items #830
  ** 21/06/2016   Bibhudatta   Reverted Changes of AspenPointe-Implementation#143, it is handeled in SSP_SCGetClientNotes

  *******************************************************************************/ 
  BEGIN 
      BEGIN TRY 
          IF( @DoNotSendStatement IS NOT NULL ) 
            UPDATE Clients 
            SET    DoNotSendStatement = @DoNotSendStatement 
            WHERE  ClientId = @ClientID 
                   AND Isnull(RecordDeleted, 'N') = 'N' 
          -- 10 Feb 2017	Vithobha         
          IF( @InternalCollections IS NOT NULL ) 
            UPDATE Clients 
            SET    InternalCollections = @InternalCollections 
            WHERE  ClientId = @ClientID 
                   AND Isnull(RecordDeleted, 'N') = 'N' 

          IF( @ExternalCollections IS NOT NULL ) 
            UPDATE Clients 
            SET    ExternalCollections = @ExternalCollections 
            WHERE  ClientId = @ClientID 
                   AND Isnull(RecordDeleted, 'N') = 'N'                    

          IF( @AccountingNotes IS NOT NULL ) 
            UPDATE Clients 
            SET    AccountingNotes = @AccountingNotes 
            WHERE  ClientId = @ClientID 
                   AND Isnull(RecordDeleted, 'N') = 'N' 

          IF( @FinancialIncomplete IS NOT NULL ) 
            UPDATE Clients 
            SET    InformationComplete = @FinancialIncomplete 
            WHERE  ClientId = @ClientID 
                   AND Isnull(RecordDeleted, 'N') = 'N' 

          IF( @Reason IS NOT NULL ) 
            UPDATE Clients 
            SET    DoNotSendStatementReason = CASE @Reason 
                                                WHEN -1 THEN NULL 
                                                ELSE @Reason 
                                              END 
            WHERE  ClientId = @ClientID 
                   AND Isnull(RecordDeleted, 'N') = 'N' 

          -----Added by Bibhudatta 21/06/2016 
          --IF EXISTS (SELECT 1 
          --           FROM   sys.objects 
          --           WHERE  object_id = 
          --                  Object_id(N'[dbo].[SCSP_PostUpdateClientAccount]') 
          --                  AND type IN ( N'P', N'PC' )) 
          --  EXEC Scsp_PostUpdateClientAccount 
          --    @ClientID 

          RETURN 0 
      END TRY 

      BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_PMUpdateClientAccountDetail') 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error,-- Message text.   
                      16,-- Severity.   
                      1 -- State.   
          ); 
      END CATCH 
  END 

GO   