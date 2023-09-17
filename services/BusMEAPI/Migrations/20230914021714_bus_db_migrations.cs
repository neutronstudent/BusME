using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace BusMEAPI.Migrations
{
    /// <inheritdoc />
    public partial class bus_db_migrations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "RouteId",
                table: "Users",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "BusRoutes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    RouteId = table.Column<string>(type: "text", nullable: false),
                    RouteShortName = table.Column<string>(type: "text", nullable: true),
                    RouteLongName = table.Column<string>(type: "text", nullable: true),
                    LastUpdated = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusRoutes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "BusStops",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    BusTripId = table.Column<int>(type: "integer", nullable: false),
                    Lat = table.Column<float>(type: "real", nullable: false),
                    Long = table.Column<float>(type: "real", nullable: false),
                    StopCode = table.Column<int>(type: "integer", nullable: false),
                    StopName = table.Column<int>(type: "integer", nullable: false),
                    SupportsWheelchair = table.Column<int>(type: "integer", nullable: false),
                    Order = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusStops", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "BusTrips",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    BusRouteId = table.Column<int>(type: "integer", nullable: false),
                    TripHeadSign = table.Column<int>(type: "integer", nullable: true),
                    ApiTripID = table.Column<string>(type: "text", nullable: false),
                    Service = table.Column<string>(type: "text", nullable: true),
                    Direction = table.Column<int>(type: "integer", nullable: true),
                    Order = table.Column<int>(type: "integer", nullable: true),
                    Lat = table.Column<float>(type: "real", nullable: true),
                    Long = table.Column<float>(type: "real", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusTrips", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BusTrips_BusRoutes_BusRouteId",
                        column: x => x.BusRouteId,
                        principalTable: "BusRoutes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BusStopBusTrip",
                columns: table => new
                {
                    BusTripId = table.Column<int>(type: "integer", nullable: false),
                    StopsId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusStopBusTrip", x => new { x.BusTripId, x.StopsId });
                    table.ForeignKey(
                        name: "FK_BusStopBusTrip_BusStops_StopsId",
                        column: x => x.StopsId,
                        principalTable: "BusStops",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BusStopBusTrip_BusTrips_BusTripId",
                        column: x => x.BusTripId,
                        principalTable: "BusTrips",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BusStopBusTrip_StopsId",
                table: "BusStopBusTrip",
                column: "StopsId");

            migrationBuilder.CreateIndex(
                name: "IX_BusTrips_BusRouteId",
                table: "BusTrips",
                column: "BusRouteId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BusStopBusTrip");

            migrationBuilder.DropTable(
                name: "BusStops");

            migrationBuilder.DropTable(
                name: "BusTrips");

            migrationBuilder.DropTable(
                name: "BusRoutes");

            migrationBuilder.DropColumn(
                name: "RouteId",
                table: "Users");
        }
    }
}
