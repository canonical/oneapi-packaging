# oneAPI Packaging for Ubuntu :rocket:

## Debian packaging

This repo contains Debian package definitions for components from the [oneAPI Base Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html) published to the following PPAs:

- Staging: [ppa:kobuk-team/oneapi-staging](https://launchpad.net/~kobuk-team/+archive/ubuntu/oneapi-staging)
- Production: :soon:

## Repo structure

```bash
├── dpc++-compiler/
│   └── debian/
├── dpc++-lib/
│   └── debian/
└── validation/
    ├── sample-A/
    │   ├── main.cpp
    │   ├── Makefile
    │   └── README.md
    └── sample-B/
        ├── main.cpp
        ├── Makefile
        └── README.md
```

In this example structure, each Debian source package is separated into its own top-level directory, while a `validation` subdirectory contains code samples (likely borrowing from [oneapi-src/oneAPI-samples](https://github.com/oneapi-src/oneAPI-samples)) we use and share to test packages. Ideally each sample application will include its own instructions about how to run the program from both upstream packages and the packages created in this repo. Each sample should also contain its own Makefile for reproducible builds.

## Branches

Ultimately this repo will manage multiple branches corresponding to different Ubuntu releases.