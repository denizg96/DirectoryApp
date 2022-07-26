//
//  KisiEkleViewController.swift
//  KisilerUygulamasi
//
//  Created by Kasım Adalan on 29.07.2019.
//  Copyright © 2019 info. All rights reserved.
//

import UIKit
import Firebase

class KisiEkleViewController: UIViewController {
    
    var ref:DatabaseReference!

    @IBOutlet weak var kisiAdTextfield: UITextField!
    @IBOutlet weak var kisiTelTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }
    
    @IBAction func ekle(_ sender: Any) {
        
        if let ad = kisiAdTextfield.text, let tel = kisiTelTextfield.text {
            kisiEkle(kisi_ad: ad, kisi_tel: tel)
        }

    }
    
    func kisiEkle(kisi_ad:String,kisi_tel:String) {
        
        let dict = ["kisi_id":"","kisi_ad":kisi_ad,"kisi_tel":kisi_tel]
        let newRef = ref.child("kisiler").childByAutoId()
        newRef.setValue(dict)
        
    }

}
