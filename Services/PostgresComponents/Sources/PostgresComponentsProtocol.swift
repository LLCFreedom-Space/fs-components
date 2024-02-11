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

/// Groups func for get psql components
public protocol PostgresComponentsProtocol {
    /// Get  postgresql version
    /// - Returns: `HealthCheckItem`
    func getVersion() async -> String 

    /// Get status for `PostgresSQL` database
    /// - Returns: `(String, String, HTTPResponseStatus)` - Connection status, version of database,  connection status code. Example - `Ok`, `PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit`,  `.ok`
    func getPostgresStatus() async -> (String, HTTPResponseStatus)

    /// Schedule repeated task
    /// - Parameter delay: `Int64`
    func scheduleRepeatedTask(second delay: Int64)
}
