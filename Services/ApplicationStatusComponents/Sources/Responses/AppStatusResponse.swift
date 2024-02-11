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
//  AppStatusResponse.swift
//
//
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

/// A generic `Application` status data that can be sent in response.
public struct AppStatusResponse: Content {
    /// Representable the App is work
    public var appStatus: String = "Ok"
    /// Representable app uptime in TimeInterval
    public var systemUptime: TimeInterval
    /// Server active Processor Count
    public var activeProcessorCount: Int
    /// Server Operating System
    public var operatingSystemVersion: String
    /// Physical Memory in Server
    public var physicalMemory: Double
    /// Representable Redis connection status
    public var redisConnectionStatus: String?
    /// Representable Redis version
    public var redisVersion: String?
    /// Representable PostgreSQL connection status
    public var psqlConnectionStatus: String?
    /// Representable PostgreSQL version
    public var psqlVersion: String?
    /// Representable MongoDB connection status
    public var mongoConnectionStatus: String?
    /// Representable MongoDB version
    public var mongoVersion: String?
    /// Representable Application name
    public var appName: String?
    /// Representable Application version
    public var appVersion: String?

    public init(
        appStatus: String = "Ok",
        systemUptime: TimeInterval,
        activeProcessorCount: Int,
        operatingSystemVersion: String,
        physicalMemory: Double,
        redisConnectionStatus: String? = nil,
        psqlConnectionStatus: String? = nil,
        mongoConnectionStatus: String? = nil,
        redisVersion: String? = nil,
        psqlVersion: String? = nil,
        mongoVersion: String? = nil,
        appName: String? = nil,
        appVersion: String? = nil
    ) {
        self.appStatus = appStatus
        self.systemUptime = systemUptime
        self.activeProcessorCount = activeProcessorCount
        self.operatingSystemVersion = operatingSystemVersion
        self.physicalMemory = physicalMemory
        self.redisConnectionStatus = redisConnectionStatus
        self.psqlConnectionStatus = psqlConnectionStatus
        self.mongoConnectionStatus = mongoConnectionStatus
        self.redisVersion = redisVersion
        self.psqlVersion = psqlVersion
        self.mongoVersion = mongoVersion
        self.appName = appName
        self.appVersion = appVersion
    }

    public static var example: AppStatusResponse {
        AppStatusResponse(
            appStatus: "Ok",
            systemUptime: 123456,
            activeProcessorCount: 12,
            operatingSystemVersion: "12.1",
            physicalMemory: 12,
            redisConnectionStatus: "Ok",
            psqlConnectionStatus: "Ok",
            mongoConnectionStatus: "Ok",
            redisVersion: "12",
            psqlVersion: "12.9",
            mongoVersion: "20.2",
            appName: "Name of application",
            appVersion: "1.1.1"
        )
    }
}
