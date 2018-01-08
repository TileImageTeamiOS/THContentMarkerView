//
//  EditorViewController.swift
//  ScrollViewContent
//
//  Created by mac on 2018. 1. 4..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import MediaPlayer

class EditorViewController: UIViewController {
    
    var imagePicker: UIImagePickerController!
    var audioPicker: MPMediaPickerController!
    var videoPath = NSURL()
    var x: Double = 0
    var y: Double = 0
    var zoom: Double = 1
    var isAudio = false
    var isVideo = false
    
    @IBOutlet weak var audioTitle: UILabel!
    
    
    @IBOutlet weak var markerTitle: UITextField!
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var videoTitle: UILabel!
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        let markerDict:[String: Any] = ["x":x,"y":y,"zoomScale":zoom,"isAudioContent":isAudio,"isVideoContent":isVideo,"videoURL":videoPath, "title":markerTitle.text ?? ""]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "makeMarker"), object: nil, userInfo: markerDict)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func chooseAudio(_ sender: Any) {
        audioPicker = MPMediaPickerController(mediaTypes: MPMediaType.music)
        audioPicker.delegate = self
        audioPicker.allowsPickingMultipleItems = false
        present(audioPicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseVideo(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.movie"]
        
        present(imagePicker, animated: true, completion: nil)
        
    }
   
}
extension EditorViewController: MPMediaPickerControllerDelegate {
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        audioTitle.text = mediaItemCollection.items.first?.title
        audioPicker.dismiss(animated:true)
        audioPicker = nil
        isAudio = true
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        audioTitle.text = "파일을 선택해 주세요"
        isAudio = false
        audioPicker.dismiss(animated:true)
        audioPicker = nil
    }
    
}

extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        videoPath = info["UIImagePickerControllerMediaURL"] as! NSURL
        
        videoTitle.text = videoPath.lastPathComponent
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
        isVideo = true
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        videoTitle.text = "파일을 선택해 주세요"
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
        isVideo = false
    }
}

extension EditorViewController:  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
