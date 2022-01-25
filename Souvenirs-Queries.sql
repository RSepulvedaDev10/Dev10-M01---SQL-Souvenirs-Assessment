--Get the 3 most inexpensive souvenirs. Then get the 7 most expensive souvenirs.--

SELECT *
FROM Souvenirs;

SELECT TOP 3 SouvenirName, Price
FROM Souvenirs
ORDER BY Price ASC;

SELECT TOP 7 SouvenirName, Price
FROM Souvenirs
ORDER BY Price DESC;

--List all mugs, ordered from heaviest to lightest.--

SELECT SouvenirName, Weight
FROM Souvenirs
WHERE SouvenirName LIKE ('%Mug%')
ORDER BY Weight DESC;

--Count the number of spoons in the collection.--

SELECT COUNT(SouvenirName) 
FROM Souvenirs
WHERE SouvenirName LIKE ('%Spoon%');

--Find the average weight, minimum weight, and maximum weight for each category by name. Use meaningful alias names for the aggregates.--

SELECT CategoryName, AVG(Weight) AS AverageWeight, MIN(Weight) AS MinimumWeight, MAX(Weight) AS MaximumWeight
FROM Souvenirs AS S
JOIN Categories as C ON S.CategoryID = C.CategoryID
GROUP BY CategoryName;

--List all kitchenware souvenirs and their general location fields - including city name, region name, country name, longitude, and latitude - without duplication.--

SELECT SouvenirName, SouvenirDescription, Weight, Price, City, Region, Country, Longitude, Latitude
FROM Souvenirs AS S
JOIN Categories AS C ON S.CategoryID = C.CategoryID
JOIN Locations AS L ON S.LocationID = L.LocationID
WHERE CategoryName LIKE ('Kitchenware');

--Find the earliest and latest obtained date for each owner, ordered by the earliest of the earliest dates to the latest of the earliest dates.--

SELECT OwnerName, MIN(DateObtained) AS EarliestDates, MAX(DateObtained) AS LatestDates
FROM Souvenirs AS S
JOIN Owners AS O ON S.OwnerID = O.OwnerID
GROUP BY OwnerName
ORDER BY EarliestDates ASC;

--What is the most popular date for the souvenirs? Store this date in a variable. Find all souvenirs obtained on that date.--

DECLARE @MostPopularDate DATE

SELECT @MostPopularDate = (SELECT TOP 1 DateObtained
FROM Souvenirs
GROUP BY DateObtained
ORDER BY COUNT(DateObtained) DESC)
FROM Souvenirs;

SELECT SouvenirName, DateObtained
FROM Souvenirs
WHERE DateObtained = @MostPopularDate;

--Find all souvenirs that do not have a latitude and longitude.--

SELECT SouvenirID, SouvenirName, Latitude, Longitude
FROM Souvenirs AS S
JOIN Locations AS L ON S.LocationID = L.LocationID
WHERE Longitude IS NULL AND Latitude IS NULL;

--Find all souvenirs that do not have a city, region, and country.--

SELECT SouvenirID, SouvenirName, City, Region, Country
FROM Souvenirs AS S
JOIN Locations AS L ON S.LocationID = L.LocationID
WHERE City IS NULL AND Region IS NULL AND Country IS NULL;

--Find all souvenirs - name, city name, region name, country name, latitude,longitude, and weight - heavier than the average weight for all souvenirs. Use a subquery in a WHERE clause to achieve this.--

SELECT SouvenirName, City, Region, Country, Longitude, Latitude, Weight
FROM Souvenirs AS S
JOIN Locations AS L ON S.LocationID = L.LocationID
WHERE Weight > (
    SELECT AVG(Weight)
    FROM Souvenirs
);

--Find the most expensive and least expensive souvenir in each category.--

--Option 1--
SELECT CategoryName, MIN(Price) AS LeastExpensiveSouvenirPrice, MAX(Price) AS MostExpensiveSouvenirPrice
FROM Souvenirs AS S
JOIN Categories AS C ON S.CategoryID = C.CategoryID
GROUP BY CategoryName;

--Option 2--
DECLARE @LeastExpensiveSouvenir DECIMAL(10,2)
DECLARE @MostExpensiveSouvenir DECIMAL(10,2)

SELECT @LeastExpensiveSouvenir = MIN(Price), @MostExpensiveSouvenir = MAX(Price)
FROM Souvenirs

SELECT SouvenirName, CategoryName, Price
FROM Souvenirs AS S
JOIN Categories AS C ON S.CategoryID = C.CategoryID
WHERE Price = @LeastExpensiveSouvenir OR Price = @MostExpensiveSouvenir
ORDER BY CategoryName ASC;