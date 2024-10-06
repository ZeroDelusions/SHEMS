
# Smart Home Energy Management App
This project is a Smart Home Energy Management example application with a Spring Boot backend for CRUD REST API and a SwiftUI frontend. It includes Google Authentication for user identification and device management.

<p align="center">
  <img src="https://github.com/user-attachments/assets/192e98e3-49a5-4b8a-b608-16867d845bb0" width="200" />
  <img src="https://github.com/user-attachments/assets/1a463ebd-4a53-4441-a5b9-6938647ef9e8" width="200" />
  <img src="https://github.com/user-attachments/assets/97e583b2-3aca-401c-8083-f333bb110c27" width="200" />
</p>

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
- [API Endpoints](#api-endpoints)
- [Security](#security)


## Features
- User Authentication: Secure login and authentication through Google Sign-In.
- Device Management: Full CRUD operations for smart home devices.
- Energy Consumption Tracking: Real-time monitoring and management of energy consumption per device.
- JWT-based Security: All API requests are protected with JWTs.
- Ownership Verification: Device ownership is verified to ensure users can only access their devices.
- Aggregation of Energy Data: Energy consumption can be aggregated across different time intervals (e.g., hourly, daily).

## Technologies Used
### Backend
- Spring Boot
- Spring Security
- Google Auth API
- JWT for token-based authentication
- PostgresSQL

### Frontend
- SwiftUI
- Google Sign-In SDK for iOS

## Getting Started

### Backend Setup
1. Clone the repository
2. Navigate to the backend directory
3. Configure application.properties with your database and Google Auth credentials
4. Run the Spring Boot application


### Frontend Setup

1.  Navigate to the frontend directory
2.  Open the .xcodeproj file in Xcode
3.  Configure Google Sign-In in your Xcode project
4.  Build and run the application on a simulator or device


## API Endpoints

### User
| Method | Endpoint               | Description                     |
|--------|------------------------|---------------------------------|
| POST   | `/api/v1/auth`         | Authenticate user and return JWT|

### Devices
| Method | Endpoint                             | Description                     |
|--------|--------------------------------------|---------------------------------|
| GET    | `/api/v1/device`                    | Retrieve user's devices         |
| POST   | `/api/v1/device`                    | Add a new device                |
| PUT    | `/api/v1/device/{id}`               | Update device information       |
| DELETE | `/api/v1/device/{id}`               | Remove a device                 |

### Energy Consumption
| Method | Endpoint                                     | Description                      |
|--------|----------------------------------------------|----------------------------------|
| GET    | `/api/v1/energy-consumption/all-devices`    | Retrieve energy consumption of all devices |
| GET    | `/api/v1/energy-consumption/all-devices/aggregated` | Retrieve aggregated energy consumption of all devices |
| GET    | `/api/v1/energy-consumption/device/{deviceId}` | Retrieve device's energy consumption |
| GET    | `/api/v1/energy-consumption/device/{deviceId}/aggregated` | Retrieve aggregated energy consumption for the device |
| POST   | `/api/v1/energy-consumption/device/{deviceId}` | Add new energy consumption for the device |

#### Energy Consumption Aggregation
The energy consumption endpoints support aggregation based on time intervals. Use the following URL components to specify aggregation:

- Aggregation time type: `MONTHLY`, `WEEKLY`, `DAILY`, `HOURLY`, or `MINUTELY`
- Begin timestamp
- End timestamp

Example:
```url
/api/v1/energy-consumption/device/{deviceId}/aggregated?type=HOURLY&begin=2023-01-01T00:00:00Z&end=2023-01-02T00:00:00Z
```

Response
```json
[
    {
        "timestamp": "2023-01-01T00:00:00Z",
        "aggregatedPowerUsage": 250
    },
    {
        "timestamp": "2023-01-01T01:00:00Z",
        "aggregatedPowerUsage": 300
    }
]
```

This will return hourly aggregated energy consumption data for the specified device between the given timestamps. The aggregation combines energy consumptions within the same time interval (e.g., hour) into one entry, summing the values (in this case poerUsage each Minute in Hour) and using the timestamp of the beginning of the interval.


## Security

-   All API requests require a valid JWT obtained through Google Authentication
-   Device ownership is verified for each request to ensure users can only access their own devices
