## Nucleus One Folder Monitor Service

### Publish
Open a Powershell terminal as an Administrator. Open the source location (the
same folder as this README) and publish the service:
```
dotnet publish -c Release -o publish
```
Move the published output to anywhere you prefer. The remaining directions
assume you've left them in the `publish` output folder.

### Install

#### Install the service
Use the commands below to install the service. Update `$installPath` below if
you've moved the output from the `publish` folder.
```
$installPath = Join-Path $PWD publish
sc.exe create NucleusOneFolderMonitorService displayname= 'Nucleus One Folder Monitor Service' start= delayed-auto binpath= $(Join-Path $installPath FolderMonitor.Service.exe)
```

#### Configure service recovery
To customize, see `sc failure` output for more information.
```
sc failure NucleusOneFolderMonitorService reset=900 actions=restart/120000/restart/300000/none/0
```

## Usage

### Configure the service
Use the GUI to configure folders to monitor. See [../README.md](../README.md).

Note: any changes to the configuration will require the service to be manuall
restarted for the changes to take effect.

### Start the service
```
sc start NucleusOneFolderMonitorService
```

### Stop the service
```
sc stop NucleusOneFolderMonitorService
```

## Upgrading
- Stop the service.
- Publish the app (and copy to install location if different).
- Start the service.

## Uninstall
After uninstalling by using the steps below, optionally delete the published
files, the source code, and the settings and data in
`"%ProgramData%\\nucleus_one_folder_monitor"`.

### Uninstall the service
Stop the service, then:
```
sc delete NucleusOneFolderMonitorService
```
