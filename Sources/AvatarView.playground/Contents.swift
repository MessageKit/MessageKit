import UIKit
import MessageKit
import PlaygroundSupport

//: Discover what is possible with the Avatar Class
//Get an image
let testImage = #imageLiteral(resourceName: "NiceSelfi.jpg")

let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 200))

view.backgroundColor = UIColor.white

//: Uncomment any line to see how it changes the `Avatar`.
//: By default its a circlular avatar with a gray background and initals of ?
let avatar = AvatarView()

//: Configure any one of the initilization parameters and delete the ones you dont want to set.
//let avatar = AvatarView(size: 50, image: testImage, highlightedImage: testImage, initals: "PL", cornerRounding: 9)

//: Throw in just an image.
//let avatar = AvatarView(image: testImage)

//: Dont have an image just add the users initals
//let avatar = AvatarView(initals: "PL")

//: Want rounded squares instead of circles just change the `cornderRounding`.
//let avatar = AvatarView(image: testImage, cornerRounding: 9)

//:Change its size
//let avatar = AvatarView(size: 5)

//let avatar = AvatarView(size: 100)

//: Everything has a default so if you dont want to set it then you dont have to.

//Helper method.
PlaygroundPage.current.liveView = avatar
