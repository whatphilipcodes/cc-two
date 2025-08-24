# Aberr

`/ˈāˌbər/`

> experimental application development in `C++` for Creative Technologies module `cc-02`.

Bare-bones RAW photo editing software for `iOS`.


### Learning Objectives

- [x] getting `swift` and `c++` interop to work in an ios app
- [ ] importing `libraw` into the project
  - [x] figuring out git submodules for upgradeability
  - [ ] build step to integrate with existing pipeline 
- [ ] handling `RAW image data` in `c++`
  - [ ] implementing a simple `exposure control`
  - [ ] implementing a simple `contrast control`

### Time Tracking

| **Day**      | Task                                                                                                   | Hours |
| ------------ | ------------------------------------------------------------------------------------------------------ | ----- |
| `2025-08-15` | begin setup and planning                                                                               | 2     |
| `2025-08-16` | getting swift and cpp to interop                                                                       | 6     |
| `2025-08-18` | wasting time with vcpkg                                                                                | 6     |
| `2025-08-22` | refactoring based on this [guide](https://arturgruchala.com/swift-and-c-interoperability-in-practice/) | 8     |
| `2025-08-23` | attempting to get `LibRaw` working                                                                     | 8     |
| `2025-08-24` | finally getting `LibRaw` to compile and build                                                          | tbd   |


### Acknowledgements

`LibRaw`<br>
This project makes use of LibRaw for RAW file decoding.
LibRaw is licensed under the Common Development and Distribution License (CDDL).
Copyright © 2008–2025 LibRaw LLC.