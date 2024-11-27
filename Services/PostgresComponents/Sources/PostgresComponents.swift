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
//  PostgresComponents.swift
//
//
//  Created by Mykola Buhaiov on 07.02.2024.
//

import Vapor
import Fluent
import FluentPostgresDriver

/// A struct that implements the `PostgresComponentsProtocol` to interact with a PostgreSQL database.
///
/// This struct provides methods to check the PostgreSQL database version,
/// retrieve the connection status, and schedule periodic health checks for PostgreSQL.
/// It is intended to be used in an application to interact with a PostgreSQL database and manage
/// the health and status of the database.
public struct PostgresComponents: PostgresComponentsProtocol {
    /// Instance of the application, used to access the database and event loop.
    public let app: Application

    /// Initializes a new instance of `PostgresComponents` with a given application.
    ///
    /// - Parameter app: The `Application` instance, which provides access to the database and other app services.
    public init(app: Application) {
        self.app = app
    }

    /// Retrieves the version of the PostgreSQL database.
    ///
    /// This method performs a query to the PostgreSQL database to get its version.
    /// If successful, it returns the version string, otherwise, it returns an error message.
    ///
    /// - Returns: A `String` containing the version of the PostgreSQL database or an error message if the connection fails.
    public func getVersion() async -> String {
        let rows = try? await (app.db(.psql) as? PostgresDatabase)?.simpleQuery("SELECT version()").get()
        let row = rows?.first?.makeRandomAccess()
        var version = "ERROR: No connect to Postgres database"
        if let result = (row?[data: "version"].string) {
            version = result
        }
        return version
    }

    /// Retrieves the connection status and version of the PostgreSQL database.
    ///
    /// This method checks the connection to the PostgreSQL database and returns the version information
    /// along with an HTTP status code indicating whether the connection was successful or not.
    ///
    /// - Returns: A tuple containing:
    ///   - A `String` with the PostgreSQL version information if the connection is successful, or an error message if the connection fails.
    ///   - A `HTTPResponseStatus` indicating the status of the connection (e.g., `.ok` for success or `.badRequest` for failure).
    ///
    /// - Example: `("PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) ...", .ok)` if successful, or `("No connect to Postgres database.", .badRequest)` if the connection fails.
    public func getPostgresStatus() async -> (String, HTTPResponseStatus) {
        var connection = String()
        var statusCode = HTTPResponseStatus.badRequest
        do {
            let rows = try await (app.db(.psql) as? PostgresDatabase)?.simpleQuery("SELECT version()").get()
            let row = rows?.first?.makeRandomAccess()
            if let version = row?[data: "version"].string {
                connection = version
                statusCode = .ok
            } else {
                app.logger.error("No connect to Postgres database. Response: \(String(describing: row))")
                connection = "No connect to Postgres database."
            }
        } catch {
            app.logger.error("No connect to Postgres database. Reason: \(error)")
            connection = "No connect to Postgres database. Reason: \(error)"
        }
        return (connection, statusCode)
    }

    /// Schedules a repeated task to check PostgreSQL's status at specified intervals.
    ///
    /// This method schedules a background task that checks the PostgreSQL status and version
    /// at regular intervals, based on the specified `delay` parameter (in seconds). The task
    /// will continue to run and check the PostgreSQL status at each interval.
    ///
    /// - Parameter delay: The interval (in seconds) between each PostgreSQL status check.
    ///                    The task will repeat at this interval until stopped or canceled.
    public func scheduleRepeatedTask(second delay: Int64) {
        DispatchQueue.global().async {
            self.app.client.eventLoop.scheduleRepeatedTask(initialDelay: .seconds(0), delay: .seconds(delay)) { _ in
                app.logger.debug("Get version from Postgres. Re-send after \(delay) seconds.")
                let version = (app.db(.psql) as? PostgresDatabase)?.simpleQuery("SELECT version()")
                version.unsafelyUnwrapped.flatMapThrowing { rows in
                    let row = rows.first?.makeRandomAccess()
                    if ((row?[data: "version"].string) != nil) {
                        app.logger.error("Get version from Postgres fail with error: \(String(describing: row))")
                    }
                }
                .flatMapErrorThrowing { error in
                    app.logger.error("No connect to Postgres database. Reason: \(error)")
                }
            }
        }
    }
}
