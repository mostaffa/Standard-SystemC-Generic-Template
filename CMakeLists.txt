cmake_minimum_required(VERSION 3.10)

project(SystemC_Project)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT DEFINED ENV{SYSTEMC_HOME})
    message(FATAL_ERROR "SYSTEMC_HOME environment variable not set")
endif()

include_directories($ENV{SYSTEMC_HOME}/include include)
# For x64 Arch:
# link_directories($ENV{SYSTEMC_HOME}/lib-linux64)
link_directories($ENV{SYSTEMC_HOME}/lib)

file(GLOB SOURCES src/*.cpp)

add_executable(SystemC_Project ${SOURCES})
target_link_libraries(SystemC_Project systemc)
