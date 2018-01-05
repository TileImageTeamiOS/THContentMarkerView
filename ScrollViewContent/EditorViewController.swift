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
        print("did pick")
        audioPicker.dismiss(animated:true)
        audioPicker = nil
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        audioPicker.dismiss(animated:true)
        audioPicker = nil
    }
    
}

extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoPath: NSURL = info["UIImagePickerControllerReferenceURL"] as! NSURL
        
        videoTitle.text = videoPath.lastPathComponent
        
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
}
