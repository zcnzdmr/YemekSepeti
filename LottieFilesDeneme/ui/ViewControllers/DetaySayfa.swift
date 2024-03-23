//
//  DetaySayfa.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 16.03.2024.
//

import UIKit
import Cosmos
import TinyConstraints
import Kingfisher

class DetaySayfa: UIViewController {
    
    var yemek : Yemekler?
    var detayViewModel = DetaySayfaViewModel()
    
    
    
    @IBOutlet weak var labelAdetTek: UILabel!
    @IBOutlet weak var stackView3LabelDetay: UIStackView!
    
    @IBOutlet weak var stepperOutletDetay: UIStepper!
    @IBOutlet weak var labelToplamFiyatDetay: UILabel!
    @IBOutlet weak var labelDakikaDetay: UILabel!
    @IBOutlet weak var labelYuzdeIndırımDetay: UILabel!
    @IBOutlet weak var labelUcretsizTeslimatDetay: UILabel!
    @IBOutlet weak var labelAdetGrinizDetay: UILabel!
    @IBOutlet weak var imageViewDetay: UIImageView!
    
    @IBOutlet weak var labelTekFiyatDetay: UILabel!
    @IBOutlet weak var labelYemekAdiDetay: UILabel!
    
    //cosmos kütüphanesinden rating starları oluşturma kısmı
    lazy var cosmosView : CosmosView = {
        var view = CosmosView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Ürün Detayı"
        
        labelToplamFiyatDetay.text = "Toplam : \(yemek!.yemek_fiyat!)"
        
        //rating yıldızlarını ekrana ekleme konum verme kısmı
        view.addSubview(cosmosView)
        //cosmosView.centerInSuperview()
        cosmosView.center(in: view, offset: CGPoint(x: 0, y: -280))
        
        if let y = yemek {
            if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(y.yemek_resim_adi!)") { DispatchQueue.main.async {
                self.imageViewDetay.kf.setImage(with: url)
            }
        }
            //label'ların açılış değerlerini verme kısmı
            labelTekFiyatDetay.text = "\(y.yemek_fiyat!) ₺"
            labelYemekAdiDetay.text = y.yemek_adi
            labelToplamFiyatDetay.text = "Toplam : \(y.yemek_fiyat!) ₺"
        }
        
        //labellar etrafına border ekleme ovalleştirme ve renklendirme kısmı
        labelDakikaDetay.layer.cornerRadius = 10
        labelDakikaDetay.layer.borderWidth = 0.3
        labelDakikaDetay.layer.borderColor = UIColor.systemBlue.cgColor
        labelDakikaDetay.text = " 25-30 dk "
        
        labelYuzdeIndırımDetay.layer.cornerRadius = 10
        labelYuzdeIndırımDetay.layer.borderWidth = 0.3
        labelYuzdeIndırımDetay.text = " %10 İndirim  "
        labelYuzdeIndırımDetay.layer.borderColor = UIColor.systemBlue.cgColor
        
        labelUcretsizTeslimatDetay.layer.cornerRadius = 10
        labelUcretsizTeslimatDetay.layer.borderWidth = 0.3
        labelUcretsizTeslimatDetay.text = " Ücretsiz Teslimat   "
        labelUcretsizTeslimatDetay.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    
    @IBAction func buttonSepeteEkleDetay(_ sender: Any) {
        
        if let xYemek_adi = yemek?.yemek_adi ,
           let xYemek_resim_adi = yemek?.yemek_resim_adi,
           let xYemek_fiyat = yemek?.yemek_fiyat,
           let xYemek_siparis_adet = Int(labelAdetGrinizDetay.text!) {
            
                
            detayViewModel.sepeteYemekEkle(yemek_adi: xYemek_adi, yemek_resim_adi: xYemek_resim_adi, yemek_fiyat: Int(xYemek_fiyat)! , yemek_siparis_adet: xYemek_siparis_adet, kullanici_adi: "zcnzdmr")
            
            
        }
    }
    
    // stepper ile adet belirtme ve adete göre toplam fiyatı hesaplayıp atama kısmı
    @IBAction func stepperActionDetay(_ sender: UIStepper) {
        labelAdetGrinizDetay.text = "\(Int(sender.value))"
        let senderNumber = Int(sender.value)
        if let k = yemek {
            let yFiyat = Int(k.yemek_fiyat!)
            let toplamFiyat = senderNumber * yFiyat!
            labelToplamFiyatDetay.text = "Toplam : \(toplamFiyat) ₺"
        }
    }
    
}
