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
    var markerDataSource: MarkerViewDataSource?
    
    @IBOutlet weak var audioTitle: UILabel!
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var videoTitle: UILabel!
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)

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
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        audioTitle.text = "파일을 선택해 주세요"
        audioPicker.dismiss(animated:true)
        audioPicker = nil
    }
    
}

extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoPath = info["UIImagePickerControllerMediaURL"] as! NSURL
        print(info)
        videoTitle.text = videoPath.lastPathComponent
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
        
        let markerView3 = MarkerView()
        markerView3.set(dataSource: markerDataSource!, x: 4000, y: 5000, zoomScale: 0.8, isAudioContent: false, isVideoContent: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        videoTitle.text = "파일을 선택해 주세요"
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
}


extension EditorViewController:  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
