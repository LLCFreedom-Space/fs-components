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
//  RedisComponents.swift
//
//
//  Created by Mykola Buhaiov on 07.02.2024.
//

import Vapor
import Redis

/// A struct that provides Redis-related functionality for the application. It allows for checking the
/// status of the Redis connection, sending periodic ping requests, and retrieving Redis connectivity status.
/// Conforms to the `RedisComponentsProtocol`.
public struct RedisComponents: RedisComponentsProtocol {
    /// Instance of app as `Application`
    public let app: Application

    /// Initializes a new `RedisComponents` instance with a given `Application` object.
    ///
    /// - Parameter app: The `Application` instance which will be used for Redis-related tasks.
    public init(app: Application) {
        self.app = app
    }

    /// Sends a ping to Redis and returns the result as a string.
    ///
    /// This method attempts to boot the application, sends a ping to the Redis server,
    /// and returns either the ping result (e.g., "PONG") or an error message.
    ///
    /// - Returns: A `String` that represents the result of the Redis ping, either `"PONG"` or an error message.
    public func getPong() async -> String {
        try? app.boot()  // Boot the application if it hasn't been booted yet.
        do {
            return try await app.redis.ping().get()  // Perform Redis ping and get the response.
        } catch {
            return "Check redis connect fail with error: \(error)"  // Return error message if ping fails.
        }
    }

    /// Gets the status of the Redis connection and returns the status as a string and an HTTP response status.
    ///
    /// This method attempts to boot the application, sends a ping to the Redis server, and checks whether
    /// the response is a "PONG". It returns the status message and corresponding HTTP response status.
    ///
    /// - Returns: A tuple of `(String, HTTPResponseStatus)`. The string contains the connection status (e.g., "Ok")
    ///   and the HTTP response status indicates the success or failure of the connection (e.g., `.ok`, `.serviceUnavailable`).
    public func getRedisStatus() async -> (String, HTTPResponseStatus) {
        try? app.boot()  // Boot the application if it hasn't been booted yet.
        let statusCode = HTTPResponseStatus.serviceUnavailable  // Default to service unavailable if connection fails.

        do {
            let responseRedis = try await app.redis.ping().get()  // Send a Redis ping and get the response.
            if responseRedis.description == "PONG" {
                return ("Ok", .ok)  // Return success if the response is "PONG".
            } else {
                return ("No connect to Redis database. Response: \(responseRedis.description)", statusCode)
            }
        } catch {
            app.logger.error("No connect to Redis database. Reason: \(error)")  // Log the error if the ping fails.
            return ("No connect to Redis database. Reason: \(error)", statusCode)
        }
    }

    /// Schedules a repeated task to ping the Redis server at regular intervals.
    ///
    /// This method schedules a background task that sends a ping to the Redis server at the specified interval
    /// (in seconds). The task is scheduled to run repeatedly at the given interval, logging any errors if the ping
    /// fails or if the response is not "PONG".
    ///
    /// - Parameter delay: The delay interval (in seconds) between each Redis ping. The task will repeat at this interval.
    public func scheduleRepeatedTask(by second: Int64) {
        try? self.app.boot()  // Boot the application if it hasn't been booted yet.
        DispatchQueue.global().async {  // Run the task in the background to avoid blocking the main thread.
            self.app.client.eventLoop.scheduleRepeatedTask(initialDelay: .seconds(0), delay: .seconds(second)) { _ in
                self.app.logger.debug("Send ping to Redis. Re-send after \(second) seconds.")  // Log when a ping is sent.

                // Send a Redis ping and handle the response.
                app.redis.ping()
                    .flatMapThrowing { response in
                        if response.description != "PONG" {
                            // Log an error if the ping response is not "PONG".
                            self.app.logger.error("Send ping to Redis fail with error: \(response)")
                        }
                    }
            }
        }
    }
}
