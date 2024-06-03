#!/usr/bin/env bash
set -ex

if [ "${mpi}" != "nompi" ]; then
  MPI=ON
else
  MPI=OFF
fi

if [ "${mpi}" == "openmpi" ]; then
  export OPAL_PREFIX=$PREFIX
  export OMPI_MCA_plm_ssh_agent=false
  export OMPI_MCA_pml=ob1
  export OMPI_MCA_mpi_yield_when_idle=true
  export OMPI_MCA_btl_base_warn_component_unused=false
  export PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe
fi

cmake_options=(
   "-DBUILD_SHARED_LIBS=ON"
   "-DWITH_MPI=${MPI}"
   "-DBUILD_TESTING=OFF"
)

cmake -B_build -GNinja -DCMAKE_VERBOSE_MAKEFILE=1 ${CMAKE_ARGS} "${cmake_options[@]}"
# cmake --build _build
cd _build
ninja -v
cd ..
cmake --install _build
