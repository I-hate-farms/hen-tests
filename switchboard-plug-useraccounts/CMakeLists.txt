cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include (Hen)

set (VALA_VERSION_MIN "0.26")

set (BUILD_TYPE "Release")

# Create and add config.vala automatically
# adding the vapi dir, po folder automatically if they
# exist
# Add the system deps: granite, switchboard and gkt3.0
build_elementary_plug (
    BINARY_NAME
        switchboard-plug-useraccounts
    TITLE
        "Users Accounts"
    VERSION
        "0.1"
    PLUG_CATEGORY
        "system"
    SOURCE_PATH
        src
    VALA_FILES
        Utils.vala
        Plug.vala
        Widgets/UserView.vala
        Widgets/UserList.vala
        Widgets/ListFooter.vala
        Widgets/UserItem.vala
        Widgets/UserSettings.vala
        Widgets/PasswordEditor.vala
        Widgets/CropView.vala
        Dialogs/NewUserDialog.vala
        Dialogs/PasswordDialog.vala
        Dialogs/AvatarDialog.vala
    C_FILES
        run-passwd.c
    PACKAGES
        AccountsService-1.0
        gnome-desktop-3.0
        posix
        polkit-gobject-1
        pwquality
        run-passwd
    C_DEFINES
        GNOME_DESKTOP_USE_UNSTABLE_API
)

build_translations ()

