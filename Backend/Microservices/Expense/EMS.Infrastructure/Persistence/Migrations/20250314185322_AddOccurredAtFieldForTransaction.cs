using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddOccurredAtFieldForTransaction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "OccurredAt",
                table: "Transactions",
                type: "timestamp with time zone",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "OccurredAt",
                table: "Transactions");
        }
    }
}
