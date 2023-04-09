# SwiftyCrypto

A cryptocurrency application that downloads live price data from an API and uses Core Data to save the current user's portfolio <br />
This app was made by following a <a href="https://www.youtube.com/playlist?list=PLwvDm4Vfkdphbc3bgy_LpLRQ9DDfFGcFu" target="_blank" >Swiftful Thinking course</a> on Youtube. <br />

### App features:
- Live cryptocurrency data
- Saving current user's portfolio
- Searching, Filtering, Sorting, and Reloading data
- Custom color theme and loading animations

### Technical features:
- MVVM Architecture
- Core Data (saving current user's portfolio)
- FileManager (saving images)
- Combine (publishers and subscribers) along with URLSession.
- Multiple API calls
- Codable (decoding JSON data)
- 100% SwiftUI interface
- Multi-threading (using background threads)
- List Pagination.
- Uses NSCache to store and retrieve Detail page data.
- Uses SwiftUI path view to generate 7 day price Chart View.
- Uses Custom Gestures (Pan) on ChartView to show price.
