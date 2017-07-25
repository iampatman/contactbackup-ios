//
//  ViewController.swift
//  ContactsBackup
//
//  Created by Nguyen Bui An Trung on 21/7/17.
//  Copyright © 2017 Nguyen Bui An Trung. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController {

	@IBOutlet weak var quantity: UILabel!
	private var viewModel: HomeViewModel?
	var contacts: [CNContact]?
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		checkPermission()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	@IBAction func loadClicked(){
		fetch()
	}
	
	
	func checkPermission(){
		let status = CNContactStore.authorizationStatus(for: .contacts)
		if status == .denied || status == .restricted || status == .notDetermined {
			presentSettingsActionSheet()
			return
		}
	}
	
	func fetch(){
		let keysToFech = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
		
		
		let store = CNContactStore()
		do {
			//self.contacts = try store.unifiedContacts(matching: CNContact.predicate, keysToFetch: keysToFech as [CNKeyDescriptor])
			let request = CNContactFetchRequest(keysToFetch: keysToFech as [CNKeyDescriptor])
			contacts = [CNContact]()
			try store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
				self.contacts?.append(contact)
			})
			self.quantity.text = "\(String(describing: self.contacts!.count)) contacts"
			self.contacts!.forEach { (contact) in
				print(contact.phoneNumbers.count)
			}
			print(self.contacts!.count)
			
		} catch is NSError {
			
		}

	}
	
	
	@IBAction func exportBtnClicked(){
		exportToCSV(contacts: self.contacts!)
	}
	
	func exportToCSV(contacts: [CNContact]){
		let filename = "contacts.csv"
		let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
		var csvText="Name,Given Name,Family Name,Phone 1 - Type,Phone 1 - Value"
		contacts.forEach { (contact) in
			//print(contact.phoneNumbers[0].value)
			
			if let number = contact.phoneNumbers.first?.value.stringValue {
				print(number)
				csvText.append("\n\(contact.givenName),\(contact.givenName),\(contact.familyName),Mobile,\(number)")
			}
		}
		do {
			try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
		} catch {
			print("Failed to create file")
			print("\(error)")
		}
		
		let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
		present(vc, animated: true, completion: nil)
	}
	
	func presentSettingsActionSheet() {
		let alertView = UIAlertController(title: "Permission to contact", message: "We need your permission to do dirty work for you", preferredStyle: .alert)
		
		alertView.addAction(UIAlertAction(title: "Go to Setting", style: .default, handler: { (_) in
			guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
				return
			}
			UIApplication.shared.open(URL(string:"App-Prefs:root=General")!, options: [:], completionHandler: nil)

//			if UIApplication.shared.canOpenURL(settingsUrl) {
//				UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//					print("Settings opened: \(success)") // Prints true
//				})
//			}

		}))
		alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		self.present(alertView, animated: true, completion: nil)
	}

}

