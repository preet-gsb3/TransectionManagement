//
//  VCTransectionsGrid.swift
//  GurpreetTest
//
//  Created by Gurpreet Singh on 01/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import UIKit

class VCTransectionsGrid: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var objViewModel = VMTransectionsgrid()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.delegate = objViewModel
        self.tblView.dataSource = objViewModel
        
        objViewModel.fetchLocalData {
            self.tblView.reloadData()
        }
        
        objViewModel.didTapOnAdd = {
            let vc = self.storyboard?.instantiateViewController(identifier: "VCAddTransection") as! VCAddTransection
            vc.completion = {
                // Update Table with updated data
                self.objViewModel.fetchLocalData {
                    self.tblView.reloadData()
                }
            }
            
            let navigation = UINavigationController(rootViewController: vc)
            navigation.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true, completion: nil)
        }
        
        objViewModel.didScrollCompletion = {
            (position, scrollType) in
            
            if scrollType == .collection {
                if let colView = self.tblView.viewWithTag(999) as? UICollectionView {
                    (colView as UIScrollView).contentOffset.x = position
                }
            }
            
            for cell in self.tblView.visibleCells as! [CellTableTransectionGrid] {
                (cell.vwCollection as UIScrollView).contentOffset.x = position
            }
        }
        
    }


}

