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
//  Validator+Extensions.swift
//
//
//  Created by Mykola Buhaiov on 08.02.2024.
//

import Vapor

extension Validator where T == String {
    /// A static property of type `Validator<T>` that validates the Ukrainian company `EDRPOU` (Unified State Register of Enterprises and Organizations) number.
    ///
    /// This validator checks if the given `EDRPOU` number is valid based on its length and checksum calculation.
    /// The `EDRPOU` number must consist of exactly 8 digits, and the checksum is calculated according to a set of rules.
    /// If the checksum matches the calculated value, the EDRPOU is considered valid.
    ///
    /// ### Rules:
    /// - The `EDRPOU` must be exactly 8 digits long.
    /// - The checksum is calculated based on different multipliers depending on the range of the `EDRPOU` number:
    ///   - If the number is between 30,000,000 and 60,000,000, a specific set of multipliers is used.
    ///   - Otherwise, a different set of multipliers is applied, and if the result is 10, an alternative multiplier set is used.
    ///
    /// - Returns: A `ValidatorResults.UkraineCompanyEdrpou` object with a boolean flag `isValidUkraineCompanyEdrpou` indicating whether the `EDRPOU` number is valid.
    public static var ukraineCompanyEdrpou: Validator<T> {
        .init { ukraineEdrpou in
            // Ensure the EDRPOU number has exactly 8 digits
            guard ukraineEdrpou.count == 8 else {
                return ValidatorResults.UkraineCompanyEdrpou(isValidUkraineCompanyEdrpou: false)
            }

            // Ensure the EDRPOU number can be converted to an integer
            guard let edrpou = Int(ukraineEdrpou) else {
                return ValidatorResults.UkraineCompanyEdrpou(isValidUkraineCompanyEdrpou: false)
            }

            // Create an array of digits from the EDRPOU number
            let registerNumberArray = ukraineEdrpou.compactMap { Int(String($0)) }
            let result = registerNumberArray[7] // The last digit is the result of the checksum

            // Variable to store the calculated checksum
            var resultMatch: Int

            // EDRPOU number range check and checksum calculation
            if edrpou < 30000000 || edrpou > 60000000 {
                // For EDRPOU numbers outside the 30M-60M range, use a specific checksum formula
                resultMatch = (
                    registerNumberArray[0] * 1 +
                    registerNumberArray[1] * 2 +
                    registerNumberArray[2] * 3 +
                    registerNumberArray[3] * 4 +
                    registerNumberArray[4] * 5 +
                    registerNumberArray[5] * 6 +
                    registerNumberArray[6] * 7) % 11

                // If checksum result is 10, use an alternative formula
                if resultMatch == 10 {
                    resultMatch = (
                        registerNumberArray[0] * 3 +
                        registerNumberArray[1] * 4 +
                        registerNumberArray[2] * 5 +
                        registerNumberArray[3] * 6 +
                        registerNumberArray[4] * 7 +
                        registerNumberArray[5] * 8 +
                        registerNumberArray[6] * 9) % 11
                }
            } else {
                // For EDRPOU numbers in the 30M-60M range, use a different set of multipliers
                resultMatch = (
                    registerNumberArray[0] * 7 +
                    registerNumberArray[1] * 1 +
                    registerNumberArray[2] * 2 +
                    registerNumberArray[3] * 3 +
                    registerNumberArray[4] * 4 +
                    registerNumberArray[5] * 5 +
                    registerNumberArray[6] * 6) % 11

                // If checksum result is 10, use an alternative formula
                if resultMatch == 10 {
                    resultMatch = (
                        registerNumberArray[0] * 9 +
                        registerNumberArray[1] * 3 +
                        registerNumberArray[2] * 4 +
                        registerNumberArray[3] * 5 +
                        registerNumberArray[4] * 6 +
                        registerNumberArray[5] * 7 +
                        registerNumberArray[6] * 8) % 11
                }
            }

            // Compare the calculated checksum with the last digit in the EDRPOU number
            let isValid = resultMatch == result

            // Return the validation result
            return ValidatorResults.UkraineCompanyEdrpou(isValidUkraineCompanyEdrpou: isValid)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `birthday` string.
    ///
    /// This validator checks if the provided `birthday` string represents a valid date and if the date is in the past
    /// (i.e., the birthday must be earlier than the current date). The date string is assumed to be in the format specified
    /// by the `Constants.dateFormat` constant, and the validation checks that it can be parsed correctly into a `Date` object.
    /// If the string is valid, the validator compares the parsed date to the current date to ensure that the birthday is not
    /// in the future.
    ///
    /// - Returns: A `ValidatorResults.Birthday` object with a boolean flag `isValidBirthday` indicating whether the
    ///   provided `birthday` is a valid date and not in the future.
    public static var birthday: Validator<T> {
        .init { birthday in
            // Append the time part "T00:00:00.000" to the birthday string to make it a valid ISO 8601 datetime format
            let fullString = birthday + "T00:00:00.000"

            // Create a DateFormatter and set its date format to match the expected format from Constants.dateFormat
            let formatter = DateFormatter()
            formatter.dateFormat = Constants.dateFormat

            // Attempt to parse the full date string
            guard let date = formatter.date(from: fullString) else {
                // If parsing fails, return an invalid date result
                return ValidatorResults.Date(isValidDate: false)
            }

            // Convert the parsed birthday date and the current date to time intervals since 1970
            let birthdayDate = date.timeIntervalSince1970
            let dateNow = Date().timeIntervalSince1970

            // Return a validation result indicating whether the birthday is in the past (valid) or in the future (invalid)
            return ValidatorResults.Birthday(isValidBirthday: dateNow > birthdayDate)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `serviceName` string.
    ///
    /// This validator checks whether the provided `serviceName` matches a specific pattern defined by the regular expression
    /// `Constants.serviceNameRegex`. The service name is considered valid if the entire string matches the pattern, from start
    /// to end. If the string does not match the pattern, the validation fails.
    ///
    /// The validation ensures that the `serviceName` adheres to the expected format defined in the regular expression, but the
    /// specific format is determined by the `Constants.serviceNameRegex` constant.
    ///
    /// - Returns: A `ValidatorResults.ServiceName` object with a boolean flag `isValidServiceName` indicating whether the
    ///   provided `serviceName` matches the expected format.
    public static var serviceName: Validator<T> {
        .init {
            // Check if the serviceName string fully matches the regular expression pattern from start to end
            guard
                let range = $0.range(of: Constants.serviceNameRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                // If it doesn't match, return an invalid service name result
                return ValidatorResults.ServiceName(isValidServiceName: false)
            }

            // If the serviceName matches the pattern, return a valid service name result
            return ValidatorResults.ServiceName(isValidServiceName: true)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `phoneNumber` string.
    ///
    /// This validator checks whether the provided `phoneNumber` matches a specific pattern defined by the regular expression
    /// `Constants.phoneNumberRegex`. The phone number is considered valid if the entire string matches the pattern, from start
    /// to end. If the string does not match the pattern, the validation fails.
    ///
    /// The validation ensures that the `phoneNumber` adheres to the expected format defined in the regular expression, but the
    /// exact format is determined by the `Constants.phoneNumberRegex` constant. This may include rules such as country code,
    /// area code, and number formatting.
    ///
    /// - Returns: A `ValidatorResults.PhoneNumber` object with a boolean flag `isValidPhoneNumber` indicating whether the
    ///   provided `phoneNumber` matches the expected format.
    public static var phoneNumber: Validator<T> {
        .init {
            // Check if the phoneNumber string fully matches the regular expression pattern from start to end
            guard
                let range = $0.range(of: Constants.phoneNumberRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                // If it doesn't match, return an invalid phone number result
                return ValidatorResults.PhoneNumber(isValidPhoneNumber: false)
            }

            // If the phoneNumber matches the pattern, return a valid phone number result
            return ValidatorResults.PhoneNumber(isValidPhoneNumber: true)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `phoneNumberCode` string.
    ///
    /// This validator checks whether the provided `phoneNumberCode` matches a specific pattern defined by the regular expression
    /// `Constants.phoneNumberCodeRegex`. The phone number code is considered valid if the entire string matches the pattern, from start
    /// to end. If the string does not match the pattern, the validation fails.
    ///
    /// The validation ensures that the `phoneNumberCode` adheres to the expected format defined in the regular expression, but the
    /// exact format is determined by the `Constants.phoneNumberCodeRegex` constant. This may include rules such as length restrictions,
    /// only numeric characters, or specific country code patterns.
    ///
    /// - Returns: A `ValidatorResults.PhoneNumberCode` object with a boolean flag `isValidPhoneNumberCode` indicating whether the
    ///   provided `phoneNumberCode` matches the expected format.
    public static var phoneNumberCode: Validator<T> {
        .init {
            // Check if the phoneNumberCode string fully matches the regular expression pattern from start to end
            guard
                let range = $0.range(of: Constants.phoneNumberCodeRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                // If it doesn't match, return an invalid phone number code result
                return ValidatorResults.PhoneNumberCode(isValidPhoneNumberCode: false)
            }

            // If the phoneNumberCode matches the pattern, return a valid phone number code result
            return ValidatorResults.PhoneNumberCode(isValidPhoneNumberCode: true)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `name` string.
    ///
    /// This validator checks whether the provided `name` matches a specific pattern defined by the regular expression
    /// `Constants.nameRegex`. The name is considered valid if the entire string matches the pattern, from start
    /// to end. If the string does not match the pattern, the validation fails.
    ///
    /// The validation ensures that the `name` adheres to the expected format defined in the regular expression, but the
    /// exact format is determined by the `Constants.nameRegex` constant. This may include rules such as allowing only
    /// alphabetic characters, spaces, or certain punctuation marks, depending on the specific regular expression used.
    ///
    /// - Returns: A `ValidatorResults.Name` object with a boolean flag `isValidName` indicating whether the
    ///   provided `name` matches the expected format.
    public static var name: Validator<T> {
        .init {
            // Check if the name string fully matches the regular expression pattern from start to end
            guard
                let range = $0.range(of: Constants.nameRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                // If it doesn't match, return an invalid name result
                return ValidatorResults.Name(isValidName: false)
            }

            // If the name matches the pattern, return a valid name result
            return ValidatorResults.Name(isValidName: true)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `postalCode` string.
    ///
    /// This validator checks whether the provided `postalCode` matches a specific pattern defined by the regular expression
    /// `Constants.postalCodeRegex`. The postal code is considered valid if the entire string matches the pattern, from start
    /// to end. If the string does not match the pattern, the validation fails.
    ///
    /// The validation ensures that the `postalCode` adheres to the expected format defined in the regular expression, but the
    /// exact format is determined by the `Constants.postalCodeRegex` constant. This may include rules such as:
    /// - The length of the postal code (e.g., 5 digits or 6 characters).
    /// - Specific character formatting, such as the inclusion of letters, numbers, or special characters (e.g., a dash `-`).
    ///
    /// - Returns: A `ValidatorResults.PostalCode` object with a boolean flag `isValidPostalCode` indicating whether the
    ///   provided `postalCode` matches the expected format.
    public static var postalCode: Validator<T> {
        .init {
            // Check if the postalCode string fully matches the regular expression pattern from start to end
            guard
                let range = $0.range(of: Constants.postalCodeRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                // If it doesn't match, return an invalid postal code result
                return ValidatorResults.PostalCode(isValidPostalCode: false)
            }

            // If the postalCode matches the pattern, return a valid postal code result
            return ValidatorResults.PostalCode(isValidPostalCode: true)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `isoCountryCode` string.
    ///
    /// This validator checks whether the provided `isoCountryCode` matches a specific pattern defined by the regular expression
    /// `Constants.isoCountryCodeRegex`. The ISO country code is considered valid if the entire string matches the pattern, from start
    /// to end. If the string does not match the pattern, the validation fails.
    ///
    /// The validation ensures that the `isoCountryCode` adheres to the expected format defined in the regular expression, which
    /// typically includes:
    /// - A two-letter uppercase country code (e.g., `US`, `CA`, `FR`, `DE`).
    /// - The pattern follows the ISO 3166-1 standard for country codes.
    ///
    /// - Returns: A `ValidatorResults.IsoCountryCode` object with a boolean flag `isValidIsoCountryCode` indicating whether the
    ///   provided `isoCountryCode` matches the expected format.
    public static var isoCountryCode: Validator<T> {
        .init {
            // Check if the isoCountryCode string fully matches the regular expression pattern from start to end
            guard
                let range = $0.range(of: Constants.isoCountryCodeRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                // If it doesn't match, return an invalid ISO country code result
                return ValidatorResults.IsoCountryCode(isValidIsoCountryCode: false)
            }

            // If the isoCountryCode matches the pattern, return a valid ISO country code result
            return ValidatorResults.IsoCountryCode(isValidIsoCountryCode: true)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `password` string.
    ///
    /// This validator checks whether the provided `password` matches a specific pattern defined by the regular expression
    /// `Constants.passwordRegex`. The password is considered valid if the entire string matches the pattern, from start
    /// to end. If the string does not match the pattern, the validation fails.
    ///
    /// The validation ensures that the `password` adheres to the expected format defined in the regular expression, which
    /// may include common security rules such as:
    /// - Minimum and maximum length.
    /// - Inclusion of at least one uppercase letter.
    /// - Inclusion of at least one lowercase letter.
    /// - Inclusion of at least one number.
    /// - Inclusion of special characters (e.g., `!@#$%^&*()`).
    ///
    /// The exact requirements for the password format are determined by the `Constants.passwordRegex` regular expression,
    /// which is typically designed to ensure a secure password format.
    ///
    /// - Returns: A `ValidatorResults.Password` object with a boolean flag `isValidPassword` indicating whether the
    ///   provided `password` matches the expected format.
    public static var password: Validator<T> {
        .init {
            // Check if the password string fully matches the regular expression pattern from start to end
            guard
                let range = $0.range(of: Constants.passwordRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                // If it doesn't match, return an invalid password result
                return ValidatorResults.Password(isValidPassword: false)
            }

            // If the password matches the pattern, return a valid password result
            return ValidatorResults.Password(isValidPassword: true)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `companyName` string.
    ///
    /// This validator checks whether the provided `companyName` matches a specific pattern defined by the regular expression
    /// `Constants.companyNameRegex`. The company name is considered valid if the entire string matches the pattern, from start
    /// to end. If the string does not match the pattern, the validation fails.
    ///
    /// The validation ensures that the `companyName` adheres to the expected format defined in the regular expression, which
    /// may include common business name conventions such as:
    /// - The use of alphanumeric characters (e.g., letters and numbers).
    /// - The inclusion of spaces, hyphens, and possibly other special characters (e.g., `&`, `.`).
    /// - Length restrictions or prohibitions on special characters that may not be allowed in certain jurisdictions or business contexts.
    ///
    /// The exact rules for the company name format are determined by the `Constants.companyNameRegex` regular expression,
    /// which is typically tailored to enforce proper naming conventions for businesses or organizations.
    ///
    /// - Returns: A `ValidatorResults.CompanyName` object with a boolean flag `isValidCompanyName` indicating whether the
    ///   provided `companyName` matches the expected format.
    public static var companyName: Validator<T> {
        .init {
            // Check if the companyName string fully matches the regular expression pattern from start to end
            guard
                let range = $0.range(of: Constants.companyNameRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                // If it doesn't match, return an invalid company name result
                return ValidatorResults.CompanyName(isValidCompanyName: false)
            }

            // If the companyName matches the pattern, return a valid company name result
            return ValidatorResults.CompanyName(isValidCompanyName: true)
        }
    }

    /// A static property of type `Validator<T>` that validates a given `ukraineTin` (Taxpayer Identification Number) string.
    ///
    /// This validator checks whether the provided `ukraineTin` string is a valid Ukrainian TIN. The validation process ensures:
    /// - The TIN has exactly 10 digits.
    /// - The TIN consists of numeric characters only.
    /// - The TIN passes a checksum validation based on a specific algorithm used for TINs in Ukraine.
    ///
    /// The validation logic is based on the following rules:
    /// 1. The TIN must be exactly 10 digits long.
    /// 2. The digits are then checked using a checksum algorithm, where each digit in the TIN is multiplied by a predefined weight.
    /// 3. The checksum digit (the last digit of the TIN) is validated by ensuring it matches the result of the weighted sum modulo 11.
    ///
    /// - Returns: A `ValidatorResults.UkraineTin` object with a boolean flag `isValidUkraineTin` indicating whether the
    ///   provided `ukraineTin` passes the validation rules.
    public static var ukraineTin: Validator<T> {
        .init { ukraineTin in
            // Check if the TIN is exactly 10 digits long
            guard ukraineTin.count == 10 else {
                return ValidatorResults.UkraineTin(isValidUkraineTin: false)
            }

            // Check if the TIN consists of numeric characters
            guard Int(ukraineTin) != nil else {
                return ValidatorResults.UkraineTin(isValidUkraineTin: false)
            }

            // Convert each character of the TIN to an array of integers
            let tinArray = ukraineTin.compactMap { Int(String($0)) }

            // Checksum calculation using a specific algorithm
            let isValid = tinArray[9] == (
                (-1 * tinArray[0] +
                 5 * tinArray[1] +
                 7 * tinArray[2] +
                 9 * tinArray[3] +
                 4 * tinArray[4] +
                 6 * tinArray[5] +
                 10 * tinArray[6] +
                 5 * tinArray[7] +
                 7 * tinArray[8]) % 11
            )

            // Return the validation result
            return ValidatorResults.UkraineTin(isValidUkraineTin: isValid)
        }
    }
}

extension Validator where T == [String] {
    /// An extension of `Validator` where the type `T` is `[String]`, representing an array of strings.
    ///
    /// This validator checks whether each string in the array is a valid URL. It ensures that:
    /// 1. The array is not empty.
    /// 2. Each element in the array is a valid URL string.
    ///
    /// The validator checks the validity of each URL by attempting to create a `URL` object from each string in the array.
    /// If any of the strings is not a valid URL, the validation fails. If all strings are valid URLs, the validation succeeds.
    ///
    /// - Returns: A `ValidatorResults.ArrayUrls` object with a boolean flag `isValid` indicating whether the
    ///   provided array of strings contains only valid URLs.
    public static var arrayUrls: Validator<T> {
        .init {
            // Ensure the array is not empty
            guard !$0.isEmpty else {
                return ValidatorResults.ArrayUrls(isValid: false)
            }

            // Check if each string in the array is a valid URL
            for item in $0 {
                guard URL(string: item) != nil else {
                    return ValidatorResults.ArrayUrls(isValid: false)
                }
            }

            // If all URLs are valid, return a valid result
            return ValidatorResults.ArrayUrls(isValid: true)
        }
    }

}

extension ValidatorResults {
    /// A structure representing the validation result for a phone number.
    ///
    /// This struct holds a single boolean property `isValidPhoneNumber` that indicates whether a phone number is valid or not.
    /// A valid phone number is typically determined by a specific format or regex validation.
    ///
    /// - `isValidPhoneNumber`: `true` if the phone number is valid, `false` otherwise.
    public struct PhoneNumber {
        public let isValidPhoneNumber: Bool
    }

    /// A structure representing the validation result for a phone number code.
    ///
    /// This struct holds a single boolean property `isValidPhoneNumberCode` that indicates whether a phone number code (e.g., area code or country code) is valid or not.
    /// A valid phone number code is typically determined by matching the string against a specific regex pattern.
    ///
    /// - `isValidPhoneNumberCode`: `true` if the phone number code is valid, `false` otherwise.
    public struct PhoneNumberCode {
        public let isValidPhoneNumberCode: Bool
    }

    /// A structure representing the validation result for a name.
    ///
    /// This struct holds a single boolean property `isValidName` that indicates whether the name is valid or not.
    /// A valid name is typically determined by a specific format, such as allowing only letters, spaces, and possibly certain special characters.
    ///
    /// - `isValidName`: `true` if the name is valid, `false` otherwise.
    public struct Name {
        public let isValidName: Bool
    }

    /// A structure representing the validation result for a postal code.
    ///
    /// This struct holds a single boolean property `isValidPostalCode` that indicates whether the postal code is valid or not.
    /// A valid postal code is typically determined by matching the string against a specific regex pattern based on the country's postal code rules.
    ///
    /// - `isValidPostalCode`: `true` if the postal code is valid, `false` otherwise.
    public struct PostalCode {
        public let isValidPostalCode: Bool
    }

    /// A structure representing the validation result for a birthday.
    ///
    /// This struct holds a single boolean property `isValidBirthday` that indicates whether the birthday is valid or not.
    /// A valid birthday is typically determined by checking if the date is a valid date and if the user’s age is valid (e.g., the date is not in the future).
    ///
    /// - `isValidBirthday`: `true` if the birthday is valid, `false` otherwise.
    public struct Birthday {
        public let isValidBirthday: Bool
    }

    /// A structure representing the validation result for a generic date.
    ///
    /// This struct holds a single boolean property `isValidDate` that indicates whether the date is valid or not.
    /// A valid date is typically determined by checking if the format and values (e.g., day, month, year) are correct.
    ///
    /// - `isValidDate`: `true` if the date is valid, `false` otherwise.
    public struct Date {
        public let isValidDate: Bool
    }

    /// A structure representing the validation result for an ISO country code.
    ///
    /// This struct holds a single boolean property `isValidIsoCountryCode` that indicates whether the ISO country code is valid or not.
    /// A valid ISO country code is typically a 2-letter or 3-letter country code based on the ISO 3166-1 standard.
    ///
    /// - `isValidIsoCountryCode`: `true` if the ISO country code is valid, `false` otherwise.
    public struct IsoCountryCode {
        public let isValidIsoCountryCode: Bool
    }

    /// A structure representing the validation result for a password.
    ///
    /// This struct holds a single boolean property `isValidPassword` that indicates whether the password is valid or not.
    /// A valid password is typically determined by meeting specific criteria, such as length, character variety (uppercase, lowercase, numbers, special characters), etc.
    ///
    /// - `isValidPassword`: `true` if the password is valid, `false` otherwise.
    public struct Password {
        public let isValidPassword: Bool
    }

    /// A structure representing the validation result for a company name.
    ///
    /// This struct holds a single boolean property `isValidCompanyName` that indicates whether the company name is valid or not.
    /// A valid company name is typically determined by checking it against a specific pattern, such as allowed characters and length constraints.
    ///
    /// - `isValidCompanyName`: `true` if the company name is valid, `false` otherwise.
    public struct CompanyName {
        public let isValidCompanyName: Bool
    }

    /// A structure representing the validation result for a Ukrainian Taxpayer Identification Number (TIN).
    ///
    /// This struct holds a single boolean property `isValidUkraineTin` that indicates whether the Ukrainian TIN is valid or not.
    /// A valid Ukrainian TIN follows specific rules and a checksum validation algorithm.
    ///
    /// - `isValidUkraineTin`: `true` if the TIN is valid, `false` otherwise.
    public struct UkraineTin {
        public let isValidUkraineTin: Bool
    }

    /// A structure representing the validation result for a Ukrainian Company EDRPOU (Enterprise State Register Code).
    ///
    /// This struct holds a single boolean property `isValidUkraineCompanyEdrpou` that indicates whether the Ukrainian EDRPOU is valid or not.
    /// The validation is based on specific checksum rules for Ukrainian company EDRPOUs.
    ///
    /// - `isValidUkraineCompanyEdrpou`: `true` if the EDRPOU is valid, `false` otherwise.
    public struct UkraineCompanyEdrpou {
        public let isValidUkraineCompanyEdrpou: Bool
    }

    /// A structure representing the validation result for a service name.
    ///
    /// This struct holds a single boolean property `isValidServiceName` that indicates whether the service name is valid or not.
    /// A valid service name is typically determined by matching the string against a specific regex pattern, ensuring it conforms to naming conventions.
    ///
    /// - `isValidServiceName`: `true` if the service name is valid, `false` otherwise.
    public struct ServiceName {
        public let isValidServiceName: Bool
    }

    /// A structure representing the validation result for a URL.
    ///
    /// This struct holds a single boolean property `isValidUrl` that indicates whether the URL is valid or not.
    /// A valid URL is determined by attempting to create a `URL` object and checking its validity.
    ///
    /// - `isValidUrl`: `true` if the URL is valid, `false` otherwise.
    public struct Url {
        public let isValidUrl: Bool
    }

    /// A structure representing the validation result for an array of URLs.
    ///
    /// This struct holds a single boolean property `isValid` that indicates whether all URLs in the array are valid or not.
    /// It checks each string in the array to ensure it is a valid URL.
    ///
    /// - `isValid`: `true` if all URLs in the array are valid, `false` otherwise.
    public struct ArrayUrls {
        public let isValid: Bool
    }
}

/// Extension for `ValidatorResults.PhoneNumber` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a phone number.
///
/// - `isFailure`: Returns `true` if the phone number is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the phone number is valid.
///   - Example: `"is a valid phone number"`
/// - `failureDescription`: The description returned when the phone number is invalid.
///   - Example: `"is not a valid phone number"`
extension ValidatorResults.PhoneNumber: ValidatorResult {
    public var isFailure: Bool {
        !isValidPhoneNumber
    }

    public var successDescription: String? {
        "is a valid phone number"
    }

    public var failureDescription: String? {
        "is not a valid phone number"
    }
}

/// Extension for `ValidatorResults.PhoneNumberCode` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a phone number code.
///
/// - `isFailure`: Returns `true` if the phone number code is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the phone number code is valid.
///   - Example: `"is a valid phone code"`
/// - `failureDescription`: The description returned when the phone number code is invalid.
///   - Example: `"is not a valid phone code"`
extension ValidatorResults.PhoneNumberCode: ValidatorResult {
    public var isFailure: Bool {
        !isValidPhoneNumberCode
    }

    public var successDescription: String? {
        "is a valid phone code"
    }

    public var failureDescription: String? {
        "is not a valid phone code"
    }
}

/// Extension for `ValidatorResults.Name` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a name.
///
/// - `isFailure`: Returns `true` if the name is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the name is valid.
///   - Example: `"is a valid name"`
/// - `failureDescription`: The description returned when the name is invalid.
///   - Example: `"is not a valid name"`
extension ValidatorResults.Name: ValidatorResult {
    public var isFailure: Bool {
        !isValidName
    }

    public var successDescription: String? {
        "is a valid name"
    }

    public var failureDescription: String? {
        "is not a valid name"
    }
}

/// Extension for `ValidatorResults.PostalCode` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a postal code.
///
/// - `isFailure`: Returns `true` if the postal code is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the postal code is valid.
///   - Example: `"is a valid postal code"`
/// - `failureDescription`: The description returned when the postal code is invalid.
///   - Example: `"is not a valid postal code"`
extension ValidatorResults.PostalCode: ValidatorResult {
    public var isFailure: Bool {
        !isValidPostalCode
    }

    public var successDescription: String? {
        "is a valid postal code"
    }

    public var failureDescription: String? {
        "is not a valid postal code"
    }
}

/// Extension for `ValidatorResults.Birthday` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a birthday.
///
/// - `isFailure`: Returns `true` if the birthday is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the birthday is valid.
///   - Example: `"Birthday is valid"`
/// - `failureDescription`: The description returned when the birthday is invalid.
///   - Example: `"Birthday is invalid"`
extension ValidatorResults.Birthday: ValidatorResult {
    public var isFailure: Bool {
        !isValidBirthday
    }

    public var successDescription: String? {
        "Birthday is valid"
    }

    public var failureDescription: String? {
        "Birthday is invalid"
    }
}

/// Extension for `ValidatorResults.Date` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a date.
///
/// - `isFailure`: Returns `true` if the date is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the date is valid.
///   - Example: `"Date conversion success"`
/// - `failureDescription`: The description returned when the date is invalid.
///   - Example: `"Date conversion error"`
extension ValidatorResults.Date: ValidatorResult {
    public var isFailure: Bool {
        !isValidDate
    }

    public var successDescription: String? {
        "Date conversion success"
    }

    public var failureDescription: String? {
        "Date conversion error"
    }
}

/// Extension for `ValidatorResults.IsoCountryCode` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of an ISO country code.
///
/// - `isFailure`: Returns `true` if the ISO country code is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the ISO country code is valid.
///   - Example: `"ISO country code is valid"`
/// - `failureDescription`: The description returned when the ISO country code is invalid.
///   - Example: `"ISO country code is invalid"`
extension ValidatorResults.IsoCountryCode: ValidatorResult {
    public var isFailure: Bool {
        !isValidIsoCountryCode
    }

    public var successDescription: String? {
        "ISO country code is valid"
    }

    public var failureDescription: String? {
        "ISO country code is invalid"
    }
}

/// Extension for `ValidatorResults.Password` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a password.
///
/// - `isFailure`: Returns `true` if the password is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the password is valid.
///   - Example: `"is a valid password"`
/// - `failureDescription`: The description returned when the password is invalid.
///   - Example: `"is not a valid password"`
extension ValidatorResults.Password: ValidatorResult {
    public var isFailure: Bool {
        !isValidPassword
    }

    public var successDescription: String? {
        "is a valid password"
    }

    public var failureDescription: String? {
        "is not a valid password"
    }
}

/// Extension for `ValidatorResults.CompanyName` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a company name.
///
/// - `isFailure`: Returns `true` if the company name is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the company name is valid.
///   - Example: `"is a valid company name"`
/// - `failureDescription`: The description returned when the company name is invalid.
///   - Example: `"is not a valid company name"`
extension ValidatorResults.CompanyName: ValidatorResult {
    public var isFailure: Bool {
        !self.isValidCompanyName
    }

    public var successDescription: String? {
        "is a valid company name"
    }

    public var failureDescription: String? {
        "is not a valid company name"
    }
}

/// Extension for `ValidatorResults.UkraineTin` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a Ukrainian TIN.
///
/// - `isFailure`: Returns `true` if the Ukraine TIN is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the TIN is valid.
///   - Example: `"is a valid UkraineTin Tin"`
/// - `failureDescription`: The description returned when the TIN is invalid.
///   - Example: `"is not a valid UkraineTin Tin"`
extension ValidatorResults.UkraineTin: ValidatorResult {
    public var isFailure: Bool {
        !self.isValidUkraineTin
    }

    public var successDescription: String? {
        "is a valid UkraineTin Tin"
    }

    public var failureDescription: String? {
        "is not a valid UkraineTin Tin"
    }
}

/// Extension for `ValidatorResults.UkraineCompanyEdrpou` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a Ukrainian Company EDRPOU.
///
/// - `isFailure`: Returns `true` if the Ukraine Company EDRPOU is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the EDRPOU is valid.
///   - Example: `"is a valid Ukraine Company Edrpou"`
/// - `failureDescription`: The description returned when the EDRPOU is invalid.
///   - Example: `"is not
extension ValidatorResults.UkraineCompanyEdrpou: ValidatorResult {
    public var isFailure: Bool {
        !self.isValidUkraineCompanyEdrpou
    }

    public var successDescription: String? {
        "is a valid Ukraine Company Edrpou"
    }

    public var failureDescription: String? {
        "is not a valid Ukraine Company Edrpou"
    }
}

/// Extension for `ValidatorResults.ServiceName` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a service name.
///
/// - `isFailure`: Returns `true` if the service name is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the service name is valid.
///   - Example: `"is a valid service name"`
/// - `failureDescription`: The description returned when the service name is invalid.
///   - Example: `"is not a valid service name"`
extension ValidatorResults.ServiceName: ValidatorResult {
    public var isFailure: Bool {
        !isValidServiceName
    }

    public var successDescription: String? {
        "is a valid service name"
    }

    public var failureDescription: String? {
        "is not a valid service name"
    }
}

/// Extension for `ValidatorResults.Url` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of a URL.
///
/// - `isFailure`: Returns `true` if the URL is invalid, `false` if it is valid.
/// - `successDescription`: The description returned when the URL is valid.
///   - Example: `"is a valid url"`
/// - `failureDescription`: The description returned when the URL is invalid.
///   - Example: `"is not a valid url"`
extension ValidatorResults.Url: ValidatorResult {
    public var isFailure: Bool {
        !isValidUrl
    }

    public var successDescription: String? {
        "is a valid url"
    }

    public var failureDescription: String? {
        "is not a valid url"
    }
}

/// Extension for `ValidatorResults.ArrayUrls` that conforms to `ValidatorResult`.
///
/// This extension provides human-readable descriptions for the validation of an array of URLs.
///
/// - `isFailure`: Returns `true` if any URL in the array is invalid, `false` if all URLs are valid.
/// - `successDescription`: The description returned when all URLs in the array are valid.
///   - Example: `"has valid an URL"`
/// - `failureDescription`: The description returned when any URL in the array is invalid.
///   - Example: `"has not valid an URL"`
extension ValidatorResults.ArrayUrls: ValidatorResult {
    public var isFailure: Bool {
        !isValid
    }

    public var successDescription: String? {
        "has valid an URL"
    }

    public var failureDescription: String? {
        "has not valid an URL"
    }
}
