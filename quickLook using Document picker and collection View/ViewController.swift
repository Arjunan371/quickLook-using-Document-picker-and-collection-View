//
//  ViewController.swift
//  quickLook using Document picker and collection View
//
//  Created by Mohammed Abdullah on 19/07/23.
//
import AVFoundation
import MobileCoreServices
import QuickLook
import UIKit
struct fileItem{
    let fileUrl : URL
    let fileName : String
    let fileType : String
}
class ViewController: UIViewController,UIDocumentPickerDelegate {
    @IBOutlet weak var collection: UICollectionView!
    var array:[fileItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        let vc = UIDocumentPickerViewController(documentTypes: [String(kUTTypeContent)], in: .import)
        vc.delegate = self
        vc.allowsMultipleSelection = false
        present(vc, animated: true)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        guard let selectedUrl = urls.first else{
            print("No URL Selected")
            return
        }
        let fileNam = selectedUrl.deletingLastPathComponent().pathExtension
        let fileTyp = selectedUrl.pathExtension
        let fileItem = fileItem(fileUrl: selectedUrl, fileName: fileNam, fileType: fileTyp)
        array.append(fileItem)
        collection.reloadData()
    }
}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "one", for: indexPath) as! firstCollectionViewCell
        let fileExtension = array[indexPath.row].fileType.lowercased()
        cell.label1.text = array[indexPath.row].fileType
        switch fileExtension{
        case "jpg","jpeg","png":
            if let imageData = try? Data(contentsOf: array[indexPath.row].fileUrl),let image = UIImage(data: imageData){
                cell.imageView.image = image
            } else{
                cell.imageView.image = UIImage(systemName: "person.fill")
            }
        case "pdf":
            cell.imageView.image = UIImage(named: "pdf")
        case "mp3":
            cell.imageView.image = UIImage(named: "mp3")
        case "mp4","mov":
            if fileExtension == "mp4"{
                cell.imageView.image = UIImage(named: "mp4")
            } else if fileExtension == "mov"{
                cell.imageView.image = UIImage(named:"mov")
            } else{
                cell.imageView.image = UIImage(named: "Any")
            }
            
        default:
            cell.imageView.image = UIImage(systemName: "person")
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let yourWidth = collectionView.bounds.width/1.0
        let yourHeight = yourWidth
        //    let noOfCellsInRow = 2
        //
        //    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        //
        //    let totalSpace = flowLayout.sectionInset.left
        //        + flowLayout.sectionInset.right
        //        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        //
        //    let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        //
        //    return CGSize(width: size, height: size)
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = indexPath.row
        present(previewController, animated: true)
        let fileItem = array[indexPath.row].fileType.lowercased()
        switch fileItem{
        case "mp3":
            let player = AVPlayer(url: array[indexPath.row].fileUrl)
            player.play()
        case "mp4", "mov":
            toPlayVideo()
            print("success")
        default:
            print("failure")
        }
        func toPlayVideo(){
            let player = AVPlayer(url: array[indexPath.row].fileUrl)
            let playerLayer = AVPlayerLayer(player: player)
            //            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(playerLayer)
            player.play()
        }
        
    }
    
}

extension ViewController:QLPreviewControllerDataSource,QLPreviewControllerDelegate{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return array.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return array[index].fileUrl as QLPreviewItem
    }
    
    
}


