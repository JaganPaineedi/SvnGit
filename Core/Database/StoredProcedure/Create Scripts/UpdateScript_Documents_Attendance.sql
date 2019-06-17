/*************************************************************************************                                                   
-- Purpose: Insert Script To delete Some wrong rows which created for attendance
--  
-- Author:  Vamsi
-- Date:    24-May-2016 
--  
**************************************************************************************/

UPDATE D
SET RecordDeleted = 'Y'
	,DeletedBy = '492 VSGL'
	,DeletedDate = GETDATE()
FROM Documents D
JOIN Services S ON D.ServiceId = S.ServiceId
JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId
JOIN Groups G ON GS.GroupId = G.GroupId
WHERE ISNULL(G.GroupNoteType, 9383) <> 9383
	AND G.GroupId IS NOT NULL
	AND S.GroupServiceId IS NOT NULL
	AND ISNULL(S.RecordDeleted, 'N') = 'N'
	AND ISNULL(D.RecordDeleted, 'N') = 'N'
	AND ISNULL(GS.RecordDeleted, 'N') = 'N'
	AND ISNULL(G.RecordDeleted, 'N') = 'N'
