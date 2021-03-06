#	Copyright (c) 2016, TecSec, Inc.
#
#	Redistribution and use in source and binary forms, with or without
#	modification, are permitted provided that the following conditions are met:
#	
#		* Redistributions of source code must retain the above copyright
#		  notice, this list of conditions and the following disclaimer.
#		* Redistributions in binary form must reproduce the above copyright
#		  notice, this list of conditions and the following disclaimer in the
#		  documentation and/or other materials provided with the distribution.
#		* Neither the name of TecSec nor the names of the contributors may be
#		  used to endorse or promote products derived from this software 
#		  without specific prior written permission.
#		 
#	ALTERNATIVELY, provided that this notice is retained in full, this product
#	may be distributed under the terms of the GNU General Public License (GPL),
#	in which case the provisions of the GPL apply INSTEAD OF those given above.
#		 
#	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#	DISCLAIMED.  IN NO EVENT SHALL TECSEC BE LIABLE FOR ANY 
#	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#	LOSS OF USE, DATA OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Written by Roger Butler

include (CheckIncludeFiles)
include (CheckLibraryExists)
include (CheckSymbolExists)

find_path(GTEST_INCLUDE_DIR gtest/gtest.h
    HINTS
        $ENV{GTEST_ROOT}/include
        ${GTEST_ROOT}/include
)
mark_as_advanced(GTEST_INCLUDE_DIR)
# if (NOT GTEST_LIBRARIES)
# message(STATUS "Using GTEST_ROOT  ${GTEST_ROOT}")
	# if(MSYS OR MINGW)
	# 	SET(_tmp ${CMAKE_FIND_LIBRARY_SUFFIXES})
	# 	SET(CMAKE_FIND_LIBRARY_SUFFIXES .dll.a)
	# 	find_library(GTEST_SHARED_LIBRARY_RELEASE NAMES gtest libgtest HINTS $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
	# 	find_library(GTEST_SHARED_LIBRARY_DEBUG NAMES gtestd libgtestd HINTS $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
	# 	find_library(GTEST_MAIN_SHARED_LIBRARY_RELEASE NAMES gtest_main libgtest_main HINTS $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
	# 	find_library(GTEST_MAIN_SHARED_LIBRARY_DEBUG NAMES gtest_maind libgtest_maind HINTS $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
	# 	SET(CMAKE_FIND_LIBRARY_SUFFIXES ${_tmp})
	# else(MSYS OR MINGW)
    find_library(GTEST_SHARED_LIBRARY_RELEASE NAMES gtest HINTS $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
    find_library(GTEST_SHARED_LIBRARY_DEBUG NAMES gtestd HINTS $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
    find_library(GTEST_MAIN_SHARED_LIBRARY_RELEASE NAMES gtest_main HINTS $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
    find_library(GTEST_MAIN_SHARED_LIBRARY_DEBUG NAMES gtest_maind HINTS $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
	# endif(MSYS OR MINGW)
	IF(WIN32)
		SET(_tmp ${CMAKE_FIND_LIBRARY_SUFFIXES})
		SET(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX})
		find_library(GTEST_SHARED_SO_RELEASE NAMES gtest libgtest HINTS $ENV{GTEST_ROOT}/bin ${GTEST_ROOT}/bin $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
		find_library(GTEST_SHARED_SO_DEBUG NAMES gtestd libgtestd HINTS $ENV{GTEST_ROOT}/bin ${GTEST_ROOT}/bin $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
		find_library(GTEST_MAIN_SHARED_SO_RELEASE NAMES gtest_main libgtest_main HINTS $ENV{GTEST_ROOT}/bin ${GTEST_ROOT}/bin $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
		find_library(GTEST_MAIN_SHARED_SO_DEBUG NAMES gtest_maind libgtest_maind HINTS $ENV{GTEST_ROOT}/bin ${GTEST_ROOT}/bin $ENV{GTEST_ROOT}/lib ${GTEST_ROOT}/lib)
		SET(CMAKE_FIND_LIBRARY_SUFFIXES ${_tmp})
	endif(WIN32)
# endif ()

# handle the QUIETLY and REQUIRED arguments and set BZip2_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
if(WIN32)
	FIND_PACKAGE_HANDLE_STANDARD_ARGS(GTEST
                                  REQUIRED_VARS GTEST_SHARED_LIBRARY_RELEASE GTEST_SHARED_LIBRARY_DEBUG 
                                  GTEST_MAIN_SHARED_LIBRARY_RELEASE GTEST_MAIN_SHARED_LIBRARY_DEBUG 
																		GTEST_INCLUDE_DIR GTEST_SHARED_SO_RELEASE GTEST_SHARED_SO_DEBUG 
																		GTEST_MAIN_SHARED_SO_RELEASE GTEST_MAIN_SHARED_SO_DEBUG)
else(WIN32)
	FIND_PACKAGE_HANDLE_STANDARD_ARGS(GTEST
																			REQUIRED_VARS GTEST_SHARED_LIBRARY_RELEASE  
																			GTEST_MAIN_SHARED_LIBRARY_RELEASE  
																			GTEST_INCLUDE_DIR)
endif(WIN32)


if(GTEST_FOUND)
    set(GTEST_INCLUDE_DIRS ${GTEST_INCLUDE_DIR})

    if(NOT TARGET GTEST)
		if(WIN32)
		  add_library(GTEST SHARED IMPORTED)
		  set_property(TARGET GTEST PROPERTY IMPORTED_LOCATION_DEBUG "${GTEST_SHARED_SO_DEBUG}")
		  set_property(TARGET GTEST PROPERTY IMPORTED_LOCATION_RELEASE "${GTEST_SHARED_SO_RELEASE}")
		  set_property(TARGET GTEST PROPERTY INTERFACE_BIN_MODULES_DEBUG "${GTEST_SHARED_SO_DEBUG}")
		  set_property(TARGET GTEST PROPERTY INTERFACE_BIN_MODULES_RELEASE "${GTEST_SHARED_SO_RELEASE}")
		  set_property(TARGET GTEST PROPERTY IMPORTED_IMPLIB_DEBUG "${GTEST_SHARED_LIBRARY_DEBUG}")
		  set_property(TARGET GTEST PROPERTY IMPORTED_IMPLIB_RELEASE "${GTEST_SHARED_LIBRARY_RELEASE}")
		  set_property(TARGET GTEST PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")
				
				# message(STATUS "GTEST_SHARED_SO_DEBUG = ${GTEST_SHARED_SO_DEBUG}")
				# message(STATUS "GTEST_SHARED_SO_RELEASE = ${GTEST_SHARED_SO_RELEASE}")
				# message(STATUS "GTEST_SHARED_LIBRARY_DEBUG = ${GTEST_SHARED_LIBRARY_DEBUG}")
				# message(STATUS "GTEST_SHARED_LIBRARY_RELEASE = ${GTEST_SHARED_LIBRARY_RELEASE}")
		else(WIN32)
		  add_library(GTEST SHARED IMPORTED)
		  set_target_properties(GTEST PROPERTIES
			IMPORTED_LOCATION_DEBUG "${GTEST_SHARED_LIBRARY_DEBUG}"
			IMPORTED_LOCATION_RELEASE "${GTEST_SHARED_LIBRARY_RELEASE}"
			INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")
		endif(WIN32)
    endif()
    if(NOT TARGET GTEST_MAIN)
		if(WIN32)
		  add_library(GTEST_MAIN SHARED IMPORTED)
		  set_property(TARGET GTEST_MAIN PROPERTY IMPORTED_LOCATION_DEBUG "${GTEST_MAIN_SHARED_SO_DEBUG}")
		  set_property(TARGET GTEST_MAIN PROPERTY IMPORTED_LOCATION_RELEASE "${GTEST_MAIN_SHARED_SO_RELEASE}")
		  set_property(TARGET GTEST_MAIN PROPERTY INTERFACE_BIN_MODULES_DEBUG "${GTEST_MAIN_SHARED_SO_DEBUG}")
		  set_property(TARGET GTEST_MAIN PROPERTY INTERFACE_BIN_MODULES_RELEASE "${GTEST_MAIN_SHARED_SO_RELEASE}")
		  set_property(TARGET GTEST_MAIN PROPERTY IMPORTED_IMPLIB_DEBUG "${GTEST_MAIN_SHARED_LIBRARY_DEBUG}")
		  set_property(TARGET GTEST_MAIN PROPERTY IMPORTED_IMPLIB_RELEASE "${GTEST_MAIN_SHARED_LIBRARY_RELEASE}")
		  set_property(TARGET GTEST_MAIN PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")

				# message(STATUS "GTEST_MAIN_SHARED_SO_DEBUG = ${GTEST_MAIN_SHARED_SO_DEBUG}")
				# message(STATUS "GTEST_MAIN_SHARED_SO_RELEASE = ${GTEST_MAIN_SHARED_SO_RELEASE}")
				# message(STATUS "GTEST_MAIN_SHARED_LIBRARY_DEBUG = ${GTEST_MAIN_SHARED_LIBRARY_DEBUG}")
				# message(STATUS "GTEST_MAIN_SHARED_LIBRARY_RELEASE = ${GTEST_MAIN_SHARED_LIBRARY_RELEASE}")

		else(WIN32)
		  add_library(GTEST_MAIN SHARED IMPORTED)
		  set_target_properties(GTEST_MAIN PROPERTIES
			IMPORTED_LOCATION_DEBUG "${GTEST_MAIN_SHARED_LIBRARY_DEBUG}"
			IMPORTED_LOCATION_RELEASE "${GTEST_MAIN_SHARED_LIBRARY_RELEASE}"
			INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")
		endif(WIN32)
    endif()
endif()

mark_as_advanced(GTEST_INCLUDE_DIR)
