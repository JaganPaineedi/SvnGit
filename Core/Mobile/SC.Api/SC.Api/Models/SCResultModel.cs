using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api
{
    public class _SCResult<T>
    {
        public int UnsavedId { get; set; }
        public int SavedId { get; set; }
        public bool ShowDetails { get; set; }
        public object Details { get; set; }
        public string LocalstoreName { get; set; }
        public string LocalName { get; set; }
        public T SavedResult { get; set; }
        public object ServiceValidationMessages { get; set; }
        public object NoteValidationMessages { get; set; }
        public bool DeleteUnsavedChanges { get; set; }
        public bool DeleteObjectStoreData { get; set; }
    }
}