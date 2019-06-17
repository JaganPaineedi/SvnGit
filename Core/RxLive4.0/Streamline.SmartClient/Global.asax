<%@ Application Language="C#" %>
 <%@ Import Namespace="Zetafax.SystemFramework" %>

<script RunAt="server">
     
    void Application_OnStart(object sender, EventArgs e)
    {
        try
        {
            ApplicationConfiguration.OnApplicationStart(Context.Server.MapPath(HttpRuntime.AppDomainAppVirtualPath));
            Streamline.UserBusinessServices.SharedTables objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
            objectSharedTables.getSharedTablesData();
            Microsoft.ApplicationBlocks.ExceptionManagement.DefaultPublisher.CallErrorWriteToDatabase += new Microsoft.ApplicationBlocks.ExceptionManagement.DataAvailableEventHandler(DefaultPublisher_CallErrorWriteToDatabase);
        }
        catch (Exception ex)
        {
            WriteToDatabase(ex.Message, "Error", new System.Data.DataSet());
        }
      
    }

    /// <summary>
    /// Event to Insert the error messages to Database
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// <author>Piyush</author>
    /// <cretaedOn>20th June 2007</cretaedOn>
    public void DefaultPublisher_CallErrorWriteToDatabase(object sender, Microsoft.ApplicationBlocks.ExceptionManagement.DataAvailableForError e)
    {
        System.Data.DataSet DatasetWhichGenratedException = new System.Data.DataSet();
        DatasetWhichGenratedException = (System.Data.DataSet)e.GetAppData;
        WriteToDatabase(Microsoft.ApplicationBlocks.ExceptionManagement.DefaultPublisher.strErrorInfo, Microsoft.ApplicationBlocks.ExceptionManagement.DefaultPublisher.strErrorType, DatasetWhichGenratedException);
    }
    /// <summary>
    /// This is used to insert the Error Messages in the Database and into the queue
    /// </summary>
    /// <param name="entry"></param>
    /// <param name="type"></param>
    /// <author>Piyush</author>
    /// <cretaedOn>20th June 2007</cretaedOn>
    public void WriteToDatabase(string entry, string type, System.Data.DataSet DatasetWhichGenratedException)
    {
        Streamline.UserBusinessServices.ApplicationCommonFunctions ObjectApplicationCommonFunctions = null;
        try
        {
            ObjectApplicationCommonFunctions = new Streamline.UserBusinessServices.ApplicationCommonFunctions();
            ObjectApplicationCommonFunctions.WriteToDatabase(entry, type);
      }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        finally
        {
            ObjectApplicationCommonFunctions = null;
        }
    }
    
    
    
    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        Context.ClearError();
    }

    void Session_Start(object sender, EventArgs e)
    {
        

    }

    void Session_End(object sender, EventArgs e)
    {
        Streamline.UserBusinessServices.ClientMedication ObjectApplicationCommonFunctions = null;
        try
        {
            ObjectApplicationCommonFunctions = new Streamline.UserBusinessServices.ClientMedication();
            ObjectApplicationCommonFunctions.DeleteTempTables(Session.SessionID);
        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        finally
        {
            ObjectApplicationCommonFunctions = null;
        }
    }
       
</script>
