# Included by project() of the debug build (CMAKE_PROJECT_INCLUDE), after
# ESP-IDF has made its component list and before it builds: the GDB stub joins
# also a project that lists its components (set(COMPONENTS main)).
# "components" is a variable of ESP-IDF's project.cmake.
list(APPEND components esp_gdbstub)
