-- ============================================
-- DATABASE OPERATIONS AND UTILITIES
-- ============================================

-- 1. VIEWS FOR COMMON QUERIES

-- View for property listings with details
CREATE OR REPLACE VIEW vw_property_listings AS
SELECT 
    p.PropertyID,
    p.Title,
    pt.TypeName AS PropertyType,
    CONCAT(u.FirstName, ' ', u.LastName) AS HostName,
    l.City,
    l.Country,
    p.BasePrice,
    p.MaxGuests,
    p.Bedrooms,
    p.Bathrooms,
    p.IsActive,
    (SELECT COUNT(*) FROM Review r JOIN Booking b ON r.BookingID = b.BookingID WHERE b.PropertyID = p.PropertyID) AS ReviewCount,
    (SELECT ROUND(AVG(r.Rating), 2) FROM Review r JOIN Booking b ON r.BookingID = b.BookingID WHERE b.PropertyID = p.PropertyID) AS AvgRating
FROM Property p
JOIN PropertyType pt ON p.TypeID = pt.TypeID
JOIN User u ON p.HostID = u.UserID
JOIN Location l ON p.LocationID = l.LocationID;

-- View for booking details
CREATE OR REPLACE VIEW vw_booking_details AS
SELECT 
    b.BookingID,
    CONCAT(ug.FirstName, ' ', ug.LastName) AS GuestName,
    CONCAT(uh.FirstName, ' ', uh.LastName) AS HostName,
    p.Title AS PropertyTitle,
    bs.StatusName AS BookingStatus,
    b.CheckInDate,
    b.CheckOutDate,
    b.Nights,
    b.GuestsCount,
    b.TotalPrice,
    pm.MethodName AS PaymentMethod,
    ps.StatusName AS PaymentStatus,
    r.Rating AS GuestRating,
    r.Comment AS GuestReview
FROM Booking b
JOIN User ug ON b.GuestID = ug.UserID
JOIN Property p ON b.PropertyID = p.PropertyID
JOIN User uh ON p.HostID = uh.UserID
JOIN BookingStatus bs ON b.StatusID = bs.StatusID
LEFT JOIN Payment py ON b.BookingID = py.BookingID AND py.StatusID = (SELECT PaymentStatusID FROM PaymentStatus WHERE StatusName = 'Completed')
LEFT JOIN PaymentMethod pm ON py.MethodID = pm.MethodID
LEFT JOIN PaymentStatus ps ON py.StatusID = ps.PaymentStatusID
LEFT JOIN Review r ON b.BookingID = r.BookingID;

-- View for host dashboard
CREATE OR REPLACE VIEW vw_host_dashboard AS
SELECT 
    u.UserID AS HostID,
    CONCAT(u.FirstName, ' ', u.LastName) AS HostName,
    COUNT(DISTINCT p.PropertyID) AS PropertiesListed,
    COUNT(DISTINCT b.BookingID) AS TotalBookings,
    SUM(CASE WHEN bs.StatusName = 'Completed' THEN b.TotalPrice ELSE 0 END) AS TotalRevenue,
    AVG(r.Rating) AS AvgRating,
    COUNT(DISTINCT r.ReviewID) AS ReviewCount,
    SUM(po.Amount) AS TotalPayouts
FROM User u
LEFT JOIN Property p ON u.UserID = p.HostID
LEFT JOIN Booking b ON p.PropertyID = b.PropertyID
LEFT JOIN BookingStatus bs ON b.StatusID = bs.StatusID
LEFT JOIN Review r ON b.BookingID = r.BookingID AND r.RevieweeID = u.UserID
LEFT JOIN Payout po ON u.UserID = po.HostID
WHERE u.RoleID = (SELECT RoleID FROM Role WHERE RoleName = 'Host')
GROUP BY u.UserID, u.FirstName, u.LastName;

-- 2. STORED PROCEDURES

-- Procedure to make a booking
DELIMITER $$
CREATE PROCEDURE sp_make_booking(
    IN p_guest_id INT,
    IN p_property_id INT,
    IN p_checkin DATE,
    IN p_checkout DATE,
    IN p_guests INT,
    IN p_special_requests TEXT
)
BEGIN
    DECLARE v_base_price DECIMAL(10,2);
    DECLARE v_nights INT;
    DECLARE v_total_price DECIMAL(12,2);
    DECLARE v_max_guests INT;
    DECLARE v_is_available BOOLEAN;
    
    -- Check property exists and is active
    SELECT BasePrice, MaxGuests INTO v_base_price, v_max_guests
    FROM Property 
    WHERE PropertyID = p_property_id AND IsActive = TRUE;
    
    IF v_base_price IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Property not found or not active';
    END IF;
    
    -- Check guest count
    IF p_guests > v_max_guests THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Guest count exceeds property maximum';
    END IF;
    
    -- Check availability
    SELECT NOT EXISTS (
        SELECT 1 FROM AvailabilityCalendar 
        WHERE PropertyID = p_property_id 
        AND CalendarDate BETWEEN p_checkin AND DATE_SUB(p_checkout, INTERVAL 1 DAY)
        AND IsAvailable = FALSE
    ) INTO v_is_available;
    
    IF NOT v_is_available THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Property not available for selected dates';
    END IF;
    
    -- Calculate nights and total price
    SET v_nights = DATEDIFF(p_checkout, p_checkin);
    SET v_total_price = v_base_price * v_nights;
    
    -- Create booking with pending status
    INSERT INTO Booking (GuestID, PropertyID, CheckInDate, CheckOutDate, GuestsCount, BasePrice, TotalPrice, StatusID, SpecialRequests)
    VALUES (p_guest_id, p_property_id, p_checkin, p_checkout, p_guests, v_base_price, v_total_price, 
           (SELECT StatusID FROM BookingStatus WHERE StatusName = 'Pending'), p_special_requests);
    
    -- Mark dates as unavailable
    INSERT INTO AvailabilityCalendar (PropertyID, CalendarDate, IsAvailable)
    SELECT p_property_id, date_table.selected_date, FALSE
    FROM (
        SELECT DATE_ADD(p_checkin, INTERVAL t.n DAY) AS selected_date
        FROM (
            SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
            UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13
            UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
            UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION SELECT 26 UNION SELECT 27
            UNION SELECT 28 UNION SELECT 29
        ) t
        WHERE DATE_ADD(p_checkin, INTERVAL t.n DAY) < p_checkout
    ) date_table
    ON DUPLICATE KEY UPDATE IsAvailable = FALSE;
    
    -- Log the action
    INSERT INTO AuditLog (UserID, Action, EntityType, EntityID, Details)
    VALUES (p_guest_id, 'BOOKING_CREATED', 'Booking', LAST_INSERT_ID(), 
            JSON_OBJECT('property_id', p_property_id, 'checkin', p_checkin, 'checkout', p_checkout, 'total', v_total_price));
    
    SELECT 'Booking created successfully' AS Message, LAST_INSERT_ID() AS BookingID, v_total_price AS TotalPrice;
END$$
DELIMITER ;

-- Procedure to process payment
DELIMITER $$
CREATE PROCEDURE sp_process_payment(
    IN p_booking_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_method_id INT,
    IN p_transaction_id VARCHAR(100)
)
BEGIN
    DECLARE v_booking_total DECIMAL(12,2);
    DECLARE v_guest_id INT;
    
    -- Get booking total and guest ID
    SELECT TotalPrice, GuestID INTO v_booking_total, v_guest_id
    FROM Booking WHERE BookingID = p_booking_id;
    
    IF v_booking_total IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking not found';
    END IF;
    
    -- Verify payment amount matches or is less (for deposit)
    IF p_amount > v_booking_total THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment amount exceeds booking total';
    END IF;
    
    -- Create payment record
    INSERT INTO Payment (BookingID, Amount, PaymentDate, MethodID, StatusID, TransactionID)
    VALUES (p_booking_id, p_amount, NOW(), p_method_id, 
           (SELECT PaymentStatusID FROM PaymentStatus WHERE StatusName = 'Completed'), p_transaction_id);
    
    -- Update booking status to confirmed if full payment
    IF p_amount = v_booking_total THEN
        UPDATE Booking 
        SET StatusID = (SELECT StatusID FROM BookingStatus WHERE StatusName = 'Confirmed')
        WHERE BookingID = p_booking_id;
    END IF;
    
    -- Log the action
    INSERT INTO AuditLog (UserID, Action, EntityType, EntityID, Details)
    VALUES (v_guest_id, 'PAYMENT_PROCESSED', 'Payment', LAST_INSERT_ID(), 
            JSON_OBJECT('booking_id', p_booking_id, 'amount', p_amount, 'method', p_method_id));
    
    SELECT 'Payment processed successfully' AS Message;
END$$
DELIMITER ;

-- 3. TRIGGERS

-- Trigger to update booking updated_at timestamp
DELIMITER $$
CREATE TRIGGER trg_booking_updated
BEFORE UPDATE ON Booking
FOR EACH ROW
BEGIN
    SET NEW.UpdatedAt = CURRENT_TIMESTAMP;
END$$
DELIMITER ;

-- Trigger to prevent double booking
DELIMITER $$
CREATE TRIGGER trg_prevent_double_booking
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE v_conflict_count INT;
    
    SELECT COUNT(*) INTO v_conflict_count
    FROM Booking b
    WHERE b.PropertyID = NEW.PropertyID
      AND b.StatusID IN (SELECT StatusID FROM BookingStatus WHERE StatusName IN ('Pending', 'Confirmed'))
      AND (
          (NEW.CheckInDate BETWEEN b.CheckInDate AND DATE_SUB(b.CheckOutDate, INTERVAL 1 DAY)) OR
          (NEW.CheckOutDate BETWEEN DATE_ADD(b.CheckInDate, INTERVAL 1 DAY) AND b.CheckOutDate) OR
          (b.CheckInDate BETWEEN NEW.CheckInDate AND DATE_SUB(NEW.CheckOutDate, INTERVAL 1 DAY))
      );
    
    IF v_conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking conflict: Property already booked for selected dates';
    END IF;
END$$
DELIMITER ;

-- Trigger to update host report after booking completion
DELIMITER $$
CREATE TRIGGER trg_update_host_report
AFTER UPDATE ON Booking
FOR EACH ROW
BEGIN
    DECLARE v_host_id INT;
    DECLARE v_month_start DATE;
    DECLARE v_month_end DATE;
    
    IF NEW.StatusID = (SELECT StatusID FROM BookingStatus WHERE StatusName = 'Completed') AND OLD.StatusID != NEW.StatusID THEN
        -- Get host ID
        SELECT HostID INTO v_host_id FROM Property WHERE PropertyID = NEW.PropertyID;
        
        -- Calculate month start and end
        SET v_month_start = DATE_FORMAT(NEW.CheckInDate, '%Y-%m-01');
        SET v_month_end = LAST_DAY(NEW.CheckInDate);
        
        -- Update or insert host report
        INSERT INTO HostReport (HostID, PeriodStart, PeriodEnd, TotalBookings, TotalNights, TotalRevenue, AvgRating)
        VALUES (
            v_host_id,
            v_month_start,
            v_month_end,
            1,
            NEW.Nights,
            NEW.TotalPrice,
            NULL
        )
        ON DUPLICATE KEY UPDATE
            TotalBookings = TotalBookings + 1,
            TotalNights = TotalNights + NEW.Nights,
            TotalRevenue = TotalRevenue + NEW.TotalPrice;
    END IF;
END$$
DELIMITER ;

-- 4. FUNCTIONS

-- Function to calculate property rating
DELIMITER $$
CREATE FUNCTION fn_calculate_property_rating(p_property_id INT)
RETURNS DECIMAL(3,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_avg_rating DECIMAL(3,2);
    
    SELECT ROUND(AVG(r.Rating), 2) INTO v_avg_rating
    FROM Review r
    JOIN Booking b ON r.BookingID = b.BookingID
    WHERE b.PropertyID = p_property_id
      AND r.RevieweeID = (SELECT HostID FROM Property WHERE PropertyID = p_property_id);
    
    RETURN IFNULL(v_avg_rating, 0);
END$$
DELIMITER ;

-- Function to check property availability
DELIMITER $$
CREATE FUNCTION fn_check_availability(p_property_id INT, p_checkin DATE, p_checkout DATE)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_is_available BOOLEAN;
    
    SELECT NOT EXISTS (
        SELECT 1 FROM AvailabilityCalendar 
        WHERE PropertyID = p_property_id 
        AND CalendarDate BETWEEN p_checkin AND DATE_SUB(p_checkout, INTERVAL 1 DAY)
        AND IsAvailable = FALSE
    ) INTO v_is_available;
    
    RETURN v_is_available;
END$$
DELIMITER ;

-- 5. INDEXES FOR PERFORMANCE
CREATE INDEX idx_booking_dates ON Booking(CheckInDate, CheckOutDate);
CREATE INDEX idx_property_location ON Property(LocationID);
CREATE INDEX idx_payment_booking ON Payment(BookingID);
CREATE INDEX idx_review_booking ON Review(BookingID);
CREATE INDEX idx_message_users ON Message(SenderID, ReceiverID);
CREATE INDEX idx_calendar_property_date ON AvailabilityCalendar(PropertyID, CalendarDate);

-- Show all created objects
SELECT 'Database operations completed successfully!' AS Status;
SELECT 'Views:' AS ObjectType, COUNT(*) AS Count FROM information_schema.views WHERE table_schema = 'airbnb_db'
UNION ALL
SELECT 'Procedures', COUNT(*) FROM information_schema.routines WHERE routine_schema = 'airbnb_db' AND routine_type = 'PROCEDURE'
UNION ALL
SELECT 'Functions', COUNT(*) FROM information_schema.routines WHERE routine_schema = 'airbnb_db' AND routine_type = 'FUNCTION'
UNION ALL
SELECT 'Triggers', COUNT(*) FROM information_schema.triggers WHERE trigger_schema = 'airbnb_db';