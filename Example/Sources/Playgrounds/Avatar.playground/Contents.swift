import UIKit
import MessageKit
import PlaygroundSupport

//: Discover what is possible with the Avatar Class
//Get an image
let testImage = #imageLiteral(resourceName: "NiceSelfi.jpg")

var avatarView = AvatarView()

//: Uncomment any line to see how it changes the `Avatar`. Change the parameters and see the effects.

//: By default its a circlular avatar with a gray background and initals of "?"

//: Create an avatar object and set it for the view.
var avatarObject = Avatar(image: testImage)
avatarView.set(avatar: avatarObject)

//: If you don't have a picture for the user you can pass in there initals instead.
avatarObject = Avatar(initals: "DL")
avatarView.set(avatar: avatarObject)

//: Want rounded squares instead of circles just adjust the radius with the method .setCorner(radius: CGFLoat)`.
//avatarView.setCorner(radius: 5)

//: Everything has a default so if you dont want to set it then you dont have to.

//Helper method.
PlaygroundPage.current.liveView = avatarView
