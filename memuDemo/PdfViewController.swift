//
//  PdfViewController.swift
//  memuDemo
//
//  Created by Timur on 1/18/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import PDFKit
class PdfViewController: UIViewController {

    var pdfView = PDFView()
    var pdfUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPdf(self)
        self.title = "Квитанция"
        view.addSubview(pdfView)
        if #available(iOS 10.0, *) {
            do {
//                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let docURL = try FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(Requests.pdfFileName)") {
                        print(url)
                        if let document = PDFDocument(url: pdfUrl) {
                            pdfView.document = document
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        
        
        // Do any additional setup after loading the view.
    }
}
    override func viewDidLayoutSubviews() {
        pdfView.frame = view.frame
    }
    
    @IBAction func closePdfView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPdf(_ sender: Any) {
        let pdfViewController = PdfViewController()
        pdfViewController.pdfUrl = self.pdfUrl
        present(pdfViewController, animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

