//
//  AnasayfaViewModel.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 15.03.2024.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    
    var yemekListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var anasayfaRepo = AnasayfaRepository()
    
    init() {
        self.yemekListesi = anasayfaRepo.yemekListesi
        yemekleriYukle()
    }
    
    func yemekleriYukle() {
        anasayfaRepo.yemekleriYukle()
    }
    
    func sepeteYemekEkle(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int,yemek_siparis_adet:Int, kullanici_adi:String){
        anasayfaRepo.sepeteYemekEkle(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
    }
    
    func yemekAra(aramaKelimesi:String, delegate:SearchDelegate) {
        anasayfaRepo.yemekAra(aramaKelimesi: aramaKelimesi, delegate: delegate)
    }
}
