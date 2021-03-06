//
//  GADetailsViewController.swift
//  GeographicalApp
//
//  Created by Shimaa Magdi on 2/10/18.
//  Copyright © 2018 Shimaa Magdi. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
/**
 *  GA Details View Controller contains locations details.
 */
class GADetailsViewController: GABaseController, MFMailComposeViewControllerDelegate {
    var modelObject: GALocationViewModel!
    var email = "shimaa.magdi@yahoo.com"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func phonePressed(_ sender: UIButton) {
        Utils.makeAPhoneCall(phoneNumber: modelObject.phone)
    }
    
    @IBAction func emailPressed(_ sender: UIButton) {
        sendEmail()
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    // MARK: - Methods
    
    // MARK: - Init
    
    /**
     Initialize an instance of Details ViewController
     - returns: GADetailsViewController Object
     */
    public static func create() -> GADetailsViewController {
        return UIStoryboard(name: StoryboardIdentifier.mainStoryboardIdentifier, bundle: Bundle.main).instantiateViewController(withIdentifier: StoryboardIdentifier.detailsVCIdentifier)as! GADetailsViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openUrl" {
            let webVC: GAWebViewController = segue.destination as! GAWebViewController
            webVC.urlStr = modelObject.url
        }
    }
    
    /**
     Customize Cell With Model displays details for each location data model.
     - Parameter locationDataModel: GALocationViewModel contains DMlocation details.
     */
    func setUpView() {
        mapView.dropCardShadow()
        nameLabel.text = modelObject.name
        addressLabel.text = modelObject.address
        typeLabel.text = modelObject.type
        addReginWithAnnotation(coordinate: modelObject.coordinate)
    }
    
    /**
     Adding annotation displays DM location on cell map.
     - Parameter location: CLLocation for the DM location.
     */
    func addReginWithAnnotation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
        mapView.setRegion(region, animated: true)
        let point = MKPointAnnotation()
        point.coordinate = coordinate
        self.mapView.addAnnotation(point)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("emailBody".localized, isHTML: true)
            present(mail, animated: true)
        } else {
            showMessage(message: "emailError".localized)
        }
    }
}

typealias emailDelegate = GADetailsViewController
extension emailDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
