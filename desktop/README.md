# Maputnik Desktop [![GitHub CI status](https://github.com/maputnik/desktop/workflows/ci/badge.svg)](https://github.com/maputnik/desktop/actions?query=workflow%3Aci)

---

A Golang based cross platform executable for integrating Maputnik locally.
This binary packages up the JavaScript and CSS bundle produced by [maputnik/editor](https://github.com/maputnik/desktop)
and embeds it in the program for easy distribution. It also allows
exposing a local style file and work on it both in Maputnik and with your favorite
editor.

Report issues on [maputnik/editor](https://github.com/maputnik/editor).

## Install

You can download a single binary for Linux, OSX or Windows from [the latest releases of **maputnik/editor**](https://github.com/maputnik/editor/releases/latest).

### Usage

Simply start up a web server and access the Maputnik editor GUI at `localhost:8000`.

```bash
maputnik
```

Expose a local style file to Maputnik allowing the web based editor
to save to the local filesystem.

```bash
maputnik --file basic-v9.json
```

Watch the local style for changes and inform the editor via web socket.
This makes it possible to edit the style with a local text editor and still
use Maputnik.

```bash
maputnik --watch --file basic-v9.json
```

Choose a local port to listen on, instead of using the default port 8000.

```bash
maputnik --port 8001
```

Specify a path to a directory which, if it exists, will be served under http://localhost:8000/static/ .
Could be used to serve sprites and glyphs.

```bash
maputnik --static ./localFolder
```

### API

`maputnik` exposes the configured styles via a HTTP API.

| Method                          | Description
|---------------------------------|---------------------------------------
| `GET /styles`                   | List the ID of all configured style files
| `GET /styles/{filename}`        | Get contents of a single style file
| `PUT /styles/{filename}`        | Update contents of a style file
| `WEBSOCKET /ws`                 | Listen to change events for the configured style files

### Build

Clone the repository. Make sure you clone it into the correct directory `$GOPATH/src/github.com/maputnik`.

```
git clone git@github.com:maputnik/desktop.git
```

Run `make` to install the 3rd party dependencies and build the `maputnik` binary embedding the editor.

```
make
```

You should now find the `maputnik` binary in your `bin` directory.
