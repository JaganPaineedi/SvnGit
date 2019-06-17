/****** Object:  StoredProcedure [dbo].[ssp_PMClientNotesDetail]    Script Date: 07/06/2016 11:35:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMClientNotesDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMClientNotesDetail]
GO


/****** Object:  StoredProcedure [dbo].[ssp_PMClientNotesDetail]    Script Date: 05/27/2016 10:42:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[ssp_PMClientNotesDetail] @ClientId INT
AS
/********************************************************************************                                                    
-- Stored Procedure: ssp_PMClientNotesDetail  1103490
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: Procedure to return data for the client notes details page.  
--  
-- Author:  Girish Sanaba  
-- Date:    26 July 2011  
--  
-- *****History****  
-- 24 Aug 2011 Girish Removed References to Rowidentifier and/or ExternalReferenceId  
-- 27 Aug 2011 Girish Readded References to Rowidentifier  
-- 27 Aug 2011 Girish Removed first resultset for dataentry and changed final resultset  
-- 08 Jan 2015  Avi Goyal What : Changed Client NoteType from GlobalCode to FlagTypes  
        Why : Task 600 Security Alerts of Network-180 Customizations  
-- 19 Oct 2015  Revathi  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.    
        why:task #609, Network180 Customization  
-- 06 Apr 2016  Neelima  What : Added convert to the startdate condition  
        Why : Camino - Environment Issues Tracking - #1.08  
-- 27 May 2016  NJain	 Removed Time Value from Start Date  
-- 31 Aug 2016  Veena    What:Added Active condition for FlagTypes.Why:It was listing inactive flags as well in the grid MFS CIT #245 
-- 20 June 2017  Neelima    What:Added WorkGroup and WorkGroupText columns since its throwing concurrency error Why:SC: PROD: Error Message when trying to end flags Key Point - Support Go Live #1103
-- 24 April 2018 Vijay    What:We modified 'Client Flags Detai' page as part of Client Tracking Why: Engineering Improvement Initiatives- NBL(I) - Task#590 - ClientTracking
*********************************************************************************/  

    BEGIN  
        BEGIN TRY  
            SELECT  CN.ClientId ,  
   --Case WHEN C.MiddleName IS NULL THEN     
   --ELSE RTRIM(C.LastName) + ', ' + RTRIM(C.FirstName) + ' ' + RTRIM(C.MiddleName)                                                         
   --END ClientName,  
   --Added by Revathi 19 Oct 2015  
                    CASE WHEN ISNULL(C.ClientType, 'I') = 'I' THEN RTRIM(ISNULL(C.LastName, '')) + ', ' + RTRIM(ISNULL(C.FirstName, ''))
                         ELSE ISNULL(C.OrganizationName, '')
                    END AS ClientName ,
                    CN.ClientNoteId ,
                    CN.NoteType ,
                    FT.FlagType AS NoteTypeText , 
                    CN.NoteSubtype ,
                    CN.NoteLevel ,
                    GC2.CodeName AS NoteLevelText ,
                    CN.Note ,
                    CN.Active ,
                    CAST(CN.StartDate AS DATE) AS StartDate,
                    CN.EndDate ,
                    CN.Comment ,
                    CN.CreatedBy ,
                    CN.CreatedDate ,
                    CN.ModifiedBy ,
                    CN.ModifiedDate ,
                    CN.RecordDeleted ,
                    CN.DeletedDate ,
                    CN.DeletedBy ,
                    FT.FlagTypeId ,  
                    CN.AssignedTo ,
                    FT.PermissionedFlag ,
                    FT.DoNotDisplayFlag ,
                    FT.NeverPopup
                    ,CN.WorkGroup  -- Added by Neelima on 26 June 2017
					,dbo.ssf_GetGlobalCodeNameById(CN.WorkGroup) AS WorkGroupText  -- Added by Neelima on 26 June 2017
					,CN.OpenDate
					,CN.DueDate
					,CN.TrackingProtocolId
					,CN.FlagRecurs
					,CN.CompletedBy
					,CN.FlagLinkTo
					,CN.DocumentCodeId
					,DC.DocumentName
					,CN.DocumentId
					,CN.ActionId
					,SA.[Action] as ActionName
					,CN.TrackingProtocolFlagId,
					CN.RecordDeleted
            FROM    ClientNotes CN
                    INNER JOIN Clients C ON C.ClientId = CN.ClientId  
                    LEFT JOIN TrackingProtocolFlags PTF ON PTF.TrackingProtocolFlagId = CN.TrackingProtocolFlagId AND ISNULL(PTF.RecordDeleted, 'N') = 'N'
					LEFT JOIN TrackingProtocols PTD ON PTD.TrackingProtocolId = PTF.TrackingProtocolId AND ISNULL(PTD.RecordDeleted, 'N') = 'N' AND ISNULL(PTD.Active,'Y') = 'Y' 
					--LEFT JOIN FlagTypes FT1 ON FT1.FlagTypeId = PTF.FlagTypeId AND ISNULL(FT1.RecordDeleted, 'N') = 'N'
					LEFT JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType AND ISNULL(FT.RecordDeleted, 'N') = 'N' AND ISNULL(FT.Active,'N') = 'Y'
                    LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = CN.NoteLevel
                    LEFT JOIN Staff S ON S.StaffId = CN.AssignedTo AND ISNULL(S.RecordDeleted, 'N') = 'N'
                    LEFT JOIN DocumentCodes DC ON DC.DocumentCodeId = CN.DocumentCodeId AND ISNULL(DC.RecordDeleted, 'N') = 'N'
                    --LEFT JOIN DocumentCodes DC1 ON DC1.DocumentCodeId = FT.DocumentCodeId AND ISNULL(DC1.RecordDeleted, 'N') = 'N'
					LEFT JOIN SystemActions SA ON SA.ActionId = CN.ActionId AND ISNULL(SA.RecordDeleted, 'N') = 'N'
					--LEFT JOIN SystemActions SA1 ON SA1.ActionId = FT.ActionId AND ISNULL(SA1.RecordDeleted, 'N') = 'N'
            WHERE   CN.ClientID = @ClientId
                    AND ISNULL(CN.RecordDeleted, 'N') = 'N'
                    
		-- ClientNoteAssignedUsers
			Select CNAU.ClientNoteAssignedUserId
					,CNAU.CreatedBy
					,CNAU.CreatedDate
					,CNAU.ModifiedBy
					,CNAU.ModifiedDate
					,CNAU.RecordDeleted
					,CNAU.DeletedBy
					,CNAU.DeletedDate
					,CNAU.ClientNoteId
					,CNAU.StaffId
					,CASE WHEN ISNULL(S.DisplayAs, '') != '' Then S.DisplayAs
							ELSE (S.LastName + ', ' + S.FirstName)
					 END AS StaffName
			From ClientNoteAssignedUsers  CNAU
			INNER JOIN ClientNotes CN On CN.ClientNoteId = CNAU.ClientNoteId
			INNER JOIN Clients C ON C.ClientId = CN.ClientId
			LEFT JOIN Staff S ON S.StaffId = CNAU.StaffId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND S.Active = 'Y'
			WHERE   CN.ClientID = @ClientID 
				AND ISNULL(CNAU.RecordDeleted, 'N') = 'N' 
				AND ISNULL(CN.RecordDeleted, 'N') = 'N'
				AND ISNULL(C.RecordDeleted, 'N') = 'N' 

		-- ClientNoteAssignedRoles
			Select CNAR.ClientNoteAssignedRoleId
					,CNAR.CreatedBy
					,CNAR.CreatedDate
					,CNAR.ModifiedBy
					,CNAR.ModifiedDate
					,CNAR.RecordDeleted
					,CNAR.DeletedBy
					,CNAR.DeletedDate
					,CNAR.ClientNoteId
					,CNAR.RoleId
					,dbo.ssf_GetGlobalCodeNameById(CNAR.RoleId) AS RoleName
			From ClientNoteAssignedRoles  CNAR
			INNER JOIN ClientNotes CN On CN.ClientNoteId = CNAR.ClientNoteId
			INNER JOIN Clients C ON C.ClientId = CN.ClientId
			--LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CNAR.RoleId
			WHERE   CN.ClientID = @ClientID 
				AND ISNULL(CNAR.RecordDeleted, 'N') = 'N'
				AND ISNULL(CN.RecordDeleted, 'N') = 'N' 
				AND ISNULL(C.RecordDeleted, 'N') = 'N'  
			
			
			-- ClientNoteTrackingProtocolHistory
			Select CNTPH.ClientNoteTrackingProtocolHistoryId
					,CNTPH.CreatedBy
					,CNTPH.CreatedDate
					,CNTPH.ModifiedBy
					,CNTPH.ModifiedDate
					,CNTPH.RecordDeleted
					,CNTPH.DeletedBy
					,CNTPH.DeletedDate
					,CNTPH.ClientNoteId
					,CNTPH.TrackingProtocolId
					,CNTPH.TrackingProtocolFlagId
					,CNTPH.StartDate
					,CNTPH.EndDate
			From ClientNoteTrackingProtocolHistory CNTPH
			INNER JOIN ClientNotes CN On CN.ClientNoteId = CNTPH.ClientNoteId
			WHERE   CN.ClientID = @ClientID 
				AND ISNULL(CNTPH.RecordDeleted, 'N') = 'N'
				AND ISNULL(CN.RecordDeleted, 'N') = 'N'
			
                    
        END TRY  
  
        BEGIN CATCH  
            DECLARE @Error VARCHAR(8000)  
  
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientNotesDetail') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
            RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
        END CATCH  
  
        RETURN  
    END  

GO
