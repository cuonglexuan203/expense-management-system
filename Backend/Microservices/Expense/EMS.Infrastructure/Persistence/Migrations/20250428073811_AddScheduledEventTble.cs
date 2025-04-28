using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddScheduledEventTble : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_CalendarEvents_CalendarEventId",
                table: "Transactions");

            migrationBuilder.DropTable(
                name: "CalendarEvents");

            migrationBuilder.CreateTable(
                name: "RecurrenceRules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Frequency = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    Interval = table.Column<int>(type: "integer", nullable: false),
                    ByDayOfWeek = table.Column<string[]>(type: "text[]", nullable: false),
                    ByMonthDay = table.Column<int[]>(type: "integer[]", nullable: false),
                    ByMonth = table.Column<int[]>(type: "integer[]", nullable: false),
                    EndDate = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    MaxOccurrences = table.Column<int>(type: "integer", nullable: true),
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
                    table.PrimaryKey("PK_RecurrenceRules", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ScheduledEvents",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserId = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    Name = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    Description = table.Column<string>(type: "text", nullable: true),
                    Type = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Payload = table.Column<string>(type: "jsonb", nullable: true),
                    Status = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    RecurrenceRuleId = table.Column<int>(type: "integer", nullable: true),
                    InitialTrigger = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    NextOccurrence = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    LastOccurrence = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    ApplicationUserId = table.Column<string>(type: "text", nullable: true),
                    WalletId = table.Column<int>(type: "integer", nullable: true),
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
                    table.PrimaryKey("PK_ScheduledEvents", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ScheduledEvents_AspNetUsers_ApplicationUserId",
                        column: x => x.ApplicationUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ScheduledEvents_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ScheduledEvents_RecurrenceRules_RecurrenceRuleId",
                        column: x => x.RecurrenceRuleId,
                        principalTable: "RecurrenceRules",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ScheduledEvents_Wallets_WalletId",
                        column: x => x.WalletId,
                        principalTable: "Wallets",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "ScheduledEventExecutions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ScheduledEventId = table.Column<int>(type: "integer", nullable: false),
                    ScheduledTime = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    ProcessingStartTime = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    ProcessingEndTime = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    Status = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    Notes = table.Column<string>(type: "text", nullable: true),
                    TransactionId = table.Column<int>(type: "integer", nullable: true),
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
                    table.PrimaryKey("PK_ScheduledEventExecutions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ScheduledEventExecutions_ScheduledEvents_ScheduledEventId",
                        column: x => x.ScheduledEventId,
                        principalTable: "ScheduledEvents",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ScheduledEventExecutions_Transactions_TransactionId",
                        column: x => x.TransactionId,
                        principalTable: "Transactions",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledEventExecutions_ScheduledEventId",
                table: "ScheduledEventExecutions",
                column: "ScheduledEventId");

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledEventExecutions_TransactionId",
                table: "ScheduledEventExecutions",
                column: "TransactionId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledEvents_ApplicationUserId",
                table: "ScheduledEvents",
                column: "ApplicationUserId");

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledEvents_RecurrenceRuleId",
                table: "ScheduledEvents",
                column: "RecurrenceRuleId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledEvents_UserId",
                table: "ScheduledEvents",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledEvents_WalletId",
                table: "ScheduledEvents",
                column: "WalletId");

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_ScheduledEvents_CalendarEventId",
                table: "Transactions",
                column: "CalendarEventId",
                principalTable: "ScheduledEvents",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_ScheduledEvents_CalendarEventId",
                table: "Transactions");

            migrationBuilder.DropTable(
                name: "ScheduledEventExecutions");

            migrationBuilder.DropTable(
                name: "ScheduledEvents");

            migrationBuilder.DropTable(
                name: "RecurrenceRules");

            migrationBuilder.CreateTable(
                name: "CalendarEvents",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    WalletId = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    CreatedBy = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    DeletedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    DeletedBy = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    Description = table.Column<string>(type: "text", nullable: true),
                    EndDate = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    EstimatedAmount = table.Column<float>(type: "real", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Location = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    ModifiedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    ModifiedBy = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    RecurrenceType = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    StartDate = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    Title = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    TransactionType = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: true),
                    UserId = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CalendarEvents", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CalendarEvents_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CalendarEvents_Wallets_WalletId",
                        column: x => x.WalletId,
                        principalTable: "Wallets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_CalendarEvents_UserId",
                table: "CalendarEvents",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_CalendarEvents_WalletId",
                table: "CalendarEvents",
                column: "WalletId");

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_CalendarEvents_CalendarEventId",
                table: "Transactions",
                column: "CalendarEventId",
                principalTable: "CalendarEvents",
                principalColumn: "Id");
        }
    }
}
