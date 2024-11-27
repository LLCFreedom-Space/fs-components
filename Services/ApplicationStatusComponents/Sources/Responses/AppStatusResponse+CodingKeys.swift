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
//  AppStatusResponse+CodingKeys.swift
//  
//
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

/// An enumeration of coding keys used for encoding and decoding `AppStatusResponse` properties.
///
/// This enum maps the properties of `AppStatusResponse` to their corresponding keys
/// in a serialized representation, such as JSON. Each case corresponds to a property,
/// with the raw value representing the key in the serialized format.
///
/// Example usage:
/// ```json
/// {
///   "app_status": "Ok",
///   "system_uptime": 123456,
///   "active_processor_count": 12,
///   "operating_system_version": "12.1",
///   "physical_memory": 12,
///   "redis_connection_status": "Ok",
///   "psql_connection_status": "Ok",
///   "mongo_connection_status": "Ok",
///   "redis_version": "12",
///   "psql_version": "12.9",
///   "mongo_version": "20.2",
///   "app_name": "Name of application",
///   "app_version": "1.1.1"
/// }
/// ```
///
/// - Note: The raw values match the expected key names in JSON.
extension AppStatusResponse {
    public enum CodingKeys: String, CodingKey {
        /// The application's status.
        case appStatus = "app_status"
        /// The system's uptime in seconds.
        case systemUptime = "system_uptime"
        /// The number of active processors.
        case activeProcessorCount = "active_processor_count"
        /// The operating system version.
        case operatingSystemVersion = "operating_system_version"
        /// The amount of physical memory available, in bytes.
        case physicalMemory = "physical_memory"
        /// The status of the Redis connection.
        case redisConnectionStatus = "redis_connection_status"
        /// The status of the PostgreSQL connection.
        case psqlConnectionStatus = "psql_connection_status"
        /// The status of the MongoDB connection.
        case mongoConnectionStatus = "mongo_connection_status"
        /// The version of Redis in use.
        case redisVersion = "redis_version"
        /// The version of PostgreSQL in use.
        case psqlVersion = "psql_version"
        /// The version of MongoDB in use.
        case mongoVersion = "mongo_version"
        /// The name of the application.
        case appName = "app_name"
        /// The version of the application.
        case appVersion = "app_version"
    }
}

