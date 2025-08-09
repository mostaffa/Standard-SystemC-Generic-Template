# Standard SystemC Generic Template

## 1. Overview
This repository provides a ready-to-use SystemC project template with the following features:
- Automatic Project Generator (`generate.sh`)
- CMake Build System for multi-file projects
- VS Code Configuration for:
    - Code completion (IntelliSense)
    - Breakpoint debugging
    - Easy build tasks
- Sample Models to get started quickly

## 2. Features
|Feature|Description|
|-------|-----------|
|SystemC Ready	| Works with SystemC ≥ 3.0.0 and C++17|
|Cross-Platform	| Tested on Linux (should work on Windows WSL & macOS) |
|Multi-File Support | Easily add more modules to `/src` and `/include` |
|VS Code Integration |	Pre-configured `.vscode` settings |
|Debug Support | Launch configurations for `gdb` debugging|


## 3. Requirements
Before using this template, make sure you have:
- **SystemC** installed
```bash
/usr/local/systemc-3.0.1
```
- **CMake** ≥ 3.10
- **g++** (C++17 or higher)
- **VS Code** with extensions:
    - C/C++
    - CMake Tools
    - CodeLLDB or C++ Debugger

## 4. Quick Start
1. Clone the Repository
    - HTTPS:
    ```bash
    git clone https://github.com/mostaffa/Standard-SystemC-Generic-Template.git
    ```
    - SSH
    ```bash
    git clone git@github.com:mostaffa/Standard-SystemC-Generic-Template.git
    ```
2. Generate a New Project
    ```bash
    chmod +x generate.sh
    ./generate.sh MyProject
    ```
    This will create the following structure:
    ```bash
    MyProject/
    ├── CMakeLists.txt
    ├── include/
    │    ├── module_a.h
    │    ├── module_b.h
    ├── src/
    │    ├── main.cpp
    │    ├── module_a.cpp
    │    ├── module_b.cpp
    ├── .vscode/
    │    ├── tasks.json
    │    ├── launch.json
    └── build/
    ```

## 5. Building the Project
```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

## 6. Running the Simulation
```bash
./build/SystemC_Project
```

## 7. Debugging in VS Code
1. Open the folder in VS Code
2. Set breakpoints in your `.cpp` files
3. Press F5 to start debugging
4. Choose the pre-configured SystemC Debug launch option

## 8. Adding More Modules
1. Add your header files to include/
2. Add your source files to src/
3. Update CMakeLists.txt:
```cmake
add_executable(SystemC_Project
    src/main.cpp
    src/module_a.cpp
    src/module_b.cpp
    src/my_new_module.cpp
)
```
4. Rebuild the project.

## 9. Example Output
When running the sample template:
```sql
[SystemC] Simulation started
Module A says: Hello from Module A
Module B says: Hello from Module B
[SystemC] Simulation ended
```

## 10. License
MIT License – free to use and modify.


