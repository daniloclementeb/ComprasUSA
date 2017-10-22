//
//  TotalCompraViewController.swift
//  DaniloMeire
//
//  Created by macos on 14/10/17.
//  Copyright © 2017 fiap. All rights reserved.
//

import UIKit
import CoreData

class TotalCompraViewController: UIViewController {

    @IBOutlet weak var lbTotalUS: UILabel!
    @IBOutlet weak var lbTotalRS: UILabel!
    
    var totalUS : Double = 0
    var totalRS : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTotal()
    }
    
    func getTotal() {
        totalUS = 0
        totalRS = 0
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Compra", in: self.context)
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.context.fetch(fetchRequest)
            for element  in result {
                let compra = element as! Compra
                totalUS += compra.preco
                var dolar = 1.0
                if UserDefaults.standard.string(forKey: "cotacao_dolar") != nil {
                    dolar = Double(UserDefaults.standard.string(forKey: "cotacao_dolar")!)!
                }
                var iof = 1.0
                if UserDefaults.standard.string(forKey: "iof") != nil {
                    iof = Double(UserDefaults.standard.string(forKey: "iof")!)!
                }
                var valor = compra.preco * dolar
                valor += valor*(compra.estado?.imposto)!/100
                print("imposto estado: \(valor)")
                if compra.cartao {
                    valor += valor*iof/100
                    print("iof: \(valor)")
                }
                totalRS += valor
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        lbTotalUS.text = "\(totalUS)"
        lbTotalRS.text = "\(totalRS)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
