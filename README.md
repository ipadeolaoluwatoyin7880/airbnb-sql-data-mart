# 🏠 Airbnb Database System – Complete Data Mart Implementation

A fully normalized, production-ready relational database system for an Airbnb‑style property rental platform. This project demonstrates advanced SQL concepts including triple relationships, recursive relationships, stored procedures, triggers, and views.

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![GitHub](https://img.shields.io/badge/GitHub-Repository-green)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## 📊 Entity Relationship Diagram

![ER Diagram](ER_Diagram.png)

*Figure 1: Complete ER model with 22 entities, Chen notation, and cardinality specifications*

---

## 📋 Project Overview

This database system supports a fully functional property rental platform with:

| Feature | Description |
|---------|-------------|
| **User Roles** | Guests, Hosts, Admin, Support |
| **Property Management** | Listings, locations, amenities, availability calendars |
| **Booking Engine** | Reservations, status tracking, availability checks |
| **Payment Processing** | Multiple payment methods, transaction tracking, payouts |
| **Review System** | Guest-host ratings, comments, responses |
| **Communication** | Messaging between users |
| **Dispute Resolution** | Ticket system for issue management |
| **Audit Logging** | Complete action history |

---

## 🗄️ Database Schema – 22 Tables

### Core Entities
| Table | Description |
|-------|-------------|
| `User` | Platform users (guests, hosts, admin) |
| `Role` | User roles and permissions |
| `Location` | Property locations |
| `PropertyType` | Types of accommodations |

### Property Management
| Table | Description |
|-------|-------------|
| `Property` | Property listings |
| `Amenity` | Available amenities |
| `PropertyAmenity` | Bridge table (M:N relationship) |
| `AvailabilityCalendar` | Date-based availability |
| `CancellationPolicy` | Booking cancellation rules |

### Transactions
| Table | Description |
|-------|-------------|
| `Booking` | Reservation records |
| `BookingStatus` | Booking states |
| `Payment` | Payment transactions |
| `PaymentMethod` | Payment types |
| `PaymentStatus` | Payment states |
| `Payout` | Host earnings |

### User Interactions
| Table | Description |
|-------|-------------|
| `Review` | Guest/host feedback (recursive) |
| `Message` | User communications (recursive) |
| `Dispute` | Issue tracking |

### System Management
| Table | Description |
|-------|-------------|
| `AuditLog` | Action history |
| `SocialLink` | User social profiles |
| `HostReport` | Host performance metrics |
| `Verification` | Identity verification |

---

## 🔗 Key Relationships

### Triple Relationships
- **Booking** connects Guest, Property, and BookingStatus
- **Payment** connects Booking, PaymentMethod, and PaymentStatus
- **Review** connects Booking, Reviewer, and Reviewee

### Recursive Relationships
- **Message:** Users can message other users
- **Review:** Users can review other users

---

## 📊 Sample Data Statistics

| Table | Count | Table | Count |
|-------|-------|-------|-------|
| `User` | 24 | `Role` | 4 |
| `Property` | 22 | `Location` | 23 |
| `Booking` | 22 | `PropertyType` | 13 |
| `Payment` | 22 | `Amenity` | 28 |
| `Review` | 14 | `Message` | 12 |

---

## 🚀 Installation Guide

### Prerequisites
- MySQL 8.0 or higher
- MySQL Workbench (recommended) or command line client

```bash
# Clone the repository
git clone https://github.com/ipadeolaoluwatoyin7880/airbnb-sql-data-mart.git
cd airbnb-sql-data-mart

# Create database and tables
mysql -u root -p < 01_create_database.sql
mysql -u root -p airbnb_db < 02_create_tables.sql

# Insert sample data
mysql -u root -p airbnb_db < 03_insert_sample_data.sql

# Test the implementation
mysql -u root -p airbnb_db < 04_test_queries.sql

# Create views, procedures, triggers, functions
mysql -u root -p airbnb_db < 05_database_operations.sql

### Using MySQL Workbench
- Open MySQL Workbench and connect to your server
- File → Open SQL Script → Select each file in order from the sql/ folder
- Execute (lightning bolt) for each file

---

## ⚡ Advanced Features

### Stored Procedures
-- Make a booking with automatic availability check
CALL sp_make_booking(1, 1, '2024-12-01', '2024-12-05', 2, 'Early check-in');
-- Process payment and update booking status
CALL sp_process_payment(1, 600.00, 1, 'TXN001');

### Triggers
- trg_prevent_double_booking – Ensures no overlapping bookings
- trg_update_host_report – Automatically updates host earnings reports
- trg_booking_updated – Maintains audit timestamps

### Functions
-- Calculate average rating for a property
SELECT fn_calculate_property_rating(1);
-- Check property availability for dates
SELECT fn_check_availability(1, '2024-12-01', '2024-12-05');

### Views
-- Property listings with host details and ratings
SELECT * FROM vw_property_listings;
-- Complete booking history with payment status
SELECT * FROM vw_booking_details;
-- Host performance dashboard
SELECT * FROM vw_host_dashboard;

---

## 📁 File Structure

airbnb-sql-data-mart/
├── 📂 sql/                          # All SQL scripts
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_insert_sample_data.sql
│   ├── 04_test_queries.sql
│   └── 05_database_operations.sql
├── 📂 docs/                          # Documentation
│   ├── 📂 01-conception/             # Phase 1 documents
│   │   ├── 01_problem_summary.md
│   │   ├── 02_requirements_specification.md
│   │   ├── 03_er_diagram.png
│   │   ├── 04_data_dictionary.md
│   │   └── 05_conception_summary.md
│   └── 📂 03-finalisation/           # Phase 3 documents
│       └── abstract.md
├── 📂 presentation/                   # Phase 2 presentation
│   └── IPADEOLA_OLUWATOYIN_92130758_DLBDSPBDM01_P2_Presentation.pdf
├── 📂 summary/                        # Phase 2 summary
│   └── IPADEOLA_OLUWATOYIN_92130758_DLBDSPBDM01_P2_Summary.pdf
├── 📂 screenshots/                    # Execution screenshots
│   ├── 01_database_created.png
│   ├── 02_tables_list.png
│   └── ...
├── .gitignore
└── README.md

---

## 🎯 Key Achievements

✅ 22 normalized tables with proper constraints
✅ 3 triple relationships implemented
✅ 2 recursive relationships implemented
✅ 20+ sample rows per main table
✅ 3 views for simplified data access
✅ 2 stored procedures for business logic
✅ 3 triggers for automated processes
✅ 2 custom functions for calculations
✅ Chen notation in ER diagram
✅ Comprehensive documentation

---

## 👤 Author

Name: IPADEOLA OLUWATOYIN ENIOLA
Matriculation: 92130758
Course: DLBDSPBDM01 – Build a Data Mart in SQL
Institution: IU International University of Applied Sciences
GitHub: ipadeolaoluwatoyin7880/airbnb-sql-data-mart

---

## 📜 License

This project is submitted as part of academic requirements for IU International University. All rights reserved.
