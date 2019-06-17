If Exists(Select * from DocumentVersions where DocumentVersionId=341156 And DocumentId=335772)
Begin
Update DocumentVersions Set RecordDeleted=Null Where DocumentVersionId=341156 And DocumentId=335772
End