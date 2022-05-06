# icarus-containers
Recipes for working with ICARUS code in containers, for laptops and clusters

## `sl7_base`

This recipe is for making a SL7 container with the minimal number of packags to setup `icaruscode` through cvmfs.
cvmfs is assumed to be setup on the host computer.
The container accesses the packages in cvmfs by simply binding the folder /cvmfs when running the container.

Example:

```
docker run -it -v /cvmfs:/cvmfs nutufts/sl7_base
```

To convert the docker image into a singularity image, run the following command:

```
singularity build sl7_base.simg  docker-daemon://nutufts/sl7_base:latest
```

Last tested status (5/5/2022): could run `lar -c eventdump.fcl -s [larsoft file] -n 1` and get the expected output.

## `sl7_build`

Recipe for making an SL7 container with packages needed to build.