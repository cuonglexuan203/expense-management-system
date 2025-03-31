using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EMS.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateMediaEntity : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "Url",
                table: "Media",
                type: "character varying(1023)",
                maxLength: 1023,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(500)",
                oldMaxLength: 500);

            migrationBuilder.AlterColumn<string>(
                name: "Type",
                table: "Media",
                type: "character varying(15)",
                maxLength: 15,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<long>(
                name: "Size",
                table: "Media",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AddColumn<string>(
                name: "AssetId",
                table: "Media",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Duration",
                table: "Media",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Height",
                table: "Media",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsOptimized",
                table: "Media",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "Metadata",
                table: "Media",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "PublicId",
                table: "Media",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "SecureUrl",
                table: "Media",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Status",
                table: "Media",
                type: "character varying(15)",
                maxLength: 15,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ThumbnailUrl",
                table: "Media",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Width",
                table: "Media",
                type: "integer",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AssetId",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "Duration",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "Height",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "IsOptimized",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "Metadata",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "PublicId",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "SecureUrl",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "ThumbnailUrl",
                table: "Media");

            migrationBuilder.DropColumn(
                name: "Width",
                table: "Media");

            migrationBuilder.AlterColumn<string>(
                name: "Url",
                table: "Media",
                type: "character varying(500)",
                maxLength: 500,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "character varying(1023)",
                oldMaxLength: 1023,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Type",
                table: "Media",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(15)",
                oldMaxLength: 15);

            migrationBuilder.AlterColumn<int>(
                name: "Size",
                table: "Media",
                type: "integer",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint");
        }
    }
}
