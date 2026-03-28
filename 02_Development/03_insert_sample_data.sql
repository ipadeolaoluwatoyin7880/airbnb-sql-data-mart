-- ============================================
-- INSERT SAMPLE DATA (20+ rows per main table)
-- CORRECTED VERSION WITH PROPER INSERT ORDER
-- ============================================

-- 1. FIRST: Insert Roles (no dependencies)
INSERT INTO Role (RoleName, Permissions) VALUES
('Guest', '{"book": true, "review": true, "message": true}'),
('Host', '{"list_property": true, "manage_bookings": true, "receive_payments": true}'),
('Admin', '{"manage_users": true, "view_reports": true, "resolve_disputes": true}'),
('Support', '{"view_tickets": true, "assist_users": true}');

SELECT '4 roles inserted' AS Status;

-- 2. Insert Users (depends on Role table)
INSERT INTO User (RoleID, FirstName, LastName, Email, Phone, PasswordHash, VerifiedStatus) VALUES
(1, 'John', 'Smith', 'john.smith@email.com', '+1-555-0101', 'hashed_password_1', TRUE),
(1, 'Emma', 'Johnson', 'emma.j@email.com', '+1-555-0102', 'hashed_password_2', TRUE),
(1, 'Michael', 'Brown', 'michael.b@email.com', '+1-555-0103', 'hashed_password_3', FALSE),
(1, 'Sarah', 'Davis', 'sarah.d@email.com', '+1-555-0104', 'hashed_password_4', TRUE),
(1, 'David', 'Wilson', 'david.w@email.com', '+1-555-0105', 'hashed_password_5', TRUE),
(2, 'Robert', 'Miller', 'robert.m@email.com', '+1-555-0106', 'hashed_password_6', TRUE),
(2, 'Jennifer', 'Taylor', 'jennifer.t@email.com', '+1-555-0107', 'hashed_password_7', TRUE),
(2, 'William', 'Anderson', 'william.a@email.com', '+1-555-0108', 'hashed_password_8', TRUE),
(2, 'Linda', 'Thomas', 'linda.t@email.com', '+1-555-0109', 'hashed_password_9', TRUE),
(2, 'James', 'Jackson', 'james.j@email.com', '+1-555-0110', 'hashed_password_10', TRUE),
(2, 'Patricia', 'White', 'patricia.w@email.com', '+1-555-0111', 'hashed_password_11', FALSE),
(2, 'Christopher', 'Harris', 'chris.h@email.com', '+1-555-0112', 'hashed_password_12', TRUE),
(3, 'Admin', 'User', 'admin@airbnb.com', '+1-555-0000', 'hashed_admin', TRUE),
(1, 'Lisa', 'Martin', 'lisa.m@email.com', '+1-555-0113', 'hashed_password_13', TRUE),
(1, 'Daniel', 'Thompson', 'daniel.t@email.com', '+1-555-0114', 'hashed_password_14', FALSE),
(1, 'Nancy', 'Garcia', 'nancy.g@email.com', '+1-555-0115', 'hashed_password_15', TRUE),
(1, 'Mark', 'Martinez', 'mark.m@email.com', '+1-555-0116', 'hashed_password_16', TRUE),
(2, 'Elizabeth', 'Robinson', 'elizabeth.r@email.com', '+1-555-0117', 'hashed_password_17', TRUE),
(2, 'Richard', 'Clark', 'richard.c@email.com', '+1-555-0118', 'hashed_password_18', TRUE),
(2, 'Susan', 'Rodriguez', 'susan.r@email.com', '+1-555-0119', 'hashed_password_19', TRUE),
(1, 'Joseph', 'Lewis', 'joseph.l@email.com', '+1-555-0120', 'hashed_password_20', TRUE),
(1, 'Jessica', 'Lee', 'jessica.l@email.com', '+1-555-0121', 'hashed_password_21', TRUE),
(1, 'Thomas', 'Walker', 'thomas.w@email.com', '+1-555-0122', 'hashed_password_22', TRUE),
(1, 'Karen', 'Hall', 'karen.h@email.com', '+1-555-0123', 'hashed_password_23', TRUE);

SELECT CONCAT(COUNT(*), ' users inserted') AS Status FROM User;

-- 3. Insert Locations (no dependencies)
INSERT INTO Location (Address, City, State, Country, PostalCode, Latitude, Longitude) VALUES
('123 Main St', 'New York', 'NY', 'USA', '10001', 40.712776, -74.005974),
('456 Park Ave', 'Los Angeles', 'CA', 'USA', '90001', 34.052235, -118.243683),
('789 Ocean Dr', 'Miami', 'FL', 'USA', '33139', 25.761681, -80.191788),
('101 Mountain Rd', 'Denver', 'CO', 'USA', '80202', 39.739235, -104.990250),
('202 River View', 'Chicago', 'IL', 'USA', '60601', 41.878113, -87.629799),
('303 Sunset Blvd', 'San Francisco', 'CA', 'USA', '94102', 37.774929, -122.419418),
('404 Lake St', 'Seattle', 'WA', 'USA', '98101', 47.606209, -122.332069),
('505 Forest Ave', 'Portland', 'OR', 'USA', '97201', 45.505106, -122.675026),
('606 Beach Rd', 'San Diego', 'CA', 'USA', '92101', 32.715736, -117.161087),
('707 Hill St', 'Austin', 'TX', 'USA', '73301', 30.267153, -97.743057),
('808 Valley Rd', 'Phoenix', 'AZ', 'USA', '85001', 33.448376, -112.074036),
('909 Plaza Sq', 'Las Vegas', 'NV', 'USA', '89101', 36.169941, -115.139832),
('1010 Garden Ln', 'Boston', 'MA', 'USA', '02101', 42.360081, -71.058884),
('1111 Market St', 'Philadelphia', 'PA', 'USA', '19107', 39.952583, -75.165222),
('1212 Bridge Rd', 'London', NULL, 'UK', 'SW1A 1AA', 51.507351, -0.127758),
('1313 Champs Elysees', 'Paris', NULL, 'France', '75008', 48.856613, 2.352222),
('1414 Ginza', 'Tokyo', NULL, 'Japan', '104-0061', 35.689487, 139.691711),
('1515 Opera', 'Sydney', 'NSW', 'Australia', '2000', -33.868820, 151.209290),
('1616 Harbour', 'Vancouver', 'BC', 'Canada', 'V6C 1A1', 49.282729, -123.120738),
('1717 Temple', 'Rome', NULL, 'Italy', '00186', 41.902782, 12.496366),
('1818 Gardens', 'Singapore', NULL, 'Singapore', '018953', 1.352083, 103.819836),
('1919 Central', 'Hong Kong', NULL, 'China', NULL, 22.319304, 114.169361),
('2020 Medina', 'Dubai', NULL, 'UAE', NULL, 25.204849, 55.270782);

SELECT CONCAT(COUNT(*), ' locations inserted') AS Status FROM Location;

-- 4. Insert Property Types (no dependencies)
INSERT INTO PropertyType (TypeName, Description) VALUES
('Apartment', 'Self-contained housing unit in a building'),
('House', 'Detached residential building'),
('Villa', 'Luxury vacation home'),
('Condo', 'Individually owned unit in a complex'),
('Studio', 'Single room combining living, sleeping, and kitchen areas'),
('Loft', 'Open-plan living space, often converted from industrial use'),
('Cabin', 'Wooden house in a natural setting'),
('Castle', 'Historical fortified building'),
('Bungalow', 'Single-story house'),
('Treehouse', 'Structure built among trees'),
('Boat', 'Floating accommodation'),
('Camper/RV', 'Mobile home on wheels'),
('Farm', 'Agricultural property with accommodation');

SELECT CONCAT(COUNT(*), ' property types inserted') AS Status FROM PropertyType;

-- 5. Insert Properties (depends on User, PropertyType, Location)
-- NOTE: HostID must be users with RoleID = 2 (Hosts)
-- In our data: UserID 6, 7, 8, 9, 10, 11, 12, 18, 19, 20, 21 are hosts
INSERT INTO Property (HostID, TypeID, Title, Description, LocationID, BasePrice, MaxGuests, Bedrooms, Bathrooms, SquareMeters) VALUES
(6, 1, 'Cozy Downtown Apartment', 'Modern apartment in heart of NYC', 1, 120.00, 4, 2, 1, 75),
(7, 2, 'Beachfront Villa', 'Luxury villa with private beach access', 3, 450.00, 8, 4, 3, 200),
(8, 3, 'Mountain Retreat Cabin', 'Peaceful cabin with mountain views', 4, 180.00, 6, 3, 2, 120),
(9, 1, 'City Center Loft', 'Industrial-style loft with high ceilings', 2, 200.00, 4, 1, 1, 90),
(10, 4, 'Lakeside Condo', 'Beautiful condo overlooking the lake', 7, 150.00, 4, 2, 2, 85),
(11, 5, 'Artistic Studio', 'Creative space for artists', 5, 90.00, 2, 1, 1, 50),
(12, 6, 'Urban Loft', 'Modern loft in trendy neighborhood', 6, 220.00, 3, 1, 1, 70),
(18, 7, 'Forest Cabin', 'Secluded cabin in the woods', 8, 130.00, 5, 2, 1, 80),
(19, 8, 'Historic Castle', '15th century castle with modern amenities', 16, 800.00, 12, 6, 5, 500),
(20, 9, 'Beach Bungalow', 'Traditional bungalow steps from the beach', 3, 160.00, 4, 2, 1, 70),
(21, 10, 'Treehouse Escape', 'Unique treehouse experience', 8, 190.00, 3, 1, 1, 40),
(6, 11, 'Luxury Yacht', 'Private yacht for overnight stays', 3, 650.00, 6, 3, 2, NULL),
(7, 12, 'Vintage Airstream', 'Retro camper with modern comforts', 4, 110.00, 3, 1, 1, 25),
(8, 13, 'Farm Stay', 'Working farm with guest cottage', 4, 140.00, 5, 2, 1, 90),
(9, 1, 'Penthouse with View', 'Top-floor apartment with panoramic views', 1, 350.00, 6, 3, 2, 120),
(10, 2, 'Family Home', 'Spacious house perfect for families', 2, 280.00, 8, 4, 3, 180),
(11, 3, 'Luxury Villa', 'Private villa with pool and garden', 3, 520.00, 10, 5, 4, 250),
(12, 4, 'Waterfront Condo', 'Condo with direct water access', 7, 210.00, 4, 2, 2, 95),
(18, 5, 'Designer Studio', 'Minimalist studio by famous designer', 6, 180.00, 2, 1, 1, 55),
(19, 6, 'Warehouse Loft', 'Converted warehouse with original features', 5, 240.00, 4, 2, 2, 110),
(20, 7, 'Mountain Cabin', 'Rustic cabin with fireplace', 4, 170.00, 6, 3, 2, 100),
(21, 8, 'Chateau', 'French countryside chateau', 16, 750.00, 15, 7, 6, 600);

SELECT CONCAT(COUNT(*), ' properties inserted') AS Status FROM Property;

-- 6. Insert Amenities (no dependencies)
INSERT INTO Amenity (AmenityName, Category) VALUES
('WiFi', 'Essentials'),
('Kitchen', 'Essentials'),
('Washer', 'Essentials'),
('Dryer', 'Essentials'),
('Air Conditioning', 'Essentials'),
('Heating', 'Essentials'),
('TV', 'Entertainment'),
('Cable TV', 'Entertainment'),
('Netflix', 'Entertainment'),
('Pool', 'Outdoor'),
('Hot Tub', 'Outdoor'),
('Patio', 'Outdoor'),
('BBQ Grill', 'Outdoor'),
('Garden', 'Outdoor'),
('Parking', 'Logistics'),
('Elevator', 'Logistics'),
('Gym', 'Facilities'),
('Sauna', 'Facilities'),
('Fireplace', 'Comfort'),
('Balcony', 'Views'),
('Ocean View', 'Views'),
('Mountain View', 'Views'),
('City View', 'Views'),
('Pet Friendly', 'Special'),
('Smoking Allowed', 'Special'),
('Wheelchair Accessible', 'Accessibility'),
('Breakfast Included', 'Food'),
('Minibar', 'Food');

SELECT CONCAT(COUNT(*), ' amenities inserted') AS Status FROM Amenity;

-- 7. Insert PropertyAmenity (depends on Property and Amenity)
INSERT INTO PropertyAmenity (PropertyID, AmenityID) VALUES
(1, 1), (1, 2), (1, 5), (1, 7), (1, 15),
(2, 1), (2, 2), (2, 5), (2, 10), (2, 11), (2, 13), (2, 21),
(3, 1), (3, 2), (3, 6), (3, 19), (3, 22),
(4, 1), (4, 2), (4, 5), (4, 7), (4, 9), (4, 20),
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 10), (5, 12),
(6, 1), (6, 2), (6, 5), (6, 7),
(7, 1), (7, 2), (7, 5), (7, 7), (7, 9), (7, 17),
(8, 1), (8, 2), (8, 6), (8, 19), (8, 22),
(9, 1), (9, 2), (9, 5), (9, 6), (9, 10), (9, 13), (9, 17), (9, 18),
(10, 1), (10, 2), (10, 5), (10, 12), (10, 13), (10, 21);

SELECT CONCAT(COUNT(*), ' property-amenity links inserted') AS Status FROM PropertyAmenity;

-- 8. Insert Booking Statuses (no dependencies)
INSERT INTO BookingStatus (StatusName, Description) VALUES
('Pending', 'Booking request sent, awaiting host confirmation'),
('Confirmed', 'Booking confirmed by host'),
('Cancelled', 'Booking cancelled by guest or host'),
('Completed', 'Stay has been completed'),
('No-show', 'Guest did not arrive'),
('Refunded', 'Booking cancelled and refund processed');

SELECT CONCAT(COUNT(*), ' booking statuses inserted') AS Status FROM BookingStatus;

-- 9. Insert Bookings (depends on User, Property, BookingStatus)
-- GuestID must be users with RoleID = 1 (Guests)
-- PropertyID must exist (1-22)
-- StatusID = 2 (Confirmed) must exist
INSERT INTO Booking (GuestID, PropertyID, CheckInDate, CheckOutDate, GuestsCount, BasePrice, TotalPrice, StatusID) VALUES
(1, 1, '2024-03-15', '2024-03-20', 2, 120.00, 600.00, 2),
(2, 2, '2024-04-10', '2024-04-17', 4, 450.00, 3150.00, 2),
(3, 3, '2024-05-01', '2024-05-07', 3, 180.00, 1080.00, 2),
(4, 4, '2024-06-15', '2024-06-20', 2, 200.00, 1000.00, 2),
(5, 5, '2024-07-01', '2024-07-10', 3, 150.00, 1350.00, 2),
(14, 6, '2024-03-25', '2024-03-30', 2, 90.00, 450.00, 2),
(15, 7, '2024-04-05', '2024-04-12', 2, 220.00, 1540.00, 2),
(16, 8, '2024-05-20', '2024-05-25', 4, 130.00, 650.00, 2),
(17, 9, '2024-06-01', '2024-06-08', 6, 800.00, 5600.00, 2),
(22, 10, '2024-07-15', '2024-07-22', 3, 160.00, 1120.00, 2),
(23, 11, '2024-08-01', '2024-08-07', 2, 190.00, 1140.00, 2),
(24, 12, '2024-09-10', '2024-09-15', 4, 650.00, 3250.00, 2),
(1, 13, '2024-10-05', '2024-10-10', 2, 110.00, 550.00, 2),
(2, 14, '2024-11-15', '2024-11-20', 3, 140.00, 700.00, 2),
(3, 15, '2024-12-01', '2024-12-08', 4, 350.00, 2450.00, 2),
(4, 16, '2024-03-10', '2024-03-15', 5, 280.00, 1400.00, 2),
(5, 17, '2024-04-20', '2024-04-27', 6, 520.00, 3640.00, 2),
(14, 18, '2024-05-15', '2024-05-20', 3, 210.00, 1050.00, 2),
(15, 19, '2024-06-10', '2024-06-15', 2, 180.00, 900.00, 2),
(16, 20, '2024-07-25', '2024-08-01', 3, 240.00, 1680.00, 2),
(17, 21, '2024-08-15', '2024-08-22', 4, 170.00, 1190.00, 2),
(22, 22, '2024-09-05', '2024-09-12', 8, 750.00, 5250.00, 2);

SELECT CONCAT(COUNT(*), ' bookings inserted') AS Status FROM Booking;

-- 10. Insert Payment Methods (no dependencies)
INSERT INTO PaymentMethod (MethodName, Processor) VALUES
('Credit Card', 'Stripe'),
('PayPal', 'PayPal'),
('Apple Pay', 'Apple'),
('Google Pay', 'Google'),
('Bank Transfer', 'Direct'),
('Cash', 'Manual');

SELECT CONCAT(COUNT(*), ' payment methods inserted') AS Status FROM PaymentMethod;

-- 11. Insert Payment Statuses (no dependencies)
INSERT INTO PaymentStatus (StatusName) VALUES
('Pending'),
('Completed'),
('Failed'),
('Refunded'),
('Partially Refunded');

SELECT CONCAT(COUNT(*), ' payment statuses inserted') AS Status FROM PaymentStatus;

-- 12. Insert Payments (depends on Booking, PaymentMethod, PaymentStatus)
INSERT INTO Payment (BookingID, Amount, PaymentDate, MethodID, StatusID, TransactionID) VALUES
(1, 600.00, '2024-03-01 10:30:00', 1, 2, 'TXN001'),
(2, 3150.00, '2024-03-25 14:45:00', 2, 2, 'TXN002'),
(3, 1080.00, '2024-04-15 09:15:00', 1, 2, 'TXN003'),
(4, 1000.00, '2024-05-20 16:30:00', 3, 2, 'TXN004'),
(5, 1350.00, '2024-06-01 11:00:00', 1, 2, 'TXN005'),
(6, 450.00, '2024-03-10 13:20:00', 2, 2, 'TXN006'),
(7, 1540.00, '2024-03-28 15:45:00', 1, 2, 'TXN007'),
(8, 650.00, '2024-05-05 10:10:00', 1, 2, 'TXN008'),
(9, 5600.00, '2024-05-20 14:30:00', 2, 2, 'TXN009'),
(10, 1120.00, '2024-06-25 12:15:00', 1, 2, 'TXN010'),
(11, 1140.00, '2024-07-15 09:45:00', 3, 2, 'TXN011'),
(12, 3250.00, '2024-08-20 16:00:00', 1, 2, 'TXN012'),
(13, 550.00, '2024-09-10 11:30:00', 2, 2, 'TXN013'),
(14, 700.00, '2024-10-05 14:20:00', 1, 2, 'TXN014'),
(15, 2450.00, '2024-11-01 10:00:00', 1, 2, 'TXN015'),
(16, 1400.00, '2024-02-25 15:30:00', 2, 2, 'TXN016'),
(17, 3640.00, '2024-03-30 13:45:00', 1, 2, 'TXN017'),
(18, 1050.00, '2024-04-28 12:10:00', 3, 2, 'TXN018'),
(19, 900.00, '2024-05-25 09:30:00', 1, 2, 'TXN019'),
(20, 1680.00, '2024-07-10 16:45:00', 1, 2, 'TXN020'),
(21, 1190.00, '2024-07-30 14:00:00', 2, 2, 'TXN021'),
(22, 5250.00, '2024-08-20 11:15:00', 1, 2, 'TXN022');

SELECT CONCAT(COUNT(*), ' payments inserted') AS Status FROM Payment;

-- 13. Insert Payouts (depends on User, Booking)
INSERT INTO Payout (HostID, BookingID, Amount, PayoutDate, Status) VALUES
(6, 1, 540.00, '2024-03-25', 'Completed'),
(7, 2, 2835.00, '2024-04-20', 'Completed'),
(8, 3, 972.00, '2024-05-10', 'Completed'),
(9, 4, 900.00, '2024-06-25', 'Completed'),
(10, 5, 1215.00, '2024-07-15', 'Completed'),
(11, 6, 405.00, '2024-04-05', 'Completed'),
(12, 7, 1386.00, '2024-04-15', 'Completed'),
(18, 8, 585.00, '2024-05-30', 'Completed'),
(19, 9, 5040.00, '2024-06-12', 'Completed'),
(20, 10, 1008.00, '2024-07-30', 'Completed'),
(21, 11, 1026.00, '2024-08-10', 'Completed'),
(6, 12, 2925.00, '2024-09-20', 'Pending'),
(7, 13, 495.00, '2024-10-15', 'Pending'),
(8, 14, 630.00, '2024-11-25', 'Pending'),
(9, 15, 2205.00, '2024-12-12', 'Pending'),
(10, 16, 1260.00, '2024-03-20', 'Completed'),
(11, 17, 3276.00, '2024-04-05', 'Completed'),
(12, 18, 945.00, '2024-05-25', 'Completed'),
(18, 19, 810.00, '2024-06-20', 'Completed'),
(19, 20, 1512.00, '2024-07-15', 'Completed'),
(20, 21, 1071.00, '2024-08-05', 'Pending'),
(21, 22, 4725.00, '2024-09-17', 'Pending');

SELECT CONCAT(COUNT(*), ' payouts inserted') AS Status FROM Payout;

-- 14. Insert Reviews (depends on Booking, User)
-- First disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO Review (BookingID, ReviewerID, RevieweeID, Rating, Comment, Response) VALUES
(1, 1, 6, 5, 'Great apartment, very clean and well located!', 'Thank you, John! You were a perfect guest.'),
(2, 2, 7, 4, 'Beautiful villa, but WiFi was slow.', 'Thanks Emma! We will upgrade the WiFi.'),
(3, 3, 8, 5, 'Perfect mountain getaway!', 'So glad you enjoyed it, Michael!'),
(4, 4, 9, 4, 'Cool loft, amazing design.', 'Thank you Sarah!'),
(5, 5, 10, 5, 'Best lake view ever!', 'Come back anytime, David!'),
(6, 14, 11, 3, 'Studio was smaller than expected.', 'Thanks for your feedback, Lisa.'),
(7, 15, 12, 5, 'Amazing urban experience!', 'Welcome back anytime, Daniel!'),
(8, 16, 18, 4, 'Peaceful forest retreat.', 'Thank you Nancy!'),
(9, 17, 19, 5, 'Once in a lifetime experience!', 'We are happy you enjoyed the castle!'),
(10, 22, 20, 5, 'Perfect beach bungalow!', 'Thanks Mark!'),
(11, 23, 21, 4, 'Fun treehouse, kids loved it!', 'Glad your family enjoyed it!'),
(12, 6, 1, 5, 'Excellent guest, very respectful.', 'Thank you Robert!'),
(13, 7, 2, 5, 'Lovely guests, left the villa clean.', 'Thank you Jennifer!'),
(14, 8, 3, 4, 'Good communication, minor cleanup needed.', 'Thanks for hosting us!');

SET FOREIGN_KEY_CHECKS = 1;

SELECT CONCAT(COUNT(*), ' reviews inserted') AS Status FROM Review;

-- 15. Insert AvailabilityCalendar (depends on Property)
INSERT INTO AvailabilityCalendar (PropertyID, CalendarDate, IsAvailable, CustomPrice) VALUES
(1, '2024-03-15', FALSE, NULL),
(1, '2024-03-16', FALSE, NULL),
(1, '2024-03-17', FALSE, NULL),
(1, '2024-03-18', FALSE, NULL),
(1, '2024-03-19', FALSE, NULL),
(1, '2024-03-20', FALSE, NULL),
(1, '2024-03-21', TRUE, NULL),
(1, '2024-03-22', TRUE, NULL),
(2, '2024-04-10', FALSE, NULL),
(2, '2024-04-11', FALSE, NULL),
(2, '2024-04-12', FALSE, NULL),
(2, '2024-04-13', FALSE, NULL),
(2, '2024-04-14', FALSE, NULL),
(2, '2024-04-15', FALSE, NULL),
(2, '2024-04-16', FALSE, NULL),
(2, '2024-04-17', FALSE, NULL),
(2, '2024-04-18', TRUE, NULL),
(3, '2024-05-01', FALSE, NULL),
(3, '2024-05-02', FALSE, NULL),
(3, '2024-05-03', FALSE, NULL),
(3, '2024-05-04', FALSE, NULL),
(3, '2024-05-05', FALSE, NULL),
(3, '2024-05-06', FALSE, NULL),
(3, '2024-05-07', FALSE, NULL);

SELECT CONCAT(COUNT(*), ' calendar entries inserted') AS Status FROM AvailabilityCalendar;

-- 16. Insert Messages (depends on User, Booking)
INSERT INTO Message (SenderID, ReceiverID, BookingID, MessageText) VALUES
(1, 6, 1, 'Hi, is early check-in possible?'),
(6, 1, 1, 'Yes, 1 PM check-in is fine.'),
(2, 7, 2, 'Do you provide beach towels?'),
(7, 2, 2, 'Yes, beach towels are provided.'),
(3, 8, 3, 'Is the road to the cabin accessible in winter?'),
(8, 3, 3, 'Yes, the road is plowed regularly.'),
(4, 9, 4, 'What is the parking situation?'),
(9, 4, 4, 'Street parking available with permit.'),
(5, 10, 5, 'Is fishing allowed from the dock?'),
(10, 5, 5, 'Yes, fishing is allowed.'),
(1, 6, NULL, 'Thinking of booking again next month!'),
(6, 1, NULL, 'Great! Let me know dates.');

SELECT CONCAT(COUNT(*), ' messages inserted') AS Status FROM Message;

-- 17. Insert Disputes (depends on Booking, User)
INSERT INTO Dispute (BookingID, RaisedByID, Title, Description, Status) VALUES
(6, 14, 'Cleanliness Issue', 'The studio was not properly cleaned before arrival.', 'Resolved'),
(7, 15, 'Noise Complaint', 'Construction noise during stay not mentioned.', 'Open'),
(11, 23, 'Safety Concern', 'Treehouse ladder needs repair.', 'In Progress');

SELECT CONCAT(COUNT(*), ' disputes inserted') AS Status FROM Dispute;

-- 18. Insert Audit Log (depends on User)
INSERT INTO AuditLog (UserID, Action, EntityType, EntityID, Details) VALUES
(1, 'BOOKING_CREATED', 'Booking', 1, '{"amount": 600, "property": "Cozy Downtown Apartment"}'),
(2, 'BOOKING_CREATED', 'Booking', 2, '{"amount": 3150, "property": "Beachfront Villa"}'),
(6, 'PROPERTY_UPDATED', 'Property', 1, '{"field": "price", "old": 110, "new": 120}'),
(13, 'USER_VERIFIED', 'User', 3, '{"verified": true}'),
(13, 'DISPUTE_REVIEWED', 'Dispute', 1, '{"resolution": "refund_issued", "amount": 50}');

SELECT CONCAT(COUNT(*), ' audit log entries inserted') AS Status FROM AuditLog;

-- 19. Insert Social Links (depends on User)
INSERT INTO SocialLink (UserID, Platform, ProfileURL, IsVerified) VALUES
(1, 'Facebook', 'https://facebook.com/johnsmith', TRUE),
(2, 'LinkedIn', 'https://linkedin.com/in/emmajohnson', TRUE),
(6, 'Facebook', 'https://facebook.com/robertmiller', TRUE),
(7, 'Instagram', 'https://instagram.com/jennifert', TRUE),
(13, 'Twitter', 'https://twitter.com/airbnbadmin', TRUE);

SELECT CONCAT(COUNT(*), ' social links inserted') AS Status FROM SocialLink;

-- 20. Insert Host Reports (depends on User)
INSERT INTO HostReport (HostID, PeriodStart, PeriodEnd, TotalBookings, TotalNights, TotalRevenue, AvgRating) VALUES
(6, '2024-01-01', '2024-03-31', 3, 21, 4500.00, 4.8),
(7, '2024-01-01', '2024-03-31', 2, 14, 3700.00, 4.5),
(8, '2024-01-01', '2024-03-31', 2, 13, 2050.00, 4.7),
(9, '2024-01-01', '2024-03-31', 2, 10, 1900.00, 4.4),
(10, '2024-01-01', '2024-03-31', 2, 15, 2565.00, 5.0);

SELECT CONCAT(COUNT(*), ' host reports inserted') AS Status FROM HostReport;

-- 21. Insert Cancellation Policies (depends on Property)
INSERT INTO CancellationPolicy (PropertyID, PolicyType, RefundPercentage, DaysBeforeCheckin, Description) VALUES
(1, 'Flexible', 100, 2, 'Full refund if cancelled 2 days before check-in'),
(2, 'Moderate', 50, 7, '50% refund if cancelled 7 days before check-in'),
(3, 'Strict', 0, 14, 'No refund if cancelled within 14 days'),
(4, 'Flexible', 100, 1, 'Full refund 1 day before'),
(5, 'Moderate', 50, 5, '50% refund 5 days before');

SELECT CONCAT(COUNT(*), ' cancellation policies inserted') AS Status FROM CancellationPolicy;

-- 22. Insert Verifications (depends on User)
INSERT INTO Verification (UserID, DocumentType, DocumentURL, Status, VerifiedDate) VALUES
(1, 'Passport', 'https://storage.example.com/passport1.jpg', 'Verified', '2024-01-15'),
(2, 'Drivers License', 'https://storage.example.com/dl2.jpg', 'Verified', '2024-01-20'),
(6, 'Passport', 'https://storage.example.com/passport6.jpg', 'Verified', '2024-02-01'),
(7, 'ID Card', 'https://storage.example.com/id7.jpg', 'Verified', '2024-02-05'),
(13, 'Business License', 'https://storage.example.com/biz13.jpg', 'Verified', '2024-01-10');

SELECT CONCAT(COUNT(*), ' verifications inserted') AS Status FROM Verification;

-- Final Summary
SELECT 'Sample data insertion completed successfully!' AS Status;
SELECT 
    (SELECT COUNT(*) FROM User) AS Users,
    (SELECT COUNT(*) FROM Property) AS Properties,
    (SELECT COUNT(*) FROM Booking) AS Bookings,
    (SELECT COUNT(*) FROM Payment) AS Payments,
    (SELECT COUNT(*) FROM Review) AS Reviews,
    (SELECT COUNT(*) FROM Message) AS Messages;