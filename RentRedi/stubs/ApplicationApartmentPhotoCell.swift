//
//  ApplicationApartmentPhotoCell.swift
//  RentRedi
//
//  Created by James Folk on 9/19/22.
//

import Foundation
import UIKit

class ApplicationApartmentPhotoCell: UICollectionViewCell {
    let apartmentPhoto: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(apartmentPhoto)
        
        apartmentPhoto.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        apartmentPhoto.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        apartmentPhoto.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        apartmentPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
