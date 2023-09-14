using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BusMEAPI.Migrations
{
    /// <inheritdoc />
    public partial class apiid : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ApiId",
                table: "BusStops",
                type: "text",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ApiId",
                table: "BusStops");
        }
    }
}
