--File to create the SQL table/s for the DBInterface 

create table users (
    Id SERIAL PRIMARY KEY,
    Username varchar(255) NOT NULL UNIQUE,
    PName varchar(255) NOT NULL,
    UserType int NOT NULL,
    Email varchar(255) NOT NULL,
    Phone varchar(255) NOT NULL
);
