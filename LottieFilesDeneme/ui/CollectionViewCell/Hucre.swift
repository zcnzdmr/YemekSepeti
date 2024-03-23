//
//  Hucre.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 15.03.2024.
//

import UIKit
import Lottie

protocol AnasayfaProtokol {
    func sepeteEkle(indexPath:IndexPath)
}

class Hucre: UICollectionViewCell {
    
    var anasayfaProtokol : AnasayfaProtokol?
    var indexPathX: IndexPath?
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var labelFiyatCell: UILabel!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var labelFiyatSOn: UILabel!
    
    @IBOutlet weak var labelIsımCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buttonSepeteEkleSon(_ sender: Any) {
        anasayfaProtokol?.sepeteEkle(indexPath: indexPathX!)
    }
}
