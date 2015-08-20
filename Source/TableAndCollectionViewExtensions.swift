//
//  TableAndCollectionViewExtensions.swift
//  DameJidlo
//
//  Created by Petr Šíma on Aug/20/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

extension UITableViewCell{
	class var cellIdentifier : String {
		return NSStringFromClass(self)
	}
}
extension UICollectionViewCell{
	class var cellIdentifier : String {
		return NSStringFromClass(self)
	}
}

extension UITableView {
	func dequeCellForIndexPath<T where T : UITableViewCell>(indexPath: NSIndexPath) -> T {
		registerClass(T.classForCoder(), forCellReuseIdentifier: T.cellIdentifier)
		return dequeueReusableCellWithIdentifier(T.cellIdentifier, forIndexPath: indexPath) as! T
	}
}

extension UICollectionView {
	func dequeCellForIndexPath<T where T : UICollectionViewCell>(indexPath: NSIndexPath) -> T {
		registerClass(T.classForCoder(), forCellWithReuseIdentifier: T.cellIdentifier)
		return dequeueReusableCellWithIdentifier(T.cellIdentifier, forIndexPath: indexPath) as! T
	}
}