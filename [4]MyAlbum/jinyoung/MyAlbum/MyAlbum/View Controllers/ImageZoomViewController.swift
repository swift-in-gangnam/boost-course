//
//  ImageZoomViewController.swift
//  MyAlbum
//
//  Created by Jinyoung Kim on 2021/09/17.
//

import UIKit
import Photos

class ImageZoomViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var heartButton: UIBarButtonItem!
    
    var asset: PHAsset?
    var dateString: String!
    var timeString: String!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    lazy var titleStackView: UIStackView = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = self.dateString
        let subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .gray
        subtitleLabel.font = subtitleLabel.font.withSize(13)
        subtitleLabel.text = self.timeString
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        
        PHPhotoLibrary.shared().register(self)
        changeHeartButton()
        navigationItem.titleView = titleStackView
        
        guard let asset = asset else { return }
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil) { (image, _) in
            self.imageView.image = image
        }
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    @IBAction func trashImage(_ sender: Any) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets([self.asset] as NSFastEnumeration)
        } completionHandler: { (success, error) in
            if success {
                OperationQueue.main.addOperation {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func actionPopup(_ sender: Any) {
        var imageToShare: UIImage?
        guard let asset = asset else { return }
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil) { (image, _) in
            imageToShare = image
        }
        guard let image = imageToShare else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func selectHeartButton(_ sender: Any) {
        guard let asset = asset else { return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest(for: asset).isFavorite = !asset.isFavorite
        }, completionHandler: nil)
    }
}

// MARK: - Private Funcs
extension ImageZoomViewController {
    private func changeHeartButton() {
        guard let asset = asset else { return }
        if asset.isFavorite {
            self.heartButton.image = UIImage(systemName: "heart.fill")
        } else {
            self.heartButton.image = UIImage(systemName: "heart")
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImageZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension ImageZoomViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let asset = asset else { return }
        guard let changes = changeInstance.changeDetails(for: asset) else {
            return
        }

        self.asset = changes.objectAfterChanges
        
        OperationQueue.main.addOperation {
            self.changeHeartButton()
        }
    }
}
