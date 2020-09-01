//
//  CellTransectionGrid.swift
//  GurpreetTest
//
//  Created by Gurpreet Singh on 01/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import Foundation
import UIKit

class CellCollectionTransectionGrid: UICollectionViewCell {
    @IBOutlet weak var lblValue: UILabel!
}


class CellTableTransectionGrid: UITableViewCell {
    @IBOutlet weak var vwCollection: UICollectionView!

    var objTransection: TransectionsRealmModel!
    var rowType: RowTypes!
    var delegate: CellRowTableDelegate!
    var isLastRow = false
    
    private var arrColumnTitle: [ColumnData] = [
        ColumnData(name: ColumnsTypes.date.rawValue, type: .date, cellWidth: 150),
        ColumnData(name: ColumnsTypes.desc.rawValue, type: .desc, cellWidth: 200),
        ColumnData(name: ColumnsTypes.credit.rawValue, type: .credit, cellWidth: 80),
        ColumnData(name: ColumnsTypes.debit.rawValue, type: .debit, cellWidth: 80),
        ColumnData(name: ColumnsTypes.balance.rawValue, type: .balance, cellWidth: 150),
    ]
    
    func setupRowData() {
        self.vwCollection.delegate = self
        self.vwCollection.dataSource = self
        self.vwCollection.reloadData()
    }
    
}

// MARK: - Protocol Delegate For Scroll On Grid

protocol CellRowTableDelegate {
    func scrollViewDragging(_ position: CGFloat, collectionView: UICollectionView)
    func tapOnAddTransectionAction()
}

// MARK: - CollectionView Delegate & DataSource

extension CellTableTransectionGrid: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrColumnTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollectionTransectionGrid", for: indexPath) as! CellCollectionTransectionGrid
        cell.backgroundColor = .white
        
        let objAtIndex = self.arrColumnTitle[indexPath.row]
        
        switch rowType {
        case .rootHeader:
            
            cell.lblValue.font = UIFont.boldSystemFont(ofSize: 14)
            cell.lblValue.textColor = .black
            
            if indexPath.row == 0 {
                cell.lblValue.text = "Office Transactions"
            }else if indexPath.row == self.arrColumnTitle.count-1 {
                cell.lblValue.text = "+ Add Transaction"
                
                // Add Action On Add Transection Label
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnAddTransection))
                cell.lblValue.isUserInteractionEnabled = true
                tapGesture.numberOfTouchesRequired = 1
                tapGesture.numberOfTapsRequired = 1
                cell.lblValue.addGestureRecognizer(tapGesture)
                
            }else{
                cell.lblValue.text = ""
            }
            
        case .emptyRow:
            cell.lblValue.text = ""
            
        case .subHeader:
            cell.lblValue.text = objAtIndex.name
            cell.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            cell.lblValue.font = UIFont.boldSystemFont(ofSize: 14)
            cell.lblValue.textColor = .white
        case .dataRows:
            
            cell.lblValue.font = UIFont.systemFont(ofSize: 14)
            cell.lblValue.textColor = .black
            cell.lblValue.textAlignment = .center
            
            // Manage transections Data
            switch objAtIndex.type {
            case .date:
                let date = objTransection.created.timestampToDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/YYYY"
                cell.lblValue.text = dateFormatter.string(from: date)
              
            case .desc:
                cell.lblValue.text = objTransection.desc
                cell.lblValue.textAlignment = .left
                
            case .credit:
                if objTransection.type.lowercased() == "credit" {
                    cell.lblValue.text = objTransection.amount
                }else{
                    cell.lblValue.text = "-"
                }
                
            case .debit:
                if objTransection.type.lowercased() == "debit" {
                    cell.lblValue.text = objTransection.amount
                }else{
                    cell.lblValue.text = "-"
                }
                
            case .balance:
                cell.lblValue.text = objTransection.runningBalance
            
            case .none:
                break
            }
            
        case .none:
            break
        }
        
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(vwCollection), scrollView.isDragging {
            delegate.scrollViewDragging(scrollView.contentOffset.x, collectionView: self.vwCollection)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let objAtIndex = arrColumnTitle[indexPath.row]
        return CGSize.init(width: objAtIndex.cellWidth, height: 44)
    }
    
    // MARK:- Add Action
    
    @objc func tapOnAddTransection() {
        delegate.tapOnAddTransectionAction()
    }
    
    
}



