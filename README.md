# SwiftUIGamepad

![](https://img.shields.io/badge/license-MIT-green) ![](https://img.shields.io/badge/maintained%3F-Yes-green) ![](https://img.shields.io/badge/swift-5.4-green) ![](https://img.shields.io/badge/iOS-13.0-red) ![](https://img.shields.io/badge/macOS-10.15-red) ![](https://img.shields.io/badge/tvOS-13.0-red) ![](https://img.shields.io/badge/watchOS-6.0-red) ![](https://img.shields.io/badge/release-v1.0.8-blue)

`SwiftUIGamepad` makes it easy to add Gamepad support to any `SwiftUI View`.

## Overview

Using `SwiftUIGamepad` you can easily add Gamepad support to any `SuiftUI` based app. `SwiftUIGamepad` provides a built-in set of Gamepad images and support for showing a help overlay based on the way the Gamepad is being used in any `View`. `SwiftUIGamepad` allso provides support for Gamepads attaching/detaching from the Device and has an overlay when the App requires a Gamepad to work.

### Embedded Image

There are several Gamepad images embedded in `SwiftUIGamepad` that can be used to display help for the users. Images are provided for the following controllers:

* **PS4**
* **PS5**
* **XBox**
* **Generic Gamepad**
* **Siri Remote v1**
* **Siri Remote v2**

All images are released under the Creative Commons 0 License.

### The SwiftUIGamepad Class

The `SwiftUIGamepad` provides a few helper utilities that allow you to easily access resources stored in the Swift Package (such as the images above).

For example, the following code would return the path to the `xxx.png` file:

```
let path = SwiftUIKit.pathTo(resource:"xxx.png")
```
