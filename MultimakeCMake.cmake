#
# Multimake
# Copyright (C) 2015 Pelagicore AB
#
# Permission to use, copy, modify, and/or distribute this software for 
# any purpose with or without fee is hereby granted, provided that the 
# above copyright notice and this permission notice appear in all copies. 
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL 
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED  
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR 
# BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES 
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, 
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS 
# SOFTWARE.
#
# For further information see LICENSE

macro(add_cmake_external_project PROJECT PATH DEPENDENCIES CONFIGURATION_OPTIONS)

    append_to_variables(${PROJECT})
    set_package_defined(${PROJECT})
    add_dependencies_target(${PROJECT} "${DEPENDENCIES}")

    get_build_always_property(BUILD_ALWAYS ${PROJECT})

    ExternalProject_Add(${PROJECT}
        DEPENDS ${DEPENDENCIES}
        SOURCE_DIR ${PROJECTS_LOCATION}/${PATH}
        DOWNLOAD_COMMAND ""
        PREFIX ${PROJECT}
        ${BUILD_ALWAYS}
        CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        ${CONFIGURATION_OPTIONS}
        ${COMMON_CMAKE_CONFIGURATION_OPTIONS}
        ${QT_CMAKE_OPTIONS}
    )

    write_variables_file()

endmacro()




macro(add_cmake_external_git_project PROJECT PATH REPOSITORY_URL DEPENDENCIES CONFIGURATION_OPTIONS)
    
    validate_git_commit(${PROJECT})
    get_build_always_property(BUILD_ALWAYS ${PROJECT})
    
    if(NOT ${PROJECT}_DEFINED)

        set_package_defined_with_git_repository(${PROJECT})
        add_dependencies_target(${PROJECT} "${DEPENDENCIES}")
        check_dependencies_existence(${PROJECT} "${DEPENDENCIES}")
        append_to_variables(${PROJECT})

        set(CONFIGURATION_OPTIONS_ALL -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${CONFIGURATION_OPTIONS} ${COMMON_CMAKE_CONFIGURATION_OPTIONS} ${QT_CMAKE_OPTIONS}) 

        ExternalProject_Add(${PROJECT}
            DEPENDS ${DEPENDENCIES}
            SOURCE_DIR ${PROJECTS_DOWNLOAD_DIR}/${PROJECT}
            GIT_REPOSITORY ${REPOSITORY_URL}
            PREFIX ${PROJECT}
            ${BUILD_ALWAYS}
            CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            ${CONFIGURATION_OPTIONS}
            ${COMMON_CMAKE_CONFIGURATION_OPTIONS}
            ${QT_CMAKE_OPTIONS}
            #    BUILD_COMMAND PKG_CONFIG_PATH=${PKG_CONFIG_PATH} make
            CONFIGURE_COMMAND cmake ${CONFIGURATION_OPTIONS_ALL} ${PROJECTS_DOWNLOAD_DIR}/${PATH}
            #    INSTALL_COMMAND ""
            GIT_TAG ${${PROJECT}_GIT_COMMIT}
        )

        write_variables_file()

    endif()

endmacro()
