#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "bctoolbox-static" for configuration "Release"
set_property(TARGET bctoolbox-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(bctoolbox-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C;CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libbctoolbox.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS bctoolbox-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_bctoolbox-static "${_IMPORT_PREFIX}/lib/libbctoolbox.a" )

# Import target "bctoolbox-tester-static" for configuration "Release"
set_property(TARGET bctoolbox-tester-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(bctoolbox-tester-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libbctoolbox-tester.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS bctoolbox-tester-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_bctoolbox-tester-static "${_IMPORT_PREFIX}/lib/libbctoolbox-tester.a" )

# Import target "bellesip-static" for configuration "Release"
set_property(TARGET bellesip-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(bellesip-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libbellesip.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS bellesip-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_bellesip-static "${_IMPORT_PREFIX}/lib/libbellesip.a" )

# Import target "ortp-static" for configuration "Release"
set_property(TARGET ortp-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(ortp-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libortp.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS ortp-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_ortp-static "${_IMPORT_PREFIX}/lib/libortp.a" )

# Import target "bzrtp-static" for configuration "Release"
set_property(TARGET bzrtp-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(bzrtp-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libbzrtp.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS bzrtp-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_bzrtp-static "${_IMPORT_PREFIX}/lib/libbzrtp.a" )

# Import target "mediastreamer_base-static" for configuration "Release"
set_property(TARGET mediastreamer_base-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(mediastreamer_base-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmediastreamer_base.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS mediastreamer_base-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_mediastreamer_base-static "${_IMPORT_PREFIX}/lib/libmediastreamer_base.a" )

# Import target "mediastreamer_voip-static" for configuration "Release"
set_property(TARGET mediastreamer_voip-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(mediastreamer_voip-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmediastreamer_voip.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS mediastreamer_voip-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_mediastreamer_voip-static "${_IMPORT_PREFIX}/lib/libmediastreamer_voip.a" )

# Import target "linphone-static" for configuration "Release"
set_property(TARGET linphone-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(linphone-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C;CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/liblinphone.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS linphone-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_linphone-static "${_IMPORT_PREFIX}/lib/liblinphone.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
