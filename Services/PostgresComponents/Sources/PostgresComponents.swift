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

public struct PostgresComponents: PostgresComponentsProtocol {
    /// Instance of app as `Application`
    public let app: Application

    public init(app: Application) {
        self.app = app
    }

    /// Get version from postgresql
    /// - Returns: `String`
    public func getVersion() async -> String {
        let rows = try? await (app.db(.psql) as? PostgresDatabase)?.simpleQuery("SELECT version()").get()
        let row = rows?.first?.makeRandomAccess()
        var version = "ERROR: No connect to Postgres database"
        if let result = (row?[data: "version"].string) {
            version = result
        }
        return version
    }

    /// Get status for `PostgresSQL` database
    /// - Returns: `(String, HTTPResponseStatus)`
    ///  Example - `PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit`,  `.ok`
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

    /// Schedule repeated task
    /// - Parameter delay: `Int64`
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
