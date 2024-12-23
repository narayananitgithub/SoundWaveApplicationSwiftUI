SoundwaveApplicationSwiftUI
The SoundwaveApplicationSwiftUI is a music visualization app built with SwiftUI and AVFoundation. This app provides real-time audio frequency analysis, along with playback controls like play/pause, volume adjustment, and skip forward/backward.

Features
Audio Playback
Play or pause audio tracks with a single tap.
Volume Control
Adjust the audio volume using a slider, ranging from 0 to 1.
Mute and unmute the audio with a dedicated button.
Skip Controls
Skip backward and forward by 10 seconds during audio playback with dedicated skip buttons.
Real-Time Frequency Visualization
Visualize audio frequencies in real time using bars that change dynamically based on the audio playback.
Interactive UI
The interface includes animated elements that react to audio playback, enhancing the user experience with visual feedback.
Setup
To set up the project locally, follow these steps:

Clone the repository:

Open your terminal and run the following command:

bash
Copy code
git clone https://github.com/your-username/SoundwaveApplicationSwiftUI.git
Open the project in Xcode:

Navigate to the project directory and open SoundwaveApplicationSwiftUI.xcodeproj in Xcode.

Build and Run:

Select the desired simulator or connect your iOS device.
Click on the Run button in Xcode to build and launch the app.
Components
AudioManager
AudioManager is responsible for managing audio playback using AVPlayer and audio frequency extraction using AVAudioEngine.
It handles the setup of the audio session, audio engine, and player, while also publishing frequency data and playback state (playing or paused).
RotatingRingsView
RotatingRingsView is a visual representation of the audio frequencies.
Bars are animated based on frequency data to create an engaging visualization of the audio's real-time spectral data.
ParentView
ParentView contains the main user interface, including playback controls, volume control, and the frequency visualization.
It uses AudioManager to manage audio playback and frequency data, and it provides UI elements to control playback, mute, and adjust volume.
UI Controls
Top Controls
Mute Button: Mute/unmute the audio.
Volume Slider: Adjust the volume of the audio playback.
Playback Controls
Play/Pause Button: Play or pause the audio.
Skip Forward/Backward Buttons: Skip 10 seconds forward or backward in the audio.
Frequency Visualization
Rotating Bars: Bars that represent the frequencies in the audio, with their heights changing dynamically based on real-time frequency data.
Dependencies
This project uses AVFoundation to handle audio playback and frequency analysis.
The app is built using SwiftUI to create the UI components.
License
This project is licensed under the MIT License
