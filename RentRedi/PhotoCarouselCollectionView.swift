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
        var applicationPhotoModel: ImageModel?
        
        if let data = MockNetworkManager.getImageUrls() {
            applicationPhotoModel = try? JSONDecoder().decode(ImageModel.self, from: data)
        }
        
        guard let thePhotoModel = applicationPhotoModel else {
            return
            
        }
        
        applicationPhotosUrls = thePhotoModel.imageUrls.compactMap { URL(string: $0) }
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
