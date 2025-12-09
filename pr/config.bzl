load("@bazel_skylib//lib:paths.bzl", "paths")
load("@rules_cc//cc:defs.bzl", _cc_library = "cc_library")

def cc_library(name, srcs = [], local_defines = [], includes = [], copts = [], **kwargs):
    include_path = paths.relativize(native.package_name(), "pr").split("/")
    include_path = "/".join([".."] * (len(include_path))) + "/include"

    common_defines = [
        "PACKAGE_NAME=\"\"",
        "PACKAGE_TARNAME=\"\"",
        "PACKAGE_VERSION=\"\"",
        "PACKAGE_STRING=\"\"",
        "PACKAGE_BUGREPORT=\"\"",
        "PACKAGE_URL=\"\"",
        "HAVE_VISIBILITY_HIDDEN_ATTRIBUTE=1",
        "HAVE_VISIBILITY_PRAGMA=1",
        "XP_UNIX=1",
        "_GNU_SOURCE=1",
        "HAVE_FCNTL_FILE_LOCKING=1",
        "HAVE_POINTER_LOCALTIME_R=1",
        "HAVE_DLADDR=1",
        "HAVE_GETTID=1",
        "HAVE_LCHOWN=1",
        "HAVE_SETPRIORITY=1",
        "HAVE_STRERROR=1",
        "HAVE_SYSCALL=1",
        "HAVE_SECURE_GETENV=1",
        "_REENTRANT=1",
        "FORCE_PR_LOG",
        "_NSPR_BUILD_",
    ]

    linux_defines = [
        "LINUX=1",
        "_PR_PTHREADS",
    ]

    _cc_library(
        name = name,
        srcs = srcs + ["//pr/include"],
        local_defines = local_defines + common_defines + select({
            "@platforms//os:linux": linux_defines,
            "//conditions:default": [],
        }),
        includes = includes + [
            # "$(GENDIR)/%s" % include_path,
            include_path,
            "%s/private" % include_path,
            "%s/md" % include_path,
        ],
        copts = copts + [
            "-Wno-unused-but-set-variable",
        ],
        **kwargs
    )
