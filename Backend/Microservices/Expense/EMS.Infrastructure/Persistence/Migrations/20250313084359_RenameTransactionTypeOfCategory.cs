using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RenameTransactionTypeOfCategory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Description",
                table: "Transactions");

            migrationBuilder.RenameColumn(
                name: "TransactionType",
                table: "Categories",
                newName: "FinancialFlowType");

            migrationBuilder.AddColumn<string>(
                name: "Name",
                table: "Transactions",
                type: "character varying(255)",
                maxLength: 255,
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Name",
                table: "Transactions");

            migrationBuilder.RenameColumn(
                name: "FinancialFlowType",
                table: "Categories",
                newName: "TransactionType");

            migrationBuilder.AddColumn<string>(
                name: "Description",
                table: "Transactions",
                type: "text",
                nullable: true);
        }
    }
}
