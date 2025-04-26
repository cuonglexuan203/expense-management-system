using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class NullableForRelationshipChatExtractionAndExtractedTransaction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ExtractedTransactions_ChatExtractions_ChatExtractionId",
                table: "ExtractedTransactions");

            migrationBuilder.AlterColumn<int>(
                name: "ChatExtractionId",
                table: "ExtractedTransactions",
                type: "integer",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AddForeignKey(
                name: "FK_ExtractedTransactions_ChatExtractions_ChatExtractionId",
                table: "ExtractedTransactions",
                column: "ChatExtractionId",
                principalTable: "ChatExtractions",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ExtractedTransactions_ChatExtractions_ChatExtractionId",
                table: "ExtractedTransactions");

            migrationBuilder.AlterColumn<int>(
                name: "ChatExtractionId",
                table: "ExtractedTransactions",
                type: "integer",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "integer",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_ExtractedTransactions_ChatExtractions_ChatExtractionId",
                table: "ExtractedTransactions",
                column: "ChatExtractionId",
                principalTable: "ChatExtractions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
