using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddTimeZoneIdColumnForUserPreference : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ScheduledEvents_AspNetUsers_ApplicationUserId",
                table: "ScheduledEvents");

            migrationBuilder.DropForeignKey(
                name: "FK_ScheduledEvents_Wallets_WalletId",
                table: "ScheduledEvents");

            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_ScheduledEvents_CalendarEventId",
                table: "Transactions");

            migrationBuilder.DropIndex(
                name: "IX_Transactions_CalendarEventId",
                table: "Transactions");

            migrationBuilder.DropIndex(
                name: "IX_ScheduledEvents_ApplicationUserId",
                table: "ScheduledEvents");

            migrationBuilder.DropIndex(
                name: "IX_ScheduledEvents_WalletId",
                table: "ScheduledEvents");

            migrationBuilder.DropColumn(
                name: "CalendarEventId",
                table: "Transactions");

            migrationBuilder.DropColumn(
                name: "ApplicationUserId",
                table: "ScheduledEvents");

            migrationBuilder.DropColumn(
                name: "WalletId",
                table: "ScheduledEvents");

            migrationBuilder.AddColumn<string>(
                name: "TimeZoneId",
                table: "UserPreferences",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "TimeZoneId",
                table: "UserPreferences");

            migrationBuilder.AddColumn<int>(
                name: "CalendarEventId",
                table: "Transactions",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ApplicationUserId",
                table: "ScheduledEvents",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "WalletId",
                table: "ScheduledEvents",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_CalendarEventId",
                table: "Transactions",
                column: "CalendarEventId");

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledEvents_ApplicationUserId",
                table: "ScheduledEvents",
                column: "ApplicationUserId");

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledEvents_WalletId",
                table: "ScheduledEvents",
                column: "WalletId");

            migrationBuilder.AddForeignKey(
                name: "FK_ScheduledEvents_AspNetUsers_ApplicationUserId",
                table: "ScheduledEvents",
                column: "ApplicationUserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ScheduledEvents_Wallets_WalletId",
                table: "ScheduledEvents",
                column: "WalletId",
                principalTable: "Wallets",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_ScheduledEvents_CalendarEventId",
                table: "Transactions",
                column: "CalendarEventId",
                principalTable: "ScheduledEvents",
                principalColumn: "Id");
        }
    }
}
