	IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAssociateStaff]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetAssociateStaff] --16928
GO
CREATE PROCEDURE [dbo].[ssp_SCGetAssociateStaff]  
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetAssociateStaff]              */
/* Date              Author                  Purpose                 */
/* 4/17/2015        Sunil.D             SC: Treatment Episode New Screen and Banner not Client Episode
											Thresholds - Support  #828                       */
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/
/*					*/    
/**  --------  --------    ------------------------------------------- */
BEGIN
	BEGIN TRY
	
	
	SELECT s.StaffId,s.LastName+', '+s.FirstName as StaffName
		FROM Staff s join StaffPermissionExceptions e
		on s.StaffId=e.StaffId
		join
		GlobalCodes g
		on g.GlobalCodeId=e.PermissionItemId 
	where  g.Category='STAFFLIST' and S.Active = 'Y' 
	and (s.FirstName is not null or s.LastName is not null) 
	and g.code='TxEpisodeAssociatedStaff' 
	order by StaffName 
	
	
	
 END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)
		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetAssociateStaff') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())
		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END