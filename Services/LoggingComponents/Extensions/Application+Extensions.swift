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
//  Application+Extensions.swift
//  
//
//  Created by Mykola Buhaiov on 20.07.2024.
//

import Vapor

extension Application {
    /// Provides access to the `LogLevel` utility for configuring the application's logging level.
    ///
    /// This computed property initializes and returns an instance of the `LogLevel` struct,
    /// which is used to configure and manage the application's logging level.
    ///
    /// - Usage:
    ///   ```swift
    ///   let logLevel = app.logLevel
    ///   logLevel.setupLoggingLevel()
    ///   ```
    ///
    /// - Returns: A `LogLevel` instance initialized with the current application.
    public var logLevel: LogLevel {
        .init(app: self)
    }
}
