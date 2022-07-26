//
//  KisiGuncelleViewController.swift
//  KisilerUygulamasi
//
//  Created by Kasım Adalan on 29.07.2019.
//  Copyright © 2019 info. All rights reserved.
//

import UIKit
import Firebase

class KisiGuncelleViewController: UIViewController {
    
    var ref:DatabaseReference!
    
    @IBOutlet weak var kisiAdTextfield: UITextField!
    
    @IBOutlet weak var kisiTelTextfield: UITextField!
    
    var kisi:Kisiler?
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        if let k = kisi {
            
            kisiAdTextfield.text = k.kisi_ad
            kisiTelTextfield.text = k.kisi_tel
        }
    }

    @IBAction func guncelle(_ sender: Any) {
        
        if let ad = kisiAdTextfield.text, let tel = kisiTelTextfield.text,let k = kisi {
            kisiGuncelle(kisi_id: k.kisi_id!, kisi_ad: ad, kisi_tel: tel)
        }

    }
    
    
    
    func kisiGuncelle(kisi_id:String,kisi_ad:String,kisi_tel:String) {
        
        let dict = ["kisi_ad":kisi_ad,"kisi_tel":kisi_tel]
        ref.child("kisiler").child(kisi_id).updateChildValues(dict)
    }
}
