﻿namespace EMS.Core.Constants
{
    public abstract class Policies
    {
        public const string CanPurge = nameof(CanPurge);
        public const string UserAccess = nameof(UserAccess);
        public const string AdminAccess = nameof(AdminAccess);

        public const string FrontendAccess = nameof(FrontendAccess);

        #region Service polices
        public const string AiServiceAccess = nameof(AiServiceAccess);
        public const string DispatcherServiceAccess = nameof(DispatcherServiceAccess);
        #endregion
    }
}
