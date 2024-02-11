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
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

/// Constants
public enum Constants {
    /// RegEx for phone numbers
    /// https://en.wikipedia.org/wiki/Telephone_numbering_plan
    static let phoneNumberRegex: String = "^(\\s*)?(\\+)?([-()+]?\\d[- _():=+]?){5,15}(\\s*)?$"
    static let serviceNameRegex: String = "^[a-z-]{1,100}$"
    static let phoneNumberCodeRegex: String = "^\\d{6}$"
    static let nameRegex: String = "^.{1,100}$"
    static let postalCodeRegex: String = "(^\\d{5}(-\\d{4})?$)|(^[ABCEGHJKLMNPRSTVXY]\\d[A-Z][- ]*\\d[A-Z]\\d$)"
    static let isoCountryCodeRegex = "^[A-Z]{2}$"
    static let passwordRegex: String = "^.{8,}$"
    static let companyNameRegex: String = "^.{6,255}$"
    /// Default date format
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
}
