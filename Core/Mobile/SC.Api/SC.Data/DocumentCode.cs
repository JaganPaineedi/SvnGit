//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SC.Data
{
    using System;
    using System.Collections.Generic;
    
    public partial class DocumentCode
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DocumentCode()
        {
            this.Documents = new HashSet<Document>();
            this.Screens = new HashSet<Screens>();
            this.ProcedureCodes = new HashSet<ProcedureCodes>();
            this.ProcedureCodes1 = new HashSet<ProcedureCodes>();
        }
    
        public int DocumentCodeId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public string DeletedBy { get; set; }
        public string DocumentName { get; set; }
        public string DocumentDescription { get; set; }
        public Nullable<int> DocumentType { get; set; }
        public string Active { get; set; }
        public string ServiceNote { get; set; }
        public string PatientConsent { get; set; }
        public byte[] ViewDocument { get; set; }
        public string OnlyAvailableOnline { get; set; }
        public Nullable<int> ImageFormatType { get; set; }
        public Nullable<int> DefaultImageFolderId { get; set; }
        public byte[] ImageFormat { get; set; }
        public string ViewDocumentURL { get; set; }
        public string ViewDocumentRDL { get; set; }
        public string StoredProcedure { get; set; }
        public string TableList { get; set; }
        public string RequiresSignature { get; set; }
        public string ViewOnlyDocument { get; set; }
        public string DocumentSchema { get; set; }
        public string DocumentHTML { get; set; }
        public string DocumentURL { get; set; }
        public string ToBeInitialized { get; set; }
        public Nullable<int> InitializationProcess { get; set; }
        public string InitializationStoredProcedure { get; set; }
        public Nullable<int> FormCollectionId { get; set; }
        public string ValidationStoredProcedure { get; set; }
        public string ViewStoredProcedure { get; set; }
        public Nullable<int> MetadataFormId { get; set; }
        public string TextTemplate { get; set; }
        public string RequiresLicensedSignature { get; set; }
        public Nullable<int> ReviewFormId { get; set; }
        public string MedicationReconciliationDocument { get; set; }
        public string NewValidationStoredProcedure { get; set; }
        public string AllowEditingByNonAuthors { get; set; }
        public string EnableEditValidationStoredProcedure { get; set; }
        public string MultipleCredentials { get; set; }
        public string RecreatePDFOnClientSignature { get; set; }
        public string DiagnosisDocument { get; set; }
        public string RegenerateRDLOnCoSignature { get; set; }
        public string DefaultCoSigner { get; set; }
        public string DefaultGuardian { get; set; }
        public string Need5Columns { get; set; }
        public string SignatureDateAsEffectiveDate { get; set; }
        public string FamilyHistoryDocument { get; set; }
        public string CoSignerRDL { get; set; }
        public string ShareDocumentOnSave { get; set; }
        public string DSMV { get; set; }
        public string ExcludeFromBatchSigning { get; set; }
        public Nullable<int> DaysDocumentEditableAfterSignature { get; set; }
        public string Mobile { get; set; }
        public string AllowClientPortalUserAsAuthor { get; set; }
        public Nullable<int> PrintOrder { get; set; }
        public string DisclosurePrintOrder { get; set; }
        public string ClientOrder { get; set; }
        public string Code { get; set; }
        public string AllowVersionAuthorToSign { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Document> Documents { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Screens> Screens { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ProcedureCodes> ProcedureCodes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ProcedureCodes> ProcedureCodes1 { get; set; }
    }
}