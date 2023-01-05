## Nucleus One Folder Monitor Tool
This tool monitors configured folders for documents and uploads them to Nucleus
One. A common use case is documents created by copier machines, but any device
or process that saves documents to folders will work.

### Requirements
- Run as a Windows Service.
- Ability to run on macOS and/or Linux in the future.
- Can map a folder to an N1 Project or Deportment.
- Can make multiple ma  ppings.
- Available N1 Projects and Departments are determined by user provided API key.
- Can configure after upload action: delete or move (configure destination
  folder).

See mockups for more context.<br>
https://balsamiq.cloud/s848pc2/plkw4ge

### Frontend
The UI is a Flutter Desktop app.

- pro:
  - This allows the app to run on Windows, macOS, and Linux.
  - Can make use of the N1 Dart SDK.
- con:
  - Still a relatively new framework, especially desktop support.

**Alternatives considered**
- Serve a local web app from the service.
  - pro:
    - Single app to deploy.
  - con:
    - Service is more complex.
    - .NET selected for backend and there currently is no N1 .NET SDK.

### Backend
The backend is a .NET 7 (C#) Windows Service.

- pro:
  - Built-in support for Windows Service apps.
  - Mature platform.
  - Runs well on macOS and Linux (will need to research and modify to run as the
    rough equivalent of a Windows Service on those OSes.)
- con:
  - There is no N1 .NET SDK. The best short term solution may be to call the N1
    APIs directly since the tool pretty much just needs to upload files.

**Alternatives considered**
- Dart app.
  (https://github.com/winsw/winsw)
  - pro:
    - Can make use of N1 Dart SDK.
  - con:
    - Dart does not have built-in support for running as a Windows Service.
    - Possibly use Windows Service Wrapper (https://github.com/winsw/winsw).
      WinSW seems to have a lot of open issues. Unsure of it's reliability.
    - Other service wrappers found would need to be purchased per install or
      have unfortunate names (https://nssm.cc/).

### Config
- Monitored Folders settings are stored as json at
  "%PROGRAMDATA%\Nucleus One Folder Monitor\settings.json".
- Other settings location(s) TBD. The reason for possibly multiple files is that
  a Flutter GUI needs read/write and a C# Service needs at least read to the
  settings.json. If any Service specific settings, such as logging
  configuration, are present then the GUI will need to know how to keep those
  settings on config write.
- Service reads settings at startup and settings changes do not take effect
  until service restart.
  - Initially, service restart can be done manually in Services MMC.
  - Possibly offer a button in UI to restart service via:
    - Use Process to run sc.exe stop, sc.exe start
    - MethodChannel for Windows platform specific code
    - Above options probably require elevation. Will need to research how best
      to achieve from flutter.
    - Another option may be to use Pipes to signal service to reload config.

### Deployment
TBD
