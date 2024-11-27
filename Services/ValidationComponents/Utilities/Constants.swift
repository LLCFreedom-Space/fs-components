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

/// A collection of constant values and regular expressions used for validation purposes.
public enum Constants {
    /// Regular expression for phone numbers.
    ///
    /// The pattern matches phone numbers with optional international country code
    /// and allows various formats (e.g., with spaces, dashes, or parentheses).
    ///
    /// - Example matches: `+1 123-456-7890`, `123 456 7890`, `(123) 456-7890`
    /// - Source: [Telephone Numbering Plan](https://en.wikipedia.org/wiki/Telephone_numbering_plan)
    public static let phoneNumberRegex: String = "^(\\s*)?(\\+)?([-()+]?\\d[- _():=+]?){5,15}(\\s*)?$"

    /// Regular expression for service name.
    ///
    /// The pattern matches lowercase alphabetical characters and hyphens, with a length range of 1 to 100 characters.
    ///
    /// - Example: `service-name`, `myservice`
    public static let serviceNameRegex: String = "^[a-z-]{1,100}$"

    /// Regular expression for phone number code (e.g., country code).
    ///
    /// The pattern matches a 6-digit phone number code, used typically for regions or countries.
    ///
    /// - Example: `123456`, `987654`
    public static let phoneNumberCodeRegex: String = "^\\d{6}$"

    /// Regular expression for name validation.
    ///
    /// The pattern matches any string of characters between 1 and 100 characters in length.
    ///
    /// - Example: `John Doe`, `Jane`
    public static let nameRegex: String = "^.{1,100}$"

    /// Regular expression for postal code validation.
    ///
    /// The pattern matches both US-style zip codes (`12345` or `12345-6789`)
    /// as well as Canadian-style postal codes (`A1A 1A1`).
    ///
    /// - Example matches: `12345`, `12345-6789`, `A1A 1A1`, `K1A 0B1`
    public static let postalCodeRegex: String = "(^\\d{5}(-\\d{4})?$)|(^[ABCEGHJKLMNPRSTVXY]\\d[A-Z][- ]*\\d[A-Z]\\d$)"

    /// Regular expression for ISO country code.
    ///
    /// The pattern matches exactly two uppercase letters, representing a country code (e.g., `US`, `CA`).
    ///
    /// - Example: `US`, `CA`, `GB`
    public static let isoCountryCodeRegex = "^[A-Z]{2}$"

    /// Regular expression for password validation.
    ///
    /// The pattern matches any string that is at least 8 characters long.
    ///
    /// - Example: `Password123`, `securepass`
    public static let passwordRegex: String = "^.{8,}$"

    /// Regular expression for company name validation.
    ///
    /// The pattern matches a string with a length between 6 and 255 characters, allowing company names with
    /// a wide range of characters (e.g., letters, numbers, and symbols).
    ///
    /// - Example: `Acme Inc.`, `XYZ Corporation`
    public static let companyNameRegex: String = "^.{6,255}$"

    /// Default date format used in the application.
    ///
    /// The format is `yyyy-MM-dd'T'HH:mm:ss.SSS`, which corresponds to the ISO 8601 standard for date and time.
    ///
    /// - Example: `2024-11-27T13:45:30.000`
    public static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
}
