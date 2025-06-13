# Rental Management System

A full-stack rental management application with Node.js/Express backend and Flutter frontend.

## Features

### Authentication

- ✅ User registration with password hashing (bcrypt)
- ✅ Secure login with email/password
- ✅ Role-based access (Admin/User)
- ✅ Password change functionality
- ✅ Persistent authentication

### User Features

- ✅ Browse available properties
- ✅ Advanced property search with filters
- ✅ Property booking with date selection
- ✅ View booking history
- ✅ Profile management

### Admin Features

- ✅ Property management (CRUD operations)
- ✅ User management (role changes, deletion)
- ✅ View all bookings
- ✅ Dashboard with statistics

## Technology Stack

### Backend

- **Runtime**: Node.js
- **Framework**: Express.js v5.1.0
- **Database**: MySQL with mysql2 driver
- **Authentication**: bcrypt for password hashing
- **Environment**: dotenv for configuration

### Frontend

- **Framework**: Flutter (Dart SDK ^3.8.1)
- **UI**: Material Design 3
<!-- - **State Management**: setState -->
- **HTTP Client**: http package
- **Storage**: SharedPreferences for auth persistence

## Setup Instructions

### 1. Database Setup

1. Make sure MySQL is installed and running
2. Create the database and tables:
   ```bash
   mysql -u root -p < rental_backend/database_setup.sql
   ```

### 2. Backend Setup

1. Navigate to backend directory:

   ```bash
   cd rental_backend
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Create `.env` file in `rental_backend` directory:

   ```env
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_mysql_password
   DB_NAME=rental_db
   PORT=3000
   ```

4. Start the backend server:

   ```bash
   npm run dev
   ```

   The backend will run on `http://localhost:3000`

### 3. Frontend Setup

1. Navigate to frontend directory:

   ```bash
   cd rental_frontend
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the Flutter app:
   ```bash
   flutter run
   ```

## API Endpoints

### Authentication

- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `PUT /api/auth/change-password/:userId` - Change password

### Users

- `GET /api/users` - Get all users (Admin only)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user (Admin only)

### Properties

- `GET /api/properties` - Get all properties
- `GET /api/properties/:id` - Get property by ID
- `POST /api/properties` - Create property (Admin only)
- `PUT /api/properties/:id` - Update property (Admin only)
- `DELETE /api/properties/:id` - Delete property (Admin only)

### Bookings

- `GET /api/bookings` - Get all bookings (Admin only)
- `GET /api/bookings/user/:userId` - Get user bookings
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/:id` - Update booking
- `DELETE /api/bookings/:id` - Delete booking

## Test Credentials

After running the database setup script, you can use these test accounts:

### Admin Account

- **Email**: admin@rental.com
- **Password**: admin123

### User Account

- **Email**: user@rental.com
- **Password**: user123

## Project Structure

```
rental_project/
├── rental_backend/
│   ├── src/
│   │   ├── config/
│   │   │   └── db.js
│   │   ├── controllers/
│   │   │   ├── authController.js
│   │   │   ├── userController.js
│   │   │   ├── propertyController.js
│   │   │   └── bookingController.js
│   │   ├── models/
│   │   │   ├── User.js
│   │   │   ├── Property.js
│   │   │   └── Booking.js
│   │   ├── routes/
│   │   │   ├── authRoutes.js
│   │   │   ├── userRoutes.js
│   │   │   ├── propertyRoutes.js
│   │   │   └── bookingRoutes.js
│   │   └── server.js
│   ├── database_setup.sql
│   ├── generate_sample_users.js
│   └── package.json
└── rental_frontend/
    ├── lib/
    │   ├── models/
    │   ├── services/
    │   ├── screens/
    │   │   ├── auth/
    │   │   ├── home/
    │   │   ├── search/
    │   │   ├── bookings/
    │   │   ├── admin/
    │   │   ├── property/
    │   │   └── profile/
    │   └── main.dart
    └── pubspec.yaml
```

## Security Features

- ✅ Password hashing with bcrypt (salt rounds: 10)
- ✅ Input validation on both frontend and backend
- ✅ SQL injection prevention with parameterized queries
- ✅ Role-based access control
- ✅ Secure password change with current password verification

## Development Notes

- The backend uses connection pooling for efficient database management
- Frontend implements proper error handling and loading states
- Material Design 3 provides a modern, consistent UI
- The app supports both light theme and follows Material Design guidelines
- All forms include comprehensive validation
- The app handles network errors gracefully

## Future Enhancements

- JWT token-based authentication
- Image upload for properties
- Push notifications for bookings
- Payment integration
- Advanced booking calendar
- Property reviews and ratings
- Email notifications
- Multi-language support
