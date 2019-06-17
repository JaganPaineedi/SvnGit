----- STEP 1 ----------
-------- STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------ 

IF COL_LENGTH('Insurers','ICD10StartDate')IS NULL
BEGIN
	ALTER TABLE Insurers ADD ICD10StartDate datetime NULL
	
	PRINT 'STEP 3 COMPLETED'
END

-----END Of STEP 3--------------------
---------------------------------------------------------------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

