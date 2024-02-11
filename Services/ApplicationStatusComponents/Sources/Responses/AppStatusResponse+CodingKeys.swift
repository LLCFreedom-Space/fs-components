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
//  AppStatusResponse+CodingKeys.swift
//  
//
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

extension AppStatusResponse {
    public enum CodingKeys: String, CodingKey {
        case appStatus = "app_status"
        case systemUptime = "system_uptime"
        case activeProcessorCount = "active_processor_count"
        case operatingSystemVersion = "operating_system_version"
        case physicalMemory = "physical_memory"
        case redisConnectionStatus = "redis_connection_status"
        case psqlConnectionStatus = "psql_connection_status"
        case mongoConnectionStatus = "mongo_connection_status"
        case redisVersion = "redis_version"
        case psqlVersion = "psql_version"
        case mongoVersion = "mongo_version"
        case appName = "app_name"
        case appVersion = "app_version"
    }
}
