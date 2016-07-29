set(GTEST_VERSION "1.7.0")
set(GTEST_ZIP "gtest-${GTEST_VERSION}.zip")
set(GTEST_URL "http://googletest.googlecode.com/files/${GTEST_ZIP}")
set(GTEST_MD5 "2d6ec8ccdf5c46b05ba54a9fd1d130d7")

ExternalProject_Add(
  googletest
  PREFIX ${PROJECT_THIRD_PARTY}
  DOWNLOAD_DIR ${PROJECT_THIRD_PARTY}/downloads
  URL ${GTEST_URL}
  URL_MD5 ${GTEST_MD5}
  TIMEOUT 10
  INSTALL_COMMAND ""
  PATCH_COMMAND ""
  UPDATE_COMMAND ""
  # Wrap download, configure and build steps in a script to log output
  LOG_DOWNLOAD OFF
  LOG_CONFIGURE OFF
  LOG_BUILD OFF)

include_directories( SYSTEM ${PROJECT_THIRD_PARTY}/src/googletest/include )
link_directories( ${PROJECT_THIRD_PARTY}/src/googletest-build )
