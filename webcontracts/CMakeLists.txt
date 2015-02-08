cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include (Elementary)

set (VALA_VERSION_MIN "0.26")

set (BUILD_TYPE "Release")

build_elementary_plug (
    BINARY_NAME
        sharing-accounts
    TITLE
        "Sharing Accounts"
    VERSION
        "0.2"
    PLUG_CATEGORY
        "system"
    SOURCE_PATH
        src
    VALA_FILES
        WebcontractsPlug.vala
        Utils.vala
        Contract.vala
        Contracts/Imagebin.vala
        Contracts/Pastebin.vala
        Contracts/Twitter.vala
        Contracts/Videobin.vala
        Contracts/Flickr.vala
        Contracts/Imgur.vala
        Contracts/Facebook.vala
        Contracts/Youtube.vala
        Contracts/GooglePlus.vala
        Contracts/GoogleTranslate.vala
        Contracts/Wikipedia.vala
        Contracts/GoogleSearch.vala
    PACKAGES
        # Is this package list really minimal?
        json-glib-1.0
        rest-0.7
        webkitgtk-3.0
        libsoup-2.4
    SCHEMA
        org.pantheon.contractor.gschema.xml
)

build_elementary_app (
    BINARY_NAME
        webcontracts
    TITLE
        "Sharing Accounts"
    VERSION
        "0.2"
    SOURCE_PATH
        src
    VALA_FILES
        Webcontracts.vala
        Utils.vala
        Contract.vala
        Contracts/Imagebin.vala
        Contracts/Pastebin.vala
        Contracts/Twitter.vala
        Contracts/Videobin.vala
        Contracts/Flickr.vala
        Contracts/Imgur.vala
        Contracts/Facebook.vala
        Contracts/Youtube.vala
        Contracts/GooglePlus.vala
        Contracts/GoogleTranslate.vala
        Contracts/Wikipedia.vala
        Contracts/GoogleSearch.vala
    PACKAGES
        gthread-2.0
        gtk+-3.0
        json-glib-1.0
        granite
        rest-0.7
        webkitgtk-3.0
        libsoup-2.4
)

build_translations()
