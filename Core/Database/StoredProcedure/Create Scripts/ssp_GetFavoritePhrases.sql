IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_GetFavoritePhrases')
	BEGIN
		DROP  Procedure  ssp_GetFavoritePhrases
	END

GO


CREATE PROCEDURE ssp_GetFavoritePhrases 
(
@KeyPhraseCategory int,
@StaffId int,
@ScreenId int,
@PrimaryKeyName varchar(250),
@ClientId int
)
AS
/*********************************************************************/                                                                      
 /* Stored Procedure: [ssp_GetFavoritePhrases]					 */                                                             
 /* Creation Date: 10/Nov/2011														 */                                                                      
 /* Purpose: To Get The Favorite KeyPhrases According to the Screen  */                                                                    
 /* Input Parameters: @KeyPhraseCategory			               */                                                                    
 /* Output Parameters:   Returns the Table of Favorite Phrases Agency as Well as Key Phrases  */                                                                      
 /* Called By: Document.cs            */                                                            
 /* Data Modifications:														*/                                                                      
 /*   Updates:																*/                                                                      
 /*   Date				Author											*/                                                                      
 /*  10/Nov/2011	    Devi Dayal		
  *  07/08/2018         Lakshmi            Replaced single quotes with respective html code since it was breaking tool tip 
											feature in key phrase. MFS Build Cycle Tasks #27
     12/12/2018         Gautam              called scsp for thresholds, MFS Build Cycle Tasks > Tasks #27 > BC2 TRAIN: Key Phrases text cuts off after apostrophe 
 /*********************************************************************/ */
 BEGIN
  BEGIN TRY

Create table #FavoritePhrases(
KeyPhraseId int,
KeyPhraseText varchar(max),
KeyPhraseCategory int,
CreatedBy varchar(250),
ModifiedBy Varchar(250),
ModifiedDate DateTime,
RecordDeleted Char(1),
DeletedBy Varchar(250),
DeletedDate DateTime
) 
Insert into #FavoritePhrases
(
KeyPhraseId,
KeyPhraseText,
KeyPhraseCategory,
CreatedBy,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedBy,
DeletedDate
)
 SELECT 
 KeyPhraseId,
 PhraseText,
 KeyPhraseCategory,
 CreatedBy,
 ModifiedBy,
 ModifiedDate,
 RecordDeleted,
 DeletedBy,
 DeletedDate
 From KeyPhrases 
 Where KeyPhraseCategory=@KeyPhraseCategory AND StaffId=@StaffId
 AND Favorite='Y' AND  ISNULL(RecordDeleted,'N') = 'N' 
 
Insert into #FavoritePhrases
(
KeyPhraseId,
KeyPhraseText,
KeyPhraseCategory,
CreatedBy,
 ModifiedBy,
 ModifiedDate,
 RecordDeleted,
 DeletedBy,
 DeletedDate
) 
SELECT
 AP.AgencyKeyPhraseId,
 AP.PhraseText,
 AP.KeyPhraseCategory, 
 AP.CreatedBy,
 AP.ModifiedBy,
 AP.ModifiedDate,
 AP.RecordDeleted,
 AP.DeletedBy,
 AP.DeletedDate
 From AgencyKeyPhrases AP Inner Join StaffAgencyKeyPhrases SAP on AP.AgencyKeyPhraseId=SAP.AgencyKeyPhraseId AND SAP.StaffId=@StaffId  
 Where AP.KeyPhraseCategory=@KeyPhraseCategory AND  ISNULL(AP.RecordDeleted,'N') = 'N' AND ISNULL(SAP.RecordDeleted,'N') = 'N' 

 IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GetFavoritePhrases]'))
	   Begin
	          EXEC scsp_GetFavoritePhrases @KeyPhraseCategory ,
						@StaffId ,
						@ScreenId ,
						@PrimaryKeyName ,
						@ClientId 
			 
	   END	
    else
       begin
			SElect 
			KeyPhraseid,
			dbo.ssf_ReplacePhraseText(KeyPhraseText,KeyPhraseCategory,@ScreenId,@PrimaryKeyName,@ClientId) AS KeyPhraseText,
			KeyPhraseCategory,
			CreatedBy,
			ModifiedBy,
			ModifiedDate,
			RecordDeleted,
			DeletedBy,
			DeletedDate
			 from  #FavoritePhrases Order By ModifiedDate ASC
	   end
	   
	   
DROP table 	#FavoritePhrases 

END TRY                                                                                                 
--Checking For Errors                                      
BEGIN CATCH            
    DECLARE @Error VARCHAR(8000)
		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetFavoritePhrases') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
		RAISERROR (
				@Error
				,-- Message text.              
				16
				,-- Severity.              
				1 -- State.              
				);                
 END CATCH 

END

