USE master;
GO
DROP DATABASE IF EXISTS SouvenirsAssessment;
GO
CREATE DATABASE SouvenirsAssessment;
GO

CREATE TABLE Owners (
    OwnerID INT PRIMARY KEY IDENTITY(1,1),
    OwnerName VARCHAR(25) NOT NULL
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(25) NOT NULL
);

CREATE TABLE Locations (
    LocationID INT PRIMARY KEY IDENTITY(1,1),
    City VARCHAR(50) NULL,
    Region VARCHAR(50) NULL,
    Country VARCHAR(50) NULL,
    Longitude FLOAT NULL,
    Latitude FLOAT NULL
);

CREATE TABLE Souvenirs (
    SouvenirID INT PRIMARY KEY IDENTITY(1,1),
    SouvenirName VARCHAR(100) NOT NULL,
    SouvenirDescription VARCHAR(200) NULL,
    CategoryID INT NOT NULL,
    Weight INT NULL,
    Price DECIMAL(10,2) NOT NULL,
    LocationID INT NOT NULL,
    OwnerID INT NOT NULL,
    DateObtained DATE NOT NULL
    CONSTRAINT fk_Souvenirs_CategoryID
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),
    CONSTRAINT fk_Souvenirs_LocationID
        FOREIGN KEY (LocationID)
        REFERENCES Locations(LocationID),
    CONSTRAINT fk_Souvenirs_OwnerID
        FOREIGN KEY (OwnerID)
        REFERENCES Owners(OwnerID)
);