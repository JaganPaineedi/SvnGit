
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetClientAssignedPopultaion]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[SSP_SCGetClientAssignedPopultaion]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetClientAssignedPopultaion] 
(
 @ClientId int,
 @ProviderAuthorizationDocumentId int,
 @ScreenId int
 )

AS

BEGIN
  /*********************************************************************/
  /* Stored Procedure: dbo.SSP_SCGetClientAssignedPopultaion           */

  /* Copyright: 2018 Streamline Healthcare Solutions                   */

  /* Creation Date:  06 Feb 2018                                       */
  /*                                                                   */
  /* Purpose: Gets Client AssignedPopultaion                           */
  /*                                                                   */
  /* Input Parameters: @ClientId                                       */
  /*                                                                   */
  /* Output Parameters:                                                */
  /*                                                                   */
  /* Return:                                                           */
  /*                                                                   */
  /* Called By: GetClientRecentAssignedPopultaion Method in Auhtorization 
                Class Of DataService  in "SmartClient Application"     */

  /*                                                                   */
  /* Calls:                                                            */
  /*                                                                   */
  /* Data Modifications:                                               */
  /*                                                                   */
  /*   Updates:                                                        */

  /*       Date                  Author                  Purpose       */
  /*       Feb 06 2018           Hemant                  Created 
                                                         What?Initialize assigned population from [CustomFieldsData] table to that client.
                                                         Why?KCMH-Enhancements: #542 
                                                                       */
  /*********************************************************************/
  
  
  
  IF object_id('dbo.SCSP_SCGetClientAssignedPopultaion', 'P') is not null
  Begin
  EXEC SCSP_SCGetClientAssignedPopultaion @ClientId,@ProviderAuthorizationDocumentId,@ScreenId
  END 
  Else
  Begin
  SELECT - 1 AS 'AssignedPopultaionID'  
  END   

  IF (@@error != 0)
  BEGIN
    RAISERROR ('SSP_SCGetClientAssignedPopultaion: An Error Occured', 16, 1)
    RETURN
  END

END
GO