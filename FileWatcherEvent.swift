import Foundation
/**
 * - Parameters:
 *    - id: is an id number that the os uses to differentiate between events.
 *    - path: is the path the change took place. its formated like so: Users/John/Desktop/test/text.txt
 *    - flag: pertains to the file event type.
 * ## Examples:
 * let url = NSURL(fileURLWithPath: event.path)//<--formats paths to: file:///Users/John/Desktop/test/text.txt
 * Swift.print("fileWatcherEvent.fileChange: " + "\(event.fileChange)")
 * Swift.print("fileWatcherEvent.fileModified: " + "\(event.fileModified)")
 * Swift.print("\t eventId: \(event.id) - eventFlags:  \(event.flags) - eventPath:  \(event.path)")
 */
public class FileWatcherEvent {
    public var id: FSEventStreamEventId
    public var path: String
    public var flags: FSEventStreamEventFlags
    init(_ eventId: FSEventStreamEventId, _ eventPath: String, _ eventFlags: FSEventStreamEventFlags) {
        self.id = eventId
        self.path = eventPath
        self.flags = eventFlags
    }
}
/**
 * The following code is to differentiate between the FSEvent flag types (aka file event types)
 * - Remark: Be aware that .DS_STORE changes frequently when other files change
 */
extension FileWatcherEvent {
    /*general*/
    var fileChange: Bool { return (flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsFile)) != 0 }
    var dirChange: Bool { return (flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsDir)) != 0 }
    /*CRUD*/
    var created: Bool { return (flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemCreated)) != 0 }
    var removed: Bool { return (flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemRemoved)) != 0 }
    var renamed: Bool { return (flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemRenamed)) != 0 }
    var modified: Bool { return (flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemModified)) != 0 }
    var none: Bool { return (flags & FSEventStreamEventFlags(kFSEventStreamEventFlagNone)) != 0 }
    var xattrMod: Bool { return (flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemXattrMod)) != 0 }
}
/**
 * Convenince
 */
extension FileWatcherEvent {
    /*File*/
    public var fileCreated: Bool { return fileChange && created }
    public var fileRemoved: Bool { return fileChange && removed }
    public var fileRenamed: Bool { return fileChange && renamed }
    public var fileModified: Bool { return fileChange && modified }
    public var fileAccessed: Bool { return fileChange && xattrMod }
    /*Directory*/
    public var dirCreated: Bool { return dirChange && created }
    public var dirRemoved: Bool { return dirChange && removed }
    public var dirRenamed: Bool { return dirChange && renamed }
    public var dirModified: Bool { return dirChange && modified }
}
/**
 * Simplifies debugging
 * ## Examples:
 * Swift.print(event.description)//Outputs: The file /Users/John/Desktop/test/text.txt was modified
 */
extension FileWatcherEvent {
    public var description: String {
        var result = "The \(fileChange ? "file":"directory") \(self.path) was"
        if self.removed { result += " removed" }
        else if self.created { result += " created" }
        else if self.renamed { result += " renamed" }
        else if self.modified { result += " modified" }
        else if self.xattrMod { result += " accessed" }
        let flagsHexStr = String(self.flags, radix: 16, uppercase: true)
        return result + "With flags:" + "0x" + flagsHexStr
    }
    public var eventFlagsStr: String {
        var result = "FileWatcher eventFlags:\n"
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagNone)) != 0 {
            result = result + "kFSEventStreamEventFlagNone" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagMustScanSubDirs)) != 0 {
            result = result + "kFSEventStreamEventFlagMustScanSubDirs" + "\n"
        }
        
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagUserDropped)) != 0 {
            result = result + "kFSEventStreamEventFlagUserDropped" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagKernelDropped)) != 0 {
            result = result + "kFSEventStreamEventFlagKernelDropped" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagEventIdsWrapped)) != 0 {
            result = result + "kFSEventStreamEventFlagEventIdsWrapped" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagHistoryDone)) != 0 {
            result = result + "kFSEventStreamEventFlagHistoryDone" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagRootChanged)) != 0 {
            result = result + "kFSEventStreamEventFlagRootChanged" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagMount)) != 0 {
            result = result + "kFSEventStreamEventFlagMount" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagUnmount)) != 0 {
            result = result + "kFSEventStreamEventFlagUnmount" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemChangeOwner)) != 0 {
            result = result + "kFSEventStreamEventFlagItemChangeOwner" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemCreated)) != 0 {
            result = result + "kFSEventStreamEventFlagItemCreated" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemFinderInfoMod)) != 0 {
            result = result + "kFSEventStreamEventFlagItemFinderInfoMod" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemInodeMetaMod)) != 0 {
            result = result + "kFSEventStreamEventFlagItemInodeMetaMod" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsDir)) != 0 {
            result = result + "kFSEventStreamEventFlagItemIsDir" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsFile)) != 0 {
            result = result + "kFSEventStreamEventFlagItemIsFile" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsHardlink)) != 0 {
            result = result + "kFSEventStreamEventFlagItemIsHardlink" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsLastHardlink)) != 0 {
            result = result + "kFSEventStreamEventFlagItemIsLastHardlink" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsSymlink)) != 0 {
            result = result + "kFSEventStreamEventFlagItemIsSymlink" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemModified)) != 0 {
            result = result + "kFSEventStreamEventFlagItemModified" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemRemoved)) != 0 {
            result = result + "kFSEventStreamEventFlagItemRemoved" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemRenamed)) != 0 {
            result = result + "kFSEventStreamEventFlagItemRenamed" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemXattrMod)) != 0 {
            result = result + "kFSEventStreamEventFlagItemXattrMod" + "\n"
        }
        if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagOwnEvent)) != 0 {
            result = result + "kFSEventStreamEventFlagOwnEvent" + "\n"
        }
        if #available(OSX 10.13, *) {
            if (self.flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemCloned)) != 0 {
                result = result + "kFSEventStreamEventFlagItemCloned" + "\n"
            }
        }
        
        return result
    }
}
