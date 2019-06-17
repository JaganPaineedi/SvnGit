---Author:  Anto Jenkins
---Date  :  12 Sep 2017
---Task  :  Engineering Improvement Initiatives- NBL(I) #214
---Purpose: Should not allow to delete any core global code from the system
----------------------------------------------------------------------------------------

UPDATE GlobalCodes
SET CannotModifyNameOrDelete = 'Y'
WHERE GlobalCodeId < 10000






