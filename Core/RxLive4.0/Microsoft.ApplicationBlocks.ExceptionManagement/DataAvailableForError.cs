using System;
using System.Data; 


namespace Microsoft.ApplicationBlocks.ExceptionManagement
{
	/// <summary>
	/// This is the delegate used by the Service Agent to define the event it uses to
	/// broadcast that data is available and UI can be refreshed.
	/// </summary>
	public delegate void DataAvailableEventHandler(object sender, 
	DataAvailableForError e);

	/// <summary>
	/// Summary description for DataAvailableEventArgs.
	/// </summary>
	public class DataAvailableForError :EventArgs
	{
		private object appData;
		public DataAvailableForError( object refAppData)
		{
			appData = refAppData;			
		}

		public object GetAppData{ get{return appData; }}
	}
	
}
