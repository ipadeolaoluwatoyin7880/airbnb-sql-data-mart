-- ============================================
-- TEST QUERIES FOR AIRBNB DATABASE
-- Demonstrates functionality and relationships
-- ============================================

-- 1. TEST TRIPLE RELATIONSHIP 1: Booking connects Guest, Property, and Status
-- Show all bookings with guest details, property info, and status
SELECT 
    b.BookingID,
    CONCAT(u.FirstName, ' ', u.LastName) AS GuestName,
    p.Title AS Property,
    bs.StatusName AS BookingStatus,
    b.CheckInDate,
    b.CheckOutDate,
    b.TotalPrice
FROM Booking b
JOIN User u ON b.GuestID = u.UserID
JOIN Property p ON b.PropertyID = p.PropertyID
JOIN BookingStatus bs ON b.StatusID = bs.StatusID
ORDER BY b.CheckInDate DESC
LIMIT 10;

-- 2. TEST TRIPLE RELATIONSHIP 2: Payment connects Booking, Method, and Status
-- Show all payments with booking, payment method, and status
SELECT 
    pm.PaymentID,
    b.BookingID,
    CONCAT(u.FirstName, ' ', u.LastName) AS GuestName,
    pmt.MethodName AS PaymentMethod,
    ps.StatusName AS PaymentStatus,
    pm.Amount,
    pm.PaymentDate
FROM Payment pm
JOIN Booking b ON pm.BookingID = b.BookingID
JOIN User u ON b.GuestID = u.UserID
JOIN PaymentMethod pmt ON pm.MethodID = pmt.MethodID
JOIN PaymentStatus ps ON pm.StatusID = ps.PaymentStatusID
ORDER BY pm.PaymentDate DESC
LIMIT 10;

-- 3. TEST TRIPLE RELATIONSHIP 3: Review connects Booking and Users (Reviewer/Reviewee)
-- Show all reviews with booking info and user relationships
SELECT 
    r.ReviewID,
    b.BookingID,
    CONCAT(rev.FirstName, ' ', rev.LastName) AS Reviewer,
    CONCAT(ree.FirstName, ' ', ree.LastName) AS Reviewee,
    r.Rating,
    r.Comment,
    r.ReviewDate
FROM Review r
JOIN Booking b ON r.BookingID = b.BookingID
JOIN User rev ON r.ReviewerID = rev.UserID
JOIN User ree ON r.RevieweeID = ree.UserID
ORDER BY r.ReviewDate DESC
LIMIT 10;

-- 4. TEST RECURSIVE RELATIONSHIP 1: Messages between Users
-- Show message exchanges between users
SELECT 
    m.MessageID,
    CONCAT(s.FirstName, ' ', s.LastName) AS Sender,
    CONCAT(r.FirstName, ' ', r.LastName) AS Receiver,
    m.MessageText,
    m.SentDate,
    m.IsRead
FROM Message m
JOIN User s ON m.SenderID = s.UserID
JOIN User r ON m.ReceiverID = r.UserID
ORDER BY m.SentDate DESC
LIMIT 10;

-- 5. TEST RECURSIVE RELATIONSHIP 2: Reviews between Users (already shown above)

-- 6. COMPLEX QUERY: Available properties in New York for specific dates
SELECT 
    p.PropertyID,
    p.Title,
    pt.TypeName AS PropertyType,
    CONCAT(u.FirstName, ' ', u.LastName) AS HostName,
    l.City,
    l.Country,
    p.BasePrice,
    p.MaxGuests,
    GROUP_CONCAT(a.AmenityName SEPARATOR ', ') AS Amenities
FROM Property p
JOIN PropertyType pt ON p.TypeID = pt.TypeID
JOIN User u ON p.HostID = u.UserID
JOIN Location l ON p.LocationID = l.LocationID
LEFT JOIN PropertyAmenity pa ON p.PropertyID = pa.PropertyID
LEFT JOIN Amenity a ON pa.AmenityID = a.AmenityID
WHERE l.City = 'New York'
    AND p.PropertyID NOT IN (
        SELECT DISTINCT PropertyID 
        FROM AvailabilityCalendar 
        WHERE CalendarDate BETWEEN '2024-04-01' AND '2024-04-07' 
        AND IsAvailable = FALSE
    )
    AND p.IsActive = TRUE
GROUP BY p.PropertyID, p.Title, pt.TypeName, u.FirstName, u.LastName, l.City, l.Country, p.BasePrice, p.MaxGuests
HAVING p.MaxGuests >= 2
ORDER BY p.BasePrice ASC
LIMIT 10;

-- 7. QUERY: Host earnings report
SELECT 
    CONCAT(u.FirstName, ' ', u.LastName) AS HostName,
    COUNT(DISTINCT b.BookingID) AS TotalBookings,
    SUM(b.TotalPrice) AS TotalRevenue,
    ROUND(AVG(r.Rating), 2) AS AvgRating,
    SUM(po.Amount) AS TotalPayouts,
    SUM(b.TotalPrice) - SUM(po.Amount) AS PlatformEarnings
FROM User u
LEFT JOIN Property p ON u.UserID = p.HostID
LEFT JOIN Booking b ON p.PropertyID = b.PropertyID
LEFT JOIN Review r ON b.BookingID = r.BookingID AND r.RevieweeID = u.UserID
LEFT JOIN Payout po ON u.UserID = po.HostID
WHERE u.RoleID = (SELECT RoleID FROM Role WHERE RoleName = 'Host')
    AND b.StatusID = (SELECT StatusID FROM BookingStatus WHERE StatusName = 'Completed')
GROUP BY u.UserID, u.FirstName, u.LastName
ORDER BY TotalRevenue DESC
LIMIT 10;

-- 8. QUERY: Monthly booking trends
SELECT 
    DATE_FORMAT(b.CheckInDate, '%Y-%m') AS Month,
    COUNT(*) AS NumberOfBookings,
    SUM(b.TotalPrice) AS TotalRevenue,
    AVG(b.TotalPrice) AS AvgBookingValue,
    AVG(DATEDIFF(b.CheckOutDate, b.CheckInDate)) AS AvgStayLength
FROM Booking b
WHERE b.StatusID IN (SELECT StatusID FROM BookingStatus WHERE StatusName IN ('Confirmed', 'Completed'))
GROUP BY DATE_FORMAT(b.CheckInDate, '%Y-%m')
ORDER BY Month DESC
LIMIT 12;

-- 9. QUERY: Most popular amenities
SELECT 
    a.AmenityName,
    a.Category,
    COUNT(DISTINCT pa.PropertyID) AS NumberOfProperties,
    ROUND(AVG(p.BasePrice), 2) AS AvgPriceWithAmenity
FROM Amenity a
JOIN PropertyAmenity pa ON a.AmenityID = pa.AmenityID
JOIN Property p ON pa.PropertyID = p.PropertyID
GROUP BY a.AmenityID, a.AmenityName, a.Category
ORDER BY NumberOfProperties DESC
LIMIT 10;

-- 10. QUERY: Guest booking history with reviews
SELECT 
    CONCAT(u.FirstName, ' ', u.LastName) AS GuestName,
    COUNT(DISTINCT b.BookingID) AS TotalBookings,
    SUM(b.TotalPrice) AS TotalSpent,
    ROUND(AVG(r_given.Rating), 2) AS AvgRatingGiven,
    ROUND(AVG(r_received.Rating), 2) AS AvgRatingReceived
FROM User u
LEFT JOIN Booking b ON u.UserID = b.GuestID
LEFT JOIN Review r_given ON u.UserID = r_given.ReviewerID
LEFT JOIN Review r_received ON u.UserID = r_received.RevieweeID
WHERE u.RoleID = (SELECT RoleID FROM Role WHERE RoleName = 'Guest')
GROUP BY u.UserID, u.FirstName, u.LastName
HAVING TotalBookings > 0
ORDER BY TotalSpent DESC
LIMIT 10;

-- 11. TEST: Check data integrity - Properties without hosts
SELECT 'Properties without valid hosts' AS Test, COUNT(*) AS Issues
FROM Property p
LEFT JOIN User u ON p.HostID = u.UserID
WHERE u.UserID IS NULL OR u.RoleID != (SELECT RoleID FROM Role WHERE RoleName = 'Host')
UNION ALL
-- Bookings without valid guests
SELECT 'Bookings without valid guests', COUNT(*)
FROM Booking b
LEFT JOIN User u ON b.GuestID = u.UserID
WHERE u.UserID IS NULL OR u.RoleID != (SELECT RoleID FROM Role WHERE RoleName = 'Guest')
UNION ALL
-- Payments without bookings
SELECT 'Payments without bookings', COUNT(*)
FROM Payment p
LEFT JOIN Booking b ON p.BookingID = b.BookingID
WHERE b.BookingID IS NULL;

-- 12. TEST: Verify all required entities have 20+ entries
SELECT 
    'User' AS Entity, COUNT(*) AS Count FROM User
UNION ALL SELECT 'Property', COUNT(*) FROM Property
UNION ALL SELECT 'Booking', COUNT(*) FROM Booking
UNION ALL SELECT 'Payment', COUNT(*) FROM Payment
UNION ALL SELECT 'Review', COUNT(*) FROM Review
UNION ALL SELECT 'Message', COUNT(*) FROM Message
ORDER BY Count DESC;