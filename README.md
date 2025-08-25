# Aberr

`/ˈāˌbər/`

> experimental application development in `C++` for Creative Technologies module `cc-02`.

Bare-bones RAW photo editing software for `iOS`.


### Development

> Disclaimer: Development was only tested on `x86_64`. Apple Silicon as development platform might work but is neither tested nor maintained.

`LibRaw` is present as a submodule in this repository. To run a full library compilation and install `cd cpp/` and run:

```sh
make build-libs
```

Afterwards you can use the `open xcodeproj` task to build the ios app (either in simulator or on-device). The pure `make` command will rebuild the swift package and the `cpp` codebase in `Sources/` only.


### Learning Objectives

- [x] getting `swift` and `c++` interop to work in an ios app
- [x] importing `libraw` into the project
  - [x] figuring out git submodules for upgradeability
  - [x] build step to integrate with existing pipeline 
- [ ] handling `RAW image data` in `c++`
  - [ ] load & decode raw image data using `libraw` 
  - [ ] implementing a simple `exposure control`
  - [ ] implementing a simple `contrast control`
  - [ ] save 'developed' image to device

### Time Tracking

| **Day**      | Task                                                                                                   | Hours |
| ------------ | ------------------------------------------------------------------------------------------------------ | ----- |
| `2025-08-15` | begin setup and planning                                                                               | 2     |
| `2025-08-16` | getting swift and cpp to interop                                                                       | 6     |
| `2025-08-18` | wasting time with vcpkg                                                                                | 6     |
| `2025-08-22` | refactoring based on this [guide](https://arturgruchala.com/swift-and-c-interoperability-in-practice/) | 8     |
| `2025-08-23` | attempting to get `LibRaw` working                                                                     | 8     |
| `2025-08-24` | finally getting `LibRaw` to compile and build & rough cpp package architecture rework                  | 8     |


### Acknowledgements

`LibRaw`<br>
This project makes use of LibRaw for RAW file decoding.
LibRaw is licensed under the Common Development and Distribution License (CDDL).
Copyright © 2008–2025 LibRaw LLC.