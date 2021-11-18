import Foundation
import UIKit
import SKPhotoBrowser


//MARK:--  COLLECTION DATA SOURCE(S) -- 
extension OrderDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objVM.orderDetailData?.post_images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CellIdentifers.postImagesCollectionCell, for: indexPath) as? PostImagesCollectionCell
        cell?.postImageView.setSdWebImage(url: objVM.orderDetailData?.post_images?[indexPath.row] ?? "")
        return cell ?? UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = [SKPhotoProtocol]()
        for i in 0 ..< (objVM.orderDetailData?.post_images?.count ?? 0)  {
            let image = objVM.orderDetailData?.post_images?[i]
            let photo = SKPhoto.photoWithImageURL("\(WebServicesApi.imageBaseUrl)\(image ?? "")")
            photo.shouldCachePhotoURLImage = true
            images.append(photo)
        }
        displayZoomImages(imageArray: images, index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return   .init(width: (self.view.frame.width), height: 300)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionViewPost {
            let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
            let index = scrollView.contentOffset.x / witdh
            let roundedIndex = round(index)
            self.pageControl?.currentPage = Int(roundedIndex)
        }
    }
}


