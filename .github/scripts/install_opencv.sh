#! /bin/bash
echo "Installing OpenCV"
if [ "$CPU_BUILD" == "arm64" ]; then make install; elif [ "$CPU_BUILD" == "armv6l" ]; then make install_raspi; else echo "unsupported CPU" exit 1; fi
echo "Building for ${{ matrix.cpu }}"
sudo apt-get update -y && apt-get install -y git
echo "installing go"
curl -s https://dl.google.com/go/go$GO_VERSION.linux-$CPU_BUILD.tar.gz | sudo tar -C /usr/local -xz
echo "export PATH=$PATH:/usr/local/go/bin/" | sudo tee -a /etc/profile
export PATH=$PATH:/usr/local/go/bin
export GOPATH=/rasperrypi-os-go-cv-builder/go
echo "installing opencv"
git clone https://github.com/hybridgroup/gocv.git
cd gocv
git config --local advice.detachedHead false
git checkout tags/$GO_CV_TAG
if [ "$CPU_BUILD" == "arm64" ]; then make install; elif [ "$CPU_BUILD" == "armv6l" ]; then make install_raspi; else echo "unsupported CPU" exit 1; fi
go run ./cmd/version/main.go
echo "cleaning up"
rm -rf /rasperrypi-os-go-cv-builder/gocv