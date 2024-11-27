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
//  RedisComponentsProtocol.swift
//  
//
//  Created by Mykola Buhaiov on 08.02.2024.
//

import Vapor

/// A protocol defining methods for interacting with Redis components in an application.
///
/// This protocol provides functionality for checking Redis connection status,
/// sending a "ping" to Redis, and scheduling repeated tasks. It is meant to be
/// implemented by any Redis-related service or component that integrates with the application.
public protocol RedisComponentsProtocol {
    /// Sends a "ping" command to the Redis database to check its connectivity.
    ///
    /// This method asynchronously attempts to get a "pong" response from Redis.
    /// If Redis is responsive, it returns a success message; otherwise, it will
    /// return an error message indicating the failure.
    ///
    /// - Returns: A `String` containing the Redis response message.
    ///           If the connection is successful, it returns "Pong".
    ///           Otherwise, it returns an error message.
    func getPong() async -> String

    /// Retrieves the connection status of the Redis database.
    ///
    /// This method asynchronously checks the status of the Redis connection
    /// and returns a status message and an HTTP response code.
    ///
    /// - Returns: A tuple containing:
    ///   - `String`: A message indicating the Redis status. For example,
    ///     "Ok" if Redis is available, or an error message if Redis is down.
    ///   - `HTTPResponseStatus`: An HTTP status code corresponding to the result
    ///     of the Redis connection check (e.g., `.ok` for a successful connection,
    ///     `.serviceUnavailable` for a failure).
    ///
    /// - Example: ("Ok", .ok) if Redis is responsive, or ("Failed to connect", .serviceUnavailable) if it is not.
    func getRedisStatus() async -> (String, HTTPResponseStatus)

    /// Schedules a repeated task to send a "ping" to Redis at specified intervals.
    ///
    /// This method schedules a background task to ping Redis at the interval specified
    /// by the `second` parameter. The task will be executed repeatedly based on this delay.
    ///
    /// - Parameter delay: The interval in seconds between each ping request to Redis.
    ///                    The task will repeat at this interval.
    func scheduleRepeatedTask(by second: Int64)
}
