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
    /// A `ApplicationStatusComponentsKey` conform to StorageKey protocol
    public struct ApplicationStatusComponentsKey: StorageKey {
        /// Less verbose typealias for `ApplicationStatusComponentsProtocol`.
        public typealias Value = ApplicationStatusComponentsProtocol
    }

    /// Setup `appStatusComponents` in application storage
    public var appStatusComponents: ApplicationStatusComponentsProtocol? {
        get { storage[ApplicationStatusComponentsKey.self] }
        set { storage[ApplicationStatusComponentsKey.self] = newValue }
    }
}

extension Application {
    /// A `ApplicationUpTimeKey` conform to StorageKey protocol
    public struct ApplicationUpTimeKey: StorageKey {
        /// Less verbose typealias for `TimeInterval`.
        public typealias Value = TimeInterval
    }

    /// Setup `applicationUpTime` in application storage
    public var applicationUpTime: TimeInterval {
        get { storage[ApplicationUpTimeKey.self] ?? 0 }
        set { storage[ApplicationUpTimeKey.self] = newValue }
    }
}

extension Application {
    /// A `ApplicationUpDateKey` conform to StorageKey protocol
    public struct ApplicationUpDateKey: StorageKey {
        /// Less verbose typealias for `String`.
        public typealias Value = String
    }

    /// Setup `applicationUpDate` in application storage
    public var applicationUpDate: String {
        get { storage[ApplicationUpDateKey.self] ?? "0" }
        set { storage[ApplicationUpDateKey.self] = newValue }
    }
}

extension Application {
    /// Variable of date conform to DateFormatter protocol. ISO 8601 with date time format
    /// Example: `2024-02-01T11:11:59.364`
    public var dateTimeISOFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        return formatter
    }
}
