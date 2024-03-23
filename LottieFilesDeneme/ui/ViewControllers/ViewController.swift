//
//  ViewController.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 14.03.2024.
//

import UIKit
import Lottie
import RxSwift
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    var yemeklerListesi = [Yemekler]()
    var anasayfaViewModelNesnesi = AnasayfaViewModel()
    //private var animationView : LottieAnimationView?
    
    @IBOutlet weak var barButtonTrailing: UIBarButtonItem!
    @IBOutlet weak var searchBarAnasayfa: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        _ = anasayfaViewModelNesnesi.yemekListesi.subscribe(onNext: { liste in
            self.yemeklerListesi = liste
            DispatchQueue.main.async {
                self.collectionView.reloadData()
        }
    })
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBarAnasayfa.delegate = self

        let nibName = UINib(nibName: "Hucre", bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "collectionViewCell")
        
        
        //animasyon kodları
        /*var animationView : LottieAnimationView?
        animationView = .init(name: "Animation1")
        animationView!.frame = view.bounds
        
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.9
        view.addSubview(animationView!)
        animationView?.play()*/
        
        //Navigation Bar Arkaplan rengi ayarlama ve font ekleyip başlık atma kısmı
        tabBarController?.self.navigationItem.title = "Yemek Siparişim"
        let apperance = UINavigationBarAppearance()
        
        //bildirim trailing bar button item'i ekleme kısmı
        tabBarController?.navigationItem.rightBarButtonItem = barButtonTrailing
        
        apperance.backgroundColor = UIColor(named: "AnaRenk")
        apperance.titleTextAttributes = [.font : UIFont(name: "Allison-Regular", size: 35)!]
        
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        navigationController?.navigationBar.compactAppearance = apperance
        
        //collectionView Cell'e boyutunu verme kısmı
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik-30) / 2
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik*1.3)
        collectionView.collectionViewLayout = tasarim
        
    }
    
    //diğer sayfa olan Detay sayfaya ulaşıp perform segue ve prepare metodu ile veri gönderme kısmı
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetaySayfa" {
            if let yemek = sender as? Yemekler {
                let DetaySayfa = segue.destination as! DetaySayfa
                DetaySayfa.yemek = yemek
                
            }
        }
    }
}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,AnasayfaProtokol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        yemeklerListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! Hucre
        
        let yemek = yemeklerListesi[indexPath.row]
        
        //Animasyon Tanımlama ve LottieFile kütüphanesi ile animasyon ekleme kısmı
        var animationView : LottieAnimationView?
        
        animationView = .init(name: "Animation1")
        animationView!.frame = hucre.viewCell.bounds
        
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.9
        hucre.viewCell.addSubview(animationView!)
        animationView?.play()
        
        //collectionCell'in çevre çizgilerini belirginleştirme ve köşelerini ovalleştirme kısmı
        hucre.layer.borderColor = UIColor.lightGray.cgColor
        hucre.layer.borderWidth = 0.5
        hucre.layer.cornerRadius = 10
        
        
        //hucre icinde itemleri customize etme ve değer,resim, fiyat vs. atama
        hucre.labelFiyatSOn.text = "\(yemek.yemek_fiyat!) ₺"
        hucre.labelFiyatCell.text = yemek.yemek_adi
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") { DispatchQueue.main.async {
            hucre.imageViewCell.kf.setImage(with: url)
        }
            
            //hucre icindeki sepete Ekle(+) butonuna tıklanması için tanımlanan protokolü ekleme kısmı
            hucre.anasayfaProtokol = self
            hucre.indexPathX = indexPath
    }

        return hucre
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let yemek = yemeklerListesi[indexPath.row]
        
        performSegue(withIdentifier: "toDetaySayfa", sender: yemek)
    }
    
    //hucre icinde ki buton olan sepeteEkle butonunu Anasayfa da çalıştırma kısmı (protokol yardımı ile)
    func sepeteEkle(indexPath: IndexPath) {
        let yemek = yemeklerListesi[indexPath.row]
        self.anasayfaViewModelNesnesi.sepeteYemekEkle(yemek_adi: yemek.yemek_adi!, yemek_resim_adi: yemek.yemek_resim_adi!, yemek_fiyat: Int(yemek.yemek_fiyat!)!, yemek_siparis_adet: 1, kullanici_adi: "zcnzdmr")
    }
    
}

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.anasayfaViewModelNesnesi.yemekAra(aramaKelimesi: searchText, delegate: self)
    }
}

extension ViewController: SearchDelegate {
    func serch(yemekListesi: [Yemekler]) {
        yemeklerListesi = yemekListesi
        collectionView.reloadData()
    }
}

protocol SearchDelegate {
    func serch(yemekListesi:[Yemekler])
}
