//
//  Sepetim.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 16.03.2024.
//

import UIKit
import Alamofire
import Kingfisher
import RxSwift

class Sepetim: UIViewController {
    
    var sepetYemekListesi = [YemeklerSepette]()
    
    var sepetimViewModelNesnesi = SepetimViewModel()
    
    @IBOutlet weak var tableViewSepetim: UITableView!
    @IBOutlet weak var labelToplamFiyat: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableViewSepetim.delegate = self
        tableViewSepetim.dataSource = self
        
        
        _ = sepetimViewModelNesnesi.sepetYemekListesi.subscribe(onNext: { liste in
            self.sepetYemekListesi = liste
            DispatchQueue.main.async {
                self.tableViewSepetim.reloadData()
            }})
        
        tabBarItemBadgeDegeri()
        toplamFiyatFonk()
    }
    
    @IBAction func buttonSepetiOnayla(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sepetimViewModelNesnesi.sepeteYemekleriYukle()
        toplamFiyatFonk()
        tabBarItemBadgeDegeri()
        
        tabBarController?.self.navigationItem.title = "Sepetim"
    }
    
    //sepetteki ürünlerin fiyatını sayıları ile çarpıp toplam fiyatı label'a aktarma kısmı
    func toplamFiyatFonk() {
        var toplam = 0
        for i in sepetYemekListesi {
            if let yemekFiyati = Int(i.yemek_fiyat!),
               let yemekAdet = Int(i.yemek_siparis_adet!) {
                let urunFiyat = yemekFiyati * yemekAdet
                toplam += urunFiyat
            }
            labelToplamFiyat.text = "Toplam :                                                 \(toplam) ₺"
        }
    }
    
    func tabBarItemBadgeDegeri() {
        
        if let tabItems = tabBarController?.tabBar.items {
            let sepetimTabBarItem = tabItems[3]
            sepetimTabBarItem.badgeValue = String(sepetYemekListesi.count)
        }
    }
    
}

extension Sepetim : UITableViewDelegate,UITableViewDataSource, sepetimProtokol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetYemekListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let yemek = sepetYemekListesi[indexPath.row]
        
        hucre.labelYemekAdi.text = yemek.yemek_adi
        hucre.labelYemekFiyati.text = "Fiyat :  \(yemek.yemek_fiyat!) ₺"
        
        if let yemekFiyati = Int(yemek.yemek_fiyat!), let yemekAdet = Int(yemek.yemek_siparis_adet!) {
            let toplamFiyat = yemekFiyati * yemekAdet
            hucre.labelFiyat.text = "\(toplamFiyat)"
            //self.labelToplamFiyat.text = "Toplam :                                                 \(toplamFiyat) ₺"
        }
        
        hucre.labelYemekAdedi.text = "Adet :  \(yemek.yemek_siparis_adet!)"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") { DispatchQueue.main.async {
            hucre.imageViewTableCell.kf.setImage(with: url)
        }
        }
        //tablecell icinde ki silme butonu protokol tanıtma ve indexPath gönderme kısmı
        hucre.sepetimProtokolNesnesi = self
        hucre.indexPathY = indexPath
        
        return hucre
    }
    //sepetten yemek çıkarma kısmı daha sonra butona aktarılacak çöp kovası butouna
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){ contextualAction,view,bool in
            
            let yemek = self.sepetYemekListesi[indexPath.row]
            
            let alert = UIAlertController(title: "Silme İşlemi", message: "\(yemek.yemek_adi!) silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let silAction = UIAlertAction(title: "Sil", style: .destructive) { action in
                //                self.sepetimViewModelNesnesi.yemekSil(sepet_yemek_id: Int(yemek.sepet_yemek_id!)!)
                
                //                DispatchQueue.main.async{
                //                    self.sepetimViewModelNesnesi.sepeteYemekleriYukle()
                //                    self.toplamFiyatFonk()
                //                }
                self.silCopKutusu(indexPath: indexPath)
            }
            alert.addAction(silAction)
            
            self.present(alert, animated: true)
            
        }
        return UISwipeActionsConfiguration(actions: [silAction])
    }
    
    //tablecell icinde ki silme butonu kısmı
    func silCopKutusu(indexPath: IndexPath) {
        let yemek = sepetYemekListesi[indexPath.row]
        self.sepetimViewModelNesnesi.yemekSil(sepet_yemek_id: Int(yemek.sepet_yemek_id!)!)
        self.sepetimViewModelNesnesi.sepeteYemekleriYukle()
        toplamFiyatFonk()
    }
    
}
