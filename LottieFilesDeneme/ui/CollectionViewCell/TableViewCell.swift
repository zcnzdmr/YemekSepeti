//
//  TableViewCell.swift
//  LottieFilesDeneme
//
//  Created by Özcan Özdemir on 17.03.2024.
//

import UIKit

protocol sepetimProtokol {
    func silCopKutusu(indexPath:IndexPath)
}

class TableViewCell: UITableViewCell {
    
    var sepetimProtokolNesnesi : sepetimProtokol?
    var indexPathY : IndexPath?
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelYemekAdi: UILabel!
    @IBOutlet weak var labelYemekAdedi: UILabel!
    @IBOutlet weak var labelYemekFiyati: UILabel!
    @IBOutlet weak var labelFiyat: UILabel!
    @IBOutlet weak var imageViewTableCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonSepettenSil(_ sender: Any) {
        sepetimProtokolNesnesi?.silCopKutusu(indexPath: indexPathY!)
    }
    
}
