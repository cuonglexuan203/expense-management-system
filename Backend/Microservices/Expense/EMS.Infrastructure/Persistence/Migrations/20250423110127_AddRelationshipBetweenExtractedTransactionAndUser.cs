using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddRelationshipBetweenExtractedTransactionAndUser : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "ExtractedTransactions",
                type: "character varying(36)",
                maxLength: 36,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_ExtractedTransactions_UserId",
                table: "ExtractedTransactions",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_ExtractedTransactions_AspNetUsers_UserId",
                table: "ExtractedTransactions",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ExtractedTransactions_AspNetUsers_UserId",
                table: "ExtractedTransactions");

            migrationBuilder.DropIndex(
                name: "IX_ExtractedTransactions_UserId",
                table: "ExtractedTransactions");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "ExtractedTransactions");
        }
    }
}
