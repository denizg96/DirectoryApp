//
//  ViewController.swift
//  Kisiler Uygulamasi Tasarim
//
//  Created by Deniz Gülbahar on 22.04.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var kisilerTableView: UITableView!
    
    var ref:DatabaseReference!
    
    var liste = [Kisiler]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ref = Database.database().reference()
        
        kisilerTableView.delegate = self
        kisilerTableView.dataSource = self
        
        searchBar.delegate = self
        
        tumKisileriAl()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "toGuncelle" {
            
            let indeks = sender as? Int
            let gidilecekCV = segue.destination as! KisiGuncelleViewController
            gidilecekCV.kisi = liste[indeks!]
        }
        
        if segue.identifier == "toDetay" {
            
            let indeks = sender as? Int
            let gidilecekCV = segue.destination as! KisiDetayViewController
            gidilecekCV.kisi = liste[indeks!]
        }
        
    }

    
    func tumKisileriAl() {
        
        ref.child("kisiler").observe(.value, with: { snapshot in
            
            if let gelenVeriButunu = snapshot.value as? [String:AnyObject] {
                
                self.liste.removeAll()
                
                for satirVerisi in gelenVeriButunu {
                    
                    if let sozluk = satirVerisi.value as? NSDictionary {
                        
                        let key = satirVerisi.key
                        let kisi_ad = sozluk["kisi_ad"] as? String ?? ""
                        let kisi_tel = sozluk["kisi_tel"] as? String ?? ""
                        let kisi = Kisiler(kisi_id: key, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                        self.liste.append(kisi)
                    }
                }
                
                DispatchQueue.main.async {
                    self.kisilerTableView.reloadData()
                }
                
            } else {
                self.liste = [Kisiler]()
            }
            
            
        })
    }

    
    func aramaYap (aramaKelimesi:String) {
        
        ref.child("kisiler").observe(.value, with: { snapshot in
            
            if let gelenVeriButunu = snapshot.value as? [String:AnyObject] {
                
                self.liste.removeAll()
                
                for satirVerisi in gelenVeriButunu {
                    
                    if let sozluk = satirVerisi.value as? NSDictionary {
                        
                        let key = satirVerisi.key
                        let kisi_ad = sozluk["kisi_ad"] as? String ?? ""
                        let kisi_tel = sozluk["kisi_tel"] as? String ?? ""
                        
                        if kisi_ad.contains(aramaKelimesi) {
                            
                            let kisi = Kisiler(kisi_id: key, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                            
                            self.liste.append(kisi)
                            
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.kisilerTableView.reloadData()
                }
                
                
            } else {
                self.liste = [Kisiler]()
            }
            
        })
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liste.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kisiHucre", for: indexPath) as! KisiHucreTableViewCell
        
        let kisi = liste[indexPath.row]
        
        cell.kisiYaziLabel.text = " \(kisi.kisi_ad!) - \(kisi.kisi_tel!)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetay", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil") {  (contextualAction, view, boolValue) in
            
             let kisi = self.liste[indexPath.row]
             
             self.ref.child("kisiler").child(kisi.kisi_id!).removeValue()
        }
        
        let guncelleAction = UIContextualAction(style: .normal, title: "Güncelle") {  (contextualAction, view, boolValue) in
            
             self.performSegue(withIdentifier: "toGuncelle", sender: indexPath.row)
        }

        return UISwipeActionsConfiguration(actions: [silAction,guncelleAction])
    }
}

extension ViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama sonuç : \(searchText)")
        if searchText == "" {
            tumKisileriAl()
        }
        else {
            aramaYap(aramaKelimesi: searchText)
        }
        
    }

}
