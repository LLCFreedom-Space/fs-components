// FS Components
// Copyright (C) 2024  FREEDOM SPACE, LLC

//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

//
//  AppStatusResponse.swift
//
//
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

/// Represents the status and system information of the application and its dependencies.
///
/// The `AppStatusResponse` struct is used to provide a comprehensive overview of the current state
/// of the application, including system uptime, server details, and the connection statuses of
/// various services such as Redis, PostgreSQL, and MongoDB. This information is typically used for
/// health checks or diagnostics purposes.
public struct AppStatusResponse: Content {
    /// The current status of the application.
    ///
    /// This property indicates the health or operational status of the application.
    /// It is typically set to `"Ok"` to indicate the application is running normally.
    public var appStatus: String = "Ok"
    /// The system uptime in seconds since the application started.
    ///
    /// This represents the time interval (in seconds) since the system (or application) was last started.
    /// It is useful for monitoring the application's runtime and availability.
    public var systemUptime: TimeInterval
    /// The number of active processors on the server.
    ///
    /// This property represents the number of active CPU cores available for processing on the server
    /// hosting the application. It provides insight into the computational resources available.
    public var activeProcessorCount: Int
    /// The version of the operating system running on the server.
    ///
    /// This property holds the version string for the server's operating system. It is useful for
    /// compatibility checks and troubleshooting system-related issues.
    public var operatingSystemVersion: String
    /// The total physical memory (RAM) available on the server, in gigabytes.
    ///
    /// This property provides the total physical memory available on the server. It is represented
    /// as a `Double` to accommodate large memory values.
    public var physicalMemory: Double
    /// The current Redis connection status.
    ///
    /// This optional property indicates the connection status of the Redis database. It can be
    /// used to check if the application is able to connect to Redis and if it is healthy.
    public var redisConnectionStatus: String?
    /// The version of Redis currently in use.
    ///
    /// This optional property holds the version of Redis if the application is connected to a Redis
    /// instance. It is useful for ensuring the application is working with a compatible version of Redis.
    public var redisVersion: String?
    /// The current PostgreSQL connection status.
    ///
    /// This optional property indicates the connection status of the PostgreSQL database. It is useful
    /// for checking if the application can communicate with PostgreSQL and if the database is accessible.
    public var psqlConnectionStatus: String?
    /// The version of PostgreSQL currently in use.
    ///
    /// This optional property holds the version of PostgreSQL if the application is connected to a PostgreSQL
    /// database. It helps ensure compatibility with the version in use.
    public var psqlVersion: String?
    /// The current MongoDB connection status.
    ///
    /// This optional property indicates the connection status of the MongoDB database. It is useful for
    /// checking whether the application can connect to MongoDB and its health.
    public var mongoConnectionStatus: String?
    /// The version of MongoDB currently in use.
    ///
    /// This optional property holds the version of MongoDB if the application is connected to a MongoDB
    /// instance. It is useful for monitoring the MongoDB version compatibility.
    public var mongoVersion: String?
    /// The name of the application.
    ///
    /// This optional property holds the name of the application, which may be useful for monitoring,
    /// logging, or identifying the application instance.
    public var appName: String?
    /// The version of the application.
    ///
    /// This optional property holds the version number of the application. It is typically used for
    /// version tracking and monitoring the release status of the application.
    public var appVersion: String?

    /// Initializes a new instance with detailed application and system status information.
    ///
    /// This initializer sets up the instance with various application and system metrics,
    /// including connection statuses, version details, and hardware specifications.
    ///
    /// - Parameters:
    ///   - appStatus: A string representing the current status of the application. Defaults to `"Ok"`.
    ///   - systemUptime: The system's uptime, in seconds.
    ///   - activeProcessorCount: The number of active processors available.
    ///   - operatingSystemVersion: A string representing the operating system version.
    ///   - physicalMemory: The physical memory available, in bytes.
    ///   - redisConnectionStatus: (Optional) The status of the Redis connection.
    ///   - psqlConnectionStatus: (Optional) The status of the PostgreSQL connection.
    ///   - mongoConnectionStatus: (Optional) The status of the MongoDB connection.
    ///   - redisVersion: (Optional) The version of Redis in use.
    ///   - psqlVersion: (Optional) The version of PostgreSQL in use.
    ///   - mongoVersion: (Optional) The version of MongoDB in use.
    ///   - appName: (Optional) The name of the application.
    ///   - appVersion: (Optional) The version of the application.
    public init(
        appStatus: String = "Ok",
        systemUptime: TimeInterval,
        activeProcessorCount: Int,
        operatingSystemVersion: String,
        physicalMemory: Double,
        redisConnectionStatus: String? = nil,
        psqlConnectionStatus: String? = nil,
        mongoConnectionStatus: String? = nil,
        redisVersion: String? = nil,
        psqlVersion: String? = nil,
        mongoVersion: String? = nil,
        appName: String? = nil,
        appVersion: String? = nil
    ) {
        self.appStatus = appStatus
        self.systemUptime = systemUptime
        self.activeProcessorCount = activeProcessorCount
        self.operatingSystemVersion = operatingSystemVersion
        self.physicalMemory = physicalMemory
        self.redisConnectionStatus = redisConnectionStatus
        self.psqlConnectionStatus = psqlConnectionStatus
        self.mongoConnectionStatus = mongoConnectionStatus
        self.redisVersion = redisVersion
        self.psqlVersion = psqlVersion
        self.mongoVersion = mongoVersion
        self.appName = appName
        self.appVersion = appVersion
    }

    /// A static example instance of `AppStatusResponse` for testing or demonstration purposes.
    ///
    /// This example provides a pre-defined `AppStatusResponse` with sample values for all properties,
    /// illustrating typical usage or serving as a mock object in tests.
    ///
    /// - Example Usage:
    ///   ```swift
    ///   let exampleResponse = AppStatusResponse.example
    ///   print(exampleResponse.appName) // "Name of application"
    ///   ```
    public static var example: AppStatusResponse {
        AppStatusResponse(
            appStatus: "Ok",
            systemUptime: 123456,
            activeProcessorCount: 12,
            operatingSystemVersion: "12.1",
            physicalMemory: 12,
            redisConnectionStatus: "Ok",
            psqlConnectionStatus: "Ok",
            mongoConnectionStatus: "Ok",
            redisVersion: "12",
            psqlVersion: "12.9",
            mongoVersion: "20.2",
            appName: "Name of application",
            appVersion: "1.1.1"
        )
    }
}
