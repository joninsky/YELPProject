//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit


class BusinessCell: UICollectionViewCell {
    // IMPLEMENT
    let businessImage: UIImageView = UIImageView(frame: .zero)
    
    let businessName: UILabel = UILabel(frame: .zero)
    
    var dataTask: URLSessionDataTask?
    
    //MARK: Init Oberrides
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepare()
    }
    
    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: Functions
    func marryBusiness(_ business: Business) {
        self.dataTask?.cancel()
        self.businessImage.image = nil
        if let firstPhoto = business.photos.first {
            self.dataTask = self.businessImage.imageFromUrl(urlString: firstPhoto)
        }
        
        self.businessName.text = business.name
    }
    
}


extension BusinessCell: UIKitCodePreparable {
    func prepare() {
        //Set up the image
        self.businessImage.translatesAutoresizingMaskIntoConstraints = false
        self.businessImage.backgroundColor = UIColor.lightGray
        self.businessImage.contentMode = .scaleAspectFill
        self.businessImage.clipsToBounds = true
        
        //Set up name
        self.businessName.translatesAutoresizingMaskIntoConstraints = false
        self.businessName.numberOfLines = 3
        self.businessName.lineBreakMode = .byWordWrapping
        
        
        //Set up self
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.businessImage)
        self.contentView.addSubview(self.businessName)
        
        self.constrain()
        
    }
    
    func constrain() {
        self.businessImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        self.businessImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        self.businessImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        
        self.businessName.topAnchor.constraint(equalTo: self.businessImage.bottomAnchor, constant: 0).isActive = true
        self.businessName.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -4).isActive = true
        self.businessName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        self.businessName.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 4).isActive = true
    }
}
