# AnPK
unpack, decompile and analyze APK files

currently only searches source code for interesting (...) tokens and strings.

### Execution
    docker run -it --rm -e TARGET_APK=<URL> zvikam/anpk

### Arguments
Arguments are passed as environment variables to the docker container.

* DECOMPILER_TOOL = *jadx* | *apktool* (default = *jadx*)
* DECOMPILER_OPTS = \<any options acceptable by the chosen decompiler. passed as-is\>
* WORKER_THREADS = n (default = 1)
* GRABER_OPTS = \<command line arguments passed to fileGraber\>
* TARGET_APK = \<URL or path to APK\>

To get access to the extracted APK and decompiled code, be sure to map a volume to the container's `/output` directory,
e.g.

    docker run ... -v /tmp/apk_code:/output -e TARGET_APK=<URL> ...

otherwise `/output` will be created at runtime and will not be exposed outside the container.

### Specifying an APK
A target APK can be specified in several ways
* specify a download url

        docker run ... -e TARGET_APK="https://server/file" ...

* specify a file in some volume mapped to the container

        docker run ... -v /local/path:/container/path -e TARGET_APK=/container/path/to/apk ...

* map the file directly as `/input/target`

        docker run ... -v /local/path/apk:/input/target ...
