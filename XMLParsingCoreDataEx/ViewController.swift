import UIKit
import CoreData
    
class ViewController: UIViewController, NSXMLParserDelegate
    {
        @IBOutlet var tbData : UITableView?
    
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        var parser = NSXMLParser()
        var posts = NSMutableArray()
        var elements = NSMutableDictionary()
        var element = NSString()
        
        var title1 = NSMutableString()
        var date = NSMutableString()
        var link =  NSMutableString()
        var guid =  NSMutableString()
        var descript =  NSMutableString()
    
        var itemcount:Int = 0
    
        override func viewDidLoad()
        {
            super.viewDidLoad()
            
            self.beginParsing()
        }
        
        override func didReceiveMemoryWarning()
        {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func beginParsing()
        {
            posts = []
            parser = NSXMLParser(contentsOfURL:(NSURL(string:"http://www.espncricinfo.com/rss/content/story/feeds/6.xml"))!)!
            parser.delegate = self
            parser.parse()
            
            tbData!.reloadData()
        }
        
        //XMLParser Methods
        
        func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
        {
            element = elementName
            if (elementName as NSString).isEqualToString("item")
            {
                elements = NSMutableDictionary()
                elements = [:]
                title1 = NSMutableString()
                title1 = ""
                date = NSMutableString()
                date = ""
                link = NSMutableString()
                link = ""
                guid = NSMutableString()
                guid = ""
                descript = NSMutableString()
                descript = ""
                
            }
        }
        
        func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
        {
            let entityDescription = NSEntityDescription.entityForName("Item",inManagedObjectContext: managedObjectContext)

            if (elementName as NSString).isEqualToString("item") {
                
                let item = Item(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)

                if !title1.isEqual(nil) {
                    
                    item.title=title1 as String
                 //  elements.setObject(title1, forKey: "title")
                }
                if !date.isEqual(nil) {
                    item.pubdate=date as String
                   // elements.setObject(date, forKey: "date")
                }
                
                if !descript.isEqual(nil) {
                    item.descript=descript as String
                    //elements.setObject(descript, forKey: "description")
                }
                if !link.isEqual(nil) {
                    item.link=link as String
                   // elements.setObject(link, forKey: "link")
                }
                if !guid.isEqual(nil) {
                    item.guid=guid as String
                    //elements.setObject(guid, forKey: "guid")
                }
                
                itemcount=itemcount+1
                
                do {
                    try managedObjectContext.save()
                    
                } catch{
                    print("Error)")
                
                   
                }
                //posts.addObject(elements)
            }
        }
        
        func parser(parser: NSXMLParser, foundCharacters string: String)
        {
            if element.isEqualToString("title") {
                title1.appendString(string)
            }
            else if element.isEqualToString("pubDate") {
                date.appendString(string)
                
            }
            else if element.isEqualToString("description") {
                descript.appendString(string)
                
            }
            else if element.isEqualToString("link") {
                link.appendString(string)
                
            }
            else if element.isEqualToString("guid") {
                guid.appendString(string)
            }
            
            
        }
        
        //Tableview Methods
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            let request = NSFetchRequest()
            let entityDescription = NSEntityDescription.entityForName("Item",inManagedObjectContext: managedObjectContext)

            request.entity = entityDescription
            var objects  = [AnyObject]()
            
            do {
                 objects =  try managedObjectContext.executeFetchRequest(request)
                
                
            } catch {
                
            }
           return objects.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        {
            
            let entityDescription = NSEntityDescription.entityForName("Item",inManagedObjectContext: managedObjectContext)
            
            let request = NSFetchRequest()
            request.entity = entityDescription
            
            let cell:XMLData=tableView.dequeueReusableCellWithIdentifier("Cell") as! XMLData
            
            if indexPath.row % 2==0
            {
                cell.backgroundColor=UIColor.grayColor()
            }
            else
            {
                cell.backgroundColor=UIColor.clearColor()
            }
            
         
            do {
                let objects = try managedObjectContext.executeFetchRequest(request)
                
                if let results = objects as? AnyObject
                {
                    
                    if results.count > 0
                    {
                        let match = results[indexPath.row] as! NSManagedObject
                        
                        cell.title.text = match.valueForKey("title") as? String
                        cell.descript.text = match.valueForKey("descript") as? String
                        cell.link.text = match.valueForKey("link") as? String
                        cell.date.text = match.valueForKey("pubdate") as? String
                        cell.guid.text = match.valueForKey("guid") as? String
                    }
                    else
                    {
                        print("Not Found")
                    }
                }

            } catch {}
            return cell
    }
}


