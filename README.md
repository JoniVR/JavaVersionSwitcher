# JavaVersionSwitcher
A bash script for easily switching which Java version your system should be using on macOS.

![example](https://github.com/JoniVR/JavaVersionSwitcher/blob/master/example.png)

## What is it?
A script that will show you a list with currently installed Java versions on your system to pick one from to use.

## How does it work?
It works by renaming the `Info.plist` files of all other versions inside their respective `Library/Java/JavaVirtualMachines/jdk{version}.jdk/Contents/` folders to `Info.plist.disabled`, so that only the selected version will have an `Info.plist` file, this way, only the selected version will work.

## How to use?
1. Download or clone the script to your computer
2. Open a terminal window, navigate to the location where you saved the file (`cd /<folder>/`)
3. Run `chmod +x JavaVersionSwitcher.sh` to allow the user to run the script
4. Run the script: `sudo ./JavaVersionSwitcher.sh`

## Warning
This script modifies your files (`Info.plist` files inside Java installation folders), this means that Java versions won't work unless you either run the script again and select a version or rename the `Info.plist.disabled` file to `Info.plist` inside `Library/Java/JavaVirtualMachines/jdk{version}.jdk/Contents/`. Use at your own risk.

## Author
Joni Van Roost, joni.VR@hotmail.com

## License
JavaVersionSwitcher is available under the MIT license. See the [LICENSE](https://github.com/JoniVR/JavaVersionSwitcher/blob/master/LICENSE) file for more info.

## More
Feel free to submit a pull request, open an issue or fork this project. Any help is always appreciated.
