# Flutter Pagination Demo with SilverGrid

This project demonstrates how to query a Magento paginated REST API and dynamically construct a SilverGrid in Flutter as the user scrolls. It serves as a practical example for developers seeking to implement endless scrolling functionality in a Flutter application using the SilverGrid widget.

The application fetches data from the Magento API and populates the SilverGrid with the retrieved elements. As the user scrolls towards the bottom of the grid, additional data is fetched from subsequent pages of the API, providing a seamless and virtually infinite scrolling experience.

Please note that this project is intended as a functional demonstration and not as a showcase of optimal coding practices. The quality of the code, while adequate for the purpose of this demo, may not represent the best practices for production-level code. The main objective is to provide a clear, understandable example of how to implement pagination with a SilverGrid in Flutter, and there may be room for improvements and optimizations in the code.

Contributions and suggestions to enhance the code quality and efficiency are welcome and appreciated. Please feel free to open issues or submit pull requests if you have any ideas for improvements.


## Getting Started

Install dependencies
```
> flutter pub get
```

Start your iOS simulator

Find the device id 
```
> flutter devices
iPhone 14 Pro (mobile) • 11111111-1111-1111-1111-111111111111 • ios            • com.apple.CoreSimulator.SimRuntime.iOS-16-2 (simulator)
```

```
> flutter run -d 1111
```