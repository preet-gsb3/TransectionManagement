//
//  TransectionsRealmModel.swift
//  GurpreetTest
//
//  Created by Gurpreet Singh on 01/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import Foundation
import RealmSwift

class TransectionsRealmModel: Object {

    @objc dynamic var runningBalance: String = ""
    @objc dynamic var amount: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var created: String = ""

    override static func primaryKey() -> String? {
        return "created"
    }

}
