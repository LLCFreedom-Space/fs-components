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
//  HostsError.swift
//  
//
//  Created by Mykola Buhaiov on 10.05.2024.
//

import Vapor

public enum HostError: AbortError, DebuggableError {
    case notAcceptable
    case unauthorizedAccessAttempt(ipAddress: String)

    public var status: HTTPResponseStatus {
        switch self {
        case .notAcceptable:
            return .notAcceptable
        case .unauthorizedAccessAttempt:
            return .notAcceptable
        }
    }

    public var reason: String {
        switch self {
        case .notAcceptable:
            return "No identifiable ip address"
        case .unauthorizedAccessAttempt:
            return "Unauthorized access attempt"
        }
    }

    public var identifier: String {
        switch self {
        case .notAcceptable:
            return "no_identifiable_ip_address"
        case .unauthorizedAccessAttempt:
            return "unauthorized_access_attempt"
        }
    }

    var number: String {
        switch self {
        case .notAcceptable:
            return "0001"
        case .unauthorizedAccessAttempt:
            return "0002"
        }
    }
}
