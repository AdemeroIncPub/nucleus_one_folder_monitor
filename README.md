## Nucleus One Folder Monitor Tool

This tool monitors configured folders for documents and uploads them to Nucleus
One. A common use case is documents created by copier machines, but any device
or process that saves documents to folders will work.

For more information about Nucleus One, visit https://nucleus.one/.

See these documents for more information about this project:
  - [./gui/README.md](./gui/README.md)
  - [./service/README.md](./service/README.md)
  - [design.md](./design.md)

## Development
Ensure the .NET 7 SDK and the Flutter Version Manager ([FVM](https://fvm.app/)) is installed on your machine.

- Open in VS Code using the provided workspace:
  ```
  code .\nucleus_one_folder_monitor.code-workspace
  ```

### Pull Requests and Commits

Commit messages follow the [Conventional
Commits](https://www.conventionalcommits.org/en/v1.0.0/) format using the
[commitizen](https://commitizen.github.io/cz-cli/) npm package. Begin by
installing required npm packages:
```
npm install
```

To commit staged changes, run either `npx cz` or `npm run commit`. Or install
commitizen globally (`npm install -g commitizen`) then run `git cz`.

Note: IDE plugins may be available allowing properly formatted commit messages
to be written direclty in your editor.
