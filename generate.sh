#!/bin/bash

# ===============================
#  SystemC Project Generator
# ===============================

# ---- Configuration ----
PROJECT_NAME="SystemC_Project"
SYSTEMC_HOME_DEFAULT="/usr/local/systemc-3.0.1"
CXX_COMPILER="/usr/bin/g++"
C_COMPILER="/usr/bin/gcc"

# ---- Ask user for SystemC path ----
read -p "Enter SYSTEMC_HOME path [${SYSTEMC_HOME_DEFAULT}]: " SYSTEMC_HOME
SYSTEMC_HOME=${SYSTEMC_HOME:-$SYSTEMC_HOME_DEFAULT}

# ---- Create folders ----
mkdir -p ${PROJECT_NAME}/{src,include,build,.vscode}

# ---- Create Producer.h ----
cat <<EOL > ${PROJECT_NAME}/include/Producer.h
#ifndef PRODUCER_H
#define PRODUCER_H

#include <systemc.h>

SC_MODULE(Producer) {
    sc_fifo_out<int> out;

    SC_CTOR(Producer) {
        SC_THREAD(produce);
    }

    void produce() {
        for (int i = 0; i < 5; ++i) {
            wait(1, SC_SEC);
            std::cout << "[Producer] Sending: " << i << std::endl;
            out.write(i);
        }
    }
};

#endif
EOL

# ---- Create Consumer.h ----
cat <<EOL > ${PROJECT_NAME}/include/Consumer.h
#ifndef CONSUMER_H
#define CONSUMER_H

#include <systemc.h>

SC_MODULE(Consumer) {
    sc_fifo_in<int> in;

    SC_CTOR(Consumer) {
        SC_THREAD(consume);
    }

    void consume() {
        while (true) {
            int value = in.read();
            std::cout << "[Consumer] Received: " << value << std::endl;
        }
    }
};

#endif
EOL

# ---- Create main.cpp ----
cat <<EOL > ${PROJECT_NAME}/src/main.cpp
#include <systemc.h>
#include "Producer.h"
#include "Consumer.h"

int sc_main(int argc, char* argv[]) {
    sc_fifo<int> fifo(10);

    Producer producer("Producer");
    Consumer consumer("Consumer");

    producer.out(fifo);
    consumer.in(fifo);

    sc_start(10, SC_SEC);
    return 0;
}
EOL

# ---- Create CMakeLists.txt ----
cat <<EOL > ${PROJECT_NAME}/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

project(${PROJECT_NAME})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT DEFINED ENV{SYSTEMC_HOME})
    message(FATAL_ERROR "SYSTEMC_HOME environment variable not set")
endif()

include_directories(\$ENV{SYSTEMC_HOME}/include include)
# For x64 Arch:
# link_directories(\$ENV{SYSTEMC_HOME}/lib-linux64)
link_directories(\$ENV{SYSTEMC_HOME}/lib)

file(GLOB SOURCES src/*.cpp)

add_executable(${PROJECT_NAME} \${SOURCES})
target_link_libraries(${PROJECT_NAME} systemc)
EOL

# ---- Create VSCode Kit file ----
mkdir -p ~/.local/share/CMakeTools
cat <<EOL > ~/.local/share/CMakeTools/cmake-tools-kits.json
[
    {
        "name": "GCC with SystemC",
        "compilers": {
            "C": "${C_COMPILER}",
            "CXX": "${CXX_COMPILER}"
        },
        "environmentVariables": {
            "SYSTEMC_HOME": "${SYSTEMC_HOME}"
        }
    }
]
EOL

# ---- Create tasks.json ----
cat <<EOL > ${PROJECT_NAME}/.vscode/tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "CMake Configure",
            "type": "shell",
            "command": "cmake",
            "args": ["-S", ".", "-B", "build"],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        },
        {
            "label": "Build",
            "type": "shell",
            "command": "cmake",
            "args": ["--build", "build", "--config", "Debug"],
            "group": "build",
            "dependsOn": "CMake Configure",
            "problemMatcher": ["\$gcc"]
        }
    ]
}
EOL

# ---- Create launch.json ----
cat <<EOL > ${PROJECT_NAME}/.vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug SystemC",
            "type": "cppdbg",
            "request": "launch",
            "program": "\${workspaceFolder}/build/${PROJECT_NAME}",
            "args": [],
            "stopAtEntry": false,
            "cwd": "\${workspaceFolder}",
            "environment": [],
            "externalConsole": true,
            "MIMode": "gdb",
            "miDebuggerPath": "/usr/bin/gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "Build"
        }
    ]
}
EOL

echo "✅ SystemC project '${PROJECT_NAME}' created with Producer & Consumer modules."
echo "📂 Location: $(pwd)/${PROJECT_NAME}"
echo "🛠 Select Kit in VSCode: 'GCC with SystemC'"
