namespace EMS.Core.Enums
{
    /// <summary>
    /// Defines the confirmation mode for an extracted transaction.
    /// </summary>
    public enum ConfirmationMode
    {
        /// <summary>
        /// Require the user to manually confirm the transaction.
        /// </summary>
        Manual = 0,

        /// <summary>
        /// Automatically confirm the transaction.
        /// </summary>
        Auto = 1,
    }
}   
