using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddIsActiveFieldForChatThread : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ExtractedTransactions_ChatMessages_ChatMessageId",
                table: "ExtractedTransactions");

            migrationBuilder.DropForeignKey(
                name: "FK_ExtractedTransactions_Transactions_TransactionId",
                table: "ExtractedTransactions");

            migrationBuilder.DropIndex(
                name: "IX_ExtractedTransactions_ChatMessageId",
                table: "ExtractedTransactions");

            migrationBuilder.DropIndex(
                name: "IX_ExtractedTransactions_TransactionId",
                table: "ExtractedTransactions");

            migrationBuilder.DropColumn(
                name: "ChatMessageId",
                table: "ExtractedTransactions");

            migrationBuilder.AlterColumn<int>(
                name: "TransactionId",
                table: "ExtractedTransactions",
                type: "integer",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "ChatThreads",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AlterColumn<string>(
                name: "UserId",
                table: "ChatMessages",
                type: "character varying(36)",
                maxLength: 36,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(36)",
                oldMaxLength: 36);

            migrationBuilder.CreateIndex(
                name: "IX_ExtractedTransactions_TransactionId",
                table: "ExtractedTransactions",
                column: "TransactionId",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_ExtractedTransactions_Transactions_TransactionId",
                table: "ExtractedTransactions",
                column: "TransactionId",
                principalTable: "Transactions",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ExtractedTransactions_Transactions_TransactionId",
                table: "ExtractedTransactions");

            migrationBuilder.DropIndex(
                name: "IX_ExtractedTransactions_TransactionId",
                table: "ExtractedTransactions");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "ChatThreads");

            migrationBuilder.AlterColumn<int>(
                name: "TransactionId",
                table: "ExtractedTransactions",
                type: "integer",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "integer",
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ChatMessageId",
                table: "ExtractedTransactions",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AlterColumn<string>(
                name: "UserId",
                table: "ChatMessages",
                type: "character varying(36)",
                maxLength: 36,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "character varying(36)",
                oldMaxLength: 36,
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_ExtractedTransactions_ChatMessageId",
                table: "ExtractedTransactions",
                column: "ChatMessageId");

            migrationBuilder.CreateIndex(
                name: "IX_ExtractedTransactions_TransactionId",
                table: "ExtractedTransactions",
                column: "TransactionId");

            migrationBuilder.AddForeignKey(
                name: "FK_ExtractedTransactions_ChatMessages_ChatMessageId",
                table: "ExtractedTransactions",
                column: "ChatMessageId",
                principalTable: "ChatMessages",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ExtractedTransactions_Transactions_TransactionId",
                table: "ExtractedTransactions",
                column: "TransactionId",
                principalTable: "Transactions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
