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
//  AuthenticationError.swift
//
//
//  Created by Mykola Buhaiov on 03.06.2024.
//

import Vapor
import ErrorMiddleware

/// A generic `AuthenticationError` data.
public enum AuthenticationError: AppError {
    /// The `AuthorizationError` not found bearer token
    case missingAuthorizationHeader

    case claimVerificationFailure

    /// Http response status of error
    public var status: HTTPResponseStatus {
        switch self {
        case .missingAuthorizationHeader:
            return .unauthorized

        case .claimVerificationFailure:
            return .forbidden
        }
    }

    /// Reason of error
    public var reason: String {
        switch self {
        case .missingAuthorizationHeader:
            return "Missing authorization header"

        case .claimVerificationFailure:
            return "Claim verification failure"
        }
    }

    /// Identifier of error
    public var identifier: String {
        switch self {
        case .missingAuthorizationHeader:
            return "missing_authorization_header"

        case .claimVerificationFailure:
            return "claim_verification_failure"
        }
    }

    public var number: String {
        switch self {
        case .missingAuthorizationHeader:
            return "0001"
        case .claimVerificationFailure:
            return "0002"
        }
    }
}
