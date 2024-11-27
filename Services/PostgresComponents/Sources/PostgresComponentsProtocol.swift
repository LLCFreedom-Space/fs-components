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
//  PostgresComponentsProtocol.swift
//
//
//  Created by Mykola Buhaiov on 08.02.2024.
//

import Vapor

/// A protocol defining methods for interacting with PostgreSQL components in an application.
///
/// This protocol provides functionality for checking the PostgreSQL database version,
/// retrieving the connection status, and scheduling repeated tasks for PostgreSQL health checks.
/// It is designed to be implemented by any service or component that interacts with PostgreSQL
/// within an application.
public protocol PostgresComponentsProtocol {
    /// Retrieves the version of the PostgreSQL database.
    ///
    /// This method asynchronously queries the PostgreSQL server to obtain its version information.
    /// It returns a string representing the version of PostgreSQL, which may include additional
    /// details such as the operating system and build configuration.
    ///
    /// - Returns: A `String` containing the version information of the PostgreSQL database.
    ///           For example, it could return something like `"PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1)..."`.
    func getVersion() async -> String

    /// Retrieves the connection status and version of the PostgreSQL database.
    ///
    /// This method asynchronously checks the status of the PostgreSQL connection and retrieves
    /// the version information. It returns a tuple containing a status message, the version of
    /// PostgreSQL, and an HTTP response status code.
    ///
    /// - Returns: A tuple containing:
    ///   - `String`: The version of the PostgreSQL database (e.g., `"PostgreSQL 14.1..."`).
    ///   - `HTTPResponseStatus`: The HTTP status code indicating the result of the connection check
    ///                           (e.g., `.ok` for success, `.serviceUnavailable` for failure).
    ///
    /// - Example: `("Ok", "PostgreSQL 14.1...", .ok)` if PostgreSQL is available and responsive,
    ///            or `("Failed to connect", "", .serviceUnavailable)` if there is a failure in connection.
    func getPostgresStatus() async -> (String, HTTPResponseStatus)

    /// Schedules a repeated task to check PostgreSQL's status at specified intervals.
    ///
    /// This method schedules a background task that checks the PostgreSQL status and version
    /// at regular intervals, based on the specified `delay` parameter (in seconds). The task
    /// will continue to run and check the PostgreSQL status at each interval.
    ///
    /// - Parameter delay: The interval (in seconds) between each PostgreSQL status check.
    ///                    The task will repeat at this interval until stopped or canceled.
    func scheduleRepeatedTask(second delay: Int64)
}
