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
//  Constants.swift
//
//
//  Created by Mykola Buhaiov on 11.02.2024.
//

import Vapor

/// A collection of constant values used throughout the application.
///
/// The `Constants` enum provides default values that can be reused across the application,
/// ensuring consistency and reducing duplication of literal values.
public enum Constants {
    /// The default date format used for date-time representations.
    ///
    /// This constant defines the date format to be used when parsing or formatting dates in the
    /// application. It follows the ISO 8601 format with milliseconds.
    ///
    /// - Example: `"yyyy-MM-dd'T'HH:mm:ss.SSS"`
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
}
