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

public struct ApplicationStatusComponents: ApplicationStatusComponentsProtocol {
    /// Instance of app as `Application`
    public let app: Application

    /// Recording the start time for an `Application`
    /// Example - `78647017841958.0`
    public func applicationLaunchTime() {
        app.applicationUpTime = Date().timeIntervalSinceReferenceDate
    }

    /// Working time for `Application`
    /// - Returns: `Double` time the service has been running since it was started.
    /// Example - `98647017841958.0`
    public func applicationUpTime() -> Double {
        let timeNow = Date().timeIntervalSinceReferenceDate
        return timeNow - app.applicationUpTime
    }

    /// Recording the start full time for an `Application`. 
    /// Example - `2022-05-08 16:36:16.034GMT+3`
    public func applicationLaunchDate() {
        let today = Date()
        let dateString = app.dateTimeISOFormat.string(from: today)
        app.applicationUpDate = dateString
    }

    /// Working time for `Application` in Calendar Date components
    /// - Returns: `String` time the service has been running since it was started. 
    /// Example - `year: 0 month: 0 day: 0 hour: 4 minute: 18 second: 2 isLeapMonth: false`
    public func applicationUpDate() -> String {
        guard let date = app.dateTimeISOFormat.date(from: app.applicationUpDate) else {
            return "0"
        }
        let units = Array<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .timeZone])
        let components = Calendar.current.dateComponents(Set(units), from: date, to: Date())
        return "\(components)"
    }
}
