using EMS.Application.Common.DTOs;
using EMS.Core.Constants;
using EMS.Core.Entities;
using EMS.Core.Enums;
using EMS.Core.Extensions;
using EMS.Core.ValueObjects;

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

            return [.. admins, .. users];
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
                new()
                {
                    Name = "Unknown",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Expense,
                },
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
                    Name = "Unknown",
                    Type = CategoryType.Default,
                    FinancialFlowType = TransactionType.Income,
                },
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

        public static Currency[] GetDefaultCurrencies()
        {
            var defaultCurrencies = new Currency[]
            {
                new() { Code = CurrencyCode.USD, Country = "United States of America", CurrencyName = CurrencyCode.USD.GetDescription() },
                new() { Code = CurrencyCode.EUR, Country = "Euro Member Countries", CurrencyName = CurrencyCode.EUR.GetDescription() },
                new() { Code = CurrencyCode.JPY, Country = "Japan", CurrencyName = CurrencyCode.JPY.GetDescription() },
                new() { Code = CurrencyCode.CNY, Country = "China", CurrencyName = CurrencyCode.CNY.GetDescription() },
                new() { Code = CurrencyCode.KRW, Country = "South Korea", CurrencyName = CurrencyCode.KRW.GetDescription() },
                new() { Code = CurrencyCode.VND, Country = "Vietnam", CurrencyName = CurrencyCode.VND.GetDescription() }
            };

            return defaultCurrencies;
        }

        public static ChatThread[] GetDefaultChatThreads(string userId)
        {
            var defaultChatThreads = new ChatThread[]
            {
                new()
                {
                    UserId = userId,
                    Title = "Finance",
                    Type = ChatThreadType.Finance,
                    IsActive = true,
                },
                new()
                {
                    UserId = userId,
                    Title = "Assistant",
                    Type = ChatThreadType.Assistant,
                    IsActive = true,
                }
            };

            return defaultChatThreads;
        }

        public static (ApiKeyCreationDto ApiKeyCreationDto, string PlainTextKey)[] GetDefaultApiKeys()
        {
            var defaultApiKeys = new (ApiKeyCreationDto ApiKeyCreationDto, string PlainTextKey)[]
            {
                (new()
                {
                    Name = "AI Service",
                    Description = "AI service API Key",
                    Scopes = ["ai:analyze"]
                }, "E4164EFEA68EA6A9CAC2AB5761518"),
                (new()
                {
                    Name = "Admin",
                    Description = "Admin API Key",
                    Scopes = ["admin:access"]
                }, "56D88B3BFAAD73E1ABD68B2E71971")
            };

            return defaultApiKeys;
        }
    }
}