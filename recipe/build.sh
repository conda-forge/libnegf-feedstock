#!/usr/bin/env bash
set -ex

if [ "${mpi}" != "nompi" ]; then
  MPI=ON
else
  MPI=OFF
fi

if [ "${mpi}" == "openmpi" ]; then
  export OPAL_PREFIX=$PREFIX
  export OMPI_MCA_plm=isolated
  export OMPI_MCA_btl_vader_single_copy_mechanism=none
  export OMPI_MCA_rmaps_base_oversubscribe=yes
fi

cmake_options=(
   "-DBUILD_SHARED_LIBS=ON"
   "-DWITH_MPI=${MPI}"
)
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  cmake_options+=("-DBUILD_TESTING=OFF")
fi

cmake -B_build -GNinja ${CMAKE_ARGS} "${cmake_options[@]}"
cmake --build _build
cmake --install _build
