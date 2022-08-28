# EbayExercise
<img width="250" alt="Screen Shot 2022-08-28 at 12 08 52 PM" src="https://user-images.githubusercontent.com/36284798/187090578-3b96e0e1-f476-45dc-a6a9-f50d8c87c498.png"><img width="250" alt="Screen Shot 2022-08-28 at 12 09 01 PM" src="https://user-images.githubusercontent.com/36284798/187090583-0af7794e-a50f-4257-9436-f00d3a45ca89.png">


## Code/design decisions Made
- App architecture follows MVVM with Combine for bindings 
- App utilizes a protocol oriented approach with testability/scalability in mind 
- Used UIKit for the feed list and SwiftUI for the detail page
- async/await for support for iOS 15.0+ with fallback on completion handlers for previous versions 
- Supports self sizing Collection View Cells
- Added Unit Tests 

## UI/UX decisions made
- App supports dark mode and dynamic type 
- Deeplinking into Apple Music with selected song 


## Areas of improvement to get to a production ready application 
- Adequate loading indicators/error messages 
- Better image caching solution 
- UI improvements for larger screens and landscape mode
