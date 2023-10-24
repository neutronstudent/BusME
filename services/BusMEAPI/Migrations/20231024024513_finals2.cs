using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BusMEAPI.Migrations
{
    /// <inheritdoc />
    public partial class finals2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_UserSettings_SettingsId",
                table: "Users");

            migrationBuilder.AlterColumn<int>(
                name: "SettingsId",
                table: "Users",
                type: "integer",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AddColumn<DateTime>(
                name: "Expiry",
                table: "Users",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "HasWheelchair",
                table: "BusTrips",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddForeignKey(
                name: "FK_Users_UserSettings_SettingsId",
                table: "Users",
                column: "SettingsId",
                principalTable: "UserSettings",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_UserSettings_SettingsId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "Expiry",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "HasWheelchair",
                table: "BusTrips");

            migrationBuilder.AlterColumn<int>(
                name: "SettingsId",
                table: "Users",
                type: "integer",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "integer",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Users_UserSettings_SettingsId",
                table: "Users",
                column: "SettingsId",
                principalTable: "UserSettings",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
