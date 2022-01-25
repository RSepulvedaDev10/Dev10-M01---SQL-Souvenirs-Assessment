--Insert the delimited data into your database. Use SQL to populate the normalized schema. Drop the denormalized table when you're finished with it.--

INSERT INTO Categories (CategoryName)
    SELECT DISTINCT Category
    FROM SouvenirsDenormalizedTable;

INSERT INTO Owners (OwnerName)
    SELECT DISTINCT Owner
    FROM SouvenirsDenormalizedTable;

INSERT INTO Locations (City, Region, Country, Longitude, Latitude)
    SELECT DISTINCT City, Region, Country, Longitude, Latitude
    FROM SouvenirsDenormalizedTable;

INSERT INTO Souvenirs (SouvenirName, SouvenirDescription, CategoryID, Weight, Price, LocationID, OwnerID, DateObtained)
    SELECT DISTINCT SDT.Souvenir_Name, SDT.Souvenir_Description, C.CategoryID, SDT.Weight, SDT.Price, L.LocationID, O.OwnerID, SDT.DateObtained
    FROM SouvenirsDenormalizedTable AS SDT
    JOIN Categories AS C ON SDT.Category = C.CategoryName
    JOIN Locations AS L ON SDT.City = L.City AND SDT.Region = L.Region AND SDT.Country = L.Country
    JOIN Owners AS O ON SDT.Owner = O.OwnerName;

INSERT INTO Souvenirs (SouvenirName, SouvenirDescription, CategoryID, Weight, Price, LocationID, OwnerID, DateObtained)
    SELECT DISTINCT SDT.Souvenir_Name, SDT.Souvenir_Description, C.CategoryID, SDT.Weight, SDT.Price, L.LocationID, O.OwnerID, SDT.DateObtained
    FROM SouvenirsDenormalizedTable AS SDT
    JOIN Categories AS C ON SDT.Category = C.CategoryName
    JOIN Locations AS L ON SDT.Longitude = L.Longitude AND SDT.Latitude = L.Latitude
    JOIN Owners AS O ON SDT.Owner = O.OwnerName;

INSERT INTO Souvenirs (SouvenirName, SouvenirDescription, CategoryID, Weight, Price, LocationID, OwnerID, DateObtained)
    SELECT DISTINCT SDT.Souvenir_Name, SDT.Souvenir_Description, C.CategoryID, SDT.Weight, SDT.Price, L.LocationID, O.OwnerID, SDT.DateObtained
    FROM SouvenirsDenormalizedTable AS SDT
    JOIN Categories AS C ON SDT.Category = C.CategoryName
    JOIN Locations AS L ON (SDT.City IS NULL AND L.City IS NULL AND SDT.Region IS NULL AND L.Region IS NULL AND SDT.Country IS NULL AND L.Country IS NULL AND SDT.Longitude IS NULL AND L.Longitude IS NULL AND SDT.Latitude IS NULL AND L.Latitude IS NULL)
    JOIN Owners AS O ON SDT.Owner = O.OwnerName;

DROP TABLE SouvenirsDenormalizedTable;

/*Video games need to be broken out from the Toy category. Add a category for Video Game. Update the souvenirs that are video games with the new category. 
This may require you looking at the data carefully to identify video games. */

INSERT INTO Categories (CategoryName)
VALUES ('Video Games');

UPDATE Souvenirs SET
    CategoryID = 12
WHERE SouvenirName IN ('Oxygen Not Included', 'Stardew Valley');

--Jewelry boxes should be recategorized as Miscellaneous.--

UPDATE Souvenirs SET
    CategoryID = 8
WHERE SouvenirName LIKE ('%Jewelry Box%');  

--Shamisen, Egyptian Drum, and Zuffolo need to be broken out as Musical Instruments.--

INSERT INTO Categories (CategoryName)
VALUES ('Musical Instruments');

UPDATE Souvenirs SET
    CategoryID = 13
WHERE SouvenirName IN ('Shamisen', 'Egyptian Drum', 'Zuffolo');

--Delete the souvenir that is the heaviest. This is causing trouble in graphing data and is an outlier we want to exclude.--

DECLARE @HeaviestSouvenir FLOAT

SELECT @HeaviestSouvenir = MAX(Weight)
FROM Souvenirs

DELETE FROM Souvenirs
WHERE Weight = @HeaviestSouvenir;

--Delete all souvenirs that are dirt or sand.--

DELETE FROM Souvenirs
WHERE SouvenirName LIKE ('%Sand%') OR SouvenirName LIKE ('%Dirt%');