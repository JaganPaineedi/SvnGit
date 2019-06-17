--Separate Script created by Veena on 07/14/2017 as the original script is making duplicate for globalcodes
--Modified AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y' for PRESCRIBEDRESP Category.
--Requested for a core change.AspenPointe-Environment Issues #248

	UPDATE GlobalCodeCategories
	SET AllowAddDelete = 'Y'
		,AllowCodeNameEdit = 'Y'
		,AllowSortOrderEdit = 'Y'
	WHERE Category = 'PRESCRIBEDRESP     '
