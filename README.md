# icarus-containers
Recipes for working with ICARUS code in containers, for laptops and clusters

NOTE: there is already an official SL7 environment container for running on the grid. Nice.

```
/cvmfs/singularity.opensciencegrid.org/fermilab/fnal-wn-sl7:latest
```

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

Note that you have to do the usual to setup the icarus cvmfs repository. Assuming you properly binded the `/cvmfs` folder:

```
source /cvmfs/icarus.opensciencegrid.org/products/icarus/setup_icarus.sh
setup icaruscode [version] -q [qualifier]
```

If you cannot access `/cvmfs`, exit the container and run `cvmfs_config probe` (see section below on cvmfs).

## `sl7_build`

Recipe for making an SL7 container with packages needed to build.

## Pre-req: cvmfs

You can gain access to the icarus (and other sbn) software on `/cvmfs` on your laptop, by installing cvmfs.

Instructions can be found [here](https://cvmfs.readthedocs.io/en/stable/cpt-quickstart.html).

After install the program, you'll need to list the repositories you want access to by creating the file `/etc/cvmfs/default.local`. (You'll need sudo access to do this.)

In the file, add the following lines:

```
CVMFS_REPOSITORIES=config-osg.opensciencegrid.org,larsoft.opensciencegrid.org,uboone.opensciencegrid.org,icarus.opensciencegrid.org,fermilab.opensciencegrid.org,sbn.opensciencegrid.org
CVMFS_CLIENT_PROFILE=single
```

Then if you run the command, `cvmfs_config probe`, you'll see:

```
t@pop-os:~/$ cvmfs_config probe
Probing /cvmfs/config-osg.opensciencegrid.org... OK
Probing /cvmfs/larsoft.opensciencegrid.org... OK
Probing /cvmfs/uboone.opensciencegrid.org... OK
Probing /cvmfs/icarus.opensciencegrid.org... OK
Probing /cvmfs/fermilab.opensciencegrid.org... OK
Probing /cvmfs/sbn.opensciencegrid.org... OK
```

If this works, you'll find that the `/cvmfs` folder will have folders from these repositories:

```
t@pop-os:~/$ ls -l /cvmfs/
total 32
drwxr-xr-x 4 cvmfs cvmfs 4096 Feb 26  2016 config-osg.opensciencegrid.org
drwxr-xr-x 4 cvmfs cvmfs 4096 May 28  2014 cvmfs-config.cern.ch
drwxr-xr-x 7 cvmfs cvmfs 4096 Aug 12  2014 fermilab.opensciencegrid.org
drwxr-xr-x 3 cvmfs cvmfs 4096 Mar 20  2017 icarus.opensciencegrid.org
drwxr-xr-x 4 cvmfs cvmfs 4096 Mar  2  2018 larsoft.opensciencegrid.org
drwxr-xr-x 3 cvmfs cvmfs 4096 Jun  5  2020 sbn.opensciencegrid.org
drwxr-xr-x 4 cvmfs cvmfs 4096 Jun 17  2015 uboone.opensciencegrid.org
```

If you want the container to have access to these, just bind the folder `/cvmfs` to the container.

In docker:

```
docker run -it -v /cvmfs:/cvmfs myimage
```

In singularity:

```
singularity shell -B /cvmfs:/cvmfs mycontainer.simg
```