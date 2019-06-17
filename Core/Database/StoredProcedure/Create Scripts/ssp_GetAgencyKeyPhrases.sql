
/****** Object:  StoredProcedure [dbo].[ssp_GetAgencyKeyPhrases]    Script Date: 08/03/2017 20:37:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAgencyKeyPhrases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAgencyKeyPhrases]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetAgencyKeyPhrases]    Script Date: 08/03/2017 20:37:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[ssp_GetAgencyKeyPhrases] 
(
		@StaffId int,
		@ClientId int  
)
as
/************************************************************************************************                        

*************************************************************************************************/
BEGIN
BEGIN TRY
SELECT
       KP.KeyPhraseId
      ,KP.CreatedBy
      ,KP.CreatedDate
      ,KP.ModifiedBy
      ,KP.ModifiedDate
      ,KP.RecordDeleted
      ,KP.DeletedBy
      ,KP.DeletedDate
      ,KP.StaffId
      ,KP.KeyPhraseCategory
      ,KP.Favorite
      ,dbo.csf_GetRxPhraseText(KP.PhraseText,KP.KeyPhraseCategory,@ClientId) AS PhraseText
      ,CASE WHEN KP.Favorite='Y' Then 'Yes'
			WHEN KP.Favorite='N' Then 'No'
	     END AS 'FavoriteText'
	  ,GC.CodeName AS 'KeyPhraseCategoryText' 
  FROM KeyPhrases KP Inner join GlobalCOdes GC on GC.GlobalCodeId=KP.KeyPhraseCategory 
  WHERE KP.StaffId=@StaffId AND ISNULL(KP.RecordDeleted,'N')='N' AND ISNULL(GC.RecordDeleted,'N')='N' Order by KP.ModifiedDate ASC    
  
  SELECT AgencyKeyPhraseId
       ,AP.CreatedBy
      ,AP.CreatedDate
      ,AP.ModifiedBy
      ,AP.ModifiedDate
      ,AP.RecordDeleted
      ,AP.DeletedBy
      ,AP.DeletedDate
      ,AP.KeyPhraseCategory
      ,dbo.csf_GetRxPhraseText(AP.PhraseText,AP.KeyPhraseCategory,@ClientId) AS PhraseText
      ,GC.CodeName AS 'KeyPhraseCategoryText' 

  FROM AgencyKeyPhrases AP Inner join GlobalCOdes GC on GC.GlobalCodeId=AP.KeyPhraseCategory  
  WHERE ISNULL(AP.RecordDeleted,'N')='N'  AND ISNULL(GC.RecordDeleted,'N')='N' Order by AP.ModifiedDate DESC 
END TRY
 BEGIN CATCH        
  DECLARE @Error varchar(8000)                                                       
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetAgencyKeyPhrases')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                  
  RAISERROR                                                                                     
  (                                                       
   @Error, -- Message text.                                                                                    
   16, -- Severity.                                                                                    
   1 -- State.                                                                                    
   );         
 END CATCH

END


GO


