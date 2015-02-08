cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include (Hen)

set (VALA_VERSION_MIN "0.26")

set (BUILD_TYPE "Release")

build_elementary_app (
    BINARY_NAME
        eidete
    TITLE
        "Screen recording application for elementary"
    VERSION
        "0.2"
    RELEASE_NAME
        "Feature rich and functional."
    SOURCE_PATH
        src
    VALA_FILES
        eidete.vala
        desktop_launcher.vala
        Widgets/countdown.vala
        Widgets/keyview.vala
        Widgets/selectionarea.vala
        Widgets/end_dialog.vala
    C_FILES
        keycapture.c
    PACKAGES
        libwnck-3.0
        granite
        xtst
        gdk-x11-3.0
        x11
        gstreamer-1.0
        gstreamer-pbutils-1.0
    C_DEFINES
        WNCK_I_KNOW_THIS_IS_UNSTABLE
    VALA_OPTIONS
        --enable-experimental
)

build_elementary_contract (
    BINARY_NAME
        videobin-uploader
    TITLE
        "Video uploader to VideoBin"
    VERSION
        "0.2"
    ICON
        data/videobin.svg
    CONTRACT
        data/videobin.contract
    SOURCE_PATH
        src
    VALA_FILES
        videobin_uploader.vala
    PACKAGES
        gtk+-3.0
        gio-2.0
)

build_translations()
