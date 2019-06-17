/********************************* SCREENS TABLE *****************************************/
/*	Author : Arjun K R                                                                   */
/*  Date   : 05-Sept- 2015																 */
/*  Purpose : Task #604 Network180 Customizations.                                                                                     */
/*****************************************************************************************/


DECLARE @screenId INT
SET @screenId=1180

IF NOT EXISTS (SELECT * FROM screens WHERE ScreenId = @screenId) 
	BEGIN SET IDENTITY_INSERT dbo.Screens ON 
		INSERT INTO Screens 
				 (SCREENID 
				 ,SCREENNAME 
				 ,SCREENTYPE 
				 ,SCREENURL 
				 ,SCREENTOOLBARURL 
				 ,TabId 
				 ,INITIALIZATIONSTOREDPROCEDURE 
				,VALIDATIONSTOREDPROCEDURECOMPLETE
				 ,POSTUPDATESTOREDPROCEDURE
				 ,DOCUMENTCODEID) 
		VALUES	(@screenId 
				,'AuthorizationProviderSites' 
				,5761 
				,'/Modules/CareManagement/ActivityPages/Admin/Detail/AuthorizationProviderSites.ascx' 
				,'' 
				,6 
				,NULL
				,NULL
				,NULL
				,NULL) 
	SET IDENTITY_INSERT dbo.Screens OFF  END


/********************************* SCREENS TABLE END **************************************/