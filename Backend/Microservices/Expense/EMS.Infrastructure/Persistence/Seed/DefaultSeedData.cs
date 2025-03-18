using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Core.Enums;

namespace EMS.Infrastructure.Persistence.Seed
{
    public static class DefaultSeedData
    {
        public static string[] GetDefaultRoles()
        {
            var roles = new[]
            {
                Roles.Administrator,
                Roles.User,
            };

            return roles;
        }

        public static (string UserName, string Pwd, string Role)[] GetDefaultUsers()
        {
            var admins = new (string UserName, string Pwd, string Role)[]
            {
                ("admin1@gmail.com", "123456", Roles.Administrator),
                ("admin2@gmail.com", "123456", Roles.Administrator)
            };

            var users = new (string UserName, string Pwd, string Role)[]
            {
                ("user1@gmail.com", "123456", Roles.User),
                ("user2@gmail.com", "123456", Roles.User)
            };

            return [..admins, ..users];
        }

        public static SystemSetting[] GetDefaultSystemSettings()
        {
            var systemSettings = new SystemSetting[]
            {
                new SystemSetting
                {
                    SettingKey = "Currency",
                    SettingValue = CurrencyCode.USD.ToString(),
                    DataType = DataType.String,
                    Description = "Default currency used in transactions",
                    Type = SettingType.General,
                    UserConfigurable = true
                },
                new SystemSetting
                {
                    SettingKey = "Language",
                    SettingValue = Language.EN.ToString(),
                    DataType = DataType.String,
                    Description = "Default application language",
                    Type = SettingType.General,
                    UserConfigurable = true
                },
                new SystemSetting
                {
                    SettingKey = "RequiresConfirmation",
                    SettingValue = "true",
                    DataType = DataType.Boolean,
                    Description = "Indicates whether user actions require confirmation",
                    Type = SettingType.General,
                    UserConfigurable = true
                }
            };

            return systemSettings;
        }

        public static Category[] GetDefaultCategories()
        {
            var expenseCategories = new Category[]
            {
                new() {
                    Name = "Food & Drinks",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new() {
                    Name = "Home",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new() {
                    Name = "Shopping",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Transportation",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Entertainment",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Travel",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Education",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Health",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Grocery",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Pet",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Electronics",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Beauty",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
                new()
                {
                    Name = "Sports",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
            };

            var incomeCategories = new Category[]
            {
                new()
                {
                    Name = "Salary",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Income,
                },
                new()
                {
                    Name = "Investments",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Income,
                },
                new()
                {
                    Name = "Bonus",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Income,
                },
                new()
                {
                    Name = "Business",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Income,
                },
            };

            return [.. expenseCategories, .. incomeCategories];
        }
    }
}
