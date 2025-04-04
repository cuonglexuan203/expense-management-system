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

        public static CurrencySlang[] GetDefaultCurrencySlangs()
        {
            CurrencySlang[] vn = [
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "củ",
                    Multiplier = 1000000,
                    Description = "Common slang, especially in Northern Vietnam, meaning one million VND."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "chai",
                    Multiplier = 1000000,
                    Description = "Slang more popular in Southern Vietnam, meaning one million VND."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "M",
                    Multiplier = 1000000,
                    Description = "Short for Million, increasingly used due to English influence."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "tỏi",
                    Multiplier = 1000000000,
                    Description = "Slang meaning one billion VND."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "gạch",
                    Multiplier = 1000000000,
                    Description = "More recent and less common slang for one billion VND, possibly from online communities."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "garlic",
                    Multiplier = 1000000000,
                    Description = "English translation of 'gạch', used as slang for one billion VND."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "K",
                    Multiplier = 1000,
                    Description = "Short for Kilo/Thousand, common for representing thousands of VND (e.g., 100K = 100,000 VND)."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "lít",
                    Multiplier = 100000,
                    Description = "Slang, more common in the North, meaning one hundred thousand VND."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "tire",
                    Multiplier = 100000,
                    Description = "Slang, more common in the North, meaning one hundred thousand VND."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.VND,
                    SlangTerm = "coil",
                    Multiplier = 100000,
                    Description = "Slang, more common in the South, meaning one hundred thousand VND."
                }
            ];

            CurrencySlang[] china = [
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.CNY,
                    SlangTerm = "块 (kuài)",
                    Multiplier = 1,
                    Description = "The standard colloquial term for the base unit of Renminbi (CNY)."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.CNY,
                    SlangTerm = "毛 (máo)",
                    Multiplier = 0.1f,
                    Description = "The colloquial term for 1/10 of a Yuan (角 - jiǎo)."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.CNY,
                    SlangTerm = "分 (fēn)",
                    Multiplier = 0.01f,
                    Description = "The colloquial term for 1/100 of a Yuan."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.CNY,
                    SlangTerm = "大洋 (dàyáng)",
                    Multiplier = 1,
                    Description = "An older slang term for Yuan, sometimes still used, meaning 'big ocean'."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.CNY,
                    SlangTerm = "软妹币 (ruǎnmèibì)",
                    Multiplier = 1,
                    Description = "A popular and affectionate slang term for Renminbi (RMB), literally 'soft sister currency'."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.CNY,
                    SlangTerm = "胖子 (pàngzi)",
                    Multiplier = 100,
                    Description = "Slang for 100 Yuan banknotes, literally 'fat person' because the older 100 Yuan bills were relatively thick."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.CNY,
                    SlangTerm = "小朋友 (xiǎopéngyǒu)",
                    Multiplier = 100,
                    Description = "Another slang term for 100 Yuan banknotes, literally 'little friend'."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.CNY,
                    SlangTerm = "刀 (dāo)",
                    Multiplier = 1,
                    Description = "A very common slang term for Yuan, meaning 'knife'."
                }
            ];

            CurrencySlang[] korea = [
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.KRW,
                    SlangTerm = "원 (won)",
                    Multiplier = 1,
                    Description = "The official and most common term for the base unit of South Korean currency."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.KRW,
                    SlangTerm = "전 (jeon)",
                    Multiplier = 0.01f,
                    Description = "A historical subunit of the Won, rarely used in everyday transactions now but might appear in older contexts."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.KRW,
                    SlangTerm = "냥 (nyang)",
                    Multiplier = 1,
                    Description = "An older Korean unit of weight and also historically used for currency. Less common now but might be seen in historical dramas or older references."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.KRW,
                    SlangTerm = "다발 (dabal)",
                    Multiplier = 10000,
                    Description = "Literally meaning 'bundle', often used informally to refer to 10,000 Won banknotes (a bundle of them)."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.KRW,
                    SlangTerm = "장 (jang)",
                    Multiplier = 10000,
                    Description = "Literally meaning 'sheet' or 'piece', also commonly used informally to refer to 10,000 Won banknotes."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.KRW,
                    SlangTerm = "만원 (man-won)",
                    Multiplier = 10000,
                    Description = "The standard way to say 10,000 Won, often used as a base unit for larger amounts (e.g., 'two man-won' is 20,000 Won)."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.KRW,
                    SlangTerm = "억 (eok)",
                    Multiplier = 100000000,
                    Description = "The Korean word for one hundred million. Used for very large amounts (e.g., 'one eok' is 100,000,000 Won)."
                }
            ];

            CurrencySlang[] japan = [
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "円 (en)",
                    Multiplier = 1,
                    Description = "The official and most common term for the base unit of Japanese currency."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "銭 (sen)",
                    Multiplier = 0.01f,
                    Description = "A historical subunit of the Yen, now rarely used in everyday transactions but might appear in older contexts."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "厘 (rin)",
                    Multiplier = 0.001f,
                    Description = "An even smaller historical subunit of the Yen, practically obsolete."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "札 (satsu)",
                    Multiplier = 1000,
                    Description = "Refers to Japanese banknotes in general."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "万 (man)",
                    Multiplier = 10000,
                    Description = "The Japanese word for ten thousand. Often used as a base unit for larger amounts (e.g., 'ichi-man en' is 10,000 Yen)."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "千円札 (sen-en satsu)",
                    Multiplier = 1000,
                    Description = "Specifically refers to 1000 Yen banknotes."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "万円札 (man-en satsu)",
                    Multiplier = 10000,
                    Description = "Specifically refers to 10,000 Yen banknotes."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "諭吉 (yukichi)",
                    Multiplier = 10000,
                    Description = "A common nickname for the 10,000 Yen banknote, which features Fukuzawa Yukichi."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "漱石 (sōseki)",
                    Multiplier = 1000,
                    Description = "A former nickname for the 1000 Yen banknote, which featured Natsume Sōseki (the design has since changed)."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.JPY,
                    SlangTerm = "樋口一葉 (higuchi ichiyō)",
                    Multiplier = 5000,
                    Description = "The nickname for the 5000 Yen banknote, which features Higuchi Ichiyō."
                }
            ];

            CurrencySlang[] usa = [
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "dollar",
                    Multiplier = 1,
                    Description = "The official and most common term for the base unit of United States currency."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "buck",
                    Multiplier = 1,
                    Description = "A very common slang term for a dollar."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "cent",
                    Multiplier = 0.01f,
                    Description = "The official term for 1/100 of a dollar."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "penny",
                    Multiplier = 0.01f,
                    Description = "Slang term for a one-cent coin."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "nickel",
                    Multiplier = 0.05f,
                    Description = "Slang term for a five-cent coin."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "dime",
                    Multiplier = 0.10f,
                    Description = "Slang term for a ten-cent coin."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "quarter",
                    Multiplier = 0.25f,
                    Description = "Slang term for a twenty-five-cent coin."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "half-dollar",
                    Multiplier = 0.50f,
                    Description = "Slang term for a fifty-cent coin."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "grand",
                    Multiplier = 1000,
                    Description = "Common slang for one thousand dollars."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "K",
                    Multiplier = 1000,
                    Description = "Abbreviation for kilo, commonly used to represent one thousand dollars (e.g., $5K is $5,000)."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "sawbuck",
                    Multiplier = 10,
                    Description = "Older slang for a ten-dollar bill (from the Roman numeral X resembling a sawbuck)."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "fin",
                    Multiplier = 5,
                    Description = "Older slang for a five-dollar bill (from the Yiddish word 'fünf')."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "twenty",
                    Multiplier = 20,
                    Description = "Commonly used to refer to a twenty-dollar bill."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "fifty",
                    Multiplier = 50,
                    Description = "Commonly used to refer to a fifty-dollar bill."
                },
                new CurrencySlang
                {
                    CurrencyCode = CurrencyCode.USD,
                    SlangTerm = "hundred",
                    Multiplier = 100,
                    Description = "Commonly used to refer to a hundred-dollar bill."
                }
            ];

            return [.. vn, .. china, .. korea, .. japan, .. usa];
        }
    }
}