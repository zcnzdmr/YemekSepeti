//
//  AnasayfaRepository.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 16.03.2024.
//

import Foundation
import RxSwift
import Kingfisher
import Alamofire

class AnasayfaRepository {
    
    var asdas = [Yemekler]()
    var yemekListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    var sepetYemekListesi = BehaviorSubject<[YemeklerSepette]>(value: [YemeklerSepette]())
    
    func yemekleriYukle() {
        
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(CrudeCevap.self, from: data)
                    if let liste = cevap.yemekler {
                        self.asdas = liste
                        self.yemekListesi.onNext(liste)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sepeteYemekEkle(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int,yemek_siparis_adet:Int, kullanici_adi:String){
        
        let params:Parameters = ["yemek_adi":yemek_adi, "yemek_resim_adi":yemek_resim_adi, "yemek_fiyat" : yemek_fiyat, "yemek_siparis_adet" : yemek_siparis_adet, "kullanici_adi":kullanici_adi]
        
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response{ response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(SepeteYemekEklemeCrudeCevap.self,from: data)
                    print(cevap.success!)
                    print(cevap.message!)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sepeteYemekleriYukle() {
        
        let params:Parameters = ["kullanici_adi":"zcnzdmr"]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method:  .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(SepetYemekleriGetirCrude.self, from: data)
                    if let listex = cevap.sepet_yemekler {
                        
                        self.sepetYemekListesi.onNext(listex)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func yemekSil(sepet_yemek_id:Int){
        let params:Parameters = ["sepet_yemek_id":sepet_yemek_id,"kullanici_adi":"zcnzdmr"]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php",method:  .post, parameters: params).response { response in
            if let data  = response.data {
                do{
                    let cevap = try JSONDecoder().decode(SepeteYemekEklemeCrudeCevap.self, from: data)
                    print(cevap.success!)
                    print(cevap.message!)
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func yemekAra(aramaKelimesi: String, delegate:SearchDelegate) {
        if aramaKelimesi.isEmpty {
            delegate.serch(yemekListesi: asdas)
        }else{
            let filtrelenmisYemekler = asdas.filter { yemek in
                // Eğer yemek adı nil değilse ve arama kelimesini içeriyorsa true döndür
                if let isim = yemek.yemek_adi {
                    return isim.contains(aramaKelimesi)
                } else {
                    return false // Eğer yemek adı nil ise, false döndür
                }
            }
            
            delegate.serch(yemekListesi: filtrelenmisYemekler)
        }
    }

}
