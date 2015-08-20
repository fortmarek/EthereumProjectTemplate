//
//  FoundationExtensions.swift
//  ProjectName
//
//  Created by Petr Šíma on Aug/20/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation

extension String { //credit Sam nebo JM poperte se ;)
	var localized : String {
		return NSLocalizedString(self, comment: "")
	}
}