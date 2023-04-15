# 128spec - 8502/Commodore128 Testing Framework for KickAssembler

## Installation

### Gradle way

Edit your <code>build.gradle</code> file and add a <code>libFromGitHub</code> to specify 128spec dependency.
Be sure to add also a <code>viceExecutable = 'x128.exe'</code> because retro-assembler plugin default emulator is c64.

```gradle
retroProject {
    viceExecutable = 'x128.exe'

    libFromGitHub "c128lib/128spec", "0.7.2"
}
```

### Other way

1. Create a dir for libraries that your KickAssembler projects use.
2. Get the current version of the 128spec.asm file and put it in this dir along with other libraries. 
3. Import it in your spec files as <code>#import "128spec.asm"</code>
4. Make sure to pass option <code>-libdir <path-to-your-libraries-dir></code> when compiling with KickAssembler.

### If you just want to try it out

1. Get the current version of the 128spec.asm file and put it in the same directory as your spec files.
2. Import it in your spec files as <code>#import "128spec.asm"</code>

## Quick Start

#### 1. Create file example_spec.asm

``` asm
#import "128spec.asm"

sfspec: init_spec()
  
  // TODO: Add assertions here

  finish_spec()
```

![Empty Spec](docs/qs01-empty.png?raw=true "Empty Spec")

#### 2. Add first failing assertion.

``` asm
#import "128spec.asm"

sfspec: init_spec()
  
  lda #0
  assert_a_equal #42

  finish_spec()
```

![Empty Spec](docs/qs02-fail.png?raw=true "Test failed")

#### 3. Make it pass

``` asm
#import "128spec.asm"

sfspec: init_spec()

  lda #42
  assert_a_equal #42
  
  finish_spec()
```

![Empty Spec](docs/qs03-pass.png?raw=true "Test passed")

## License
The MIT License (MIT)

Copyright (c) 2015 Michał Taszycki

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
