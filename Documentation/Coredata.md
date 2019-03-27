# Coredata

## Coredata for Persistence

Coredata is used for persistence of the chat history. Coredata is supposedly the best way to store data in Apple eco-system. There is a direct iCloud, spotlight etc. integration which can be further leveraged.

## Files:

MessageKit.xcdatamodelId file defines the relationship between coredata entities.
There is a coredata wrapper file for each of ChatSender, ChatMessage and ChatMessageKind original structures / enum model files. This wrapper objects retain the contents of respective structure and enum model values but only act as an interface or a medium to store the data into persistence layer. When a coredata object is created from the persistence layer the corresponding struct or enum will be created back using respective setters and getters.

## Usage:

### Creating an user (Loading existing user if it already exists):

```Swift
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatSender")
        var anUser:ChatSender?
        request.predicate = NSPredicate(format: "senderID != %@", "001")    // 001 is the ID of the current user!! So, we try to first sender here for demo purpose who is not me!
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                anUser = data as? ChatSender
                break
            }
        } catch {
            print("Failed")
        }
        
        if (anUser == nil) {
            let entity = NSEntityDescription.entity(forEntityName: "ChatSender", in: context)
            anUser = NSManagedObject(entity: entity!, insertInto: context) as? ChatSender
            anUser?.senderID = "007"
            anUser?.displayName = "Bot"
            /*do {
             try context.save()
             } catch {
             print("Failed saving")
             }*/
        }
```

### Creating ChatMessageKind and ChatMessage 

```Swift
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ChatMessage", in: context)
                let message = NSManagedObject(entity: entity!, insertInto: context) as? ChatMessage
                message?.chatMessageID = UUID().uuidString
                message?.chatMessageSentDate = Date() as NSDate
                let mk:MessageKind = MessageKind.text(str)
                let mkEntity = NSEntityDescription.entity(forEntityName: "ChatMessageKind", in: context)
                let messageKindManagedObject:ChatMessageKind = NSManagedObject (entity: mkEntity!, insertInto: context) as! ChatMessageKind
                messageKindManagedObject.kind = mk
                message?.chatMessageKind = messageKindManagedObject
                message?.chatMessageSender = <<<User created in step above>>>
```

## Coredata initialization

This is the standard way to initialize the coredata in AppDelegate

```Swift
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        // Raj: To get the Bundle from a project within Pods - https://stackoverflow.com/a/35903720/260665
        let frameworkBundle = Bundle(for: ChatSender.self)
        let container = NSPersistentContainer(name: "MessageKit", bundle: frameworkBundle)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
```

## Consideration:

- Make sure that `MessageKit.xcdatamodelId` file is part of the Build Copy phase of the parent project.
- Refer to `ChatExample` project's `CoredataChatViewController.swift` file for an example implementation.
