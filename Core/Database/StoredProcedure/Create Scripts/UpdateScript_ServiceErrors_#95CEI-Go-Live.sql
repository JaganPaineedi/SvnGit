------------------------------------------------------------------------------------------------------------------------
--Author : Shruthi.S
--Date   : 18/01/2016
--Purpose: Added a script to soft delete 'Billing diagnosis order required for completing the service' service error.Ref : #95 CEI - Support Go Live.  
------------------------------------------------------------------------------------------------------------------------


Update ServiceErrors set Recorddeleted='Y' where ErrorMessage='Billing diagnosis order required for completing the service.'