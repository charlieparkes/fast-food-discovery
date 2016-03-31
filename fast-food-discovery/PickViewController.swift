/*
 Copywrite Grove City College 2016
 Authored by Charlie Mathews & Sarah Burgess
*/


// example query for reference
// https://maps.googleapis.com/maps/api/place/textsearch/json?query=unique+fast+food+near+16127&key=AIzaSyDsTvS1RyzH7wVbYhqXGM276SWlnRU5-HA

// API documentation
// https://developers.google.com/places/web-service/search#RadarSearchRequests


import UIKit

class PickViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var placePicker: UIPickerView!

    let places = Places()
    var pickerData : [String] = []
    var watchList : [String] = ["types"]
    let options = NSKeyValueObservingOptions([.New, .Old])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placePicker.delegate = self
        self.placePicker.dataSource = self
        loadObservers()
        places.fetchTextSearch("fast+food", location: "16127")
    }

    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func loadObservers() {
        for w in watchList {
            NSLog("Adding observer for \"\(w)\".")
            places.addObserver(self, forKeyPath: w, options: options, context: nil)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        print("Value of \(keyPath) changed to \(change![NSKeyValueChangeNewKey]!)")
        
        pickerData = places.types
        placePicker.reloadAllComponents()
    }

    deinit {
        for w in watchList {
            places.removeObserver(self, forKeyPath: w, context: nil)
        }
    }

}

