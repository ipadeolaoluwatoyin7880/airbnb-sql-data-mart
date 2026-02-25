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

## 📁 File Structure
airbnb-sql-data-mart/
├── 01_create_database.sql          # Database creation
├── 02_create_tables.sql             # 22 tables with constraints
├── 03_insert_sample_data.sql        # Sample data (20+ rows per table)
├── 04_test_queries.sql              # Relationship validation queries
├── 05_database_operations.sql       # Views, procedures, triggers, functions
├── ER_Diagram.png                    # Entity Relationship Diagram
└── README.md                         # This documentation

## 👤 Author

Name: IPADEOLA OLUWATOYIN ENIOLA
Matriculation: 92130758
Course: DLBDSPBDM01 – Build a Data Mart in SQL
Institution: IU International University of Applied Sciences
GitHub: ipadeolaoluwatoyin7880/airbnb-sql-data-mart

## 📜 License

This project is submitted as part of academic requirements for IU International University. All rights reserved.
