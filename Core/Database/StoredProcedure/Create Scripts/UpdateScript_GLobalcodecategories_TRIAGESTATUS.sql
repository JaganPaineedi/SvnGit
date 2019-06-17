---Author:  Bibhu
---Date  :  28 Mar 2017
---Task  :  AspenPointe-Environment Issues #184
----------------------------------------------------------------------------------------
Declare @GlobalCodeCategoryId INT
SET @GlobalCodeCategoryId=
(Select GlobalCodeCategoryId from GlobalcodeCategories Where Category='TRIAGESTATUS')

Update GLobalcodecategories SET UserDefinedCategory='N' Where GlobalCodeCategoryId=@GlobalCodeCategoryId




