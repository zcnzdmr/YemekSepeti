//
//  SepetimViewModel.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 16.03.2024.
//

import Foundation
import RxSwift

class SepetimViewModel {
    
    var sepetYemekListesi = BehaviorSubject<[YemeklerSepette]>(value: [YemeklerSepette]())
    
    var anasayfaRepo = AnasayfaRepository()
    
    init() {
        sepetYemekListesi = anasayfaRepo.sepetYemekListesi
        sepeteYemekleriYukle()
    }
    
    func sepeteYemekleriYukle() {
        anasayfaRepo.sepeteYemekleriYukle()
    }
    func yemekSil(sepet_yemek_id:Int){
        anasayfaRepo.yemekSil(sepet_yemek_id: sepet_yemek_id)
    }
}
