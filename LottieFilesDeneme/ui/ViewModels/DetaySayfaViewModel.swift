//
//  DetaySayfaViewModel.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 16.03.2024.
//

import Foundation

class DetaySayfaViewModel {
    
    var repoNesnesi = AnasayfaRepository()
    
    func sepeteYemekEkle(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int,yemek_siparis_adet:Int, kullanici_adi:String) {
        
        repoNesnesi.sepeteYemekEkle(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
    }
}
