//
//  VMTransectionsgrid.swift
//  GurpreetTest
//
//  Created by Gurpreet Singh on 01/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import Foundation
import UIKit

class VMTransectionsgrid: NSObject {
    
    var arrTransections: [TransectionsRealmModel] = []
    private var colContentOffset = CGFloat()
    
    enum ScrollType{
        case collection, table
    }
    typealias SCROLL_COMPLETION = (_ position:CGFloat, _ type: ScrollType)->Void
    typealias ADD_COMPLETION = ()->Void
    
    var didScrollCompletion: SCROLL_COMPLETION?
    var didTapOnAdd: ADD_COMPLETION?
    
    func fetchLocalData(_ completion: @escaping ()->Void) {
        let arrObjects = uiRealm.objects(TransectionsRealmModel.self)
        self.arrTransections = Array(arrObjects).sorted(by: { (lhs, rhs) -> Bool in
            return lhs.created.timestampToDate() > rhs.created.timestampToDate()
        })
        
        completion()
    }
}

extension VMTransectionsgrid: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTransections.count+3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTableTransectionGrid") as! CellTableTransectionGrid
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.rowType = .rootHeader
        }else if indexPath.row == 1 {
            cell.rowType = .emptyRow
        }else if indexPath.row == 2 {
            cell.rowType = .subHeader
        }else{
            cell.rowType =  .dataRows
            let objAtIndex = self.arrTransections[indexPath.row-3]
            cell.objTransection = objAtIndex
        }
        
        
        
        cell.setupRowData()
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CellTableTransectionGrid") as! CellTableTransectionGrid
//        headerCell.delegate = self
//
//        if section == 0 {
//            headerCell.rowType = .rootHeader
//        }else if section == 1 {
//            headerCell.rowType = .emptyRow
//        }else if section == 2 {
//            headerCell.rowType = .subHeader
//        }
//
//        headerCell.setupRowData()
//
//        return headerCell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
}

// MARK:- Manage Cell Row Delegates

extension VMTransectionsgrid: CellRowTableDelegate {
    func scrollViewDragging(_ position: CGFloat, collectionView: UICollectionView) {
        colContentOffset = position

        if didScrollCompletion != nil{
            didScrollCompletion!(position, .collection)
        }
    }
    
    func tapOnAddTransectionAction() {
        if didTapOnAdd != nil {
            didTapOnAdd!()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if didScrollCompletion != nil{
            didScrollCompletion!(colContentOffset, .table)
        }
    }
}
