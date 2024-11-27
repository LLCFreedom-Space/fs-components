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
//  ApplicationStatusComponentsProtocol.swift
//  
//
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

/// A protocol that defines components for tracking an application's status and runtime metrics.
public protocol ApplicationStatusComponentsProtocol {
    /// Logs or calculates the application's launch time.
    ///
    /// This function typically records or provides information about when the application started.
    func applicationLaunchTime()

    /// Returns the application's uptime in seconds.
    ///
    /// This function computes how long the application has been running since its launch.
    /// - Returns: The time in seconds since the application launched.
    func applicationUpTime() -> Double

    /// Logs or calculates the application's launch date.
    ///
    /// This function provides the date and time the application was launched.
    func applicationLaunchDate()

    /// Returns a string representation of the application's uptime.
    ///
    /// This function converts the application's uptime into a human-readable format.
    /// - Returns: A formatted string representing the application's uptime (e.g., "2 hours, 30 minutes").
    func applicationUpDate() -> String
}
