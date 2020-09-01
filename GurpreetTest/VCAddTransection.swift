//
//  VCAddTransection.swift
//  GurpreetTest
//
//  Created by Gurpreet Singh on 01/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import UIKit
import DropDown

class VCAddTransection: UIViewController {

    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var tfDescription: UITextView!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var btnCloseOutlet: UIButton!
    
    typealias COMPLETION = ()->Void
    var completion: COMPLETION?
    
    private let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize Close Button
        btnCloseOutlet.layer.cornerRadius = btnCloseOutlet.bounds.midX
        btnCloseOutlet.clipsToBounds = true
        
        // Setup Drop Down Default Values
        dropDown.dataSource = ["Credit", "Debit"]
        dropDown.selectRow(0)
    }
    
   @IBAction func btnDropDown(sender: UIButton) {
        dropDown.hide()
        dropDown.anchorView = sender

        dropDown.selectionAction = { (index: Int, item: String) in
            self.tfType.text = item
        }
        dropDown.show()
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        let validationAlert = self.validateForm()
        
        if validationAlert == nil {
            // Save Item to Local Database
            
            let transectionModel = TransectionsRealmModel()
            transectionModel.type = tfType.text!
            let timestamp = Date().toTimeStamp()
            transectionModel.created = timestamp
            transectionModel.desc = tfDescription.text!
            transectionModel.amount = tfAmount.text!
            RealmManager.shared.save(transectionModel)
            
            
            // Update Running balance
            
            let objDatabase = uiRealm.objects(TransectionsRealmModel.self).filter({$0.created == timestamp})
            if let dataAtIndex = objDatabase.first {
                
                do{
                    try uiRealm.safeWrite {
                        dataAtIndex.runningBalance = "\(self.calculateRunningBalance())"
                    }
                }catch{
                    print(error)
                }
                
            }
            
            AlertManager.shared.showPopup(GPAlert(title: "", message: "Transection added Successfully"), forTime: 3.0) { (_) in
                if self.completion != nil {
                    self.completion!()
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            AlertManager.shared.show(validationAlert!)
        }
        
    }
    
    private func calculateRunningBalance() -> Int64{
        
        let arrTotalData = uiRealm.objects(TransectionsRealmModel.self).filter({$0.type.lowercased() == "credit"})
        var totalBalance: Int64 = 0
        for data in arrTotalData {
            let amount = Int64(data.amount) ?? 0
            totalBalance = totalBalance + amount
        }
        
        let arrDebitData = uiRealm.objects(TransectionsRealmModel.self).filter({$0.type.lowercased() == "debit"})
        var debitBalance: Int64 = 0
        for data in arrDebitData {
            let amount = Int64(data.amount) ?? 0
            debitBalance = debitBalance + amount
        }
        
        return totalBalance-debitBalance
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        tfType.text = ""
        tfDescription.text = ""
        tfAmount.text = ""
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func validateForm() -> GPAlert? {
        var alert: GPAlert?
        
        if tfType.text!.isEmpty {
            alert = GPAlert(title: "Transection Type", message: "Please select Transection Type")
        }else if tfAmount.text!.isEmpty {
            alert = GPAlert(title: "Amount", message: "Please enter an Amount")
        }else if !tfAmount.text!.isValidNumber {
            alert = GPAlert(title: "Amount", message: "Please enter valid Amount")
        }else if tfDescription.text!.isEmpty {
            alert = GPAlert(title: "Description", message: "Please enter Description")
        }
        
        return alert
    }
    
}
