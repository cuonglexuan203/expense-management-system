using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ChangeRelationshipChatMessageAndTransaction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Transactions_ChatMessageId",
                table: "Transactions");

            migrationBuilder.AddColumn<string>(
                name: "Type",
                table: "ChatThreads",
                type: "character varying(15)",
                maxLength: 15,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_ChatMessageId",
                table: "Transactions",
                column: "ChatMessageId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Transactions_ChatMessageId",
                table: "Transactions");

            migrationBuilder.DropColumn(
                name: "Type",
                table: "ChatThreads");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_ChatMessageId",
                table: "Transactions",
                column: "ChatMessageId",
                unique: true);
        }
    }
}
