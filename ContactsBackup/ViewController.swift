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
	private var viewModel = HomeViewModel()
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.fetchingContactsCallback = updateLabelFetchingCallback
		viewModel.exportingContactsCallback = exportToCSVCallback
		
	}
	
	override func viewDidAppear(_ animated: Bool) {

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	@IBAction func loadClicked(){
		viewModel.fetchContactsList()
	}
	
	
	func updateLabelFetchingCallback(numberOfContact: Int){
		self.quantity.text = "\(String(describing: numberOfContact)) contacts"

	}

	
	
	@IBAction func exportBtnClicked(){

		viewModel.exportToCSV()
	}
	
	func exportToCSVCallback(path: URL){
		let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
		present(vc, animated: true, completion: nil)
	}
	
	
}

