//
//  TransectionData.swift
//  GurpreetTest
//
//  Created by Gurpreet Singh on 01/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import Foundation
import UIKit

enum ColumnsTypes: String {
    case date = "Date"
    case desc = "Description"
    case credit = "Credit"
    case debit = "Debit"
    case balance = "Running Balance"
}

enum RowTypes {
    case rootHeader, emptyRow, subHeader, dataRows
}

struct ColumnData {
    var name: String!
    var type: ColumnsTypes!
    var cellWidth: CGFloat!
}
