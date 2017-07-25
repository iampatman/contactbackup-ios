//
//  HomeViewModel.swift
//  ContactsBackup
//
//  Created by Nguyen Bui An Trung on 24/7/17.
//  Copyright © 2017 Nguyen Bui An Trung. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

class HomeViewModel {
	
	var fetchingContactsCallback: ((Int) -> Void)?
	var exportingContactsCallback: ((URL) -> Void)?

	var contacts = [CNContact]()

	init() {
		
	}
	
	func fetchContactsList(){
		let keysToFech = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]

		
		let store = CNContactStore()
		do {

			let request = CNContactFetchRequest(keysToFetch: keysToFech as [CNKeyDescriptor])
			try store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
				self.contacts.append(contact)
			})
			fetchingContactsCallback!(self.contacts.count)
			//self.quantity.text = "\(String(describing: self.contacts!.count)) contacts"
			self.contacts.forEach { (contact) in
				print(contact.phoneNumbers.count)
			}
			print(self.contacts.count)
			
		} catch is NSError {
			print("Cant fetch contacts")
		}
		
	}
	
	
	
	func exportToCSV(){

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
			exportingContactsCallback!(path!)
		} catch {
			print("Failed to create file")
			print("\(error)")
		}
		
	}
	
}
