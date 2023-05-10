# This port needs to be updated at the same time as mongo-c-driver

vcpkg_minimum_required(VERSION 2022-10-12) # for ${VERSION}

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kkloberdanz/mongo-c-driver
    REF "${VERSION}"
    SHA512 82e9259012884e1b597e2bad25a709ae65050d5337bbea244eb7066716820061907ee65227882191055c0ebb7dd2144552c770e6751fb483b8a3a1361b60f38e
    HEAD_REF vcpkgtest
)
file(WRITE "${SOURCE_PATH}/VERSION_CURRENT" "${VERSION}")

# Cannot use string(COMPARE EQUAL ...)
set(ENABLE_STATIC OFF)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(ENABLE_STATIC ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DENABLE_BSON=ON
        -DENABLE_EXAMPLES=OFF
        -DENABLE_ICU=OFF
        -DENABLE_MONGOC=OFF
        -DENABLE_SASL=OFF
        -DENABLE_SNAPPY=OFF
        -DENABLE_SRV=OFF
        -DENABLE_SSL=OFF
        -DENABLE_STATIC=${ENABLE_STATIC}
        -DENABLE_TESTS=OFF
        -DENABLE_UNINSTALL=OFF
        -DENABLE_ZLIB=SYSTEM
        -DENABLE_ZSTD=OFF
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

vcpkg_cmake_config_fixup(PACKAGE_NAME bson-1.0 CONFIG_PATH "lib/cmake/bson-1.0" DO_NOT_DELETE_PARENT_CONFIG_PATH)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    vcpkg_cmake_config_fixup(PACKAGE_NAME libbson-static-1.0 CONFIG_PATH "lib/cmake/libbson-static-1.0")
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/libbson-1.0")
    file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/libbson-1.0-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/libbson-1.0")
else()
    vcpkg_cmake_config_fixup(PACKAGE_NAME libbson-1.0 CONFIG_PATH "lib/cmake/libbson-1.0")
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/share/mongo-c-driver"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION  "${CURRENT_PACKAGES_DIR}/share/${PORT}")

vcpkg_install_copyright(
    FILE_LIST
        "${SOURCE_PATH}/COPYING"
        "${SOURCE_PATH}/THIRD_PARTY_NOTICES"
        "${SOURCE_PATH}/src/libbson/THIRD_PARTY_NOTICES"
)
