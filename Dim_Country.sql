CREATE TABLE Dim_Country (

countryCode SMALLINT PRIMARY KEY,
CountryName VARCHAR(100) NOT NULL

);
INSERT INTO Dim_Country (countryCode, CountryName)
VALUES
	(391, 'United States'),
	(406, 'Canada'),
    (770, 'United Kingdom'),
    (818, 'Germany'),
    (897, 'France')