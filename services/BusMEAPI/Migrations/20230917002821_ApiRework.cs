using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BusMEAPI.Migrations
{
    /// <inheritdoc />
    public partial class ApiRework : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Order",
                table: "BusTrips");

            migrationBuilder.DropColumn(
                name: "Service",
                table: "BusTrips");

            migrationBuilder.AddColumn<DateTime>(
                name: "StartTime",
                table: "BusTrips",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "StartTime",
                table: "BusTrips");

            migrationBuilder.AddColumn<int>(
                name: "Order",
                table: "BusTrips",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Service",
                table: "BusTrips",
                type: "text",
                nullable: true);
        }
    }
}
