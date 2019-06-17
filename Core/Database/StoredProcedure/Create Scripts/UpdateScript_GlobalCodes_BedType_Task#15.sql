
If Exists (Select * from GlobalCodes Where Category ='BedType1' and GlobalCodeId in (24498, 24499))
Begin
Update GlobalCodes Set RecordDeleted ='Y', DeletedBy ='BBCT#15' Where Category ='BedType1' and GlobalCodeId in (24498, 24499)
End
Go

If Exists (Select * from GlobalCodes Where Category ='BedType2' and GlobalCodeId =24500)
Begin
Update GlobalCodes Set RecordDeleted ='Y', DeletedBy ='BBCT#15' Where Category ='BedType2' and GlobalCodeId =24500
End
Go

If Exists (Select * from GlobalCodes Where Category ='BedType3' and GlobalCodeId =24501)
Begin
Update GlobalCodes Set RecordDeleted ='Y', DeletedBy ='BBCT#15' Where Category ='BedType3' and GlobalCodeId =24501
End
Go

If Exists (Select * from GlobalCodes Where Category ='BedType4' and GlobalCodeId =24502)
Begin
Update GlobalCodes Set RecordDeleted ='Y', DeletedBy ='BBCT#15' Where Category ='BedType4' and GlobalCodeId =24502
End
Go