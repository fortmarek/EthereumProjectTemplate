//
//  UserDefaultsExtensions.swift
//  ProjectSkeleton
//
//  Created by Борис Анисимов on 22.12.16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation

extension UserDefaults {
	private enum Keys {
		static let deviceIdKey = "ud_device_id"
	}
	
	var deviceId: String {
		if let result = string(forKey: Keys.deviceIdKey) {
			return result
		}
		
		let newDeviceId = NSUUID().uuidString
		
		set(newDeviceId, forKey: Keys.deviceIdKey)
		synchronize()
		
		return newDeviceId
	}
	
}
