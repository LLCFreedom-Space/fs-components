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
//  ErrorResponse+Extensions.swift
//
//
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

extension ErrorResponse {
    public static var badRequest: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "400",
            status: "Bad request",
            code: "400.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var unauthorized: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "401",
            status: "Unauthorized",
            code: "401.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var forbidden: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "403",
            status: "Forbidden",
            code: "403.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var notFound: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "404",
            status: "Not Found",
            code: "404.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var notAcceptable: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "406",
            status: "Not Acceptable",
            code: "406.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var conflict: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "409",
            status: "Conflict",
            code: "409.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var gone: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "410",
            status: "Gone",
            code: "410.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var upgradeRequired: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "426",
            status: "Upgrade Required",
            code: "426.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var internalServerError: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "500",
            status: "Internal Server Error",
            code: "500.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var badGateway: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "502",
            status: "Bad Gateway",
            code: "502.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }

    public static var serviceUnavailable: ErrorResponse {
        ErrorResponse(
            isError: true,
            reason: "reason",
            error: "503",
            status: "Service Unavailable",
            code: "503.000.000",
            errorUri: "https://example.com/doc/errors"
        )
    }
}
