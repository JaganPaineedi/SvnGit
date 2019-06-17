/*
9/8/2016    What: ViewDocumentRDL should point to RDLClientOrders instead of RDLCustomDocumentLabsXRaysReferrals for DocumentName 'client Orders'.
			Why	: Core Bugs Task#2184
*/

UPDATE DocumentCodes
SET ViewDocumentRDL = 'RDLClientOrders'
 ,ViewDocumentURL = 'RDLClientOrders'
WHERE DocumentCodeId = 1506