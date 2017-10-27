//
//  Options.swift
//  GotToGo
//
//  Created by HSI on 10/26/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

class Options: UIViewController, MFMailComposeViewControllerDelegate {


    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

    @IBAction func emailPressed(_ sender: Any) {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["publicrelations@hscottindustries.com"])
        mailVC.setSubject("Got To Go Issues")
        mailVC.setMessageBody("Please Describe Issue", isHTML: false)
        present(mailVC, animated: true, completion: nil)

    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }


    @IBAction func questionPage(_ sender: Any) {
        let url = URL(string: "https://www.hscottindustries.com/got-to-go")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Opened Page")
            })

        }
    }

}
