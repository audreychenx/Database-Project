create database Database_Project1;
use Database_Project1;

drop table Customer;

CREATE TABLE Customer(
    LastName            CHAR(35),
    FirstName           CHAR(35),
    Address             CHAR(35),
    City                CHAR(35),
    State               CHAR(35),
    ZipCode             INTEGER,
    Telephone           CHAR(15),
    Email               CHAR(255),
    AccountNumber       INTEGER,
    AccountCreationDate DATE,
    CreditCardNumber    CHAR(16),
    PRIMARY KEY(AccountNumber),
    CONSTRAINT CCardRange CHECK ( CreditCardNumber LIKE '%[0-9]%')
);

## Add, Edit and Delete information for an customer
INSERT INTO Customer (LastName,FirstName,Address,City,State,Zipcode,Telephone,Email, AccountNumber,AccountCreationDate,CreditCardNumber)
VALUES ("Tan","Amy","366 College Ave", "Princeton", "NJ", 08902, "608-323-2002", "ta@rutgers,edu", 12346,20110223,"4111111111111112"),
	   ("Lee","Tim","286 College Ave", "Princeton", "NJ", 08902, "608-323-2002", "lt@rutgers,edu", 12347,20110123,"4111211111111112"),
	   ("Zhao","Vic","389 College Ave", "Trenton", "NJ", 08902, "608-323-2002", "zv@rutgers,edu", 12348,20110223,"4111111111131112"),
	   ("Siedel","Matt","376 College Ave", "Princeton", "NJ", 08901, "608-323-2002", "st@rutgers,edu", 12349,20080223,"4111111114111112"),
		("Vogal","Kip","896 College Ave", "Princeton", "NJ", 08900, "608-323-2002", "vk@rutgers,edu", 12350,20110223,"4111111115111112"),
		("Grey","John","300 College Ave", "Princeton", "NJ", 08902, "608-323-2002", "gj@rutgers,edu", 12351,20130223,"4111111111171112"),
		("Pepe","Bob","312 College Ave", "Princeton", "NJ", 08902, "608-323-2002", "pb@rutgers,edu", 12352,20000223,"4111111111111114"),
		("Bei","Christ","226 Marc Dr", "New Brunswick", "NJ", 08902, "808-323-2012", "bc@rutgers,edu", 12353,20120223,"4111111111116113");

SELECT * FROM Customer;

   
CREATE TABLE Preferences (
    AccountNumber   INTEGER,
    PreferredSeat   ENUM('aisle', 'window', 'business', 'first', 'economy'),
    PreferredMeal   ENUM('beef & rice', 'chicken & noodle', 'pizza'),
    FOREIGN KEY(AccountNumber) REFERENCES Customer(AccountNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    PRIMARY KEY(AccountNumber)
);

CREATE TABLE Reservation (
    ReservationNumber         INTEGER,
    DateOfTravel              DATETIME,
    BookingFee                INTEGER,
    FareRestriction           CHAR(60),
    PassengerNumber           INTEGER,
    TotalFare                 INTEGER,
	CustomerAcc               INTEGER,
    EmployeeNumber            INTEGER,
    FOREIGN KEY ( EmployeeNumber) REFERENCES Manager(EmployeeNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (CustomerAcc) REFERENCES Customer(AccountNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    PRIMARY KEY (ReservationNumber),
    CONSTRAINT FeeLessThanFare CHECK (BookingFee < TotalFare)
); 

CREATE TABLE Leg (
    Id                    INTEGER,
    StopId1              char(3),
    StopId2              char(3),
    FlightNumber        INTEGER,
    ReservationNumber  INTEGER,
    SeatNumber          CHAR(3),
    SpecialMeal         ENUM('beef & rice', 'chicken & noodle', 'pizza'),
    SeatClass           ENUM('aisle', 'window', 'business', 'first', 'economy'),
    FOREIGN KEY (StopId1)      REFERENCES Airport(Id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (StopId2)      REFERENCES Airport(Id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (ReservationNumber) REFERENCES
   Reservation(ReservationNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    UNIQUE KEY (FlightNumber, SeatNumber, StopId1, StopId2) ,
    PRIMARY KEY (Id)
);

DROP TABLE Airport;

CREATE TABLE Airport (
    Id      CHAR(10),
    Name    CHAR(90) NOT NULL,
    City    CHAR(90) ,
    Country CHAR(90),
    PRIMARY KEY (Id)
);

LOAD DATA LOCAL INFILE '/Users/AudreyChen/Desktop/Database/airports.csv' INTO TABLE Airport
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Airport;

CREATE TABLE Flight (
    FlightNumber    INTEGER,
    Seats           INTEGER,
    FareRestriction CHAR(60), 
    Fare            INTEGER,
    AirlineId       CHAR(2),
    FOREIGN KEY (AirlineId) REFERENCES Airline(Id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
        CONSTRAINT FlightRange CHECK (FlightNumber > 0 AND
                                            FlightNumber < 10000),
    PRIMARY KEY (FlightNumber)
);

CREATE TABLE Manager (
EmployeeNumber  INTEGER,
    ManagerAcc INTEGER,
    ManagerPassword   CHAR(35),
    PRIMARY KEY(EmployeeNumber)
    );

CREATE TABLE Stop_at (
	ID            INTEGER,
    ArrivalTime   DATETIME,
    DepartureTime DATETIME,
    AirportId     CHAR(3),
    FlightNumber  INTEGER,
    
	PRIMARY KEY (ID),

    FOREIGN KEY (AirportId) REFERENCES Airport(Id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,

    FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FlightRange CHECK (FlightNumber > 0 AND
                                        FlightNumber < 10000),
      UNIQUE KEY (ArrivalTime, DepartureTime, AirportId, FlightNumber)
);

CREATE TABLE Airline (
    Id CHAR(2),
    Name CHAR(50) NOT NULL,
    PRIMARY KEY (Id)
);

CREATE TABLE DaysOfWeek (
    FlightNumber INTEGER,
    DayOfWeek ENUM('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
    FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (FlightNumber, DayOfWeek)
);

# list available flights for customers to search
Select *
From Leg l1, Stop_at s1
Where l1.StopId1 = "" and 
	  l1.StopId2 = "" and 
	  s1. = "" and 
      lt.depart_date = "";



