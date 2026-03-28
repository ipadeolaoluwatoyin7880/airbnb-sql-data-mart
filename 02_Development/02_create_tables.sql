-- ============================================
-- CREATE TABLES FOR AIRBNB DATABASE
-- Follows ER Model with 22 entities
-- ============================================

-- 1. ROLE TABLE
CREATE TABLE Role (
    RoleID INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(50) NOT NULL,
    Permissions JSON,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(RoleName)
);

-- 2. USER TABLE (References Role)
CREATE TABLE User (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    RoleID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    ProfilePic VARCHAR(255),
    PasswordHash VARCHAR(255) NOT NULL,
    JoinDate DATE DEFAULT (CURRENT_DATE),
    VerifiedStatus BOOLEAN DEFAULT FALSE,
    LastLogin TIMESTAMP NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID) ON DELETE RESTRICT,
    INDEX idx_email (Email),
    INDEX idx_role (RoleID)
);

-- 3. LOCATION TABLE
CREATE TABLE Location (
    LocationID INT PRIMARY KEY AUTO_INCREMENT,
    Address VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100),
    Country VARCHAR(100) NOT NULL,
    PostalCode VARCHAR(20),
    Latitude DECIMAL(10, 8),
    Longitude DECIMAL(11, 8),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_city (City),
    INDEX idx_country (Country)
);

-- 4. PROPERTYTYPE TABLE
CREATE TABLE PropertyType (
    TypeID INT PRIMARY KEY AUTO_INCREMENT,
    TypeName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. PROPERTY TABLE (Triple Relationship: User-Host-Property)
CREATE TABLE Property (
    PropertyID INT PRIMARY KEY AUTO_INCREMENT,
    HostID INT NOT NULL,
    TypeID INT NOT NULL,
    Title VARCHAR(200) NOT NULL,
    Description TEXT,
    LocationID INT NOT NULL,
    BasePrice DECIMAL(10, 2) NOT NULL CHECK (BasePrice > 0),
    CleaningFee DECIMAL(8, 2) DEFAULT 0,
    ServiceFee DECIMAL(8, 2) DEFAULT 0,
    MaxGuests INT NOT NULL CHECK (MaxGuests > 0),
    Bedrooms INT,
    Bathrooms DECIMAL(3, 1),
    SquareMeters INT,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (HostID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (TypeID) REFERENCES PropertyType(TypeID) ON DELETE RESTRICT,
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE RESTRICT,
    INDEX idx_host (HostID),
    INDEX idx_location (LocationID),
    INDEX idx_type (TypeID)
);

-- 6. AMENITY TABLE
CREATE TABLE Amenity (
    AmenityID INT PRIMARY KEY AUTO_INCREMENT,
    AmenityName VARCHAR(100) NOT NULL UNIQUE,
    Category VARCHAR(50),
    IconClass VARCHAR(50),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. PROPERTYAMENITY BRIDGE TABLE (M:N Relationship)
CREATE TABLE PropertyAmenity (
    PropertyID INT NOT NULL,
    AmenityID INT NOT NULL,
    AddedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (PropertyID, AmenityID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID) ON DELETE CASCADE,
    FOREIGN KEY (AmenityID) REFERENCES Amenity(AmenityID) ON DELETE CASCADE,
    INDEX idx_property (PropertyID),
    INDEX idx_amenity (AmenityID)
);

-- 8. BOOKINGSTATUS TABLE
CREATE TABLE BookingStatus (
    StatusID INT PRIMARY KEY AUTO_INCREMENT,
    StatusName VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(255),
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. BOOKING TABLE (Triple Relationship: Guest-Property-Booking)
CREATE TABLE Booking (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT NOT NULL,
    PropertyID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    Nights INT GENERATED ALWAYS AS (DATEDIFF(CheckOutDate, CheckInDate)) STORED,
    GuestsCount INT NOT NULL DEFAULT 1 CHECK (GuestsCount > 0),
    BasePrice DECIMAL(10, 2) NOT NULL,
    CleaningFee DECIMAL(8, 2) DEFAULT 0,
    ServiceFee DECIMAL(8, 2) DEFAULT 0,
    TotalPrice DECIMAL(12, 2) NOT NULL,
    StatusID INT NOT NULL,
    SpecialRequests TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (GuestID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID) ON DELETE CASCADE,
    FOREIGN KEY (StatusID) REFERENCES BookingStatus(StatusID) ON DELETE RESTRICT,
    INDEX idx_guest (GuestID),
    INDEX idx_property (PropertyID),
    INDEX idx_dates (CheckInDate, CheckOutDate),
    INDEX idx_status (StatusID),
    CONSTRAINT chk_dates CHECK (CheckOutDate > CheckInDate),
    CONSTRAINT chk_guests CHECK (GuestsCount > 0)
);

-- 10. PAYMENTMETHOD TABLE
CREATE TABLE PaymentMethod (
    MethodID INT PRIMARY KEY AUTO_INCREMENT,
    MethodName VARCHAR(50) NOT NULL UNIQUE,
    Processor VARCHAR(50),
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. PAYMENTSTATUS TABLE
CREATE TABLE PaymentStatus (
    PaymentStatusID INT PRIMARY KEY AUTO_INCREMENT,
    StatusName VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. PAYMENT TABLE (Triple Relationship: Booking-Payment-Method)
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount > 0),
    PaymentDate DATETIME NOT NULL,
    MethodID INT NOT NULL,
    StatusID INT NOT NULL,
    TransactionID VARCHAR(100) UNIQUE,
    Notes TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (MethodID) REFERENCES PaymentMethod(MethodID) ON DELETE RESTRICT,
    FOREIGN KEY (StatusID) REFERENCES PaymentStatus(PaymentStatusID) ON DELETE RESTRICT,
    INDEX idx_booking (BookingID),
    INDEX idx_status (StatusID),
    INDEX idx_transaction (TransactionID)
);

-- 13. PAYOUT TABLE
CREATE TABLE Payout (
    PayoutID INT PRIMARY KEY AUTO_INCREMENT,
    HostID INT NOT NULL,
    BookingID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount > 0),
    PayoutDate DATE NOT NULL,
    Status VARCHAR(50) DEFAULT 'Pending',
    TransactionRef VARCHAR(100),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (HostID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE,
    INDEX idx_host (HostID),
    INDEX idx_booking (BookingID),
    INDEX idx_status (Status)
);

-- 14. REVIEW TABLE (Recursive Relationship: User reviews User)
CREATE TABLE Review (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT NOT NULL UNIQUE,
    ReviewerID INT NOT NULL,
    RevieweeID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    Response TEXT,
    ReviewDate DATE DEFAULT (CURRENT_DATE),
    IsPublished BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (ReviewerID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (RevieweeID) REFERENCES User(UserID) ON DELETE CASCADE,
    INDEX idx_reviewer (ReviewerID),
    INDEX idx_reviewee (RevieweeID),
    INDEX idx_rating (Rating),
    CONSTRAINT chk_not_self_review CHECK (ReviewerID != RevieweeID)
);

-- 15. AVAILABILITYCALENDAR TABLE
CREATE TABLE AvailabilityCalendar (
    CalendarID INT PRIMARY KEY AUTO_INCREMENT,
    PropertyID INT NOT NULL,
    CalendarDate DATE NOT NULL,
    IsAvailable BOOLEAN DEFAULT TRUE,
    CustomPrice DECIMAL(10, 2),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID) ON DELETE CASCADE,
    UNIQUE KEY uk_property_date (PropertyID, CalendarDate),
    INDEX idx_property (PropertyID),
    INDEX idx_date (CalendarDate)
);

-- 16. MESSAGE TABLE (Recursive Relationship: User messages User)
CREATE TABLE Message (
    MessageID INT PRIMARY KEY AUTO_INCREMENT,
    SenderID INT NOT NULL,
    ReceiverID INT NOT NULL,
    BookingID INT,
    MessageText TEXT NOT NULL,
    SentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ReadDate TIMESTAMP NULL,
    IsRead BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (SenderID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ReceiverID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE SET NULL,
    INDEX idx_sender (SenderID),
    INDEX idx_receiver (ReceiverID),
    INDEX idx_booking (BookingID)
);

-- 17. DISPUTE TABLE
CREATE TABLE Dispute (
    DisputeID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT NOT NULL,
    RaisedByID INT NOT NULL,
    Title VARCHAR(200) NOT NULL,
    Description TEXT NOT NULL,
    Status VARCHAR(50) DEFAULT 'Open',
    Resolution TEXT,
    CreatedDate DATE DEFAULT (CURRENT_DATE),
    ResolvedDate DATE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (RaisedByID) REFERENCES User(UserID) ON DELETE CASCADE,
    INDEX idx_booking (BookingID),
    INDEX idx_status (Status)
);

-- 18. AUDITLOG TABLE
CREATE TABLE AuditLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Action VARCHAR(255) NOT NULL,
    EntityType VARCHAR(50),
    EntityID INT,
    Details JSON,
    IPAddress VARCHAR(45),
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE SET NULL,
    INDEX idx_user (UserID),
    INDEX idx_action (Action),
    INDEX idx_timestamp (Timestamp)
);

-- 19. SOCIALLINK TABLE
CREATE TABLE SocialLink (
    LinkID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    Platform VARCHAR(50) NOT NULL,
    ProfileURL VARCHAR(255) NOT NULL,
    ConnectedDate DATE DEFAULT (CURRENT_DATE),
    IsVerified BOOLEAN DEFAULT FALSE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    INDEX idx_user (UserID),
    INDEX idx_platform (Platform)
);

-- 20. HOSTREPORT TABLE
CREATE TABLE HostReport (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    HostID INT NOT NULL,
    PeriodStart DATE NOT NULL,
    PeriodEnd DATE NOT NULL,
    TotalBookings INT DEFAULT 0,
    TotalNights INT DEFAULT 0,
    TotalRevenue DECIMAL(12, 2) DEFAULT 0,
    AvgRating DECIMAL(3, 2),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (HostID) REFERENCES User(UserID) ON DELETE CASCADE,
    INDEX idx_host (HostID),
    INDEX idx_period (PeriodStart, PeriodEnd)
);

-- 21. CANCELLATIONPOLICY TABLE
CREATE TABLE CancellationPolicy (
    PolicyID INT PRIMARY KEY AUTO_INCREMENT,
    PropertyID INT NOT NULL UNIQUE,
    PolicyType VARCHAR(50) NOT NULL,
    RefundPercentage INT CHECK (RefundPercentage >= 0 AND RefundPercentage <= 100),
    DaysBeforeCheckin INT,
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID) ON DELETE CASCADE,
    INDEX idx_property (PropertyID)
);

-- 22. VERIFICATION TABLE
CREATE TABLE Verification (
    VerificationID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    DocumentType VARCHAR(50) NOT NULL,
    DocumentURL VARCHAR(255) NOT NULL,
    Status VARCHAR(50) DEFAULT 'Pending',
    VerifiedBy INT,
    VerifiedDate DATE,
    Notes TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE,
    FOREIGN KEY (VerifiedBy) REFERENCES User(UserID) ON DELETE SET NULL,
    INDEX idx_user (UserID),
    INDEX idx_status (Status)
);

-- Show table creation summary
SELECT 'All 22 tables created successfully' AS Status;
SELECT COUNT(*) AS 'Total Tables Created' FROM information_schema.tables 
WHERE table_schema = 'airbnb_db' AND table_type = 'BASE TABLE';