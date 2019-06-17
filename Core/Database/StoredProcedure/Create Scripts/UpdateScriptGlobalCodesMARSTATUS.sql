--Update script to Update GlobalCodeCategories XMARSTATUS with MARSTATUS.
--Engineering improvement task #460

-- Finally Update Category with 'MARSTATUS' for Category = 'XMARSTATUS'
Alter table GlobalCodes drop constraint GlobalCodeCategories_GlobalCodes_FK
go

Update GlobalCodes
set Category = 'MARSTATUS' 
where Category = 'XMARSTATUS'


UPDATE GlobalCodeCategories SET Category = 'MARSTATUS' ,
CategoryName = 'MARSTATUS'
WHERE Category = 'XMARSTATUS'

-- Update ExternalCode1 with code for Category = 'XMARSTATUS'
Update GlobalCodes
set ExternalCode1=Code
where Category = 'MARSTATUS'

ALTER TABLE GlobalCodes ADD CONSTRAINT GlobalCodeCategories_GlobalCodes_FK 
    FOREIGN KEY (Category)
    REFERENCES GlobalCodeCategories (Category)

go
