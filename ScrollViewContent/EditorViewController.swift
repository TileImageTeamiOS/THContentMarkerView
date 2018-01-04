//
//  EditorViewController.swift
//  ScrollViewContent
//
//  Created by mac on 2018. 1. 4..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import FileExplorer

class EditorViewController: UIViewController {
    @IBOutlet weak var audioTitle: UILabel!
    let fileExplorer = FileExplorerViewController()
    var audio = true
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBOutlet weak var videoTitle: UILabel!
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fileExplorer.canChooseFiles = true //specify whether user is allowed to choose files
        fileExplorer.canChooseDirectories = false //specify whether user is allowed to choose directories
        fileExplorer.delegate = self as? FileExplorerViewControllerDelegate

        // Do any additional setup after loading the view.
    }
    public func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL]) {
        print(urls)
    }
    @IBAction func chooseAudio(_ sender: Any) {
        audio = true
        fileExplorer.fileFilters = [Filter.extension("mp3")]
        self.present(fileExplorer, animated: true, completion: nil)
    }
    @IBAction func chooseVideo(_ sender: Any) {
        audio = false
        fileExplorer.fileFilters = [Filter.extension("mp4"), Filter.extension("avi")]
        self.present(fileExplorer, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
