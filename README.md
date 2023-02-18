# Docker distroless Java

Small Docker image with Java, only Java
*****


## Build
To build Docker image, you must ensure that Docker is correctly installed and your current user have permission to use it.

    #> chmod +x ./build.sh
    #> ./build.sh



## Usage

    #> docker run -it --rm thibaultmeyer/distroless-java:oracle19 java -version
