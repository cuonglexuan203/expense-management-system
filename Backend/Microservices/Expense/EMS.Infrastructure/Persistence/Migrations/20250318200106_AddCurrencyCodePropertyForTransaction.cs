using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddCurrencyCodePropertyForTransaction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Currency",
                table: "UserPreferences");

            migrationBuilder.AddColumn<string>(
                name: "CurrencyCode",
                table: "UserPreferences",
                type: "character varying(3)",
                maxLength: 3,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_UserPreferences_CurrencyCode",
                table: "UserPreferences",
                column: "CurrencyCode");

            migrationBuilder.AddForeignKey(
                name: "FK_UserPreferences_Currencies_CurrencyCode",
                table: "UserPreferences",
                column: "CurrencyCode",
                principalTable: "Currencies",
                principalColumn: "Code",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserPreferences_Currencies_CurrencyCode",
                table: "UserPreferences");

            migrationBuilder.DropIndex(
                name: "IX_UserPreferences_CurrencyCode",
                table: "UserPreferences");

            migrationBuilder.DropColumn(
                name: "CurrencyCode",
                table: "UserPreferences");

            migrationBuilder.AddColumn<string>(
                name: "Currency",
                table: "UserPreferences",
                type: "character varying(31)",
                maxLength: 31,
                nullable: false,
                defaultValue: "");
        }
    }
}
