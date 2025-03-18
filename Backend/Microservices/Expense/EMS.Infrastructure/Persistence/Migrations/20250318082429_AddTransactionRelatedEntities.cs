using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddTransactionRelatedEntities : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "RequiresConfirmation",
                table: "UserPreferences");

            migrationBuilder.DropColumn(
                name: "DetectedItems",
                table: "ChatMessages");

            migrationBuilder.DropColumn(
                name: "RequiresConfirmation",
                table: "ChatMessages");

            migrationBuilder.DropColumn(
                name: "UserConfirmation",
                table: "ChatMessages");

            migrationBuilder.RenameColumn(
                name: "Interval",
                table: "CalendarEvents",
                newName: "RecurrenceType");

            migrationBuilder.AddColumn<string>(
                name: "ConfirmationMode",
                table: "UserPreferences",
                type: "character varying(15)",
                maxLength: 15,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "CurrencyCode",
                table: "Transactions",
                type: "character varying(3)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "ChatExtractions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ChatMessageId = table.Column<int>(type: "integer", nullable: false),
                    ExtractionType = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    ExtractedData = table.Column<string>(type: "jsonb", nullable: true),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    CreatedBy = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    ModifiedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    ModifiedBy = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    DeletedBy = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ChatExtractions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ChatExtractions_ChatMessages_ChatMessageId",
                        column: x => x.ChatMessageId,
                        principalTable: "ChatMessages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Currencies",
                columns: table => new
                {
                    Code = table.Column<string>(type: "character varying(3)", unicode: false, maxLength: 3, nullable: false),
                    Country = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    CurrencyName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Currencies", x => x.Code);
                });

            migrationBuilder.CreateTable(
                name: "ExtractedTransactions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ChatExtractionId = table.Column<int>(type: "integer", nullable: false),
                    ChatMessageId = table.Column<int>(type: "integer", nullable: false),
                    CategoryId = table.Column<int>(type: "integer", nullable: false),
                    TransactionId = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    Amount = table.Column<float>(type: "real", nullable: false),
                    Type = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    OccurredAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    ConfirmationMode = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    ConfirmationStatus = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    CurrencyCode = table.Column<string>(type: "character varying(3)", nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    CreatedBy = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    ModifiedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    ModifiedBy = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    DeletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    DeletedBy = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ExtractedTransactions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ExtractedTransactions_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ExtractedTransactions_ChatExtractions_ChatExtractionId",
                        column: x => x.ChatExtractionId,
                        principalTable: "ChatExtractions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ExtractedTransactions_ChatMessages_ChatMessageId",
                        column: x => x.ChatMessageId,
                        principalTable: "ChatMessages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ExtractedTransactions_Currencies_CurrencyCode",
                        column: x => x.CurrencyCode,
                        principalTable: "Currencies",
                        principalColumn: "Code",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ExtractedTransactions_Transactions_TransactionId",
                        column: x => x.TransactionId,
                        principalTable: "Transactions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_CurrencyCode",
                table: "Transactions",
                column: "CurrencyCode");

            migrationBuilder.CreateIndex(
                name: "IX_ChatExtractions_ChatMessageId",
                table: "ChatExtractions",
                column: "ChatMessageId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ExtractedTransactions_CategoryId",
                table: "ExtractedTransactions",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_ExtractedTransactions_ChatExtractionId",
                table: "ExtractedTransactions",
                column: "ChatExtractionId");

            migrationBuilder.CreateIndex(
                name: "IX_ExtractedTransactions_ChatMessageId",
                table: "ExtractedTransactions",
                column: "ChatMessageId");

            migrationBuilder.CreateIndex(
                name: "IX_ExtractedTransactions_CurrencyCode",
                table: "ExtractedTransactions",
                column: "CurrencyCode");

            migrationBuilder.CreateIndex(
                name: "IX_ExtractedTransactions_TransactionId",
                table: "ExtractedTransactions",
                column: "TransactionId");

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_Currencies_CurrencyCode",
                table: "Transactions",
                column: "CurrencyCode",
                principalTable: "Currencies",
                principalColumn: "Code",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_Currencies_CurrencyCode",
                table: "Transactions");

            migrationBuilder.DropTable(
                name: "ExtractedTransactions");

            migrationBuilder.DropTable(
                name: "ChatExtractions");

            migrationBuilder.DropTable(
                name: "Currencies");

            migrationBuilder.DropIndex(
                name: "IX_Transactions_CurrencyCode",
                table: "Transactions");

            migrationBuilder.DropColumn(
                name: "ConfirmationMode",
                table: "UserPreferences");

            migrationBuilder.DropColumn(
                name: "CurrencyCode",
                table: "Transactions");

            migrationBuilder.RenameColumn(
                name: "RecurrenceType",
                table: "CalendarEvents",
                newName: "Interval");

            migrationBuilder.AddColumn<bool>(
                name: "RequiresConfirmation",
                table: "UserPreferences",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "DetectedItems",
                table: "ChatMessages",
                type: "jsonb",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "RequiresConfirmation",
                table: "ChatMessages",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "UserConfirmation",
                table: "ChatMessages",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }
    }
}
