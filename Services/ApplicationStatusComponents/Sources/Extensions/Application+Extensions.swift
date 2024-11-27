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
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

extension Application {
    /// A `ApplicationStatusComponentsKey` conforming to `StorageKey` protocol.
    ///
    /// This key is used to store and retrieve the `ApplicationStatusComponentsProtocol` from the
    /// application’s storage. It provides a structured way to access and manage components that
    /// describe the status of the application.
    public struct ApplicationStatusComponentsKey: StorageKey {
        /// Less verbose typealias for `ApplicationStatusComponentsProtocol`.
        public typealias Value = ApplicationStatusComponentsProtocol
    }

    /// A computed property that retrieves or sets the `ApplicationStatusComponentsProtocol` in the application storage.
    ///
    /// - `get`: Retrieves the `ApplicationStatusComponentsProtocol` from storage.
    /// - `set`: Stores the `ApplicationStatusComponentsProtocol` in storage.
    ///
    /// This property is used to manage and access various components that monitor the application's status.
    public var appStatusComponents: ApplicationStatusComponentsProtocol? {
        get { storage[ApplicationStatusComponentsKey.self] }
        set { storage[ApplicationStatusComponentsKey.self] = newValue }
    }
}

extension Application {
    /// A `ApplicationUpTimeKey` conforming to `StorageKey` protocol.
    ///
    /// This key is used to store and retrieve the application’s uptime, which represents how long
    /// the application has been running, in the form of a `TimeInterval`.
    public struct ApplicationUpTimeKey: StorageKey {
        /// Less verbose typealias for `TimeInterval`.
        public typealias Value = TimeInterval
    }

    /// A computed property that retrieves or sets the application’s uptime in the application storage.
    ///
    /// - `get`: Retrieves the uptime of the application, represented as a `TimeInterval` (in seconds).
    /// - `set`: Stores the uptime of the application in the storage.
    ///
    /// This property is used to store and track the time elapsed since the application started.
    public var applicationUpTime: TimeInterval {
        get { storage[ApplicationUpTimeKey.self] ?? 0 }
        set { storage[ApplicationUpTimeKey.self] = newValue }
    }
}

extension Application {
    /// A `ApplicationUpDateKey` conforming to `StorageKey` protocol.
    ///
    /// This key is used to store and retrieve the application’s launch date as a `String` in ISO 8601 format.
    public struct ApplicationUpDateKey: StorageKey {
        /// Less verbose typealias for `String`.
        public typealias Value = String
    }

    /// A computed property that retrieves or sets the application’s launch date in the application storage.
    ///
    /// - `get`: Retrieves the application’s launch date, represented as a `String` in ISO 8601 format.
    /// - `set`: Stores the application’s launch date in storage.
    ///
    /// This property is used to store the exact date and time when the application started.
    public var applicationUpDate: String {
        get { storage[ApplicationUpDateKey.self] ?? "0" }
        set { storage[ApplicationUpDateKey.self] = newValue }
    }
}

extension Application {
    /// A computed property that returns a `DateFormatter` configured for ISO 8601 format with date and time.
    ///
    /// This `DateFormatter` is specifically set to format dates as `yyyy-MM-dd'T'HH:mm:ss.SSS`,
    /// which is a widely used standard for date-time representations in APIs and logs.
    ///
    /// Example: `2024-02-01T11:11:59.364`
    public var dateTimeISOFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        return formatter
    }
}
