using SC.Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SC.Api
{
    public interface IDocumentRepository
    {
        _SCResult<ClientDocumentsModel> UpdateSignature(ClientDocumentsModel sig);
        ClientDocumentsModel GetDocumentModel(int DocumentVersionId);
    }
}
