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
//  ApplicationStatusComponents.swift
//
//
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

/// A structure that provides methods to record and retrieve application status information
/// such as launch time, uptime, and the duration the application has been running.
/// Conforms to `ApplicationStatusComponentsProtocol` to ensure consistent status tracking functionality.
public struct ApplicationStatusComponents: ApplicationStatusComponentsProtocol {
    /// The `Application` instance providing the context and functionality for tracking application status.
    public let app: Application

    /// Creates an instance of `ApplicationStatusComponents` with the provided `Application`.
    ///
    /// This initializer associates the given `Application` object with the status components instance,
    /// enabling access to application-specific properties and functionality such as uptime tracking.
    ///
    /// - Parameter app: An `Application` object that provides context and functionality for the status components.
    public init(app: Application) {
        self.app = app
    }

    /// Records the launch time of the application.
    ///
    /// This method stores the current time when the application was launched in the `app.applicationUpTime`
    /// property as a time interval since the reference date (January 1, 2001).
    /// This can be used to measure the uptime of the application.
    ///
    /// - Example Usage:
    /// ```swift
    /// appStatusComponents.applicationLaunchTime()
    /// ```
    public func applicationLaunchTime() {
        app.applicationUpTime = Date().timeIntervalSinceReferenceDate
    }

    /// Retrieves the uptime of the application.
    ///
    /// This method calculates and returns the amount of time the application has been running since it was launched.
    /// The uptime is returned as a `Double`, representing the time in seconds since the application's start.
    ///
    /// - Returns: A `Double` representing the uptime of the application in seconds.
    /// - Example: `98647017841958.0`
    public func applicationUpTime() -> Double {
        let timeNow = Date().timeIntervalSinceReferenceDate
        return timeNow - app.applicationUpTime
    }

    /// Records the launch date of the application.
    ///
    /// This method stores the current date and time in ISO 8601 format when the application is launched.
    /// The date is stored in the `app.applicationUpDate` property as a string.
    ///
    /// - Example Usage:
    /// ```swift
    /// appStatusComponents.applicationLaunchDate()
    /// ```
    public func applicationLaunchDate() {
        let today = Date()
        let dateString = app.dateTimeISOFormat.string(from: today)
        app.applicationUpDate = dateString
    }

    /// Retrieves the application’s uptime in human-readable calendar date components.
    ///
    /// This method calculates the time the application has been running since it was launched in a calendar format,
    /// including years, months, days, hours, minutes, seconds, and time zone.
    ///
    /// - Returns: A `String` representing the uptime in calendar components.
    /// - Example: `"year: 0 month: 0 day: 0 hour: 4 minute: 18 second: 2 isLeapMonth: false"`
    public func applicationUpDate() -> String {
        guard let date = app.dateTimeISOFormat.date(from: app.applicationUpDate) else {
            return "0"
        }
        let units = Array<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .timeZone])
        let components = Calendar.current.dateComponents(Set(units), from: date, to: Date())
        return "\(components)"
    }
}
