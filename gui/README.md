## Nucleus One Folder Monitor GUI

Use this GUI to configure monitored folders. Only Windows is currently
supported.

For more information see [../README.md](../README.md).

## Usage
- Generate an api key in your user profile in the Nucleus One web app.
- Ensure Flutter Version Manager ([FVM](https://fvm.app/)) is installed on your machine.
- Clone this repository to your machine.
- Open a terminal window to your cloned repository (to the same folder as this
  README.md).
- Install the Flutter SDK version found in project config:
  ```
  fvm install
  ```
- Get required dependencies:
  ```
  fvm flutter pub get
  ```
- Run the app:
  ```
  fvm flutter run -d windows
  ```
- Use the app to configure folders to monitor.

## Development
Follow the [Usage](#usage) directions to get setup.

For more information see [../README.md](../README.md).

### Testing

```
fvm flutter test
```
