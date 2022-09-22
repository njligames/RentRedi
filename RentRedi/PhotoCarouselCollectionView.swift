//
//  PhotoCarouselCollectionView.swift
//  RentRedi
//
//  Created by James Folk on 9/21/22.
//

import UIKit

@IBDesignable
class PhotoCarouselCollectionView: UIView {
    
    private let apartmentPhotoReuseIdentifier = "apartmentPhotoCell"
    var applicationPhotosUrls = [URL]()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var applicationPopupPhotos: UICollectionView!
    @IBOutlet weak var applicationPhotoDots: UIPageControl!
    @IBOutlet weak var applicationPopupPageNumber: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        populateApplicationPhotosUrls()
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("PhotoCarouselCollectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        //set the collection delegate and datasource of the photos to self(update collection view when Apartment Popup view data updates)
        applicationPopupPhotos.delegate = self
        applicationPopupPhotos.dataSource = self
        applicationPopupPhotos.register(ApplicationApartmentPhotoCell.self, forCellWithReuseIdentifier: apartmentPhotoReuseIdentifier)
        
        applicationPopupPageNumber.text = "\(0 + 1) of \(applicationPhotosUrls.count)"
    }
    
    func appendPhotoUrl(_ downloadURL:URL){
        self.applicationPhotosUrls.append(downloadURL)
    }
    func numberOfPhotos()->Int {
        return self.applicationPhotosUrls.count
    }
    func clearPhotos() {
        self.applicationPhotosUrls = []
    }

}

extension PhotoCarouselCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate func populateApplicationPhotosUrls() {
        applicationPhotosUrls = [
            "https://live.staticflickr.com/65535/52373981181_9786fb1582_m.jpg",
            "https://live.staticflickr.com/65535/52373039512_16bc89ae04_m.jpg",
            "https://live.staticflickr.com/65535/52374297929_af1fb435d7_m.jpg",
            "https://live.staticflickr.com/65535/52373844363_22ce0494f9_m.jpg",
            "https://live.staticflickr.com/65535/52373766618_9d3e033912_m.jpg",
            "https://live.staticflickr.com/31337/52372534902_edf1d0c091_m.jpg",
            "https://live.staticflickr.com/65535/52373060370_ebab65edd7_m.jpg",
            "https://live.staticflickr.com/65535/52372112236_d27f232877_m.jpg",
            "https://live.staticflickr.com/65535/52372470425_8dac3b01d3_m.jpg",
            "https://live.staticflickr.com/65535/52372203879_224943edff_m.jpg",
            "https://live.staticflickr.com/65535/52372156484_a3b92b5d37_m.jpg",
            "https://live.staticflickr.com/65535/52371605184_e3d4dabbba_m.jpg",
            "https://live.staticflickr.com/65535/52370630178_7c1d7f3e41_m.jpg",
            "https://live.staticflickr.com/65535/52370510958_f7914c7233_m.jpg",
            "https://live.staticflickr.com/65535/52369931278_67924f4f51_m.jpg",
            "https://live.staticflickr.com/65535/52369419840_8fa55f9fe1_m.jpg",
            "https://live.staticflickr.com/65535/52368950124_19c43e535c_m.jpg",
            "https://live.staticflickr.com/65535/52367696687_08ec14cb37_m.jpg",
            "https://live.staticflickr.com/65535/52367029857_26d63aa6f4_m.jpg",
            "https://live.staticflickr.com/65535/52367501083_d5d463a146_m.jpg"
            
        ].compactMap { URL(string: $0) }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //if the scrollview is application popup photos (no other scrollview is available)
        if scrollView == applicationPopupPhotos {
            //get page number of cell in view
            let pageNumber = Int((applicationPopupPhotos.contentOffset.x / applicationPopupPhotos.frame.width).rounded(.toNearestOrAwayFromZero))
            applicationPhotoDots.currentPage = pageNumber
            // set page number
            applicationPopupPageNumber.text = "\(pageNumber + 1) of \(applicationPhotosUrls.count)"

        }
    }
    // Set size of collection view items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //if the collection view is application popup photos (no other collection view is available)
        if collectionView == applicationPopupPhotos {
            // Set up CollectionView
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            //Set size of collection view item to size of collectionView to take entire space
            return CGSize(width: width, height: height)
        }
        //Set default size
        return CGSize(width: 0, height: 0)
    }
    // Determine how many sections there are in collectionView, in this case 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //application popup photos has 1 section
        return 1
    }
    // Determine how many items there are in collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if the collection view is application popup photos (no other collection view is available)
        if collectionView == applicationPopupPhotos {
            //set the number of items equal to the number of photos
            applicationPhotoDots.numberOfPages = applicationPhotosUrls.count
            return applicationPhotosUrls.count
        }
        return 0
    }
    // Determine what kind of cell is in collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //if the collection view is application popup photos (no other collection view is available)
        if collectionView == applicationPopupPhotos {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: apartmentPhotoReuseIdentifier, for: indexPath) as! ApplicationApartmentPhotoCell

            let url = applicationPhotosUrls[indexPath.row]
            //if there is a photo that can be decoded from the data of the url
            let data = try? Data(contentsOf: url)
            //set imageview photo to corresponding apartment photo
            if let imageData = data {
                cell.apartmentPhoto.image = UIImage(data: imageData)
                //move the cell the the front of user's screen
                cell.bringSubviewToFront(cell.apartmentPhoto)
            }

            // Configure the cell
            return cell
        }
        //return application apartment photo cell
        return collectionView.dequeueReusableCell(withReuseIdentifier: apartmentPhotoReuseIdentifier, for: indexPath) as! ApplicationApartmentPhotoCell
    }

    //When a collection view item is clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //do nothing because we dont need anything to be done when an apartment photo is clicked
        return
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.applicationPopupPhotos.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.applicationPopupPhotos.scrollToNearestVisibleCollectionViewCell()
        }
    }
}

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
