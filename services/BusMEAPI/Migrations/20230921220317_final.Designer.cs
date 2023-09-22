﻿// <auto-generated />
using System;
using BusMEAPI.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace BusMEAPI.Migrations
{
    [DbContext(typeof(BusMEContext))]
    [Migration("20230921220317_final")]
    partial class final
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.10")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("BusMEAPI.User", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<int>("DetailsId")
                        .HasColumnType("integer");

                    b.Property<string>("Hash")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Salt")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<int>("SettingsId")
                        .HasColumnType("integer");

                    b.Property<int?>("Type")
                        .HasColumnType("integer");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.HasIndex("DetailsId");

                    b.HasIndex("SettingsId");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("BusMEAPI.UserDetail", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("Phone")
                        .IsRequired()
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.ToTable("UserDetails");
                });

            modelBuilder.Entity("BusMEAPI.UserSettings", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<bool>("AudioNotifications")
                        .HasColumnType("boolean");

                    b.Property<int>("RouteId")
                        .HasColumnType("integer");

                    b.Property<bool>("VibrationNotifications")
                        .HasColumnType("boolean");

                    b.Property<int?>("notf_type")
                        .HasColumnType("integer");

                    b.HasKey("Id");

                    b.ToTable("UserSettings");
                });

            modelBuilder.Entity("BusRoute", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<DateTime>("LastUpdated")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("RouteId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("RouteLongName")
                        .HasColumnType("text");

                    b.Property<string>("RouteShortName")
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.ToTable("BusRoutes");
                });

            modelBuilder.Entity("BusStop", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<string>("ApiId")
                        .HasColumnType("text");

                    b.Property<int>("BusTripId")
                        .HasColumnType("integer");

                    b.Property<float?>("Lat")
                        .HasColumnType("real");

                    b.Property<float?>("Long")
                        .HasColumnType("real");

                    b.Property<int?>("Order")
                        .HasColumnType("integer");

                    b.Property<string>("StopCode")
                        .HasColumnType("text");

                    b.Property<string>("StopName")
                        .HasColumnType("text");

                    b.Property<int?>("SupportsWheelchair")
                        .HasColumnType("integer");

                    b.HasKey("Id");

                    b.ToTable("BusStops");
                });

            modelBuilder.Entity("BusStopBusTrip", b =>
                {
                    b.Property<int>("BusTripId")
                        .HasColumnType("integer");

                    b.Property<int>("StopsId")
                        .HasColumnType("integer");

                    b.HasKey("BusTripId", "StopsId");

                    b.HasIndex("StopsId");

                    b.ToTable("BusStopBusTrip");
                });

            modelBuilder.Entity("BusTrip", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<string>("ApiTripID")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<int>("BusRouteId")
                        .HasColumnType("integer");

                    b.Property<int?>("Direction")
                        .HasColumnType("integer");

                    b.Property<float?>("Lat")
                        .HasColumnType("real");

                    b.Property<float?>("Long")
                        .HasColumnType("real");

                    b.Property<DateTime>("StartTime")
                        .HasColumnType("timestamp with time zone");

                    b.Property<string>("TripHeadSign")
                        .HasColumnType("text");

                    b.HasKey("Id");

                    b.HasIndex("BusRouteId");

                    b.ToTable("BusTrips");
                });

            modelBuilder.Entity("BusMEAPI.User", b =>
                {
                    b.HasOne("BusMEAPI.UserDetail", "Details")
                        .WithMany()
                        .HasForeignKey("DetailsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("BusMEAPI.UserSettings", "Settings")
                        .WithMany()
                        .HasForeignKey("SettingsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Details");

                    b.Navigation("Settings");
                });

            modelBuilder.Entity("BusStopBusTrip", b =>
                {
                    b.HasOne("BusTrip", null)
                        .WithMany()
                        .HasForeignKey("BusTripId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("BusStop", null)
                        .WithMany()
                        .HasForeignKey("StopsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("BusTrip", b =>
                {
                    b.HasOne("BusRoute", "BusRoute")
                        .WithMany("Trips")
                        .HasForeignKey("BusRouteId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("BusRoute");
                });

            modelBuilder.Entity("BusRoute", b =>
                {
                    b.Navigation("Trips");
                });
#pragma warning restore 612, 618
        }
    }
}
