# Validation and Code Samples

## System Requirements

Hardware and software requirements for using oneAPI are described [here](https://www.intel.com/content/www/us/en/developer/articles/system-requirements/oneapi-base-toolkit/2025.html).

## Install upstream Debian repo and packages

Instructions from Intel can be found [here](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html?packages=oneapi-toolkit&oneapi-toolkit-os=linux&oneapi-lin=apt).

The steps for installing the Debian repo from Intel are in `install-upstream-repo.sh`. Thus, if you want to install all of the oneAPI Base Toolkit packages from Intel you can simply run:

```bash
./install-upstream-repo.sh
sudo apt install intel-oneapi-base-toolkit
```