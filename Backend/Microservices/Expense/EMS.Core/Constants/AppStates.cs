namespace EMS.Core.Constants
{
    public abstract class AppStates
    {
        public const string Starting = "Starting";
        public const string SeedingData = "SeedingData";
        public const string InitializingDatabase = "InitializingDatabase";
        public const string RunningMigrations = "RunningMigrations";
        public const string Ready = "Ready";
        public const string ShuttingDown = "ShuttingDown";
        public const string RunningBackgroundJobs = "RunningBackgroundJobs";
    }
}
